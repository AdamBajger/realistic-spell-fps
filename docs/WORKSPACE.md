# URMOM Workspace Guide

## Overview

This guide explains the workspace structure and development workflow for URMOM.

## Workspace Structure

### Root Workspace (`Cargo.toml`)

The root `Cargo.toml` defines the workspace and shared dependencies:

```toml
[workspace]
members = [
    "crates/client",
    "crates/server",
    "crates/engine",
    "crates/editor",
]
```

All crates share common dependency versions defined in `[workspace.dependencies]`.

## Crate Details

### Engine (`crates/engine`)

**Type**: Library crate

**Purpose**: Core shared functionality

**Modules**:
- `ecs/` - ECS utilities (bevy_ecs wrapper)
- `math/` - Math utilities (glam wrapper)
- `physics_core/` - Deterministic physics (Rapier3D wrapper)
- `net_proto/` - Network protocol definitions
- `io/` - File system abstractions

**Dependencies**:
- bevy_ecs
- glam
- rapier3d
- serde
- bincode
- tokio

### Client (`crates/client`)

**Type**: Binary crate

**Purpose**: Game client

**Modules**:
- `input/` - Keyboard and mouse handling
- `ui/` - Spellcasting UI
- `gameplay/` - Client-side game logic
- `physics/` - Client prediction and reconciliation
- `rendering/` - Main rendering pipeline
- `renderer_vk/` - Vulkan implementation
- `assets/` - Asset loading
- `audio/` - Sound system (optional feature)
- `net/` - Client networking

**Features**:
- `lan-host` - Enables embedding server for LAN games
- `audio` - Enables audio support (requires system libraries)

**Dependencies**:
- engine (workspace crate)
- server (optional, for LAN hosting)
- ash (Vulkan)
- winit (windowing)
- rodio (audio, optional)

### Server (`crates/server`)

**Type**: Binary + Library crate

**Purpose**: Authoritative game server

**Modules**:
- `net/` - Server networking and RPC
- `physics/` - Authoritative physics
- `game_logic/` - Game state and entities
- `persistence/` - Database and matchmaking

**Library Exports**:
Server is also exported as a library for embedding in client (LAN hosting).

**Dependencies**:
- engine (workspace crate)
- tokio (async runtime)

### Editor (`crates/editor`)

**Type**: Binary crate

**Purpose**: Level editor

**Modules**:
- `ui/` - Editor UI (egui-based)
- `scene/` - Scene management
- `tools/` - Level design utilities

**Dependencies**:
- engine (workspace crate)
- eframe (GUI framework)
- egui (immediate mode UI)

## Directory Structure

### Assets (`assets/`)

Game assets organized by type:

```
assets/
├── images/      # Textures
├── sounds/      # Audio files
├── models/      # 3D models
├── shaders/     # GLSL shaders
│   └── compiled/ # SPIR-V (git-ignored)
└── materials/   # Material definitions
```

### Build (`build/`)

Build scripts and CI tools:

```
build/
├── README.md
└── ci/
    ├── compile_shaders.sh  # Shader compilation
    ├── lint.sh             # Code quality checks
    ├── test.sh             # Run tests
    └── build.sh            # Build all crates
```

### Tests (`tests/`)

Integration tests:

```
tests/
├── integration/         # E2E tests
│   ├── e2e_server_client.rs
│   └── deterministic_physics.rs
├── harness/            # Test utilities
│   └── mod.rs
└── workspace_test.rs   # Workspace structure test
```

### Docs (`docs/`)

Documentation:

```
docs/
├── README.md                # Main documentation
├── ARCHITECTURE.md          # System architecture
├── PHYSICS_ARCHITECTURE.md  # Physics design
├── AUDIO_DESIGN.md          # Audio system
├── CONTRIBUTING.md          # Contribution guide
├── design.md                # Design document
├── networking.md            # Network architecture
└── CI_CD.md                 # CI/CD guide
```

### Tools (`tools/`)

Development utilities:

```
tools/
└── README.md
```

Future: Asset conversion, code generation, profiling tools

## Development Workflows

### Adding a New Module

1. Create directory in appropriate crate's `src/`
2. Create `mod.rs` in the directory
3. Add module declaration to parent module
4. Write code and tests
5. Update documentation

### Adding a New Crate

1. Create directory in `crates/`
2. Add `Cargo.toml` with workspace inheritance
3. Add to workspace members in root `Cargo.toml`
4. Create `src/lib.rs` or `src/main.rs`
5. Write code and tests

### Building for Production

```bash
# Release build
cargo build --release --workspace

# Client without audio (for containers)
cargo build --release -p client --no-default-features

# Server
cargo build --release -p server
```

### Running Tests

```bash
# All tests
cargo test --workspace

# Specific crate
cargo test -p engine

# Specific test
cargo test test_physics_determinism

# Integration tests
cargo test --test '*'
```

### Code Quality

```bash
# Format
cargo fmt --all

# Lint
cargo clippy --workspace

# Both via CI script
./build/ci/lint.sh
```

## Feature Flags

### Client Features

- `default = ["lan-host", "audio"]` - Default features
- `lan-host` - Embed server for LAN hosting
- `audio` - Enable audio system (requires ALSA on Linux)
- `vulkan` - Placeholder for Vulkan-specific features

### Server Features

Currently no optional features.

## Dependencies Management

### Adding a Dependency

Prefer adding to workspace dependencies:

```toml
# In root Cargo.toml
[workspace.dependencies]
new-dep = "1.0"

# In crate Cargo.toml
[dependencies]
new-dep = { workspace = true }
```

### Updating Dependencies

```bash
# Update all
cargo update

# Update specific
cargo update -p package-name
```

## Cross-Platform Support

### Linux

Fully supported. May need system libraries:
- Vulkan SDK (for graphics)
- ALSA (for audio)

### Windows

Supported with no-default-features for server/engine.

### macOS

Supported with no-default-features for server/engine.

## Troubleshooting

### Build Errors

**Problem**: Missing system libraries
**Solution**: Build with `--no-default-features` or install libraries

**Problem**: Conflicting dependencies
**Solution**: Check `Cargo.lock`, run `cargo update`

### Test Failures

**Problem**: Tests fail in CI but work locally
**Solution**: Check for timing issues, ensure deterministic tests

### Import Errors

**Problem**: Module not found
**Solution**: Check module declaration in parent `mod.rs`

## Next Steps

- Implement actual game logic
- Add networking code
- Create shader library
- Build asset pipeline
- Performance optimization
