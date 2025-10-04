/// Server-side networking and RPC module
use tokio::net::{TcpListener, TcpStream};
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tracing::{info, error};

pub struct NetworkServer {
    addr: String,
}

impl NetworkServer {
    pub fn new(host: &str, port: u16) -> Self {
        Self {
            addr: format!("{}:{}", host, port),
        }
    }

    pub async fn start(&mut self) -> anyhow::Result<()> {
        let listener = TcpListener::bind(&self.addr).await?;
        info!("Server listening on {}", self.addr);

        loop {
            match listener.accept().await {
                Ok((socket, addr)) => {
                    info!("New connection from: {}", addr);
                    tokio::spawn(async move {
                        if let Err(e) = handle_client(socket).await {
                            error!("Error handling client: {}", e);
                        }
                    });
                }
                Err(e) => {
                    error!("Error accepting connection: {}", e);
                }
            }
        }
    }
}

async fn handle_client(mut socket: TcpStream) -> anyhow::Result<()> {
    let mut buffer = [0; 1024];
    
    loop {
        let n = socket.read(&mut buffer).await?;
        
        if n == 0 {
            // Connection closed
            return Ok(());
        }

        let request = String::from_utf8_lossy(&buffer[..n]);
        info!("Received: {}", request.trim());

        // Simple "Hello World" response
        let response = if request.trim() == "HELLO" {
            "WORLD\n"
        } else if request.trim() == "PING" {
            "PONG\n"
        } else {
            "OK\n"
        };

        socket.write_all(response.as_bytes()).await?;
    }
}

impl Default for NetworkServer {
    fn default() -> Self {
        Self::new("127.0.0.1", 7777)
    }
}
