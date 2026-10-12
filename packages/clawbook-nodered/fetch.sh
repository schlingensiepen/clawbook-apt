#!/bin/bash
# Node-RED with "npm ci" from the lockfile into /usr/lib/clawbook/node-red.
# npm runs from a pinned Node.js tarball; no install scripts are run (the
# lockfile has none; bcrypt comes as a prebuilt optional package).
set -euo pipefail
. "$CLAWBOOK_APT_ROOT/lib/common.sh"
. ./versions.env
require NODE_RED_VERSION NODE_VERSION NODE_SHA256

grep -q "\"node-red\": \"$NODE_RED_VERSION\"" package.json
node_tar=$(fetch "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" "sha256:$NODE_SHA256")
mkdir -p "$WORKDIR/node"
tar -xJf "$node_tar" -C "$WORKDIR/node" --strip-components=1
export PATH=$WORKDIR/node/bin:$PATH npm_config_cache=$WORKDIR/npm-cache \
       npm_config_update_notifier=false npm_config_fund=false npm_config_audit=false

APP=$STAGE/usr/lib/clawbook/node-red
mkdir -p "$APP"
cp package.json package-lock.json "$APP/"
( cd "$APP" && npm ci --omit=dev --ignore-scripts --no-audit --no-fund --loglevel=error )
test "$(node -p "require('$APP/node_modules/node-red/package.json').version")" = "$NODE_RED_VERSION"
install -D -m 0644 "$APP/node_modules/node-red/LICENSE" "$STAGE/usr/share/doc/$PACKAGE/node-red/LICENSE"
( cd "$APP" && npm ls --omit=dev --all --parseable 2>/dev/null | sed "s|^$APP/||" ) \
  > "$STAGE/usr/share/doc/$PACKAGE/node-red/installed-packages.txt" || true
