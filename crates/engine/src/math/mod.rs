/// Math utilities module
pub use glam;

// Re-export commonly used math types
pub use glam::{Mat4, Quat, Vec2, Vec3, Vec4};

/// Common math constants and utilities
pub const EPSILON: f32 = 1e-6;

pub fn lerp(a: f32, b: f32, t: f32) -> f32 {
    a + (b - a) * t
}
