/// Server library for authoritative game simulation
/// This library can be used standalone or embedded in the client for LAN hosting
pub mod game_logic;
pub mod net;
pub mod physics;
pub mod player_data;

pub use game_logic::GameLogic;
pub use net::NetworkServer;
pub use physics::AuthoritativePhysics;
pub use player_data::PlayerDataStore;
