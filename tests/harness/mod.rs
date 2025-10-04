/// Test harness utilities for integration tests
use std::process::{Child, Command};
use std::time::Duration;

pub struct TestServer {
    process: Option<Child>,
    port: u16,
}

impl TestServer {
    pub fn start(port: u16) -> anyhow::Result<Self> {
        let process = Command::new("cargo")
            .args(&["run", "-p", "server"])
            .spawn()?;
        
        // Wait for server to start
        std::thread::sleep(Duration::from_secs(1));
        
        Ok(Self {
            process: Some(process),
            port,
        })
    }
    
    pub fn port(&self) -> u16 {
        self.port
    }
}

impl Drop for TestServer {
    fn drop(&mut self) {
        if let Some(mut process) = self.process.take() {
            let _ = process.kill();
        }
    }
}

pub struct TestClient {
    process: Option<Child>,
}

impl TestClient {
    pub fn start() -> anyhow::Result<Self> {
        let process = Command::new("cargo")
            .args(&["run", "-p", "client"])
            .spawn()?;
        
        // Wait for client to start
        std::thread::sleep(Duration::from_secs(1));
        
        Ok(Self {
            process: Some(process),
        })
    }
}

impl Drop for TestClient {
    fn drop(&mut self) {
        if let Some(mut process) = self.process.take() {
            let _ = process.kill();
        }
    }
}
