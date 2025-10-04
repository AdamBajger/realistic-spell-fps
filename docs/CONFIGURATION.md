# Configuration and Secrets Guide

## Configuration File

The project uses `config.toml` to configure server and client settings.

### Default Configuration

```toml
[server]
host = "127.0.0.1"
port = 7777

[client]
server_host = "127.0.0.1"
server_port = 7777
```

### Environment-Specific Configuration

You can create environment-specific config files:
- `config.toml` - Default configuration
- `config.production.toml` - Production settings
- `config.development.toml` - Development settings

Load them programmatically:
```rust
use engine::config::Config;
use std::path::Path;

let env = std::env::var("ENVIRONMENT").unwrap_or("development".to_string());
let config_path = format!("config.{}.toml", env);
let config = Config::load_or_default(Path::new(&config_path));
```

## GitHub Secrets for CI/CD

The CI/CD pipeline supports configuration via GitHub secrets for sensitive information.

### Setting Up Secrets

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add the following secrets (all optional):

| Secret Name | Description | Default Value |
|-------------|-------------|---------------|
| `SERVER_HOST` | Server host address | `127.0.0.1` |
| `SERVER_PORT` | Server port number | `7777` |

### How Secrets Are Used

The CI workflow (`.github/workflows/ci.yml`) uses these secrets to generate a `config.toml` file during the build:

```yaml
env:
  SERVER_HOST: ${{ secrets.SERVER_HOST || '127.0.0.1' }}
  SERVER_PORT: ${{ secrets.SERVER_PORT || '7777' }}

steps:
  - name: Generate config from environment
    run: |
      cat > config.toml << EOF
      [server]
      host = "$SERVER_HOST"
      port = $SERVER_PORT
      ...
      EOF
```

### Docker Registry Secrets

Docker images are published to GitHub Container Registry (GHCR). No additional secrets are needed - the workflow uses `GITHUB_TOKEN` which is automatically provided.

To pull images:
```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Pull images
docker pull ghcr.io/OWNER/REPO/client-linux:latest
docker pull ghcr.io/OWNER/REPO/server-linux:latest
docker pull ghcr.io/OWNER/REPO/client-windows:latest
docker pull ghcr.io/OWNER/REPO/server-windows:latest
```

## Multi-Platform Docker Images

The project builds separate Docker images for Linux and Windows:

### Linux Images
- `client-linux.Dockerfile` - Debian-based client
- `server-linux.Dockerfile` - Debian-based server

### Windows Images
- `client-windows.Dockerfile` - Windows Server Core based client
- `server-windows.Dockerfile` - Windows Server Core based server

### Building Locally

```bash
# Linux
docker build -f .devcontainer/client-linux.Dockerfile -t urmom-client-linux .
docker build -f .devcontainer/server-linux.Dockerfile -t urmom-server-linux .

# Windows (on Windows host)
docker build -f .devcontainer/client-windows.Dockerfile -t urmom-client-windows .
docker build -f .devcontainer/server-windows.Dockerfile -t urmom-server-windows .
```

### Running Containers

```bash
# Run server (Linux)
docker run -p 7777:7777 urmom-server-linux

# Run client (Linux)
docker run -p 8080:8080 urmom-client-linux

# With custom config
docker run -p 7777:7777 -v $(pwd)/config.production.toml:/app/config.toml urmom-server-linux
```

## Security Best Practices

1. **Never commit secrets** to the repository
2. **Use GitHub Secrets** for sensitive configuration in CI/CD
3. **Use environment variables** or mounted config files for production deployments
4. **Rotate secrets** regularly
5. **Use different secrets** for different environments (dev/staging/prod)
6. **Limit secret access** to necessary workflows only

## Example Production Setup

### config.production.toml
```toml
[server]
host = "0.0.0.0"  # Listen on all interfaces
port = 7777

[client]
server_host = "production-server.example.com"
server_port = 7777
```

### Docker Compose
```yaml
version: '3.8'

services:
  server:
    image: ghcr.io/owner/repo/server-linux:latest
    ports:
      - "7777:7777"
    volumes:
      - ./config.production.toml:/app/config.toml:ro
      - ./data:/app/data
    restart: unless-stopped

  client:
    image: ghcr.io/owner/repo/client-linux:latest
    ports:
      - "8080:8080"
    volumes:
      - ./config.production.toml:/app/config.toml:ro
    restart: unless-stopped
```
