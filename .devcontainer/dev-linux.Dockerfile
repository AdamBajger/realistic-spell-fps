ARG BASE_BUILDER_IMAGE=rust:1.90-slim-bullseye
FROM ${BASE_BUILDER_IMAGE} as builder

RUN apt-get update && apt-get install -y openssh-client

# add dev features for increased code quality and checks
RUN rustup component add rustfmt clippy

