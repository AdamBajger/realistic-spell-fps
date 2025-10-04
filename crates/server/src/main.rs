use tracing::info;

mod game_logic;
mod net;
mod persistence;
mod physics;

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
