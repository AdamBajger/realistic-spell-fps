/// Configuration module for server and client settings
use serde::{Deserialize, Serialize};
use std::path::Path;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ServerConfig {
    pub host: String,
    pub port: u16,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ClientConfig {
    pub server_host: String,
    pub server_port: u16,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Config {
    pub server: ServerConfig,
    pub client: ClientConfig,
}

impl Default for ServerConfig {
    fn default() -> Self {
        Self {
            host: "127.0.0.1".to_string(),
            port: 7777,
        }
    }
}

impl Default for ClientConfig {
    fn default() -> Self {
        Self {
            server_host: "127.0.0.1".to_string(),
            server_port: 7777,
        }
    }
}

impl Default for Config {
    fn default() -> Self {
        Self {
            server: ServerConfig::default(),
            client: ClientConfig::default(),
        }
    }
}

impl Config {
    pub fn load_from_file(path: &Path) -> anyhow::Result<Self> {
        let contents = std::fs::read_to_string(path)?;
        let config: Config = toml::from_str(&contents)?;
        Ok(config)
    }

    pub fn load_or_default(path: &Path) -> Self {
        Self::load_from_file(path).unwrap_or_default()
    }

    pub fn save_to_file(&self, path: &Path) -> anyhow::Result<()> {
        let contents = toml::to_string_pretty(self)?;
        std::fs::write(path, contents)?;
        Ok(())
    }
}
