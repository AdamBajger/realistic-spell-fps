#!/bin/bash
# Lint script for CI
# Runs rustfmt and clippy on the entire workspace

set -e

echo "=== Running rustfmt ==="
cargo fmt --all -- --check

echo ""
echo "=== Running clippy ==="
cargo clippy --workspace --all-targets --all-features -- -D warnings

echo ""
echo "Linting complete!"
