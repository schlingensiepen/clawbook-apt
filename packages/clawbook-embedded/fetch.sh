#!/bin/bash
# PlatformIO Core in a virtual environment at /opt/platformio.
#
# A venv is not relocatable (absolute paths in scripts and pyvenv.cfg), so
# it is built at its final path /opt/platformio with the Python of Debian
# trixie (python3.13, the same as at runtime) and then moved into the
# package. This needs root and a free /opt/platformio, i.e. a throwaway
# build container (CI). All wheels are checked against the hashes in
# requirements.txt.
set -euo pipefail
. "$CLAWBOOK_APT_ROOT/lib/common.sh"
. ./versions.env
require PLATFORMIO_VERSION

PREFIX=/opt/platformio
[ "$(id -u)" = 0 ] || { echo "clawbook-embedded must be built as root (build container)" >&2; exit 1; }
[ ! -e "$PREFIX" ] || { echo "$PREFIX exists already - build in a clean container" >&2; exit 1; }
grep -q "^platformio==$PLATFORMIO_VERSION " requirements.txt

trap 'rm -rf "$PREFIX"' EXIT
python3 -m venv "$PREFIX"
PIP_DISABLE_PIP_VERSION_CHECK=1 "$PREFIX/bin/python3" -m pip install --quiet --no-cache-dir \
  --require-hashes --no-deps --only-binary :all: -r requirements.txt
"$PREFIX/bin/pio" --version | grep -q "version $PLATFORMIO_VERSION\$"
"$PREFIX/bin/python3" -m pip check

mkdir -p "$STAGE/opt" "$STAGE/usr/bin" "$STAGE/usr/share/doc/$PACKAGE/platformio"
cp -a "$PREFIX" "$STAGE/opt/platformio"
ln -s /opt/platformio/bin/pio "$STAGE/usr/bin/pio"
ln -s /opt/platformio/bin/platformio "$STAGE/usr/bin/platformio"
find "$STAGE/opt/platformio" -path '*platformio-*.dist-info/licenses/*' -type f \
  -exec cp {} "$STAGE/usr/share/doc/$PACKAGE/platformio/" \; || true
pip_freeze=$("$PREFIX/bin/python3" -m pip freeze --all)
printf '%s\n' "$pip_freeze" > "$STAGE/usr/share/doc/$PACKAGE/platformio/installed-packages.txt"
