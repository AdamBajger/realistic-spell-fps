# Client Dockerfile
FROM rust:1.75-slim-bullseye as builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy workspace files
COPY Cargo.toml ./
COPY crates ./crates

# Copy Cargo.lock if it exists, otherwise cargo will generate it
COPY Cargo.lock* ./

# Build the client (without default features to avoid audio dependencies in container)
# If Cargo.lock is missing, cargo will generate it and lock dependencies to latest compatible versions
RUN cargo build --release -p client --no-default-features

# Runtime stage
FROM debian:bullseye-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl1.1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the built binary
COPY --from=builder /app/target/release/client /app/client

# Copy assets
COPY assets ./assets

EXPOSE 8080

CMD ["/app/client"]
