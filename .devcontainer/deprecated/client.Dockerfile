# Client Dockerfile
# Uses base builder image for consistent build environment
# Base image: ghcr.io/adambajger/realistic-spell-fps/base-builder-linux or docker.io/adambajger/realistic-spell-fps-base-builder-linux
ARG BASE_BUILDER_IMAGE=rust:1.90-slim-bullseye
FROM ${BASE_BUILDER_IMAGE} as builder

WORKDIR /app

# Copy workspace files
COPY Cargo.toml ./
COPY crates ./crates

# Copy Cargo.lock if it exists, otherwise cargo will generate it
COPY Cargo.lock* ./

# Build only the client binary
# If Cargo.lock is missing, cargo will generate it and lock dependencies to latest compatible versions
RUN cargo build --release -p client --no-default-features

# Runtime stage - minimal container with only the binary
FROM debian:bullseye-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl1.1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the built binary from builder
COPY --from=builder /app/target/release/client /app/client

# Copy assets
COPY assets ./assets

EXPOSE 8080

CMD ["/app/client"]
