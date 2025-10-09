#!/bin/bash
# Linux Container Build Script
#
# This script runs inside the Linux base builder container.
# It builds the binaries and runs tests with the workspace mounted at /workspace.
#
# Expected environment:
#   - Workspace mounted at /workspace
#   - Running inside base-builder-linux container
#   - Outputs binaries to /workspace/target/release/
#
set -e

cd /workspace

echo "=== Container Build Script for Linux ==="
echo "Working directory: $(pwd)"
echo "Rust version: $(rustc --version)"
echo "Cargo version: $(cargo --version)"
echo ""

# Build server binary
echo "=== Building server binary ==="
cargo build --release -p server --no-default-features
echo ""

# Build client binary
echo "=== Building client binary ==="
cargo build --release -p client --no-default-features
echo ""

# Verify binaries exist
echo "=== Verifying binaries ==="
ls -lh target/release/server
ls -lh target/release/client
echo ""

# Run tests
echo "=== Running tests ==="
cargo test --workspace --verbose --no-fail-fast --no-default-features
echo ""

# Check formatting
echo "=== Checking formatting ==="
cargo fmt --all -- --check
echo ""

# Run clippy (continue on error)
echo "=== Running clippy ==="
cargo clippy --workspace --all-targets --no-default-features -- -D warnings || echo "Clippy warnings found (non-blocking)"
echo ""

# Test that binaries run (timeout after 5 seconds)
echo "=== Testing binaries run ==="
timeout 5s ./target/release/server || [ $? -eq 124 ] || [ $? -eq 143 ]
timeout 5s ./target/release/client || [ $? -eq 124 ] || [ $? -eq 143 ]
echo ""

echo "=== Build complete! ==="
echo "Binaries available at:"
echo "  - /workspace/target/release/server"
echo "  - /workspace/target/release/client"
