use tracing::info;

mod scene;
mod tools;
mod ui;

fn main() -> anyhow::Result<()> {
    // Initialize logging
    tracing_subscriber::fmt::init();

    info!("Starting Realistic Spell FPS Editor");

    // TODO: Initialize editor UI
    // - Level editor tools
    // - Asset browser
    // - Entity inspector
    // - Viewport

    info!("Editor initialized");

    // TODO: Start editor event loop

    Ok(())
}
