# escape=`
# ===========================================
# Realistic Spell FPS - Dedicated Server Build
# ===========================================
# Uses base builder image for consistent build environment
# Base image: ghcr.io/adambajger/realistic-spell-fps/base-builder-windows or docker.io/adambajger/realistic-spell-fps-base-builder-windows
# ===========================================

ARG BASE_BUILDER_IMAGE=mcr.microsoft.com/windows/servercore:ltsc2022
FROM ${BASE_BUILDER_IMAGE} AS builder

WORKDIR C:\app

COPY Cargo.toml config.toml ./
COPY Cargo.lock ./
COPY crates ./crates

# ------------------------------
# Step 5: Build Server Binary
# ------------------------------
RUN cargo build --release -p server --no-default-features

# ===========================================
# Runtime Stage
# ===========================================
FROM mcr.microsoft.com/windows/nanoserver:ltsc2022 AS runtime

WORKDIR C:\app

# Copy built binary and config
COPY --from=builder C:\app\target\release\server.exe C:\app\server.exe
COPY --from=builder C:\app\config.toml C:\app\config.toml

# Create writable data directory
RUN mkdir data

EXPOSE 7777

CMD ["server.exe"]
