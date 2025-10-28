$ErrorActionPreference = "Stop"
# this script runs docker build to build the development container
# $VERSION = "0.0.1"
#load version from file
$VERSION = Get-Content VERSION
$BASE_IMAGE_TAG = "ghcr.io/adambajger/realistic-spell-fps/base:$VERSION"
$DEV_IMAGE_TAG = "ghcr.io/adambajger/realistic-spell-fps/dev:$VERSION"

# check if dev image exists, if not, check if base image exists, if not build base image first, then build dev image
# check if dev image exists, if not, check if base image exists, if not build base image first, then build dev image
$devImageExists = docker image inspect $DEV_IMAGE_TAG > $null 2>&1
if (-not $?) {
    Write-Host "Dev image $DEV_IMAGE_TAG not found, checking for base image..."
    $baseImageExists = docker image inspect $BASE_IMAGE_TAG > $null 2>&1
    if (-not $?) {
        Write-Host "Base image $BASE_IMAGE_TAG not found, building base image first..."
        docker build -t $BASE_IMAGE_TAG -f .devcontainer/base-linux.Dockerfile .
    }
    Write-Host "Building dev image $DEV_IMAGE_TAG..."
    docker build -t $DEV_IMAGE_TAG -f .devcontainer/dev-linux.Dockerfile .
}
Write-Host "Dev image $DEV_IMAGE_TAG is ready to use."
