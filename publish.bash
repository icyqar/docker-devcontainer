#!/usr/bin/env bash

# Throw an error if unset variables are used 
set -o nounset 

# Exit if an error happens
set -o errexit

# DEBUGGING:Uncomment below to see commands as they are executed
# set -o xtrace

# Container name
IMAGE_NAME="container-devcontainer"

# Define a list of environment variable names to check
ENV_VARS="IMAGE_NAME CONTAINER_REGISTRY CONTAINER_USERNAME CONTAINER_PASSWORD"

# Loop through the list of environment variable names
for var in $ENV_VARS; do
    # Check if the environment variable is not defined
    if [ -z "${!var}" ]; then
        echo "Error: The environment variable $var is not defined."
        exit 1
    fi
done

# Build the devcontainer
# --docker-path Path to the docker/podman executable to use.
# --workspace-folder Path to the folder containing the '.devcontainer' folder.
# --image-name Name to give to the built image.
devcontainer build \
--docker-path "$(which podman)" \
--workspace-folder "$(pwd)" \
--image-name "${IMAGE_NAME}"

# Push to container registry
podman push \
"localhost/${IMAGE_NAME}:latest" \
"${CONTAINER_REGISTRY}/${CONTAINER_USERNAME}/${IMAGE_NAME}:latest" \
--tls-verify=false > /dev/null

