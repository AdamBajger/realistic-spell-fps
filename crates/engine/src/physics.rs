/// Physics core utilities
pub use rapier3d::prelude::*;

/// Physics configuration
#[derive(Debug, Clone)]
pub struct PhysicsConfig {
    pub gravity: Vector<Real>,
    pub time_step: f32,
}

impl Default for PhysicsConfig {
    fn default() -> Self {
        Self {
            gravity: vector![0.0, -9.81, 0.0],
            time_step: 1.0 / 60.0,
        }
    }
}
