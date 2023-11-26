#! /bin/bash

set -e

CONTAINER="ghcr.io/3003n/chimeraos:dev"
podman pull ${CONTAINER}

mkdir -p .cache
chmod 777 .cache
# Build the AUR packages with the github container
podman run -it --rm --entrypoint /workdir/aur-pkgs/build-aur-packages.sh -v $(pwd):/workdir:Z -v $(pwd)/.cache:/home/build/.cache:Z ${CONTAINER}
# Build chimera image using the AUR packages found in aur-pkgs.
# If the -e NO_COMPRESS=1 gets removed, the docker container will tar the ouput image
podman run -it --rm -u root --privileged=true --entrypoint /workdir/build-image.sh -e NO_COMPRESS=1 -v $(pwd):/workdir:Z -v $(pwd)/output:/output:z ${CONTAINER} $(echo local-$(git rev-parse HEAD | cut -c1-7))