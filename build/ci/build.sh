#!/bin/bash
# Build script for CI
# Builds all crates in the workspace

set -e

echo "=== Building workspace ==="
cargo build --workspace --verbose

echo ""
echo "=== Building release binaries ==="
cargo build --workspace --release --verbose

echo ""
echo "Build complete!"
