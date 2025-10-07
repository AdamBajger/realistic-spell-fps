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

Published to Docker Hub as `{username}/realistic-spell-fps/base-builder-{linux|windows}`

### Building Docker Images

```bash
# Build runtime images (uses published base images)
docker build -f .devcontainer/client-linux.Dockerfile -t client-linux .
docker build -f .devcontainer/server-linux.Dockerfile -t server-linux .

# Build base images manually
docker build -f .devcontainer/base-builder-linux.Dockerfile -t base-builder-linux .
```

## GitHub Actions Configuration

### Required Secrets (for Docker Hub)

Add these in Settings → Secrets and variables → Actions:
```
DOCKERHUB_USERNAME - Your Docker Hub username
DOCKERHUB_TOKEN - Your Docker Hub access token (from https://hub.docker.com/settings/security)
```

### Optional Secrets (for custom registries)

```
DOCKER_REGISTRY - Custom registry URL (defaults to docker.io)
DOCKER_USERNAME - Custom registry username  
DOCKER_PASSWORD - Custom registry password
```

### Workflows

- **build-base-images.yml** - Builds base builder images when their Dockerfiles change
- **docker.yml** - Builds runtime images for Linux
- **docker-multiplatform.yml** - Builds runtime images for Linux and Windows
- **ci.yml** - Runs tests and linting

## Troubleshooting

### Build Errors

**Missing dependencies:**
- Linux: Ensure pkg-config and libssl-dev are installed
- Windows: Ensure Visual Studio Build Tools are installed
- macOS: Ensure Xcode Command Line Tools are installed

### Docker Build Issues

**Base images not found:**
- Check that `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets are configured
- Verify base images exist on Docker Hub
- Runtime images fall back to standard base images if custom ones are unavailable

**Slow builds:**
- First build is always slower (downloads dependencies)
- Subsequent builds use cached layers
- Base images eliminate redundant dependency installation in runtime builds

### Updating Rust Version

To update the Rust toolchain:
1. Edit `.devcontainer/base-builder-linux.Dockerfile` - change `FROM rust:1.90-slim-bullseye`
2. Edit `.devcontainer/base-builder-windows.Dockerfile` - change `ARG RUST_VERSION=stable`
3. Commit and push - base images rebuild automatically via GitHub Actions
