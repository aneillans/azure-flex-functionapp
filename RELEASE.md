# Terraform Module Release Guide

## Overview

This repository uses GitHub Actions to automatically build, version, and publish the Terraform module to a private ProGet server.

## Prerequisites

### GitHub Secrets Configuration

Configure the following secrets in your GitHub repository settings:

1. **PROGET_SERVER** - Your ProGet server URL (e.g., `https://proget.example.com`)
2. **PROGET_FEED** - Your ProGet feed name (e.g., `terraform-modules`)
3. **PROGET_API_KEY** - ProGet API key with publish permissions

**Steps to add secrets:**
- Navigate to repository Settings → Secrets and variables → Actions
- Click "New repository secret"
- Add each secret with the values above

## Publishing a Release

### Method 1: Using Git Tags (Recommended)

```bash
# Create a semantic version tag
git tag v1.0.0

# Push the tag to trigger the workflow
git push origin v1.0.0
```

### Method 2: Manual Trigger via GitHub Actions

1. Go to Actions tab in your repository
2. Select "Terraform Module Build and Publish" workflow
3. Click "Run workflow"
4. Enter the version number (e.g., `1.0.0`)
5. Click "Run workflow"

## Workflow Features

✓ **Semantic Versioning**: Uses Git tags following `v1.0.0` format
✓ **Validation**: Runs `terraform validate` and `terraform fmt` checks
✓ **Packaging**: Creates tar.gz packages of the module
✓ **Metadata**: Generates module metadata compatible with Terraform registries
✓ **ProGet Publishing**: Uploads packages to your private ProGet server
✓ **GitHub Releases**: Creates GitHub releases with packaged module
✓ **Logging**: Comprehensive workflow logs for debugging

## Module Structure

The published module includes:

```
azure-flex-functionapp-1.0.0/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── flex_function_app.tf
│   ├── serverfarm.tf
│   └── storage_account.tf
├── README.md
├── LICENSE
└── VERSION (generated metadata)
```

## Version Format

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR.MINOR.PATCH** (e.g., `1.0.0`)
  - **MAJOR**: Breaking changes
  - **MINOR**: New features (backward compatible)
  - **PATCH**: Bug fixes

## Troubleshooting

### Publish Fails

1. **Check ProGet credentials**: Verify secrets are correctly set
2. **Verify feed exists**: Ensure the ProGet feed name is correct
3. **API key permissions**: Confirm API key has "Publish" permissions
4. **Network**: Check ProGet server is accessible from GitHub runners

### View Logs

1. Go to Actions tab
2. Click the failed workflow run
3. Click "build-and-publish" job
4. Expand steps to see detailed logs

## Example Workflow Run

```bash
# 1. Commit your changes
git add terraform/
git commit -m "feat: add new variable for flex plan"

# 2. Create a semantic version
git tag -a v1.1.0 -m "Release v1.1.0"

# 3. Push changes and tag
git push origin main
git push origin v1.1.0

# Result: GitHub Actions automatically builds and publishes the module
```

## Accessing Published Module

Once published to ProGet, you can reference it in your Terraform code:

```hcl
module "flex_function_app" {
  source = "proget/custom/azure-flex-functionapp/azurerm"
  version = "1.0.0"

  # ... module variables
}
```

## Additional Resources

- [Terraform Module Registry Documentation](https://www.terraform.io/cloud-docs/registry/publish)
- [Inedo ProGet Documentation](https://docs.inedo.com/docs/proget)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
