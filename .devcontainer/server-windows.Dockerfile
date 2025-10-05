# escape=`
# Windows Server Dockerfile  
# Target platform: Windows Server 2022 (for dedicated game servers)
# Note: Can also run on Windows 10/11 Desktop for testing
FROM mcr.microsoft.com/windows/servercore:ltsc2022 as builder

SHELL ["powershell", "-Command"]

# Install Visual Studio Build Tools (required for MSVC linker)
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; `
    Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_buildtools.exe' -OutFile 'vs_buildtools.exe'; `
    Start-Process -Wait -FilePath '.\vs_buildtools.exe' -ArgumentList '--quiet', '--wait', '--norestart', '--nocache', `
        '--installPath', 'C:\BuildTools', `
        '--add', 'Microsoft.VisualStudio.Workload.VCTools', `
        '--add', 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64', `
        '--add', 'Microsoft.VisualStudio.Component.Windows11SDK.22000'; `
    Remove-Item vs_buildtools.exe

# Install Rust using rustup-init.exe (Windows installer)
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    Invoke-WebRequest -Uri 'https://win.rustup.rs/x86_64' -OutFile 'rustup-init.exe'; `
    .\rustup-init.exe -y --default-toolchain stable --profile minimal; `
    Remove-Item rustup-init.exe; `
    $env:PATH = "$env:USERPROFILE\.cargo\bin;$env:PATH"; `
    [Environment]::SetEnvironmentVariable('PATH', "$env:USERPROFILE\.cargo\bin;$([Environment]::GetEnvironmentVariable('PATH', 'Machine'))", 'Machine')

WORKDIR C:\app

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

WORKDIR C:\app

# Copy the built binary and config
COPY --from=builder C:\app\target\release\server.exe C:\app\server.exe
COPY --from=builder C:\app\config.toml C:\app\config.toml

# Create data directory
RUN mkdir data

EXPOSE 7777

CMD ["server.exe"]
