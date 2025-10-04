# Windows Server Dockerfile
# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2022 as builder

# Install Rust
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Invoke-WebRequest -Uri 'https://win.rustup.rs' -OutFile 'rustup-init.exe'; `
    .\rustup-init.exe -y --default-toolchain stable; `
    Remove-Item rustup-init.exe

# Add Rust to PATH
RUN $env:Path += ';C:\Users\ContainerAdministrator\.cargo\bin'

WORKDIR /app

# Copy workspace files
COPY Cargo.toml Cargo.lock config.toml ./
COPY crates ./crates

# Build the server
RUN cargo build --release -p server --no-default-features

# Runtime stage
FROM mcr.microsoft.com/windows/nanoserver:ltsc2022

WORKDIR /app

# Copy the built binary and config
COPY --from=builder /app/target/release/server.exe /app/server.exe
COPY --from=builder /app/config.toml /app/config.toml

# Create data directory
RUN mkdir data

EXPOSE 7777

CMD ["server.exe"]
