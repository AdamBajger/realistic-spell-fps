# URMOM Design Document

## Project Vision

URMOM (Ultimate Realms: Masters of Magic) is an ambitious multiplayer FPS game focusing on spell-based combat mechanics. This document outlines the overall design philosophy and technical approach.

## Core Pillars

1. **Modular Architecture**: Separation of concerns through a well-defined crate structure
2. **Deterministic Physics**: Shared physics simulation for client prediction and server authority
3. **Scalable Development**: Automated CI/CD, containerization, and development tooling
4. **Developer Experience**: Comprehensive dev containers and documentation

## Technical Stack

- **Language**: Rust 2021
- **ECS**: bevy_ecs for entity management
- **Physics**: Rapier3D for deterministic physics simulation
- **Graphics**: Vulkan (via ash) with SPIR-V shaders
- **Networking**: Custom binary protocol over TCP with tokio
- **Serialization**: bincode + serde

## Architecture Overview

### Workspace Structure

The project is organized as a Cargo workspace with four main crates:

#### 1. Engine (`crates/engine`)

Core shared functionality used by all other crates:

- **ECS**: Entity-Component-System utilities (bevy_ecs wrapper)
- **Math**: Vector math and utilities (glam wrapper)
- **Physics Core**: Deterministic physics simulation (Rapier3D wrapper)
- **Network Protocol**: Shared message definitions and serialization
- **IO**: File system abstractions

#### 2. Client (`crates/client`)

Game client with full rendering and interaction:

- **Input**: Keyboard/mouse handling
- **UI**: Spellcasting interface and HUD
- **Gameplay**: Client-side game logic
- **Physics**: Client-side prediction and reconciliation
- **Rendering**: Main rendering pipeline
- **Renderer VK**: Vulkan-specific implementation
- **Assets**: Asset loading and management
- **Audio**: Sound and music playback
- **Net**: Client networking

#### 3. Server (`crates/server`)

Authoritative game server:

- **Net**: Server networking and RPC
- **Physics**: Authoritative physics simulation
- **Game Logic**: Entity management and game state
- **Persistence**: Database and matchmaking

#### 4. Editor (`crates/editor`)

Level editor and development tools:

- **UI**: Editor interface (egui-based)
- **Scene**: Scene management and serialization
- **Tools**: Level design utilities

## Development Workflow

### Building

```bash
# Build entire workspace
cargo build --workspace

# Build specific crate
cargo build -p client
cargo build -p server
cargo build -p engine
cargo build -p editor
```

### Testing

```bash
# Run all tests
cargo test --workspace

# Run integration tests
cargo test --test '*'

# Run specific crate tests
cargo test -p engine
```

### CI/CD

GitHub Actions workflows automatically:

- Run tests on push and PR
- Check code formatting (rustfmt)
- Run linter (clippy)
- Build Docker images for client and server
- Test on multiple platforms (Linux, Windows, macOS)

### Containerization

Docker images are provided for:

- **Client**: Containerized game client (minimal runtime)
- **Server**: Production-ready game server
- **Dev Container**: Full development environment with all tools

## Future Enhancements

- Advanced spell crafting system
- Procedural level generation
- Replay system using deterministic physics
- Cross-platform support (Web via WASM)
- Advanced graphics features (ray tracing, PBR)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on contributing to URMOM.
