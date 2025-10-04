/// Audio playback system with spatial effects
use glam::Vec3;
use tracing::debug;

/// Parameters for spatial audio effects
#[derive(Debug, Clone)]
pub struct SpatialParams {
    /// Position of the sound source in 3D space
    pub position: Vec3,
    /// Listener position for distance calculations
    pub listener_position: Vec3,
    /// Maximum audible distance
    pub max_distance: f32,
    /// Apply distance-based high-pass filter
    pub distance_filter: bool,
}

impl Default for SpatialParams {
    fn default() -> Self {
        Self {
            position: Vec3::ZERO,
            listener_position: Vec3::ZERO,
            max_distance: 100.0,
            distance_filter: true,
        }
    }
}

/// Parameters for audio playback
#[derive(Debug, Clone)]
pub struct AudioParams {
    /// Volume/loudness (0.0 to 1.0)
    pub volume: f32,
    /// Duration in seconds (None for looping or file-based duration)
    pub duration: Option<f32>,
    /// Loop the audio
    pub looping: bool,
    /// Spatial audio parameters (None for non-positional audio)
    pub spatial: Option<SpatialParams>,
}

impl Default for AudioParams {
    fn default() -> Self {
        Self {
            volume: 1.0,
            duration: None,
            looping: false,
            spatial: None,
        }
    }
}

pub struct AudioSystem {
    // TODO: Audio state and output device
}

impl AudioSystem {
    pub fn new() -> anyhow::Result<Self> {
        debug!("Initializing audio system");
        // TODO: Initialize audio output device
        Ok(Self {})
    }

    /// Play a sound with specified parameters
    /// Simple but flexible - everything is just a sound with configurable parameters
    pub fn play(&mut self, _sound_id: &str, _params: AudioParams) {
        // TODO: Play sound with given parameters
        // - Apply volume
        // - Set duration or loop
        // - Apply spatial effects if provided:
        //   - Calculate distance attenuation
        //   - Apply hi/lo pass filters based on distance and position
        //   - Pan based on position relative to listener
    }

    /// Convenience method for non-spatial sounds
    pub fn play_simple(&mut self, sound_id: &str, volume: f32) {
        self.play(sound_id, AudioParams {
            volume,
            ..Default::default()
        });
    }

    /// Convenience method for looping background audio (e.g., ambient music)
    pub fn play_looping(&mut self, sound_id: &str, volume: f32) {
        self.play(sound_id, AudioParams {
            volume,
            looping: true,
            ..Default::default()
        });
    }

    /// Convenience method for spatial/3D positioned sounds
    pub fn play_spatial(&mut self, sound_id: &str, volume: f32, spatial: SpatialParams) {
        self.play(sound_id, AudioParams {
            volume,
            spatial: Some(spatial),
            ..Default::default()
        });
    }

    /// Update listener position for spatial audio
    pub fn update_listener(&mut self, _position: Vec3) {
        // TODO: Update listener position for 3D audio calculations
    }
}

impl Default for AudioSystem {
    fn default() -> Self {
        Self::new().expect("Failed to initialize audio system")
    }
}

