# Build Container Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         BASE BUILDER IMAGES                              │
│                    (Rarely change, built separately)                     │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  ┌────────────────────────────────┐  ┌────────────────────────────────┐ │
│  │  base-builder-linux:latest     │  │  base-builder-windows:latest   │ │
│  ├────────────────────────────────┤  ├────────────────────────────────┤ │
│  │ • Rust 1.90                    │  │ • Visual Studio Build Tools    │ │
│  │ • pkg-config                   │  │ • MSVC                         │ │
│  │ • libssl-dev                   │  │ • Windows SDK                  │ │
│  │ • Cargo registry cache         │  │ • Rust toolchain               │ │
│  └────────────────────────────────┘  └────────────────────────────────┘ │
│                                                                           │
│  Published to: docker.io/{username}/realistic-spell-fps/base-builder-*   │
│  Tags: dev-{sha}, latest                                                 │
│  Trigger: Only when base Dockerfiles change                              │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Uses via ARG BASE_BUILDER_IMAGE
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         RUNTIME IMAGES                                   │
│              (Built on every code change, use base builders)             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐      │
│  │ client-linux     │  │ server-linux     │  │ builder-linux    │      │
│  │ Uses: base-linux │  │ Uses: base-linux │  │ Uses: base-linux │      │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘      │
│                                                                           │
│  ┌──────────────────┐  ┌──────────────────┐                             │
│  │ client-windows   │  │ server-windows   │                             │
│  │ Uses: base-win   │  │ Uses: base-win   │                             │
│  └──────────────────┘  └──────────────────┘                             │
│                                                                           │
│  Published to: ghcr.io/{org}/realistic-spell-fps/{image}                │
│  Trigger: Every push/PR (except when only base Dockerfiles change)      │
└─────────────────────────────────────────────────────────────────────────┘


WORKFLOW ORCHESTRATION
══════════════════════

┌──────────────────────────────────────────────────────────────────────────┐
│ build-base-images.yml                                                     │
├──────────────────────────────────────────────────────────────────────────┤
│ Triggers on:                                                              │
│   • Changes to .devcontainer/base-builder-*.Dockerfile                   │
│   • Manual workflow dispatch                                             │
│                                                                           │
│ Builds:                                                                   │
│   1. base-builder-linux (ubuntu-latest)                                  │
│   2. base-builder-windows (windows-2022)                                 │
│                                                                           │
│ Publishes to: Docker Hub                                                 │
│ Tags: dev-{short-sha}, latest                                            │
└──────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────┐
│ docker-multiplatform.yml & docker.yml                                    │
├──────────────────────────────────────────────────────────────────────────┤
│ Triggers on:                                                              │
│   • Push to master/main                                                  │
│   • Pull requests                                                        │
│   • Version tags                                                         │
│                                                                           │
│ Skips when:                                                              │
│   • Only base-builder-*.Dockerfile changed                               │
│   • Only build-base-images.yml changed                                   │
│                                                                           │
│ Builds:                                                                   │
│   • client-linux, server-linux (Linux)                                   │
│   • client-windows, server-windows (Windows)                             │
│                                                                           │
│ Uses: Pre-built base images from Docker Hub                              │
│ Publishes to: GitHub Container Registry (GHCR)                           │
└──────────────────────────────────────────────────────────────────────────┘


BEFORE vs AFTER
═══════════════

BEFORE: Every build reinstalls dependencies
┌─────────────────────────────────────────────┐
│ Runtime Build (e.g., client-linux)          │
├─────────────────────────────────────────────┤
│ 1. FROM rust:1.90-slim-bullseye             │
│ 2. Install pkg-config, libssl-dev ← SLOW    │
│ 3. Copy source code                         │
│ 4. cargo build                              │
└─────────────────────────────────────────────┘
   ↓ Repeated for EVERY image ↓
   • client-linux
   • server-linux
   • client-windows
   • server-windows
   = 4x redundant dependency installation

AFTER: Dependencies installed once, reused many times
┌─────────────────────────────────────────────┐
│ Base Build (base-builder-linux)             │
├─────────────────────────────────────────────┤
│ 1. FROM rust:1.90-slim-bullseye             │
│ 2. Install pkg-config, libssl-dev ← ONCE   │
│ 3. Publish to Docker Hub                    │
└─────────────────────────────────────────────┘
              ↓ Used by all ↓
┌─────────────────────────────────────────────┐
│ Runtime Build (e.g., client-linux)          │
├─────────────────────────────────────────────┤
│ 1. FROM base-builder-linux:latest ← FAST   │
│ 2. Copy source code                         │
│ 3. cargo build                              │
└─────────────────────────────────────────────┘
   = Dependencies pre-installed, builds faster


CONFIGURATION
═════════════

Required GitHub Secrets:
  DOCKERHUB_USERNAME  - Docker Hub username for base image publishing
  DOCKERHUB_TOKEN     - Docker Hub access token (from hub.docker.com)

Optional GitHub Secrets (for custom registries):
  DOCKER_REGISTRY     - Custom registry URL (default: docker.io)
  DOCKER_USERNAME     - Custom registry username
  DOCKER_PASSWORD     - Custom registry password


VERSIONING STRATEGY
═══════════════════

Base Images:
  • Format: dev-{short-commit-hash}
  • Example: dev-e614bb3
  • Also tagged: latest
  • Immutable: Once published, version doesn't change
  • Updates: Only when base Dockerfiles are modified

Runtime Images:
  • Tags: branch name, PR number, semver
  • Example: main, pr-123, v1.2.3
  • Updates: On every code push


BENEFITS
════════

✅ Faster Builds
   - Skip dependency installation (saves 3-5 min per build)
   - Better layer caching

✅ Consistency
   - All images use identical build environment
   - Reproducible builds

✅ Maintainability
   - Single source of truth for build tools
   - Easy to update Rust version or dependencies
   - Update once, affects all builds

✅ Efficiency
   - Base images rarely rebuilt
   - CI/CD resources focused on application builds

✅ Separation of Concerns
   - Infrastructure (tools) vs application (code)
   - Clear ownership of different layers
