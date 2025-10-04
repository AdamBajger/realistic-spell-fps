# Physics Architecture

## Overview

The physics system is designed around a **shared core** with **authoritative server** and **client-side prediction** for optimal multiplayer experience.

## Component Structure

### 1. Engine Crate (`engine::physics`)

**Purpose**: Shared physics simulation core used by both client and server.

- **`PhysicsWorld`**: The core physics simulation wrapper around Rapier3D
  - Contains all physics state (rigid bodies, colliders, joints)
  - Provides unified `step()` method for advancing simulation
  - Used identically by both client and server to ensure determinism

**Why shared?**: Write physics logic once, use everywhere. Ensures client prediction matches server authority when inputs are the same.

### 2. Server Crate (`server::physics`)

**Purpose**: Authoritative physics simulation - the source of truth.

- **`AuthoritativePhysics`**: Wraps `PhysicsWorld` for server use
  - Runs the definitive physics simulation
  - Broadcasts state to clients
  - Resolves conflicts and validates client inputs
  - Collision detection included (Rapier handles it internally)

**Why separate?**: Server is the authority. It validates all inputs and its physics state is the truth that clients must reconcile with.

### 3. Client Crate (`client::physics`)

**Purpose**: Client-side prediction and reconciliation.

- **`ClientPhysics`**: Manages two `PhysicsWorld` instances
  - **`predicted_world`**: Runs ahead of server, predicts local player movement
  - **`confirmed_world`**: Last known authoritative state from server
  - Reconciles prediction with server updates to correct drift

**Why prediction?**: Players need immediate response to inputs. Waiting for server round-trip would feel laggy. Client predicts movement and reconciles when server state arrives.

## Flow

```
User Input -> Client Prediction -> Network -> Server Authority
                    ↓                              ↓
              Display to User                 Broadcast State
                    ↑                              ↓
              Reconciliation  <-  Network  <-  State Update
```

## Benefits

1. **No Code Duplication**: Physics logic in `engine::physics` is shared
2. **Clear Roles**: 
   - Server = Authority (validation, truth)
   - Client = Prediction (responsiveness, reconciliation)
   - Engine = Shared Logic (deterministic simulation)
3. **Extensible**: Easy to add new physics features in one place
4. **Performant**: Client-side prediction eliminates input lag

## LAN Hosting

The server is also compiled as a library (`server` crate exports `lib.rs`), allowing the client to embed the server for LAN game hosting. When the client creates a LAN game, it instantiates `server::AuthoritativePhysics` directly in-process.
