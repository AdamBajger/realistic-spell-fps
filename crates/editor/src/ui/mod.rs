/// Editor UI module
pub struct EditorUI;

impl EditorUI {
    pub fn new() -> Self {
        Self
    }

    pub fn render(&mut self) {
        // TODO: Render editor UI with egui
    }
}

impl Default for EditorUI {
    fn default() -> Self {
        Self::new()
    }
}
