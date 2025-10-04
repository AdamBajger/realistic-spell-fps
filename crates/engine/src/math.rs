/// Math utilities and types
pub use glam::*;

/// Common math constants
pub const PI: f32 = std::f32::consts::PI;
pub const TAU: f32 = std::f32::consts::TAU;

/// Interpolation utilities
pub fn lerp(a: f32, b: f32, t: f32) -> f32 {
    a + (b - a) * t
}

pub fn lerp_vec3(a: Vec3, b: Vec3, t: f32) -> Vec3 {
    a + (b - a) * t
}

/// Clamp a value between min and max
pub fn clamp(value: f32, min: f32, max: f32) -> f32 {
    value.max(min).min(max)
}
