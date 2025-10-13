# Dev Container Setup Guide

Complete guide for setting up a development environment using VS Code Dev Containers for the Realistic Spell FPS project.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Linux Setup](#linux-setup)
- [Windows Setup](#windows-setup)
- [Building Dev Container Images](#building-dev-container-images)
- [Opening the Project in Dev Container](#opening-the-project-in-dev-container)
- [Optional: SSH Agent Configuration](#optional-ssh-agent-configuration)
- [Optional: GPG Signing Configuration](#optional-gpg-signing-configuration)

---

## Prerequisites

Dev Containers provide a consistent, pre-configured development environment that runs inside Docker containers. You'll need:

- **Visual Studio Code** - Download from https://code.visualstudio.com/
- **Dev Containers Extension** - Install from VS Code marketplace
- **Docker Engine** (Linux) or **Docker Desktop** (Windows)
- **Git** - For cloning the repository

---

## Linux Setup

### 1. Install Docker Engine

**Ubuntu/Debian:**
```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install ca-certificates curl

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin
```

**Fedora:**
```bash
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin
```

**Arch Linux:**
```bash
sudo pacman -S docker
```

### 2. Configure Docker for Non-Root Access

```bash
# Create docker group (may already exist)
sudo groupadd docker

# Add your user to the docker group
sudo usermod -aG docker $USER

# Log out and back in for group changes to take effect
# Or run: newgrp docker

# Verify Docker works without sudo
docker run hello-world
```

### 3. Enable Docker Service

```bash
# Enable Docker to start on boot
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Start Docker now
sudo systemctl start docker.service
```

### 4. Install Visual Studio Code

**Ubuntu/Debian:**
```bash
# Download .deb package
wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'

# Install
sudo dpkg -i vscode.deb
sudo apt-get install -f  # Fix any dependency issues

# Or use snap
sudo snap install --classic code
```

**Fedora:**
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install code
```

### 5. Install Dev Containers Extension

Open VS Code:
1. Press `Ctrl+Shift+X` to open Extensions
2. Search for "Dev Containers"
3. Click Install on "Dev Containers" by Microsoft

---

## Windows Setup

### 1. Enable WSL 2 (Windows Subsystem for Linux)

Open PowerShell as Administrator and run:

```powershell
# Enable WSL and Virtual Machine Platform
wsl --install

# Restart your computer when prompted
```

After restart, set WSL 2 as default:

```powershell
wsl --set-default-version 2
```

Install a Linux distribution from Microsoft Store (Ubuntu 22.04 LTS recommended).

### 2. Install Docker Desktop

1. Download Docker Desktop for Windows from https://www.docker.com/products/docker-desktop/
2. Run the installer
3. **Important:** During installation, ensure **"Use WSL 2 instead of Hyper-V"** is selected
4. Restart when prompted

> **Note on Hyper-V:** You could also use the Hyper-V install to run Windows containers, but this approach is not yet documented and is not planned to be documented in the near future. Building inside Windows containers is a long-term goal in this project and will be documented eventually.

### 3. Configure Docker Desktop

1. Open Docker Desktop
2. Go to Settings (gear icon)
3. Navigate to **Resources** → **WSL Integration**
4. Enable integration with your WSL distro (e.g., Ubuntu)
5. Click "Apply & Restart"

### 4. Install Visual Studio Code

1. Download VS Code from https://code.visualstudio.com/
2. Run the installer
3. During installation, select:
   - ✅ Add "Open with Code" action to Windows Explorer file context menu
   - ✅ Add "Open with Code" action to Windows Explorer directory context menu
   - ✅ Add to PATH

### 5. Install Dev Containers Extension

Open VS Code:
1. Press `Ctrl+Shift+X` to open Extensions
2. Search for "Dev Containers"
3. Click Install on "Dev Containers" by Microsoft

---

## Building Dev Container Images

Before opening the project in a dev container, you need to build the dev container images locally.

### Linux

```bash
cd realistic-spell-fps
./scripts/dev-setup/build-devcontainer.sh
```

### Windows

Open PowerShell in the project directory:

```powershell
cd realistic-spell-fps
.\scripts\dev-setup\build-devcontainer.ps1
```

This script will check if the dev container images are ready and build them locally if they're not already available.

---

## Opening the Project in Dev Container

### Clone the Repository

```bash
git clone https://github.com/AdamBajger/realistic-spell-fps.git
cd realistic-spell-fps
```

### Open in Dev Container

1. Open VS Code
2. Open the cloned repository folder (File → Open Folder or `Ctrl+K Ctrl+O`)
3. When prompted "Folder contains a Dev Container configuration file. Reopen folder to develop in a container", click **Reopen in Container**
4. If not prompted automatically: Press `F1` → type "Dev Containers: Reopen in Container" → Enter

The first time you open the project in a container, it will take a few minutes to set up the environment. Subsequent opens will be much faster.

---

## Optional: SSH Agent Configuration

VS Code Dev Containers extension automatically forwards your SSH agent to the container. You just need to ensure SSH agent is running on your host machine and has your keys loaded.

### Linux

```bash
# Start ssh-agent if not already running
eval "$(ssh-agent -s)"

# Add your SSH key
ssh-add ~/.ssh/id_rsa  # or your key file

# Verify keys are loaded
ssh-add -l
```

The Dev Containers extension will automatically detect and forward your SSH agent.

**Useful Links:**
- GitHub SSH Documentation: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- VS Code SSH Keys in Containers: https://code.visualstudio.com/docs/devcontainers/containers#_using-ssh-keys

### Windows

Enable and start the SSH agent service in PowerShell (as Administrator):

```powershell
# Set ssh-agent to start automatically
Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service

# Verify the service is running
Get-Service ssh-agent
```

Then add your SSH key:

```powershell
# Add your SSH key (run in regular PowerShell)
ssh-add $env:USERPROFILE\.ssh\id_rsa  # or your key file

# Verify keys are loaded
ssh-add -l
```

The Dev Containers extension will automatically forward the Windows SSH agent to the container.

---

## Optional: GPG Signing Configuration

VS Code Dev Containers extension automatically forwards your GPG agent to the container. You just need to ensure GPG is installed and configured on your host machine.

### Linux

**1. Install GPG (if not already installed):**

```bash
# Ubuntu/Debian
sudo apt-get install gnupg

# Fedora
sudo dnf install gnupg2

# Arch Linux
sudo pacman -S gnupg
```

**2. Generate GPG Key (if you don't have one):**

```bash
# Generate a new GPG key
gpg --full-generate-key

# Follow the prompts:
# - Kind: (1) RSA and RSA (default)
# - Key size: 4096
# - Expiration: 0 (doesn't expire) or choose your preference
# - Real name: Your Name
# - Email: your@email.com

# List your GPG keys
gpg --list-secret-keys --keyid-format LONG

# Export your public key (replace KEY_ID with your actual key ID)
gpg --armor --export KEY_ID
```

**3. Configure Git to Use GPG:**

```bash
# Set your GPG key for Git (replace KEY_ID)
git config --global user.signingkey KEY_ID

# Enable commit signing by default
git config --global commit.gpgsign true
```

**4. Ensure GPG agent is running:**

```bash
# Start GPG agent (usually starts automatically)
gpg-agent --daemon

# Verify GPG agent is running
gpg-connect-agent /bye
```

The Dev Containers extension will automatically forward your GPG agent to the container.

### Windows

**1. Install Gpg4win:**

Download and install from https://www.gpg4win.org/

**2. Set up GPG agent in PowerShell:**

```powershell
# Start GPG agent (Gpg4win includes gpg-agent)
# The agent should start automatically with Gpg4win installation

# Verify GPG is installed
gpg --version
```

**3. Generate GPG Key (if you don't have one):**

Open PowerShell and run:

```powershell
# Generate a new GPG key
gpg --full-generate-key

# Follow the prompts (same as Linux above)

# List your GPG keys
gpg --list-secret-keys --keyid-format LONG

# Export your public key (replace KEY_ID with your actual key ID)
gpg --armor --export KEY_ID
```

**4. Configure Git to Use GPG:**

```powershell
# Set your GPG key for Git (replace KEY_ID)
git config --global user.signingkey KEY_ID

# Enable commit signing by default
git config --global commit.gpgsign true

# Tell Git where to find GPG (usually automatic with Gpg4win)
git config --global gpg.program "C:\Program Files (x86)\GnuPG\bin\gpg.exe"
```

The Dev Containers extension will automatically forward your GPG agent to the container.

### Add GPG Public Key to GitHub

Add the public key to your GitHub account: https://github.com/settings/keys

**Useful Links:**
- GitHub GPG Key Generation: https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
- Git Signing Your Work: https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work

---

## Summary

You're now ready to develop in a consistent, containerized environment! The dev container includes:
- Rust toolchain
- Build dependencies
- Development tools (rustfmt, clippy, rust-analyzer)
- Project-specific configurations

All builds, tests, and development happen inside the container, ensuring consistency across different developer machines and CI/CD pipelines.
