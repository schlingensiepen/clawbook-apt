#!/bin/bash
# Builds the repository inside a throwaway debian:trixie container, signed
# with a throwaway test key (the real key stays in CI). Run by
# test/run-docker.sh; expects the repository mounted at /src.
#
# Result: /src/public (repository, test-signed) and /src/public/clawbook-apt.asc
# (the public TEST key; never publish this output).
set -euo pipefail

apt-get update -qq
apt-get install -y -qq --no-install-recommends \
  ca-certificates curl git unzip xz-utils dpkg-dev apt-utils gnupg gpgv \
  python3 python3-venv libstdc++6 >/dev/null

GNUPGHOME=$(mktemp -d)
export GNUPGHOME
gpg --batch --quiet --pinentry-mode loopback --passphrase '' --quick-gen-key "clawbook-apt TEST key" ed25519 sign 1d
FPR=$(gpg --batch --with-colons --list-secret-keys | awk -F: '/^fpr:/ { print $10; exit }')
gpg --batch --armor --export "$FPR" > /tmp/test-key.asc

cd /src
git config --global --add safe.directory /src
APT_SIGNING_FPR=$FPR PUBLIC_KEY=/tmp/test-key.asc ./build.sh "$@"
