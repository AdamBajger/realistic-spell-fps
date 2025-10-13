# escape=`
# ===========================================
# Realistic Spell FPS - Windows Client Build
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
# Step 5: Build Client Binary
# ------------------------------
RUN cargo build --release -p client --no-default-features

# ===========================================
# Runtime Stage
# ===========================================
FROM mcr.microsoft.com/windows/nanoserver:ltsc2022 AS runtime

WORKDIR C:\app

# Copy the binary and configs from builder
COPY --from=builder C:\app\target\release\client.exe C:\app\client.exe
COPY --from=builder C:\app\config.toml C:\app\config.toml
COPY assets ./assets

EXPOSE 8080

CMD ["client.exe"]
