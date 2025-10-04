/// Authoritative server physics simulation
use engine::physics::PhysicsWorld;

pub struct AuthoritativePhysics {
    world: PhysicsWorld,
}

impl AuthoritativePhysics {
    pub fn new() -> Self {
        Self {
            world: PhysicsWorld::new(),
        }
    }

    pub fn step(&mut self, delta_time: f32) {
        self.world.step(delta_time);
    }

    pub fn validate_input(&self, _input: &str) -> bool {
        // TODO: Validate client input
        true
    }
}

impl Default for AuthoritativePhysics {
    fn default() -> Self {
        Self::new()
    }
}
