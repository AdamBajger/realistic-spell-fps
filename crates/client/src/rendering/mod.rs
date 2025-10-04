/// Rendering pipeline module
pub struct RenderPipeline;

impl RenderPipeline {
    pub fn new() -> Self {
        Self
    }

    pub fn render_frame(&mut self) {
        // TODO: Render a frame
    }
}

impl Default for RenderPipeline {
    fn default() -> Self {
        Self::new()
    }
}
