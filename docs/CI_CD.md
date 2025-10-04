# URMOM CI/CD Guide

## Overview

This document describes the CI/CD setup for URMOM (Ultimate Realms: Masters of Magic).

## GitHub Actions Workflows

### CI Workflow (`.github/workflows/ci.yml`)

Runs on every push and pull request to master/main branches.

#### Jobs

1. **Test**
   - Runs all workspace tests
   - Uses caching for faster builds
   - Continues on error to show all failures

2. **Lint**
   - Checks code formatting with `rustfmt`
   - Runs `clippy` for code quality
   - Continues on error to show all issues

3. **Build**
   - Builds on Linux, Windows, and macOS
   - Tests cross-platform compatibility
   - Builds with no default features for minimal dependencies

### Docker Workflow (`.github/workflows/docker.yml`)

Builds and publishes Docker images.

#### Jobs

1. **build-client**
   - Builds client Docker image
   - Publishes to GitHub Container Registry
   - Tags with version and branch name

2. **build-server**
   - Builds server Docker image
   - Publishes to GitHub Container Registry
   - Production-ready images

## Local CI Scripts

Located in `build/ci/`:

### `compile_shaders.sh`

Compiles GLSL shaders to SPIR-V format.

```bash
./build/ci/compile_shaders.sh
```

Requirements:
- `glslc` from Vulkan SDK

### `lint.sh`

Runs formatting and linting checks.

```bash
./build/ci/lint.sh
```

Runs:
- `cargo fmt --all -- --check`
- `cargo clippy --workspace -- -D warnings`

### `test.sh`

Runs all tests in the workspace.

```bash
./build/ci/test.sh
```

Runs:
- `cargo test --workspace`
- Integration tests

### `build.sh`

Builds all crates in debug and release mode.

```bash
./build/ci/build.sh
```

## Docker Images

### Client Image

Located: `.devcontainer/Dockerfile.client`

Features:
- Multi-stage build
- Minimal runtime image
- No audio dependencies in container build

Build:
```bash
docker build -f .devcontainer/Dockerfile.client -t urmom-client .
```

Run:
```bash
docker run -p 8080:8080 urmom-client
```

### Server Image

Located: `.devcontainer/Dockerfile.server`

Features:
- Multi-stage build
- Minimal runtime image
- Persistent data volume

Build:
```bash
docker build -f .devcontainer/Dockerfile.server -t urmom-server .
```

Run:
```bash
docker run -p 7777:7777 -v /data:/app/data urmom-server
```

## Development Container

Located: `.devcontainer/devcontainer.json`

Features:
- Rust development environment
- Docker-in-Docker support
- Pre-configured VS Code extensions
- Port forwarding for server and client

Usage:
1. Open repository in VS Code
2. Click "Reopen in Container"
3. Full development environment ready

## Best Practices

### Before Committing

```bash
# Format code
cargo fmt --all

# Run linter
cargo clippy --workspace

# Run tests
cargo test --workspace

# Build all crates
cargo build --workspace
```

### Pre-Push Checklist

- [ ] All tests pass
- [ ] Code is formatted
- [ ] No clippy warnings
- [ ] Documentation updated
- [ ] Changelog updated (if applicable)

## Troubleshooting

### Build Failures

If builds fail in CI but work locally:
- Check Cargo.lock is committed
- Verify platform-specific dependencies
- Check for missing system libraries

### Docker Build Issues

- Ensure Dockerfile paths are correct
- Check base image compatibility
- Verify multi-stage build layers

### Test Failures

- Run tests locally first
- Check for timing issues in async tests
- Verify test isolation

## Monitoring

CI status badges can be added to README.md:

```markdown
![CI](https://github.com/AdamBajger/realistic-spell-fps/workflows/CI/badge.svg)
![Docker](https://github.com/AdamBajger/realistic-spell-fps/workflows/Docker%20Build/badge.svg)
```
