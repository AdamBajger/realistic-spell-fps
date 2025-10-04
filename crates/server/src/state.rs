/// Game state management
use engine::ecs::World;
use serde::{Deserialize, Serialize};
use tracing::debug;

#[derive(Debug, Serialize, Deserialize)]
pub struct GameState {
    // TODO: Game state data
    tick: u64,
}

impl GameState {
    pub fn new() -> Self {
        debug!("Initializing game state");
        Self { tick: 0 }
    }

    pub fn update(&mut self, _world: &mut World) {
        self.tick += 1;
        // TODO: Update game state
    }

    pub fn get_tick(&self) -> u64 {
        self.tick
    }
}

impl Default for GameState {
    fn default() -> Self {
        Self::new()
    }
}
