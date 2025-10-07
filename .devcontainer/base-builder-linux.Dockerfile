# Linux Base Builder Image
# This image contains all build dependencies for Rust projects on Linux
# It is built separately and rarely updated (only when build tools need updates)
# Used by: client-linux, server-linux, and other Linux build containers
FROM rust:1.90-slim-bullseye

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Pre-warm cargo registry and git index caches
# This reduces build time for downstream images
RUN cargo search --limit 0 || true

# Set up default cargo config for better caching
RUN mkdir -p /root/.cargo && \
    echo '[net]' > /root/.cargo/config.toml && \
    echo 'git-fetch-with-cli = true' >> /root/.cargo/config.toml
