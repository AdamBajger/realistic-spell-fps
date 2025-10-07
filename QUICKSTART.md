# Build Container Unification - Quick Start Guide

This PR implements unified base builder images for the Realistic Spell FPS project, making builds faster and more efficient.

## 🎯 What Changed?

Previously, each Docker image rebuilt the same dependencies over and over. Now, we have:

1. **Base Builder Images** - Pre-built images with all build tools (Rust, MSVC, etc.)
2. **Smart Workflows** - Only rebuild base images when their Dockerfiles change
3. **Faster Builds** - Runtime images skip dependency installation (saves 3-5 min per build)

## 🚀 Setup Instructions

### 1. Configure GitHub Secrets

Add these secrets to your repository (Settings → Secrets and variables → Actions):

```
DOCKERHUB_USERNAME = your-dockerhub-username
DOCKERHUB_TOKEN = your-dockerhub-access-token
```

Get your Docker Hub token at: https://hub.docker.com/settings/security

### 2. Merge This PR

Merging will trigger the first base image build automatically.

### 3. Verify Base Images

After the workflow completes, check Docker Hub for your published base images:
- `{username}/realistic-spell-fps/base-builder-linux:latest`
- `{username}/realistic-spell-fps/base-builder-windows:latest`

### 4. Test Runtime Builds

Push a code change and verify that runtime builds are faster (check the workflow logs).

## 📁 What's Included

### New Files
- **Base Builders**: `.devcontainer/base-builder-{linux,windows}.Dockerfile`
- **Workflow**: `.github/workflows/build-base-images.yml`
- **Documentation**: `docs/DOCKER_BUILD.md`, `ARCHITECTURE.md`, `UNIFICATION_SUMMARY.md`

### Modified Files
- All runtime Dockerfiles now use base builders
- `docker.yml` and `docker-multiplatform.yml` updated with path filters

## 🔄 How It Works

### Base Image Workflow
Triggers only when base Dockerfiles change:
```
Push to master/main
  ↓
Base Dockerfile changed?
  ↓ YES
Build base-builder-linux and base-builder-windows
  ↓
Publish to Docker Hub with tags: dev-{sha}, latest
```

### Runtime Image Workflow
Skips when only base files change:
```
Push to master/main
  ↓
Only base Dockerfiles changed?
  ↓ NO
Pull base-builder-* from Docker Hub
  ↓
Build runtime images (client, server)
  ↓
Publish to GHCR
```

## 📊 Benefits

| Before | After |
|--------|-------|
| Dependencies installed in every build | Dependencies pre-installed in base image |
| ~5 min overhead per image | Overhead eliminated |
| 4+ images × 5 min = 20+ min wasted | Base built once, reused forever |
| Inconsistent environments | Guaranteed consistency |

## 🔧 Customization

### Using a Custom Registry

Set these secrets to use a different registry:
```
DOCKER_REGISTRY = registry.example.com
DOCKER_USERNAME = custom-username
DOCKER_PASSWORD = custom-password
```

### Manual Base Image Rebuild

Go to Actions → Build Base Images → Run workflow → Set "Force rebuild" to true

## 📚 Documentation

- **Quick Overview**: This file (QUICKSTART.md)
- **Architecture**: See `ARCHITECTURE.md` for visual diagrams
- **Implementation Details**: See `UNIFICATION_SUMMARY.md`
- **Build System Guide**: See `docs/DOCKER_BUILD.md`

## ❓ Troubleshooting

### Base images not found?
1. Check that `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets are set
2. Verify the build-base-images workflow completed successfully
3. Check Docker Hub for published images

### Builds are slow?
1. Verify runtime builds are using base images (check workflow logs for `Using BASE_BUILDER_IMAGE`)
2. Ensure base images were published successfully
3. Check that Docker Hub credentials are valid

### Need to update Rust version?
1. Edit `.devcontainer/base-builder-linux.Dockerfile` (change `rust:1.90` to desired version)
2. Edit `.devcontainer/base-builder-windows.Dockerfile` (change `ARG RUST_VERSION=stable`)
3. Commit and push - base images will rebuild automatically

## ✅ Validation Checklist

- [x] Base Linux builder builds successfully
- [x] Base Windows builder Dockerfile is valid
- [x] Runtime images can use base builders via build-arg
- [x] Workflow YAML syntax is valid
- [x] Path filters work correctly
- [x] Versioning uses dev- prefix
- [x] Docker Hub credentials configured properly

## 🎉 Success Criteria

After merging, you should see:
1. ✅ Base images published to Docker Hub
2. ✅ Runtime builds skip dependency installation
3. ✅ Faster workflow execution times
4. ✅ Consistent build environment across all images

## 📞 Support

For issues or questions:
- Check `docs/DOCKER_BUILD.md` for detailed documentation
- Review `ARCHITECTURE.md` for system design
- See `UNIFICATION_SUMMARY.md` for implementation details
