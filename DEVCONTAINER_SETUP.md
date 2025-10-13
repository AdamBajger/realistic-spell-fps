# Dev Container Setup Guide

Complete guide for setting up a development environment using VS Code Dev Containers for the Realistic Spell FPS project.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Linux Setup](#linux-setup)
- [Windows Setup](#windows-setup)
- [Opening the Project in Dev Container](#opening-the-project-in-dev-container)
- [Optional: SSH Agent Configuration](#optional-ssh-agent-configuration)
- [Optional: GPG Signing Configuration](#optional-gpg-signing-configuration)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

Dev Containers provide a consistent, pre-configured development environment that runs inside Docker containers. You'll need:

- **Visual Studio Code** - Download from https://code.visualstudio.com/
- **Dev Containers Extension** - Install from VS Code marketplace
- **Docker** - Platform-specific requirements below
- **Git** - For cloning the repository

---

## Linux Setup

### 1. Install Docker Engine

**Ubuntu/Debian:**
```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install ca-certificates curl gnupg

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
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**Fedora:**
```bash
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**Arch Linux:**
```bash
sudo pacman -S docker docker-compose
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

```bash
# Install from command line
code --install-extension ms-vscode-remote.remote-containers

# Or install from VS Code:
# 1. Open VS Code
# 2. Press Ctrl+Shift+X to open Extensions
# 3. Search for "Dev Containers"
# 4. Click Install on "Dev Containers" by Microsoft
```

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
3. During installation, ensure "Use WSL 2 instead of Hyper-V" is selected
4. Restart when prompted

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

Open VS Code and:
1. Press `Ctrl+Shift+X` to open Extensions
2. Search for "Dev Containers"
3. Click Install on "Dev Containers" by Microsoft

Or install from command line:
```powershell
code --install-extension ms-vscode-remote.remote-containers
```

### 6. Install WSL Extension (Optional but Recommended)

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

This allows you to develop in WSL directly from VS Code on Windows.

---

## Opening the Project in Dev Container

### Clone the Repository

**Linux:**
```bash
cd ~
git clone https://github.com/AdamBajger/realistic-spell-fps.git
cd realistic-spell-fps
```

**Windows (in WSL):**
```bash
# Open WSL terminal (e.g., Ubuntu)
cd ~
git clone https://github.com/AdamBajger/realistic-spell-fps.git
cd realistic-spell-fps
```

**Windows (PowerShell - not recommended for dev containers):**
```powershell
cd ~
git clone https://github.com/AdamBajger/realistic-spell-fps.git
cd realistic-spell-fps
```

> **Note:** For best performance on Windows, clone repositories inside WSL filesystem (not `/mnt/c/`), as Docker Desktop on Windows has faster access to WSL filesystem.

### Open in Dev Container

**Method 1: From VS Code UI**
1. Open VS Code
2. Press `Ctrl+K Ctrl+O` (or File → Open Folder)
3. Navigate to the cloned repository
4. When prompted "Folder contains a Dev Container configuration file. Reopen folder to develop in a container", click **Reopen in Container**
5. Or manually: Press `F1` → type "Dev Containers: Reopen in Container" → Enter

**Method 2: From Command Line**
```bash
# Open directory in VS Code
code .

# Then use F1 → "Dev Containers: Reopen in Container"
```

**Method 3: Direct Command**
```bash
# Open directly in container (Linux/WSL)
code --folder-uri vscode-remote://dev-container+$(echo -n "$PWD" | xxd -p | tr -d '\n')/.devcontainer
```

### First Build

The first time you open the dev container:
- Docker will build the container image (takes 5-10 minutes)
- All Rust toolchains and dependencies will be installed
- VS Code extensions will be installed in the container
- Subsequent opens will be much faster (reuses existing image)

You'll see progress in the bottom-right corner of VS Code.

---

## Optional: SSH Agent Configuration

To use SSH keys inside the dev container for Git operations:

### Linux

**1. Start SSH Agent on Host:**
```bash
# Add to ~/.bashrc or ~/.zshrc for automatic startup
eval "$(ssh-agent -s)"

# Add your SSH key
ssh-add ~/.ssh/id_rsa
# Or for ed25519: ssh-add ~/.ssh/id_ed25519

# Verify key is added
ssh-add -l
```

**2. Configure Dev Container:**

The dev container is already configured to forward your SSH agent. Verify with:
```bash
# Inside the container
ssh-add -l
```

If you see "Could not open a connection to your authentication agent":
- Ensure SSH agent is running on host: `ps aux | grep ssh-agent`
- Restart VS Code and reopen in container

**3. Persistent SSH Agent (Recommended):**

Install `keychain` to manage SSH agent across sessions:
```bash
# Ubuntu/Debian
sudo apt-get install keychain

# Add to ~/.bashrc
eval $(keychain --eval --quiet id_rsa)
# Or for ed25519: eval $(keychain --eval --quiet id_ed25519)
```

### Windows (WSL)

**1. Set Up SSH Agent in WSL:**

```bash
# Add to ~/.bashrc
if [ -z "$SSH_AUTH_SOCK" ]; then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
   if [ "$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> $HOME/.ssh/ssh-agent
   fi
   eval `cat $HOME/.ssh/ssh-agent`
fi

# Add your key
ssh-add ~/.ssh/id_rsa
```

**2. Alternative: Use Windows SSH Agent:**

If you prefer using Windows native SSH agent:

```powershell
# In PowerShell (Administrator)
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent

# Add your key
ssh-add $env:USERPROFILE\.ssh\id_rsa
```

Then in WSL, configure to use Windows SSH agent:
```bash
# Add to ~/.bashrc
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
    rm -f $SSH_AUTH_SOCK
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$HOME/.ssh/wsl2-ssh-pageant.exe" &) >/dev/null 2>&1
fi
```

**Useful Links:**
- GitHub SSH setup: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- SSH agent forwarding: https://code.visualstudio.com/docs/devcontainers/containers#_using-ssh-keys
- WSL SSH agent: https://github.com/rupor-github/wsl-ssh-agent

---

## Optional: GPG Signing Configuration

To sign Git commits inside the dev container:

### Linux

**1. Generate GPG Key on Host (if you don't have one):**

```bash
# Generate new key
gpg --full-generate-key

# Select:
# - (1) RSA and RSA
# - 4096 bits
# - Key does not expire (or set expiration)
# - Enter your name and email (must match Git email)

# List keys to get key ID
gpg --list-secret-keys --keyid-format=long

# Output example:
# sec   rsa4096/YOUR_KEY_ID 2024-01-01 [SC]
#       FINGERPRINT
# uid           [ultimate] Your Name <your.email@example.com>

# Export public key to add to GitHub
gpg --armor --export YOUR_KEY_ID
# Copy the output and add to GitHub: Settings → SSH and GPG keys → New GPG key
```

**2. Configure Git to Use GPG:**

```bash
# On host (outside container)
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
git config --global tag.gpgsign true
```

**3. Export GPG Keys for Dev Container:**

```bash
# Export private key (keep this secure!)
gpg --export-secret-keys --armor YOUR_KEY_ID > ~/.gnupg/private-key.asc

# Export ownertrust
gpg --export-ownertrust > ~/.gnupg/ownertrust.txt
```

**4. Import GPG Keys in Dev Container:**

Once inside the dev container:
```bash
# Import private key
gpg --import /home/vscode/.gnupg/private-key.asc

# Import trust
gpg --import-ownertrust /home/vscode/.gnupg/ownertrust.txt

# Verify
gpg --list-secret-keys

# Configure Git in container
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
```

**5. Automatic Setup Script (Optional):**

Create `~/.gnupg/import-gpg.sh` on host:
```bash
#!/bin/bash
# Automatically imports GPG keys in dev container

if [ ! -f ~/.gnupg/secring.gpg ]; then
    gpg --import ~/.gnupg/private-key.asc
    gpg --import-ownertrust ~/.gnupg/ownertrust.txt
    
    # Configure Git
    git config --global user.signingkey YOUR_KEY_ID
    git config --global commit.gpgsign true
    git config --global tag.gpgsign true
    
    echo "GPG keys imported and Git configured for signing"
fi
```

Make it executable: `chmod +x ~/.gnupg/import-gpg.sh`

Add to `.devcontainer/devcontainer.json`:
```json
{
  "postCreateCommand": "~/.gnupg/import-gpg.sh"
}
```

### Windows (WSL)

Follow the same steps as Linux, but perform all GPG operations inside WSL:

```bash
# Open WSL terminal
wsl

# Follow Linux instructions above
gpg --full-generate-key
# ... etc.
```

**Configure Git for Windows (if using Git for Windows outside WSL):**

```powershell
# In PowerShell
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true

# Configure GPG program for Git for Windows
git config --global gpg.program "C:\Program Files\Git\usr\bin\gpg.exe"
```

**Useful Links:**
- GitHub GPG setup: https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
- GPG signing in Git: https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work
- Dev Container GPG: https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials

---

## Troubleshooting

### "Cannot connect to Docker daemon"

**Linux:**
```bash
# Check if Docker is running
systemctl status docker

# Start Docker if not running
sudo systemctl start docker

# Verify you're in docker group
groups | grep docker

# If not, add yourself and restart
sudo usermod -aG docker $USER
# Log out and back in
```

**Windows:**
- Ensure Docker Desktop is running (check system tray)
- Verify WSL 2 integration is enabled in Docker Desktop settings
- Restart Docker Desktop

### "Dev Container fails to build"

**Check Docker logs:**
```bash
# View container logs
docker ps -a
docker logs <container-id>
```

**Clear Docker cache:**
```bash
# Remove dev container
docker rm -f vsc-realistic-spell-fps-...

# Remove image to rebuild from scratch
docker rmi vsc-realistic-spell-fps-...

# Rebuild dev container in VS Code
F1 → "Dev Containers: Rebuild Container"
```

### "Permission denied" in container

**Linux/WSL - Fix file permissions:**
```bash
# On host, ensure workspace directory has correct permissions
sudo chown -R $USER:$USER ~/realistic-spell-fps

# In container, if files are owned by root
sudo chown -R vscode:vscode /workspace
```

### "SSH keys not working in container"

**Verify SSH agent forwarding:**
```bash
# On host
echo $SSH_AUTH_SOCK  # Should show a path
ssh-add -l            # Should list your keys

# In container
echo $SSH_AUTH_SOCK  # Should show a path
ssh-add -l            # Should list your keys
```

If not working:
- Restart SSH agent on host: `eval "$(ssh-agent -s)" && ssh-add`
- Rebuild container: F1 → "Dev Containers: Rebuild Container"

### "GPG signing fails in container"

**Check GPG setup:**
```bash
# In container
gpg --list-secret-keys  # Should show your key

# Test signing
echo "test" | gpg --clearsign

# Check Git config
git config --global user.signingkey
```

If GPG prompts for passphrase repeatedly:
```bash
# Configure GPG agent
echo "use-agent" >> ~/.gnupg/gpg.conf
echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf
```

### "Slow performance on Windows"

- **Use WSL filesystem**: Clone repositories in `~/projects` (inside WSL), not `/mnt/c/Users/...`
- **Allocate more resources**: Docker Desktop → Settings → Resources
  - Increase Memory (8GB+ recommended)
  - Increase CPUs (4+ recommended)
- **Enable Docker BuildKit**: Set `DOCKER_BUILDKIT=1` environment variable

### "Dev Container keeps rebuilding"

**Check `.devcontainer/devcontainer.json`:**
- Avoid mounting files that change frequently
- Use named volumes for node_modules, target, etc.
- Cache dependencies properly

**Preserve container state:**
```bash
# Commit container changes to image
docker commit <container-id> vsc-realistic-spell-fps-custom

# Update devcontainer.json to use custom image
{
  "image": "vsc-realistic-spell-fps-custom"
}
```

---

## Next Steps

Once your dev container is running:

1. **Verify setup:**
   ```bash
   # Check Rust installation
   rustc --version
   cargo --version
   
   # Check dependencies
   pkg-config --version
   ```

2. **Build the project:**
   ```bash
   cargo build
   ```

3. **Run tests:**
   ```bash
   cargo test
   ```

4. **Start developing!** The container includes:
   - Rust analyzer for IntelliSense
   - CodeLLDB for debugging
   - All build tools pre-installed

See [QUICKSTART.md](QUICKSTART.md) for more development commands and workflows.
