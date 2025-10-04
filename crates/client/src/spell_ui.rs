/// Spell UI system for spell selection, casting, and cooldown visualization
use tracing::debug;

pub struct SpellUI {
    // TODO: UI state
}

impl SpellUI {
    pub fn new() -> Self {
        debug!("Initializing spell UI");
        Self {}
    }

    pub fn render(&self) {
        // TODO: Render spell UI elements
    }
}

impl Default for SpellUI {
    fn default() -> Self {
        Self::new()
    }
}
