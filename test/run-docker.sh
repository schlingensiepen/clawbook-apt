#!/bin/bash
# Local end-to-end test on a Docker host:
#   1. build the repository in a debian:trixie container (test key),
#   2. start a container from the clawbook image (s6 as PID 1),
#   3. install all packages from the repository (file://) and run
#      test/smoke.sh in it,
#   4. remove the containers.
#
# Usage: test/run-docker.sh [IMAGE]   (default clawbook-lehre:local)
# Keeps downloads/ between runs. The output in public/ is signed with a
# throwaway test key and must not be published.
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
IMAGE=${1:-clawbook-lehre:local}
NAME=clawbook-apt-test-$$

cleanup() { docker rm -f "$NAME" "$NAME-build" >/dev/null 2>&1 || true; }
trap cleanup EXIT

echo "### build"
docker run --rm --name "$NAME-build" -v "$ROOT:/src" debian:trixie bash /src/test/build-in-container.sh
ls -l "$ROOT"/public/pool/main/*/

echo "### test in $IMAGE"
docker run -d --name "$NAME" -v "$ROOT/public:/srv/clawbook-apt:ro" -v "$ROOT/test:/srv/test:ro" \
  "$IMAGE" sleep infinity >/dev/null
for _ in $(seq 30); do docker exec "$NAME" test -d /run/service/sshd 2>/dev/null && break; sleep 1; done
docker exec "$NAME" bash /srv/test/smoke.sh
