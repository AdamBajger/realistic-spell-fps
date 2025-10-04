#!/bin/bash
# Shader compilation script
# Compiles GLSL shaders to SPIR-V using glslc

set -e

SHADER_DIR="assets/shaders"
OUTPUT_DIR="assets/shaders/compiled"

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "Compiling shaders..."

# Check if glslc is available
if ! command -v glslc &> /dev/null; then
    echo "Error: glslc not found. Please install the Vulkan SDK."
    echo "Visit: https://vulkan.lunarg.com/"
    exit 1
fi

# Compile vertex shaders
if [ -d "$SHADER_DIR/vertex" ]; then
    for shader in "$SHADER_DIR"/vertex/*.vert; do
        if [ -f "$shader" ]; then
            filename=$(basename "$shader" .vert)
            echo "  Compiling $filename.vert -> $filename.vert.spv"
            glslc "$shader" -o "$OUTPUT_DIR/$filename.vert.spv"
        fi
    done
fi

# Compile fragment shaders
if [ -d "$SHADER_DIR/fragment" ]; then
    for shader in "$SHADER_DIR"/fragment/*.frag; do
        if [ -f "$shader" ]; then
            filename=$(basename "$shader" .frag)
            echo "  Compiling $filename.frag -> $filename.frag.spv"
            glslc "$shader" -o "$OUTPUT_DIR/$filename.frag.spv"
        fi
    done
fi

# Compile compute shaders
if [ -d "$SHADER_DIR/compute" ]; then
    for shader in "$SHADER_DIR"/compute/*.comp; do
        if [ -f "$shader" ]; then
            filename=$(basename "$shader" .comp)
            echo "  Compiling $filename.comp -> $filename.comp.spv"
            glslc "$shader" -o "$OUTPUT_DIR/$filename.comp.spv"
        fi
    done
fi

echo "Shader compilation complete!"
