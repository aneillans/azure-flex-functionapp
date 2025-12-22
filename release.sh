#!/bin/bash

# Terraform Module Release Helper Script
# This script helps manage module versioning and releases

set -e

VERSION="${1}"
COMMIT_MSG="${2:-Release $VERSION}"

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
