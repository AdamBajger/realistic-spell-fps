# Linux Builder Dockerfile
# This builds ALL binaries for Linux in one stage to maximize build cache efficiency
# Other Dockerfiles can copy binaries from this image
# Uses base builder image for consistent build environment
ARG BASE_BUILDER_IMAGE=rust:1.90-slim-bullseye
FROM ${BASE_BUILDER_IMAGE} as builder


# Copy workspace files
COPY Cargo.toml ./
COPY crates ./crates

# Copy Cargo.lock if it exists, otherwise cargo will generate it
COPY Cargo.lock* ./

# Copy config if it exists
COPY config.toml* ./

# Build ALL workspace binaries in release mode
# Using --no-default-features to avoid audio and other system dependencies
RUN cargo build --release --workspace --no-default-features

# The built binaries are now available in /app/target/release/
# Other Dockerfiles can use this as a base or copy from it

WORKDIR /app