# escape=`
# ===========================================
# Realistic Spell FPS - Dedicated Server Build
# ===========================================
# Target: Windows Server 2022 (also compatible with Windows 10/11 Desktop)
# Base:   Windows Server Core (for build compatibility)
# Focus:  Readability and stability over minimal layers
# ===========================================

FROM mcr.microsoft.com/windows/servercore:ltsc2022 AS builder

# Use PowerShell as the default shell
SHELL ["powershell", "-Command"]

# ------------------------------
# Step 1: Install Visual Studio Build Tools (MSVC)
# ------------------------------
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; `
    Write-Host 'Installing Visual Studio Build Tools...'; `
    Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_buildtools.exe' -OutFile 'vs_buildtools.exe'; `
    Start-Process -Wait -FilePath '.\vs_buildtools.exe' -ArgumentList `
        '--quiet', '--wait', '--norestart', '--nocache', `
        '--installPath', 'C:\BuildTools', `
        '--add', 'Microsoft.VisualStudio.Workload.VCTools', `
        '--add', 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64', `
        '--add', 'Microsoft.VisualStudio.Component.Windows11SDK.22000'; `
    Remove-Item 'vs_buildtools.exe'; `
    Write-Host 'Visual Studio Build Tools installation completed.'

# ------------------------------
# Step 2: Install Rust Toolchain via rustup
# ------------------------------
ARG RUST_VERSION=stable

RUN Set-ExecutionPolicy Bypass -Scope Process -Force; `
    Write-Host 'Installing Rust toolchain...'; `
    [System.Net.ServicePointManager]::SecurityProtocol = `
        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    Invoke-WebRequest -Uri 'https://win.rustup.rs/x86_64' -OutFile 'rustup-init.exe'; `
    Start-Process -Wait -FilePath '.\rustup-init.exe' -ArgumentList `
        '-y', '--default-toolchain', $env:RUST_VERSION, '--profile', 'minimal'; `
    Remove-Item 'rustup-init.exe'; `
    $cargoBin = Join-Path $env:USERPROFILE ".cargo\bin"; `
    $newPath = "$cargoBin;$env:PATH"; `
    setx PATH $newPath | Out-Null; `
    $env:PATH = $newPath; `
    Write-Host 'Rust toolchain installed successfully and PATH updated.'

# ------------------------------
# Step 3: Verify Rust Installation
# ------------------------------
RUN rustc --version; cargo --version

# ------------------------------
# Step 4: Prepare Workspace
# ------------------------------
WORKDIR C:\app

COPY Cargo.toml config.toml ./
COPY Cargo.lock ./
COPY crates ./crates

# ------------------------------
# Step 5: Build Server Binary
# ------------------------------
COPY build-rust-msvc.bat ./
RUN cmd /C build-rust-msvc.bat server

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
