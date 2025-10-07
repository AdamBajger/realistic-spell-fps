# Docker Build System Documentation

This document describes the unified Docker build system for the Realistic Spell FPS project.

## Overview

The build system uses **base builder images** that contain all build dependencies. These base images are built separately and rarely change, making the overall build process more efficient.

## Base Builder Images

### Linux Base Builder
- **File**: `.devcontainer/base-builder-linux.Dockerfile`
- **Base**: `rust:1.90-slim-bullseye`
- **Contains**: Rust toolchain, pkg-config, libssl-dev
- **Published to**: Docker Hub as `{username}/realistic-spell-fps/base-builder-linux`

### Windows Base Builder
- **File**: `.devcontainer/base-builder-windows.Dockerfile`
- **Base**: `mcr.microsoft.com/windows/servercore:ltsc2022`
- **Contains**: Visual Studio Build Tools (MSVC), Rust toolchain, Windows SDK
- **Published to**: Docker Hub as `{username}/realistic-spell-fps/base-builder-windows`

## Runtime Images

All runtime images (client/server for Linux/Windows) use the base builder images:

### Linux Runtime Images
- `client-linux.Dockerfile` - Linux client
- `server-linux.Dockerfile` - Linux server
- `client.Dockerfile` - Generic client (Linux)
- `server.Dockerfile` - Generic server (Linux)

### Windows Runtime Images
- `client-windows.Dockerfile` - Windows client
- `server-windows.Dockerfile` - Windows server

## GitHub Workflows

### 1. Build Base Images (`build-base-images.yml`)
- **Triggers**: When base Dockerfile files change, or manual dispatch
- **Path filters**: Only runs when base-builder-*.Dockerfile files are modified
- **Versioning**: Uses `dev-{short-commit-hash}` format (e.g., `dev-abc1234`)
- **Tags**: Both versioned tag and `latest` tag
- **Registry**: Docker Hub (configurable via secrets)

### 2. Multi-Platform Docker Build (`docker-multiplatform.yml`)
- **Triggers**: Push to master/main, version tags, PRs
- **Path filters**: Skips when only base Dockerfiles change
- **Uses**: Pre-built base images from Docker Hub
- **Builds**: Client and server for Linux and Windows
- **Registry**: GitHub Container Registry (GHCR) by default

### 3. Simple Docker Build (`docker.yml`)
- **Triggers**: Push to master/main, version tags, PRs
- **Path filters**: Skips when only base Dockerfiles change
- **Uses**: Pre-built base images from Docker Hub
- **Builds**: Client and server for Linux only
- **Registry**: GitHub Container Registry (GHCR)

## Configuration

### Required GitHub Secrets

For Docker Hub publishing (base images):
```
DOCKERHUB_USERNAME: Your Docker Hub username
DOCKERHUB_TOKEN: Your Docker Hub access token
```

Optional secrets for custom registries:
```
DOCKER_REGISTRY: Custom registry URL (defaults to docker.io)
DOCKER_USERNAME: Custom registry username
DOCKER_PASSWORD: Custom registry password
```

### How It Works

1. **Base images** are built when their Dockerfiles change
   - Triggered by `build-base-images.yml`
   - Published to Docker Hub with version tags
   
2. **Runtime images** use the published base images
   - Pass `BASE_BUILDER_IMAGE` build argument
   - Falls back to default base images if not available
   - Only rebuild when source code or runtime Dockerfiles change

## Build Process

### Building Base Images Manually

```bash
# Linux base builder
docker build -f .devcontainer/base-builder-linux.Dockerfile \
  -t myusername/realistic-spell-fps/base-builder-linux:dev-$(git rev-parse --short HEAD) .

# Windows base builder (on Windows)
docker build -f .devcontainer/base-builder-windows.Dockerfile \
  -t myusername/realistic-spell-fps/base-builder-windows:dev-$(git rev-parse --short HEAD) .
```

### Building Runtime Images

```bash
# Using published base image
docker build -f .devcontainer/client-linux.Dockerfile \
  --build-arg BASE_BUILDER_IMAGE=myusername/realistic-spell-fps/base-builder-linux:latest \
  -t client-linux:latest .

# Using default fallback (no base image)
docker build -f .devcontainer/client-linux.Dockerfile \
  -t client-linux:latest .
```

## Benefits

1. **Efficiency**: Build dependencies are installed once, not on every build
2. **Consistency**: All builds use the same base environment
3. **Separation of Concerns**: Base images rarely change, runtime images change frequently
4. **Cache Optimization**: Better layer caching in CI/CD pipelines
5. **Faster Builds**: Runtime builds skip dependency installation
6. **Versioning**: Base images are versioned for reproducibility

## Troubleshooting

### Base Image Not Found

If you see errors about missing base images:
1. Check that base images are published to Docker Hub
2. Verify `DOCKERHUB_USERNAME` secret is set correctly
3. Ensure base images were built successfully
4. Fallback to default images by removing `--build-arg`

### Outdated Base Images

To rebuild base images:
1. Use workflow dispatch in GitHub Actions
2. Or modify the base Dockerfile (add a comment)
3. Or build manually and push to registry

### Custom Registry

To use a different registry:
1. Set `DOCKER_REGISTRY` secret (e.g., `ghcr.io`)
2. Set `DOCKER_USERNAME` and `DOCKER_PASSWORD` secrets
3. Update `BASE_REGISTRY` in workflows if needed
