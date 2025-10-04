# Linux Server Dockerfile
FROM rust:1.70-slim-bullseye as builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy workspace files
COPY Cargo.toml Cargo.lock config.toml ./
COPY crates ./crates

# Build the server
RUN cargo build --release -p server --no-default-features

# Runtime stage
FROM debian:bullseye-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl1.1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the built binary and config
COPY --from=builder /app/target/release/server /app/server
COPY --from=builder /app/config.toml /app/config.toml

# Create data directory for persistence
RUN mkdir -p /app/data

EXPOSE 7777

CMD ["/app/server"]
