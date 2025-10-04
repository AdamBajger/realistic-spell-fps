/// Client-side networking module
pub struct NetworkClient;

impl NetworkClient {
    pub fn new() -> Self {
        Self
    }

    pub async fn connect(&mut self, _addr: &str) -> anyhow::Result<()> {
        // TODO: Connect to server
        Ok(())
    }

    pub async fn send_input(&mut self) -> anyhow::Result<()> {
        // TODO: Send input to server
        Ok(())
    }
}

impl Default for NetworkClient {
    fn default() -> Self {
        Self::new()
    }
}
