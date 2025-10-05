# escape=`
# Windows Server Dockerfile  
# Target platform: Windows Server 2022 (for dedicated game servers)
# Note: Can also run on Windows 10/11 Desktop for testing
FROM mcr.microsoft.com/windows/servercore:ltsc2022 as builder

# Install Visual Studio Build Tools (required for MSVC linker)
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_buildtools.exe' -OutFile 'vs_buildtools.exe'; `
    Start-Process -Wait -FilePath '.\vs_buildtools.exe' -ArgumentList '--quiet', '--wait', '--norestart', '--nocache', `
        '--installPath', 'C:\BuildTools', `
        '--add', 'Microsoft.VisualStudio.Workload.VCTools', `
        '--add', 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64', `
        '--add', 'Microsoft.VisualStudio.Component.Windows11SDK.22000'; `
    Remove-Item vs_buildtools.exe

# Install Rust
RUN Invoke-WebRequest -Uri 'https://win.rustup.rs' -OutFile 'rustup-init.exe'; `
    .\rustup-init.exe -y --default-toolchain stable-x86_64-pc-windows-msvc; `
    Remove-Item rustup-init.exe

# Add Rust and MSVC to PATH
ENV PATH="C:\Users\ContainerAdministrator\.cargo\bin;C:\BuildTools\VC\Tools\MSVC\14.29.30133\bin\Hostx64\x64;C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;${PATH}"

WORKDIR /app

# Copy workspace files
COPY Cargo.toml config.toml ./
COPY Cargo.lock ./
COPY crates ./crates

# Build the server (with Cargo.lock for reproducible builds)
# If Cargo.lock is missing, cargo will generate it and lock dependencies to latest compatible versions
RUN cargo build --release -p server --no-default-features

# Runtime stage - minimal Windows container
# Suitable for Windows Server 2022 or Windows 10/11 Desktop
FROM mcr.microsoft.com/windows/nanoserver:ltsc2022

WORKDIR /app

# Copy the built binary and config
COPY --from=builder /app/target/release/server.exe /app/server.exe
COPY --from=builder /app/config.toml /app/config.toml

# Create data directory
RUN mkdir data

EXPOSE 7777

CMD ["server.exe"]
