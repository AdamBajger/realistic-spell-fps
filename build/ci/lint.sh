#!/bin/bash
# Lint script for CI
#
# Purpose: Checks code quality and formatting for the entire workspace
# Usage: ./lint.sh
#
# Checks performed:
#   1. rustfmt: Ensures consistent code formatting (--check mode)
#   2. clippy: Lints code for common mistakes and improvements
#
# Exit code 0 = no issues, non-zero = formatting or lint errors found

set -e

echo "=== Running rustfmt ==="
cargo fmt --all -- --check

echo ""
echo "=== Running clippy ==="
cargo clippy --workspace --all-targets --all-features -- -D warnings

echo ""
echo "Linting complete!"
