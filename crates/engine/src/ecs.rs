/// Entity Component System abstractions
pub use bevy_ecs::prelude::*;

/// Re-export World for convenience
pub type World = bevy_ecs::world::World;

/// Common component types
#[derive(Component, Debug, Clone, Copy)]
pub struct Transform {
    pub position: glam::Vec3,
    pub rotation: glam::Quat,
    pub scale: glam::Vec3,
}

impl Default for Transform {
    fn default() -> Self {
        Self {
            position: glam::Vec3::ZERO,
            rotation: glam::Quat::IDENTITY,
            scale: glam::Vec3::ONE,
        }
    }
}

#[derive(Component, Debug, Clone, Copy)]
pub struct Velocity {
    pub linear: glam::Vec3,
    pub angular: glam::Vec3,
}

impl Default for Velocity {
    fn default() -> Self {
        Self {
            linear: glam::Vec3::ZERO,
            angular: glam::Vec3::ZERO,
        }
    }
}
