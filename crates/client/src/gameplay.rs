/// Gameplay systems and game logic
use engine::ecs::World;
use tracing::debug;

pub struct GameplaySystem {
    // TODO: Gameplay state
}

impl GameplaySystem {
    pub fn new() -> Self {
        debug!("Initializing gameplay system");
        Self {}
    }

    pub fn update(&mut self, _world: &mut World, _delta_time: f32) {
        // TODO: Update gameplay logic
    }
}

impl Default for GameplaySystem {
    fn default() -> Self {
        Self::new()
    }
}
