/// Network protocol schema module
use serde::{Deserialize, Serialize};

/// Player input state sent from client to server
/// Contains only raw controller/keyboard state - server calculates actual movement
#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct PlayerInput {
    /// Sequence number for input ordering and reconciliation
    pub sequence: u64d,

    /// Raw movement input (binary controls)
    pub move_forward: bool,
    pub move_backward: bool,
    pub move_left: bool,
    pub move_right: bool,

    /// Camera look delta (mouse movement since last frame)
    pub look_delta_x: f32,
    pub look_delta_y: f32,

    /// Action buttons
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
