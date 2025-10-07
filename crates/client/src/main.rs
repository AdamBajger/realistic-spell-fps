use engine::config::Config;
use std::path::Path;
use tracing::info;

mod assets;
mod gameplay;
mod input;
mod net;
mod physics;
mod renderer_vk;
mod rendering;
mod ui;

#[cfg(feature = "audio")]
mod audio;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // Initialize logging
    tracing_subscriber::fmt::init();

    info!("Starting URMOM Client");

    // Load configuration
    let config = Config::load_or_default(Path::new("config.toml"));
    info!(
        "Client config: connecting to {}:{}",
        config.client.server_host, config.client.server_port
    );

    // Initialize network client
    let mut client = net::NetworkClient::new();

    // Try to connect to server
    match client
        .connect(&config.client.server_host, config.client.server_port)
        .await
    {
        Ok(_) => {
            info!("Successfully connected to server");

            // Send test message
            if let Ok(response) = client.send_message("HELLO\n").await {
                info!("Server responded: {}", response.trim());
            }

            client.disconnect().await?;
        }
        Err(e) => {
            info!("Could not connect to server: {}", e);
            info!("Client can run in offline mode");
        }
    }

    #[cfg(feature = "audio")]
    {
        info!("Audio system enabled");
        // TODO: Initialize audio system
    }

    #[cfg(feature = "lan-host")]
    {
        info!("LAN hosting capability enabled - can host local servers");
        // TODO: Add logic to optionally start embedded server for LAN games
    }

    info!("Client subsystems initialized");

    // TODO: Main game loop

    Ok(())
}
