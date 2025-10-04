# Networking Architecture

## Overview

URMOM uses a client-server architecture with authoritative server simulation and client-side prediction.

## Network Protocol

### Transport

- **Protocol**: TCP for reliable message delivery
- **Library**: tokio for async I/O
- **Serialization**: bincode for efficient binary encoding

### Message Types

#### Client → Server

```rust
pub enum ClientMessage {
    Connect { player_name: String },
    Input { sequence: u32, data: Vec<u8> },
    Disconnect,
}
```

#### Server → Client

```rust
pub enum ServerMessage {
    Welcome { player_id: u32 },
    StateUpdate { tick: u32, data: Vec<u8> },
    Disconnect { reason: String },
}
```

## Client-Side Prediction

The client runs a local physics simulation to provide immediate feedback to player inputs:

1. **Input**: Player presses a key
2. **Prediction**: Client immediately applies input to local physics world
3. **Send**: Client sends input to server with sequence number
4. **Render**: Client renders predicted state
5. **Receive**: Server sends authoritative state update
6. **Reconciliation**: Client compares predicted vs actual state and corrects drift

## Server Authority

The server is the single source of truth:

- Validates all client inputs
- Runs authoritative physics simulation
- Detects and prevents cheating
- Broadcasts state updates to all clients

## State Synchronization

### Tick-Based Updates

- Server runs at fixed 60 Hz tick rate
- Each tick, server:
  1. Processes client inputs
  2. Steps physics simulation
  3. Updates game state
  4. Sends state snapshot to clients

### Delta Compression

Future optimization: Only send changed state to reduce bandwidth.

## Latency Handling

### Client-Side

- **Prediction**: Immediate response to inputs
- **Interpolation**: Smooth rendering between state updates
- **Reconciliation**: Correct prediction errors smoothly

### Server-Side

- **Input Buffering**: Queue inputs and process in order
- **Lag Compensation**: Account for RTT when validating actions

## LAN Hosting

The client can embed the server for local games:

```rust
// Client with lan-host feature enabled
#[cfg(feature = "lan-host")]
{
    let server = server::Server::new();
    server.start_local()?;
}
```

This allows:
- Playing offline
- Hosting local multiplayer games
- Testing without dedicated server

## Security Considerations

- Input validation on server
- Rate limiting for actions
- Cheat detection through physics validation
- Encrypted connections (future: TLS)

## Performance

- Binary protocol reduces bandwidth
- Async I/O handles many concurrent connections
- Efficient serialization with bincode
- Delta compression (planned)

## Monitoring

Future: Add metrics for:
- Round-trip time (RTT)
- Packet loss
- Bandwidth usage
- Server tick rate stability
