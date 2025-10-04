/// Client-side physics with prediction and reconciliation
/// The client runs physics prediction locally and reconciles with
/// authoritative server state when updates arrive.
use engine::physics::{PhysicsConfig, PhysicsWorld};
use tracing::debug;

pub struct ClientPhysics {
    /// Predicted physics state (runs ahead of server)
    predicted_world: PhysicsWorld,
    /// Last confirmed state from server (for reconciliation)
    confirmed_world: PhysicsWorld,
}

impl ClientPhysics {
    pub fn new() -> Self {
        debug!("Initializing client physics with prediction");
        Self {
            predicted_world: PhysicsWorld::new(PhysicsConfig::default()),
            confirmed_world: PhysicsWorld::new(PhysicsConfig::default()),
        }
    }

    /// Step the predicted physics forward
    pub fn step_prediction(&mut self) {
        self.predicted_world.step();
    }

    /// Update confirmed state from server and reconcile
    pub fn reconcile_with_server(&mut self) {
        // TODO: Implement state reconciliation
        // Compare predicted_world with confirmed_world
        // Apply corrections if divergence is significant
        debug!("Reconciling client prediction with server state");
    }

    /// Access the predicted physics world
    pub fn predicted(&self) -> &PhysicsWorld {
        &self.predicted_world
    }

    /// Mutably access the predicted physics world
    pub fn predicted_mut(&mut self) -> &mut PhysicsWorld {
        &mut self.predicted_world
    }

    /// Access the confirmed physics world
    pub fn confirmed(&self) -> &PhysicsWorld {
        &self.confirmed_world
    }

    /// Mutably access the confirmed physics world
    pub fn confirmed_mut(&mut self) -> &mut PhysicsWorld {
        &mut self.confirmed_world
    }
}

impl Default for ClientPhysics {
    fn default() -> Self {
        Self::new()
    }
}
