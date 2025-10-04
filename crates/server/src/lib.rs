/// Server library for authoritative game simulation
/// This library can be used standalone or embedded in the client for LAN hosting
pub mod network;
pub mod physics;
pub mod state;
pub mod persistence;

pub use network::NetworkServer;
pub use physics::AuthoritativePhysics;
pub use state::GameState;
pub use persistence::PersistenceLayer;
