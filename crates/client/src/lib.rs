/// Client library for game client functionality
pub mod assets;
pub mod gameplay;
pub mod input;
pub mod net;
pub mod physics;
pub mod renderer_vk;
pub mod rendering;
pub mod ui;

#[cfg(feature = "audio")]
pub mod audio;

pub use net::NetworkClient;
