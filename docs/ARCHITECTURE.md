# Architecture Overview

## System Architecture

The game is built using a modular architecture with clear separation of concerns:

### Client-Server Model

```
┌─────────────┐         Network          ┌─────────────┐
│   Client    │◄────────────────────────►│   Server    │
│             │                           │             │
│  Rendering  │                           │  Authority  │
│  Input      │                           │  Physics    │
│  Audio      │                           │  State      │
│  Prediction │                           │  Collision  │
└─────────────┘                           └─────────────┘
       │                                         │
       │                                         │
       └─────────────┬───────────────────────────┘
                     │
              ┌──────▼──────┐
              │   Engine    │
              │             │
              │    ECS      │
              │    Math     │
              │   Physics   │
              │   Network   │
              └─────────────┘
```

## Engine Core

### ECS (Entity Component System)

We use bevy_ecs for entity management:

- **Entities**: Game objects (players, spells, environment)
- **Components**: Data (position, health, velocity)
- **Systems**: Logic (movement, collision, rendering)

### Physics

Rapier3D provides deterministic physics simulation:

- Client: Prediction and interpolation
- Server: Authoritative simulation

### Networking

- Protocol: Custom binary protocol over TCP
- Serialization: bincode
- State synchronization: Tick-based snapshots

## Module Dependencies

```
editor ──► engine
client ──► engine
server ──► engine
```

All game logic crates depend on the engine crate, which provides shared functionality.

## Data Flow

1. **Input** → Client processes input
2. **Prediction** → Client predicts movement
3. **Network** → Client sends input to server
4. **Authority** → Server simulates authoritative state
5. **Sync** → Server sends state updates to clients
6. **Reconciliation** → Clients reconcile predicted vs actual state
7. **Render** → Client renders interpolated state

## Spell System

Spells are implemented as:
- Components: Spell data and cooldowns
- Systems: Casting logic, projectile movement, collision detection
- Network messages: Spell casting and effects

## Persistence

Server uses sled database for:
- Player progress
- World state
- Match history
