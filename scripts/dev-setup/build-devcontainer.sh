set -euo pipefail
# this script runs docker build to build the development container
# VERSION=0.0.1
# load version from file
VERSION=$(cat VERSION)
BASE_IMAGE_TAG=ghcr.io/adambajger/realistic-spell-fps-base:$VERSION
DEV_IMAGE_TAG=ghcr.io/adambajger/realistic-spell-fps-dev:$VERSION


# check if dev image exists, if not, check if base image exists, if not build base image first, then build dev image
if ! docker image inspect $DEV_IMAGE_TAG > /dev/null 2>&1; then
    echo "Dev image $DEV_IMAGE_TAG not found, checking for base image..."
    if ! docker image inspect $BASE_IMAGE_TAG > /dev/null 2>&1; then
        echo "Base image $BASE_IMAGE_TAG not found, building base image first..."
        docker build -t $BASE_IMAGE_TAG -f .devcontainer/base-linux.Dockerfile .
    fi
    echo "Building dev image $DEV_IMAGE_TAG..."
    docker build -t $DEV_IMAGE_TAG -f .devcontainer/dev-linux.Dockerfile .
fi
echo "Dev image $DEV_IMAGE_TAG is ready to use."
