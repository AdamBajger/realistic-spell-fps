use tracing::info;

mod network;
mod physics;
mod state;
mod persistence;

fn main() -> anyhow::Result<()> {
    // Initialize logging
    tracing_subscriber::fmt::init();

    info!("Starting Realistic Spell FPS Server");

    // TODO: Initialize all subsystems
    // - Network server
    // - Authoritative physics (includes collision detection)
    // - Game state management
    // - Persistence layer

    info!("Server subsystems initialized");
    
    // TODO: Start server loop
    
    Ok(())
}
