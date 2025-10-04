/// Physics core utilities and shared simulation logic
/// This module provides the authoritative physics simulation that can be used
/// by both server (as source of truth) and client (for prediction/interpolation)
pub use rapier3d::prelude::*;
use tracing::debug;

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

/// Shared physics simulation world
/// This is the core physics simulation used by both client and server.
/// Server runs this authoritatively, client uses it for prediction and reconciliation.
pub struct PhysicsWorld {
    pub gravity: Vector<Real>,
    pub integration_parameters: IntegrationParameters,
    pub physics_pipeline: PhysicsPipeline,
    pub island_manager: IslandManager,
    pub broad_phase: BroadPhase,
    pub narrow_phase: NarrowPhase,
    pub rigid_body_set: RigidBodySet,
    pub collider_set: ColliderSet,
    pub impulse_joint_set: ImpulseJointSet,
    pub multibody_joint_set: MultibodyJointSet,
    pub ccd_solver: CCDSolver,
}

impl PhysicsWorld {
    pub fn new(config: PhysicsConfig) -> Self {
        debug!("Initializing physics world");
        let mut integration_parameters = IntegrationParameters::default();
        integration_parameters.dt = config.time_step;
        
        Self {
            gravity: config.gravity,
            integration_parameters,
            physics_pipeline: PhysicsPipeline::new(),
            island_manager: IslandManager::new(),
            broad_phase: BroadPhase::new(),
            narrow_phase: NarrowPhase::new(),
            rigid_body_set: RigidBodySet::new(),
            collider_set: ColliderSet::new(),
            impulse_joint_set: ImpulseJointSet::new(),
            multibody_joint_set: MultibodyJointSet::new(),
            ccd_solver: CCDSolver::new(),
        }
    }

    /// Step the physics simulation forward by one timestep
    pub fn step(&mut self) {
        self.physics_pipeline.step(
            &self.gravity,
            &self.integration_parameters,
            &mut self.island_manager,
            &mut self.broad_phase,
            &mut self.narrow_phase,
            &mut self.rigid_body_set,
            &mut self.collider_set,
            &mut self.impulse_joint_set,
            &mut self.multibody_joint_set,
            &mut self.ccd_solver,
            None,
            &(),
            &(),
        );
    }
    
    /// Set the timestep for physics simulation
    pub fn set_timestep(&mut self, dt: f32) {
        self.integration_parameters.dt = dt;
    }
}

impl Default for PhysicsWorld {
    fn default() -> Self {
        Self::new(PhysicsConfig::default())
    }
}
