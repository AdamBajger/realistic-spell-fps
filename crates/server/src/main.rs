use tracing::info;
use engine::config::Config;
use std::path::Path;

mod game_logic;
mod net;
mod physics;
mod player_data;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // Initialize logging
    tracing_subscriber::fmt::init();

    info!("Starting URMOM Server");

    // Load configuration
    let config = Config::load_or_default(Path::new("config.toml"));
    info!("Server config: {}:{}", config.server.host, config.server.port);

    // Initialize network server
    let mut server = net::NetworkServer::new(&config.server.host, config.server.port);

    info!("Server subsystems initialized");

    // Start server (this will run forever)
    server.start().await?;

    Ok(())
}
