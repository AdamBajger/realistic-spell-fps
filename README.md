# URMOM - Ultimate Realms: Masters of Magic

A proof-of-concept indie FPS game with spell-based combat, built from scratch in Rust. Emphasis on gameplay with opportunities to polish graphics later.

## Features

- **Multiplayer**: Online multiplayer with authoritative server
- **Single Player**: Offline gameplay mode
- **Spell System**: Magic-based combat mechanics
- **Custom Engine**: Built-in Rust with ECS architecture
- **Level Editor**: Tools for creating custom levels

## Quick Start

### Prerequisites

- Rust 1.70+ (install via [rustup](https://rustup.rs/))
- Vulkan SDK (for rendering)

### Build & Run

```bash
# Build the entire workspace
cargo build --workspace

# Run the client
cargo run -p client

# Run the server
cargo run -p server

# Run the editor
cargo run -p editor
```

### Development

```bash
# Run tests
cargo test --workspace

# Format code
cargo fmt --all

# Check for issues
cargo clippy --workspace
```

## Project Structure

```
urmom/
├── crates/
│   ├── client/      # Game client (rendering, input, UI, audio)
│   │   └── src/
│   │       ├── input/       # Input handling (WASD, mouse)
│   │       ├── ui/          # Spellcasting UI and spell stack
│   │       ├── gameplay/    # Gameplay logic
│   │       ├── physics/     # Client physics & prediction
│   │       ├── rendering/   # Rendering pipeline
│   │       ├── renderer_vk/ # Vulkan-based renderer
│   │       ├── assets/      # Asset management
│   │       ├── audio/       # Audio system
│   │       └── net/         # Client-side networking
│   ├── server/      # Game server (physics, networking, state)
│   │   └── src/
│   │       ├── net/         # Networking & RPC
│   │       ├── physics/     # Authoritative physics
│   │       ├── game_logic/  # Game state & entity management
│   │       └── persistence/ # Persistence & matchmaking
│   ├── engine/      # Core engine (ECS, math, physics, network protocol)
│   │   └── src/
│   │       ├── ecs/         # ECS utilities
│   │       ├── math/        # Math utilities
│   │       ├── physics_core/# Deterministic physics core
│   │       ├── net_proto/   # Network protocol schema
│   │       └── io/          # IO abstractions
│   └── editor/      # Level editor tools
│       └── src/
│           ├── ui/          # Editor UI
│           ├── scene/       # Scene management
│           └── tools/       # Editor tools
├── assets/          # Game assets (models, textures, sounds, shaders)
│   ├── images/      # Textures and images
│   ├── sounds/      # Audio files
│   ├── models/      # 3D models
│   ├── shaders/     # GLSL shaders (compiled to SPIR-V)
│   └── materials/   # Material definitions
├── tests/           # Integration tests
│   ├── integration/ # E2E tests
│   └── harness/     # Test harness utilities
├── build/           # Build scripts and tools
│   └── ci/          # CI scripts (shader compilation, lint, test)
├── tools/           # Development utilities
├── docs/            # Documentation
└── .devcontainer/   # VS Code dev container configuration
    ├── Dockerfile.client     # Client container
    ├── Dockerfile.server     # Server container
    └── devcontainer.json     # Dev container config
```

## Documentation

- [Architecture Overview](docs/ARCHITECTURE.md)
- [Contributing Guidelines](docs/CONTRIBUTING.md)
- [Full Documentation](docs/README.md)

## Technology Stack

- **Language**: Rust 2021
- **ECS**: bevy_ecs
- **Physics**: Rapier3D
- **Graphics**: Vulkan (via ash)
- **Networking**: Tokio (async runtime)
- **Serialization**: bincode + serde

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
