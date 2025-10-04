/// Editor tools module
pub struct EditorTools;

impl EditorTools {
    pub fn new() -> Self {
        Self
    }

    pub fn select_tool(&mut self, _tool_name: &str) {
        // TODO: Select editor tool
    }
}

impl Default for EditorTools {
    fn default() -> Self {
        Self::new()
    }
}
