/// Network protocol definitions
use serde::{Deserialize, Serialize};

/// Common message types for client-server communication
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum Message {
    /// Player input message
    PlayerInput {
        tick: u64,
        movement: glam::Vec3,
        look: glam::Vec2,
    },
    /// World state snapshot
    WorldState {
        tick: u64,
        // TODO: Add state data
    },
    /// Player connected
    PlayerJoined { player_id: u64 },
    /// Player disconnected
    PlayerLeft { player_id: u64 },
}

/// Serialize a message to bytes
pub fn serialize_message(message: &Message) -> Result<Vec<u8>, bincode::Error> {
    bincode::serialize(message)
}

/// Deserialize a message from bytes
pub fn deserialize_message(bytes: &[u8]) -> Result<Message, bincode::Error> {
    bincode::deserialize(bytes)
}
