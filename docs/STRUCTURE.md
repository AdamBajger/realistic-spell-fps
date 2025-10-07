# URMOM Project Structure

```
URMOM (Ultimate Realms: Masters of Magic)
│
├── 📦 Crates (Workspace)
│   ├── 🎮 client/           Binary + optional server embedding
│   │   ├── src/
│   │   │   ├── input/       Keyboard & mouse handling
│   │   │   ├── ui/          Spellcasting UI & HUD
│   │   │   ├── gameplay/    Client game logic
│   │   │   ├── physics/     Prediction & reconciliation
│   │   │   ├── rendering/   Rendering pipeline
│   │   │   ├── renderer_vk/ Vulkan implementation
│   │   │   ├── assets/      Asset management
│   │   │   ├── audio/       Sound system
│   │   │   └── net/         Client networking
│   │   └── tests/
│   │
│   ├── 🖥️  server/          Binary + Library
│   │   ├── src/
│   │   │   ├── net/         Server networking & RPC
│   │   │   ├── physics/     Authoritative physics
│   │   │   ├── game_logic/  Entity & state management
│   │   │   └── persistence/ Database & matchmaking
│   │   └── tests/
│   │
│   ├── ⚙️  engine/          Library (shared core)
│   │   ├── src/
│   │   │   ├── ecs/         ECS utilities
│   │   │   ├── math/        Math utilities
│   │   │   ├── physics_core/Deterministic physics
│   │   │   ├── net_proto/   Network protocol
│   │   │   └── io/          File I/O abstractions
│   │   └── tests/
│   │
│   └── 🛠️  editor/          Binary
│       ├── src/
│       │   ├── ui/          Editor UI (egui)
│       │   ├── scene/       Scene management
│       │   └── tools/       Level design tools
│       └── tests/
│
├── 🎨 assets/
│   ├── images/              Textures & UI graphics
│   ├── sounds/              Audio files
│   ├── models/              3D models (.obj, .gltf)
│   ├── shaders/             GLSL shaders
│   │   └── compiled/        SPIR-V (git-ignored)
│   └── materials/           Material definitions (JSON)
│
├── 🧪 tests/
│   ├── integration/         End-to-end tests
│   │   ├── e2e_server_client.rs
│   │   └── deterministic_physics.rs
│   ├── harness/             Test utilities
│   │   └── mod.rs
│   └── workspace_test.rs
│
├── 🔧 build/
│   └── ci/                  CI scripts (see script headers for usage)
│       ├── compile_shaders.sh
│       ├── lint.sh
│       ├── test.sh
│       └── build.sh
│
├── 🛠️  tools/               Development utilities
│
├── 📚 docs/
│   ├── README.md            Main documentation
│   ├── ARCHITECTURE.md      System architecture
│   ├── PHYSICS_ARCHITECTURE.md
│   ├── AUDIO_DESIGN.md
│   ├── CONTRIBUTING.md      Includes CI/CD workflow info
│   ├── design.md            Design document
│   ├── networking.md        Network architecture
│   └── WORKSPACE.md         Workspace guide
│
├── 🐳 .devcontainer/
│   ├── Dockerfile.client    Client container
│   ├── Dockerfile.server    Server container
│   └── devcontainer.json    VS Code dev container
│
├── ⚡ .github/workflows/     CI/CD workflows (see comments in files)
│   ├── ci.yml               Test, lint, build
│   └── docker.yml           Docker image builds
│
├── 📄 Cargo.toml            Workspace definition
├── 📄 LICENSE               MIT License
├── 📄 README.md             Project README
└── 📄 .gitignore            Git ignore rules
```

## Dependency Graph

```
┌─────────┐
│ editor  │──────┐
└─────────┘      │
                 │
┌─────────┐      │      ┌─────────┐
│ client  │──────┼─────→│ engine  │
└─────────┘      │      └─────────┘
     │           │
     │ (opt)     │
     ↓           │
┌─────────┐      │
│ server  │──────┘
└─────────┘
```

- **engine**: Core shared functionality
- **server**: Authoritative game server (also exported as library)
- **client**: Game client (can optionally embed server for LAN)
- **editor**: Level design tools

## Data Flow

```
┌──────────────┐
│   Player     │
│   Input      │
└──────┬───────┘
       │
       ↓
┌──────────────┐     Network      ┌──────────────┐
│   Client     │◄────────────────►│   Server     │
│              │                   │              │
│ • Prediction │                   │ • Authority  │
│ • Rendering  │                   │ • Physics    │
│ • Audio      │                   │ • State      │
└──────┬───────┘                   └──────┬───────┘
       │                                  │
       └──────────┬───────────────────────┘
                  │
                  ↓
           ┌──────────────┐
           │   Engine     │
           │              │
           │ • ECS        │
           │ • Physics    │
           │ • Network    │
           └──────────────┘
```

## CI/CD Pipeline

```
┌─────────────┐
│  Git Push   │
└──────┬──────┘
       │
       ├──────────────────────┬──────────────────┐
       │                      │                  │
       ↓                      ↓                  ↓
┌──────────────┐    ┌──────────────┐   ┌──────────────┐
│   Test Job   │    │  Lint Job    │   │  Build Job   │
│              │    │              │   │              │
│ • Run tests  │    │ • rustfmt    │   │ • Linux      │
│ • All crates │    │ • clippy     │   │ • Windows    │
│              │    │              │   │ • macOS      │
└──────────────┘    └──────────────┘   └──────┬───────┘
                                              │
                                              ↓
                                    ┌──────────────────┐
                                    │   Docker Build   │
                                    │                  │
                                    │ • Client image   │
                                    │ • Server image   │
                                    │ • Push to GHCR   │
                                    └──────────────────┘
```

## Module Organization

### Client Module Structure
```
client/src/
├── main.rs          Entry point
├── input/mod.rs     Input handling
├── ui/mod.rs        UI rendering
├── gameplay/mod.rs  Game logic
├── physics/mod.rs   Client physics
├── rendering/mod.rs Rendering pipeline
├── renderer_vk/     Vulkan renderer
├── assets/mod.rs    Asset management
├── audio/mod.rs     Audio system
└── net/mod.rs       Client networking
```

### Server Module Structure
```
server/src/
├── lib.rs              Library exports
├── main.rs             Entry point
├── net/mod.rs          Server networking
├── physics/mod.rs      Authoritative physics
├── game_logic/mod.rs   Game state
└── persistence/mod.rs  Database
```

### Engine Module Structure
```
engine/src/
├── lib.rs              Library exports
├── ecs/mod.rs          ECS utilities
├── math/mod.rs         Math utilities
├── physics_core/mod.rs Physics simulation
├── net_proto/mod.rs    Network protocol
└── io/mod.rs           File I/O
```

## Development Workflow

```
1. Clone repository
   │
   ↓
2. Open in VS Code
   │
   ↓
3. Reopen in Dev Container
   │
   ↓
4. cargo build --workspace
   │
   ↓
5. cargo test --workspace
   │
   ↓
6. Make changes
   │
   ↓
7. cargo fmt && cargo clippy
   │
   ↓
8. cargo test
   │
   ↓
9. git commit && git push
   │
   ↓
10. CI runs automatically
```
