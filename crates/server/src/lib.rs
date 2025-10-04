pub mod game_logic;
/// Server library for authoritative game simulation
/// This library can be used standalone or embedded in the client for LAN hosting
pub mod net;
pub mod persistence;
pub mod physics;

pub use game_logic::GameLogic;
pub use net::NetworkServer;
pub use persistence::PersistenceLayer;
pub use physics::AuthoritativePhysics;
