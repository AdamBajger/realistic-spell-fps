/// Asset management module
use std::collections::HashMap;

pub struct AssetManager {
    assets: HashMap<String, Vec<u8>>,
}

impl AssetManager {
    pub fn new() -> Self {
        Self {
            assets: HashMap::new(),
        }
    }

    pub fn load_asset(&mut self, _path: &str) -> anyhow::Result<()> {
        // TODO: Load asset from disk
        Ok(())
    }
}

impl Default for AssetManager {
    fn default() -> Self {
        Self::new()
    }
}
