#!/bin/bash

# Terraform Module Release Helper Script
# This script helps manage module versioning and releases

set -e

VERSION="${1}"
COMMIT_MSG="${2:-Release $VERSION}"

MODULE_NAME="${MODULE_NAME:-azure-flex-functionapp}"

if [ -z "$VERSION" ]; then
    echo "Usage: ./release.sh <version> [commit-message]"
    echo "Example: ./release.sh 1.0.0"
    echo ""
    echo "Semantic versioning format required: MAJOR.MINOR.PATCH"
    exit 1
fi

# Validate semantic version format
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid version format. Use MAJOR.MINOR.PATCH (e.g., 1.0.0)"
    exit 1
fi

echo "=========================================="
echo "Terraform Module Release Script"
echo "=========================================="
echo "Version: v${VERSION}"
echo "Commit Message: ${COMMIT_MSG}"
echo ""

# Check git status
if ! git diff-index --quiet HEAD --; then
    echo "Error: Working directory has uncommitted changes"
    echo "Please commit or stash changes first"
    exit 1
fi

echo "✓ Working directory clean"

# Validate terraform files
echo ""
echo "Validating Terraform module..."
cd terraform
terraform init -backend=false > /dev/null 2>&1
terraform validate > /dev/null
terraform fmt -check -recursive > /dev/null
cd ..
echo "✓ Terraform validation passed"

# Create and push tag
echo ""
echo "Creating git tag v${VERSION}..."
git tag -a "v${VERSION}" -m "${COMMIT_MSG}"
echo "✓ Tag created locally"

echo ""
echo "Pushing tag to remote..."
git push origin "v${VERSION}"
echo "✓ Tag pushed to GitHub"

echo ""
echo "Building package artifact locally..."
PACKAGE_NAME="${MODULE_NAME}-${VERSION}.zip"

# Prepare build dir
rm -rf build
mkdir -p build

# Copy module files
cp -r terraform/ build/${MODULE_NAME}/

if [ -f README.md ]; then
    cp README.md build/${MODULE_NAME}/
fi

if [ -f LICENSE ]; then
    cp LICENSE build/${MODULE_NAME}/
fi

# Create module manifest
cat > build/${MODULE_NAME}/VERSION << EOF
{
  "version": "${VERSION}",
  "name": "${MODULE_NAME}",
  "namespace": "custom",
  "type": "module",
  "provider": "azurerm",
  "source": "proget/custom/${MODULE_NAME}/azurerm"
}
EOF

# Create zip
cd build
zip -r "../${PACKAGE_NAME}" "${MODULE_NAME}" > /dev/null
cd ..

echo "✓ Package created: ${PACKAGE_NAME}"

# Optionally publish to ProGet if env vars are present
if [ -n "${PROGET_SERVER}" ] && [ -n "${PROGET_FEED}" ] && [ -n "${PROGET_API_KEY}" ]; then
    echo "Publishing ${PACKAGE_NAME} to ProGet..."

    if command -v upack >/dev/null 2>&1; then
        echo "Using available upack in PATH"
        upack push "${PACKAGE_NAME}" --server "${PROGET_SERVER}" --feed "${PROGET_FEED}" --api-key "${PROGET_API_KEY}"
        STATUS=$?
    elif [ -x "$HOME/.dotnet/tools/upack" ]; then
        echo "Using upack at $HOME/.dotnet/tools/upack"
        "$HOME/.dotnet/tools/upack" push "${PACKAGE_NAME}" --server "${PROGET_SERVER}" --feed "${PROGET_FEED}" --api-key "${PROGET_API_KEY}"
        STATUS=$?
    else
        echo "upack CLI not found; attempting HTTP upload via curl as fallback"
        curl -X POST \
          -H "Authorization: Bearer ${PROGET_API_KEY}" \
          -H "Content-Type: multipart/form-data" \
          -F "file=@${PACKAGE_NAME}" \
          "${PROGET_SERVER}/api/v3/feeds/terraform-modules/package-upload?feed=${PROGET_FEED}" -v
        STATUS=$?
    fi

    if [ ${STATUS} -eq 0 ]; then
        echo "✓ Package published successfully"
    else
        echo "✗ Failed to publish package (status=${STATUS})"
    fi
else
    echo "ProGet environment variables not set; skipping publish."
    echo "You can push the package manually with upack or configure PROGET_SERVER, PROGET_FEED and PROGET_API_KEY."
fi
echo "=========================================="
echo "Release v${VERSION} initiated!"
echo "=========================================="
echo ""
echo "The GitHub Actions workflow will now:"
echo "  1. Build the module package"
echo "  2. Publish to ProGet"
echo "  3. Create a GitHub release"
echo ""
echo "Check Actions tab to monitor progress:"
echo "  https://github.com/<owner>/<repo>/actions"
echo ""
