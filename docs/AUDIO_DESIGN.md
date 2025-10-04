# Audio System Design

## Philosophy

**KISS Principle**: Everything is just a sound. No artificial distinction between "music" and "sound effects."

## Core API

### Unified `play()` Method

```rust
pub fn play(&mut self, sound_id: &str, params: AudioParams)
```

All audio playback uses a single method with configurable parameters:

### AudioParams

```rust
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
```

### Spatial Audio

For immersive 3D positional audio:

```rust
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
```

**Effects applied automatically**:
- Distance attenuation (volume decreases with distance)
- High-pass/low-pass filters based on distance (distant sounds are muffled)
- Panning based on position relative to listener
- Doppler effect (future enhancement)

## Usage Examples

### Simple Sound Effect

```rust
audio.play_simple("explosion", 0.8);
```

### Looping Background Music

```rust
audio.play_looping("ambient_music", 0.3);
```

### 3D Positioned Footstep

```rust
let spatial = SpatialParams {
    position: enemy_position,
    listener_position: player_position,
    max_distance: 50.0,
    distance_filter: true,
};
audio.play_spatial("footstep", 0.6, spatial);
```

### Full Control

```rust
audio.play("spell_cast", AudioParams {
    volume: 0.9,
    duration: Some(2.5),
    looping: false,
    spatial: Some(SpatialParams {
        position: spell_position,
        listener_position: camera_position,
        max_distance: 100.0,
        distance_filter: true,
    }),
});
```

## Design Benefits

1. **Simple**: One concept (sound), one main method (play)
2. **Flexible**: Rich parameter system handles all use cases
3. **Not Restrictive**: Full control when needed, convenience methods for common cases
4. **Immersive**: Spatial audio with distance-based effects built-in
5. **Extensible**: Easy to add new parameters (e.g., pitch, reverb) without API changes
