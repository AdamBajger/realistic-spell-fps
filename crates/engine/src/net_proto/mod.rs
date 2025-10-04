/// Network protocol schema module
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ClientMessage {
    Connect { player_name: String },
    Input { sequence: u32, data: Vec<u8> },
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
