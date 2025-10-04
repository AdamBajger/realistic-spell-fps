/// Network protocol schema module
use serde::{Deserialize, Serialize};
use glam::Vec3;

/// Player input state sent from client to server
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PlayerInput {
    pub sequence: u32,
    pub movement: Vec3,  // WASD movement vector
    pub look_direction: Vec3,  // Camera/aim direction
    pub actions: PlayerActions,
}

#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct PlayerActions {
    pub jump: bool,
    pub crouch: bool,
    pub cast_spell: bool,
    pub use_item: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ClientMessage {
    Connect { player_name: String },
    Input(PlayerInput),
    Disconnect,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ServerMessage {
    Welcome { player_id: u32 },
    StateUpdate { tick: u32, data: Vec<u8> },
    Disconnect { reason: String },
}

pub fn encode_message<T: Serialize>(msg: &T) -> anyhow::Result<Vec<u8>> {
    Ok(bincode::serialize(msg)?)
}

pub fn decode_message<T: for<'de> Deserialize<'de>>(data: &[u8]) -> anyhow::Result<T> {
    Ok(bincode::deserialize(data)?)
}
