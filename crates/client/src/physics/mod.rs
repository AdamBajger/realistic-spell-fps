/// Client-side physics prediction and reconciliation
use engine::physics::PhysicsWorld;

pub struct ClientPhysics {
    predicted_world: PhysicsWorld,
    confirmed_world: PhysicsWorld,
}

impl ClientPhysics {
    pub fn new() -> Self {
        Self {
            predicted_world: PhysicsWorld::new(),
            confirmed_world: PhysicsWorld::new(),
        }
    }

    pub fn predict(&mut self, _delta_time: f32) {
        // TODO: Run prediction step
    }

    pub fn reconcile(&mut self) {
        // TODO: Reconcile with server state
    }
}

impl Default for ClientPhysics {
    fn default() -> Self {
        Self::new()
    }
}
