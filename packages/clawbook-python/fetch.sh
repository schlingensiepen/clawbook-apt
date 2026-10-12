#!/bin/bash
# ruff from the official release, checksum pinned in versions.env.
set -euo pipefail
. "$CLAWBOOK_APT_ROOT/lib/common.sh"
. ./versions.env
require RUFF_VERSION RUFF_SHA256 RUFF_LICENSE_SHA256

tgz=$(fetch "https://github.com/astral-sh/ruff/releases/download/$RUFF_VERSION/ruff-x86_64-unknown-linux-gnu.tar.gz" \
  "sha256:$RUFF_SHA256" "ruff-$RUFF_VERSION-x86_64-unknown-linux-gnu.tar.gz")
lic=$(fetch "https://raw.githubusercontent.com/astral-sh/ruff/$RUFF_VERSION/LICENSE" \
  "sha256:$RUFF_LICENSE_SHA256" "ruff-$RUFF_VERSION-LICENSE")

mkdir -p "$WORKDIR"
tar -xzf "$tgz" -C "$WORKDIR"
install -D -m 0755 "$WORKDIR/ruff-x86_64-unknown-linux-gnu/ruff" "$STAGE/usr/bin/ruff"
install -D -m 0644 "$lic" "$STAGE/usr/share/doc/$PACKAGE/ruff/LICENSE"
"$STAGE/usr/bin/ruff" --version | grep -qx "ruff $RUFF_VERSION"
