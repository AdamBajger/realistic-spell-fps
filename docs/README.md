# URMOM - Ultimate Realms: Masters of Magic - Documentation

## Project Overview

A multiplayer/single-player FPS game with a focus on spell-based combat, built from scratch in Rust.

## Architecture

This project uses a Cargo workspace with multiple crates:

### Crates

- **client** - Game client with rendering, input, and UI
- **server** - Game server with authoritative physics and state management
- **engine** - Core game engine library (ECS, math, physics, networking)
- **editor** - Level editor and development tools

## Getting Started

### Prerequisites

- Rust 1.70+ (via rustup)
- Vulkan SDK (for rendering)
- Audio libraries (for sound)

### Building

```bash
# Build all crates
cargo build --workspace

# Build a specific crate
cargo build -p client
cargo build -p server
cargo build -p editor
```

### Running

```bash
# Run the client
cargo run -p client

# Run the server
cargo run -p server

# Run the editor
cargo run -p editor
```

### Testing

```bash
# Run all tests
cargo test --workspace

# Run tests for a specific crate
cargo test -p engine
```

## Development

### Code Style

We use `rustfmt` and `clippy` for code formatting and linting:

```bash
# Format code
cargo fmt --all

# Run linter
cargo clippy --workspace -- -D warnings
```

### VS Code Dev Container

This project includes a dev container configuration. Open in VS Code and select "Reopen in Container" for a preconfigured development environment.

## Project Structure

```
realistic-spell-fps/
├── crates/
│   ├── client/      # Game client
│   ├── server/      # Game server
│   ├── engine/      # Core engine
│   └── editor/      # Level editor
├── assets/          # Game assets
├── tests/           # Integration tests
├── build/           # Build scripts
├── docs/            # Documentation
└── .devcontainer/   # Dev container config
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## License

This project is licensed under the MIT License - see [LICENSE](../LICENSE) file for details.
