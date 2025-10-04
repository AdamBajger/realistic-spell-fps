/// Input handling system for keyboard, mouse, and gamepad
use tracing::debug;

pub struct InputManager {
    // TODO: Input state tracking
}

impl InputManager {
    pub fn new() -> Self {
        debug!("Initializing input manager");
        Self {}
    }

    pub fn update(&mut self) {
        // TODO: Process input events
    }
}

impl Default for InputManager {
    fn default() -> Self {
        Self::new()
    }
}
