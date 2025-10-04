#!/bin/bash
# Test script for CI
# Runs all tests in the workspace

set -e

echo "=== Running tests ==="
cargo test --workspace --verbose

echo ""
echo "=== Running integration tests ==="
cargo test --test '*' --verbose

echo ""
echo "All tests passed!"
