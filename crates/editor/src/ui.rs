/// Editor UI components
use tracing::debug;

pub struct EditorUI {
    // TODO: UI state
}

impl EditorUI {
    pub fn new() -> Self {
        debug!("Initializing editor UI");
        Self {}
    }

    pub fn render(&mut self) {
        // TODO: Render editor UI
    }
}

impl Default for EditorUI {
    fn default() -> Self {
        Self::new()
    }
}
