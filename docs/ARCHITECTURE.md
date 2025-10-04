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
│  Prediction │                           │Persistence  │
└─────────────┘                           └─────────────┘
       │                                         │
       │              (can embed server          │
       │               for LAN hosting)          │
       └─────────────┬───────────────────────────┘
                     │
              ┌──────▼──────┐
              │   Engine    │
              │             │
              │    ECS      │
              │    Math     │
              │PhysicsWorld │
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

**See [PHYSICS_ARCHITECTURE.md](./PHYSICS_ARCHITECTURE.md) for detailed physics system design.**

Summary:
- **Shared Core**: Engine provides `PhysicsWorld` used by both client and server
- **Server Authority**: Server runs authoritative `AuthoritativePhysics` simulation
- **Client Prediction**: Client runs `ClientPhysics` with prediction and reconciliation
- **No Duplication**: Physics logic written once in engine, used everywhere
- **Collision**: Built into Rapier3D physics simulation (no separate system needed)

### Networking

- Protocol: Custom binary protocol over TCP
- Serialization: bincode
- State synchronization: Tick-based snapshots

## Module Dependencies

```
editor ──► engine
client ──► engine
        └► server (optional, for LAN hosting)
server ──► engine
```

- **engine**: Core shared functionality (ECS, math, physics, network protocol)
- **server**: Authoritative game server (also exported as library)
- **client**: Game client with rendering, input, and optional embedded server
- **editor**: Level design and content creation tools

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
