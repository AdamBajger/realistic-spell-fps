/// Level editing tools
use engine::ecs::World;
use serde::{Deserialize, Serialize};
use tracing::debug;

#[derive(Debug, Serialize, Deserialize)]
pub struct Level {
    pub name: String,
    // TODO: Level data
}

impl Level {
    pub fn new(name: String) -> Self {
        debug!("Creating new level: {}", name);
        Self { name }
    }

    pub fn save(&self, path: &str) -> anyhow::Result<()> {
        debug!("Saving level to {}", path);
        let json = serde_json::to_string_pretty(self)?;
        std::fs::write(path, json)?;
        Ok(())
    }

    pub fn load(path: &str) -> anyhow::Result<Self> {
        debug!("Loading level from {}", path);
        let json = std::fs::read_to_string(path)?;
        let level = serde_json::from_str(&json)?;
        Ok(level)
    }
}

impl Default for Level {
    fn default() -> Self {
        Self::new("Untitled".to_string())
    }
}
