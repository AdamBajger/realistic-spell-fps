/// Core game engine library
pub mod config;
pub mod ecs;
pub mod io;
pub mod math;
pub mod net_proto;
pub mod physics_core;

// Legacy module names for backwards compatibility
pub mod physics {
    pub use crate::physics_core::*;
}

pub mod network {
    pub use crate::net_proto::*;
}

pub use bevy_ecs;
pub use glam;
pub use rapier3d;
