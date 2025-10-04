/// Audio system module
#[cfg(feature = "audio")]
pub struct AudioSystem;

#[cfg(feature = "audio")]
impl AudioSystem {
    pub fn new() -> Self {
        Self
    }

    pub fn play_sound(&self, _sound_name: &str) {
        // TODO: Play sound
    }
}

#[cfg(feature = "audio")]
impl Default for AudioSystem {
    fn default() -> Self {
        Self::new()
    }
}
