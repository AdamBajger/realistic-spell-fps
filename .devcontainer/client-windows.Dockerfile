# escape=`
# ===========================================
# Realistic Spell FPS - Windows Client Build
# ===========================================
# Target: Windows 10/11 desktop
# Base:   Windows Server Core (compatible with desktop runtime)
# Notes:  Readable version optimized for clarity over build efficiency
# ===========================================

FROM mcr.microsoft.com/windows/servercore:ltsc2022 AS builder

# Use PowerShell as default shell
SHELL ["powershell", "-Command"]

# ------------------------------
# Step 1: Install Visual Studio Build Tools
# ------------------------------
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; `
    Write-Host 'Downloading Visual Studio Build Tools installer...'; `
    Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_buildtools.exe' -OutFile 'C:\vs_buildtools.exe'

RUN Write-Host 'Installing Visual Studio Build Tools: VCTools...'; `
    Start-Process -Wait -FilePath 'C:\vs_buildtools.exe' -ArgumentList `
        '--quiet', '--wait', '--norestart', '--nocache', `
        '--installPath', 'C:\BuildTools', `
        '--add', 'Microsoft.VisualStudio.Workload.VCTools', `
        '--includeRecommended'; `
    Write-Host '✅ VCTools installation complete.'

RUN Write-Host 'Installing Visual Studio Build Tools: VC.Tools.x86.x64...'; `
    Start-Process -Wait -FilePath 'C:\vs_buildtools.exe' -ArgumentList `
        '--quiet', '--wait', '--norestart', '--nocache', `
        '--installPath', 'C:\BuildTools', `
        '--add', 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64', `
        '--includeRecommended'; `
    Write-Host '✅ VC.Tools.x86.x64 installation complete.'

RUN Write-Host 'Installing Visual Studio Build Tools: Windows 11 SDK...'; `
    Start-Process -Wait -FilePath 'C:\vs_buildtools.exe' -ArgumentList `
        '--quiet', '--wait', '--norestart', '--nocache', `
        '--installPath', 'C:\BuildTools', `
        '--add', 'Microsoft.VisualStudio.Component.Windows11SDK.26100', `
        '--includeRecommended'; `
    Write-Host '✅ Windows 11 SDK installation complete.'

RUN Remove-Item 'C:\vs_buildtools.exe' -Force

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
# Step 3: Confirm Rust installation
# ------------------------------
RUN rustc --version; cargo --version

# ------------------------------
# Step 4: Prepare workspace
# ------------------------------
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
