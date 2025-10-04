# Shaders

GLSL/Vulkan shader source files (compiled to SPIR-V).

## Directory Structure

- `vertex/` - Vertex shaders (`.vert`)
- `fragment/` - Fragment shaders (`.frag`)
- `compute/` - Compute shaders (`.comp`)
- `compiled/` - Compiled SPIR-V (`.spv`) - not committed to git

## Build

Shaders are compiled using `glslc` or similar tools.
See `build/ci/compile_shaders.sh` for the build script.
