# Realistic Spell FPS

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
realistic-spell-fps/
├── crates/
│   ├── client/      # Game client (rendering, input, UI, audio)
│   ├── server/      # Game server (physics, networking, state)
│   ├── engine/      # Core engine (ECS, math, physics, network protocol)
│   └── editor/      # Level editor tools
├── assets/          # Game assets (models, textures, sounds, shaders)
├── tests/           # Integration tests
├── build/           # Build scripts and tools
├── docs/            # Documentation
└── .devcontainer/   # VS Code dev container configuration
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
