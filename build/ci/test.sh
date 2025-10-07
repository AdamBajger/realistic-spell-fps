#!/bin/bash
# Test script for CI
#
# Purpose: Runs all tests in the workspace for continuous integration
# Usage: ./test.sh
#
# Tests performed:
#   1. Unit tests (cargo test --workspace)
#   2. Integration tests (cargo test --test '*')
#
# All tests run with --verbose for detailed output
# Exit code 0 = all tests passed, non-zero = failures occurred

set -e

echo "=== Running tests ==="
cargo test --workspace --verbose --no-default-features

echo ""
echo "=== Running integration tests ==="
cargo test --test '*' --verbose --no-default-features

echo ""
echo "All tests passed!"
