/// Server-side authoritative physics simulation
/// The server runs the authoritative physics simulation and broadcasts
/// the state to clients for reconciliation.
use engine::physics::{PhysicsConfig, PhysicsWorld};
use tracing::debug;

pub struct AuthoritativePhysics {
    physics_world: PhysicsWorld,
}

impl AuthoritativePhysics {
    pub fn new() -> Self {
        debug!("Initializing authoritative physics (server)");
        Self {
            physics_world: PhysicsWorld::new(PhysicsConfig::default()),
        }
    }

    pub fn with_config(config: PhysicsConfig) -> Self {
        debug!("Initializing authoritative physics with custom config");
        Self {
            physics_world: PhysicsWorld::new(config),
        }
    }

    /// Step the authoritative simulation
    pub fn step(&mut self) {
        self.physics_world.step();
    }

    /// Access the underlying physics world
    pub fn world(&self) -> &PhysicsWorld {
        &self.physics_world
    }

    /// Mutably access the underlying physics world
    pub fn world_mut(&mut self) -> &mut PhysicsWorld {
        &mut self.physics_world
    }
}

impl Default for AuthoritativePhysics {
    fn default() -> Self {
        Self::new()
    }
}
