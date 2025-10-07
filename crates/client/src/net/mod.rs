use tokio::io::{AsyncReadExt, AsyncWriteExt};
/// Client-side networking module
use tokio::net::TcpStream;
use tracing::{error, info};

pub struct NetworkClient {
    stream: Option<TcpStream>,
}

impl NetworkClient {
    pub fn new() -> Self {
        Self { stream: None }
    }

    pub async fn connect(&mut self, host: &str, port: u16) -> anyhow::Result<()> {
        let addr = format!("{}:{}", host, port);
        info!("Connecting to server at {}", addr);

        let stream = TcpStream::connect(&addr).await?;
        info!("Connected to server");

        self.stream = Some(stream);
        Ok(())
    }

    pub async fn send_message(&mut self, message: &str) -> anyhow::Result<String> {
        let stream = self
            .stream
            .as_mut()
            .ok_or_else(|| anyhow::anyhow!("Not connected to server"))?;

        // Send message
        stream.write_all(message.as_bytes()).await?;
        info!("Sent: {}", message.trim());

        // Read response
        let mut buffer = [0; 1024];
        let n = stream.read(&mut buffer).await?;

        let response = String::from_utf8_lossy(&buffer[..n]).to_string();
        info!("Received: {}", response.trim());

        Ok(response)
    }

    pub async fn disconnect(&mut self) -> anyhow::Result<()> {
        if let Some(stream) = self.stream.take() {
            drop(stream);
            info!("Disconnected from server");
        }
        Ok(())
    }
}

impl Default for NetworkClient {
    fn default() -> Self {
        Self::new()
    }
}
