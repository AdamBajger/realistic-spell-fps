/// IO abstractions module
use std::path::Path;

pub struct FileSystem;

impl FileSystem {
    pub fn read_file(_path: &Path) -> anyhow::Result<Vec<u8>> {
        // TODO: Read file from disk
        Ok(vec![])
    }

    pub fn write_file(_path: &Path, _data: &[u8]) -> anyhow::Result<()> {
        // TODO: Write file to disk
        Ok(())
    }
}
