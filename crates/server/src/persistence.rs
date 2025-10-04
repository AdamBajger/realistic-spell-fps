/// Persistence layer for saving/loading game state
use sled::Db;
use tracing::debug;

pub struct PersistenceLayer {
    db: Option<Db>,
}

impl PersistenceLayer {
    pub fn new(db_path: &str) -> anyhow::Result<Self> {
        debug!("Initializing persistence layer at {}", db_path);
        let db = sled::open(db_path)?;
        Ok(Self { db: Some(db) })
    }

    pub fn save(&self, _key: &str, _value: &[u8]) -> anyhow::Result<()> {
        // TODO: Save data to database
        Ok(())
    }

    pub fn load(&self, _key: &str) -> anyhow::Result<Option<Vec<u8>>> {
        // TODO: Load data from database
        Ok(None)
    }
}

impl Default for PersistenceLayer {
    fn default() -> Self {
        Self::new("./data/server.db").expect("Failed to initialize persistence layer")
    }
}
