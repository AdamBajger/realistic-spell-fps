# Quick Start Guide

Get started with Realistic Spell FPS development quickly.

## Development Environment Setup

### Option 1: Using Dev Containers (Recommended)

Dev containers provide a consistent, pre-configured development environment.

**Prerequisites:**
- Docker Desktop (Windows/macOS) or Docker Engine (Linux)
- Visual Studio Code with Remote-Containers extension

**Steps:**
1. Clone the repository:
   ```bash
   git clone https://github.com/AdamBajger/realistic-spell-fps.git
   cd realistic-spell-fps
   ```

2. Open in VS Code:
   ```bash
   code .
   ```

3. When prompted, click "Reopen in Container" or use Command Palette (F1) → "Remote-Containers: Reopen in Container"

4. Wait for the container to build. The environment includes:
   - Rust toolchain
   - All build dependencies
   - VS Code extensions for Rust development

### Option 2: Local Setup on Linux

**Prerequisites:**
- Rust 1.90 or later
- pkg-config
- libssl-dev

**Ubuntu/Debian:**
```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# Install dependencies
sudo apt-get update
sudo apt-get install pkg-config libssl-dev

# Clone and build
git clone https://github.com/AdamBajger/realistic-spell-fps.git
cd realistic-spell-fps
cargo build
```

### Option 3: Local Setup on Windows

**Prerequisites:**
- Visual Studio Build Tools with MSVC
- Rust toolchain

**Steps:**
1. Install Visual Studio Build Tools from https://visualstudio.microsoft.com/downloads/
   - Select "Desktop development with C++" workload
   
2. Install Rust:
   ```powershell
   # Download and run rustup-init.exe from https://rustup.rs/
   ```

3. Clone and build:
   ```powershell
   git clone https://github.com/AdamBajger/realistic-spell-fps.git
   cd realistic-spell-fps
   cargo build
   ```

### Option 4: Local Setup on macOS

**Prerequisites:**
- Xcode Command Line Tools
- Rust toolchain

**Steps:**
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# Clone and build
git clone https://github.com/AdamBajger/realistic-spell-fps.git
cd realistic-spell-fps
cargo build
```

## Building the Project

```bash
# Build in debug mode
cargo build

# Build in release mode (optimized)
cargo build --release

# Build specific binary
cargo build -p client
cargo build -p server
```

## Running Tests

```bash
# Run all tests
cargo test

# Run tests for specific package
cargo test -p engine
```

## Docker Build System

The project uses a unified Docker build system with base builder images.

### Base Builder Images

Pre-built images containing build dependencies:
- `base-builder-linux` - Rust 1.90, pkg-config, libssl-dev
- `base-builder-windows` - MSVC, Rust toolchain, Windows SDK

Published to GitHub Container Registry as `ghcr.io/{owner}/{repo}/base-builder-{linux|windows}`

### Building Docker Images

```bash
# Build runtime images (uses published base images)
docker build -f .devcontainer/client-linux.Dockerfile -t client-linux .
docker build -f .devcontainer/server-linux.Dockerfile -t server-linux .

# Build base images manually
docker build -f .devcontainer/base-builder-linux.Dockerfile -t base-builder-linux .
```

## GitHub Actions Configuration

The project uses GitHub Container Registry (GHCR) for all Docker images. No additional secrets are required - GitHub Actions automatically provides the `GITHUB_TOKEN` with appropriate permissions.

### Workflows

- **build-base-images.yml** - Builds base builder images when base Dockerfiles change
  - Publishes to: ghcr.io/{owner}/{repo}/base-builder-{linux|windows}
  - Tags: dev-{sha}, latest
  
- **ci.yml** - Runs tests and linting inside Docker containers
  - Uses pre-built base builder images from GHCR
  - Ensures consistent test environment
  
- **docker.yml** - Builds runtime images (quick single-platform)
  - Publishes to: ghcr.io/{owner}/{repo}/{client|server}
  
- **docker-multiplatform.yml** - Builds runtime images (multi-platform)
  - Publishes to: ghcr.io/{owner}/{repo}/{client|server}-{linux|windows}

## Troubleshooting

### Build Errors

**Missing dependencies:**
- Linux: Ensure pkg-config and libssl-dev are installed
- Windows: Ensure Visual Studio Build Tools are installed
- macOS: Ensure Xcode Command Line Tools are installed

### Docker Build Issues

**Base images not found:**
- Base images are automatically built and published to GHCR when base Dockerfiles change
- First-time builds may need to wait for base images to be available
- Check the "Build Base Images" workflow for status

**Slow builds:**
- First build is always slower (downloads dependencies)
- Subsequent builds use cached layers
- Base images eliminate redundant dependency installation in runtime builds

### Updating Rust Version

To update the Rust toolchain:
1. Edit `.devcontainer/base-builder-linux.Dockerfile` - change `FROM rust:1.90-slim-bullseye`
2. Edit `.devcontainer/base-builder-windows.Dockerfile` - change `ARG RUST_VERSION=stable`
3. Commit and push - base images rebuild automatically via GitHub Actions
