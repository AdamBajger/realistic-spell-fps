#!/bin/bash
# Build script for CI
#
# Purpose: Builds all crates in the workspace for continuous integration
# Usage: ./build.sh
#
# Builds performed:
#   1. Debug build (--verbose for detailed output)
#   2. Release build (optimized binaries)
#
# Note: If Cargo.lock is missing, cargo will generate it automatically
# and lock dependencies to their latest compatible versions.

set -e

echo "=== Building workspace ==="
cargo build --workspace --verbose --no-default-features

echo ""
echo "=== Building release binaries ==="
cargo build --workspace --release --verbose --no-default-features

echo ""
echo "Build complete!"
