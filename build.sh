#!/bin/bash
# Builds every package under packages/ and the signed apt repository.
#
# Usage: ./build.sh [--no-sign] [--check] [PACKAGE ...]
#   --check     only check the package definitions, build nothing
#   --no-sign   build the repository without InRelease/Release.gpg
#   PACKAGE     build only these packages (default: all)
#
# Environment:
#   APT_SIGNING_KEY  ASCII-armored private key (CI secret); imported into a
#                    temporary keyring that is removed afterwards
#   APT_SIGNING_FPR  fingerprint of the signing key (required for signing)
#   GNUPGHOME        keyring to sign with when APT_SIGNING_KEY is not set
#   PUBLIC_KEY       public key published with the repository
#                    (default keys/clawbook-apt.asc); must contain the
#                    signing key, so a test key cannot slip into a release
#   DOWNLOADS, WORK, OUT  directories (default downloads/, build/, public/)
#
# Needs: bash, coreutils, curl, dpkg-dev (dpkg-deb), apt-utils, gpgv
# (apt-ftparchive), gnupg, python3, unzip, xz-utils; for single packages
# more (see the fetch.sh of the package).
set -euo pipefail

ROOT=$(cd "$(dirname "$0")" && pwd)
export CLAWBOOK_APT_ROOT=$ROOT
export DOWNLOADS=${DOWNLOADS:-$ROOT/downloads}
WORK=${WORK:-$ROOT/build}
OUT=${OUT:-$ROOT/public}
PUBLIC_KEY=${PUBLIC_KEY:-$ROOT/keys/clawbook-apt.asc}

CODENAME=trixie
SUITE=stable
COMPONENT=main
ARCH=amd64

# shellcheck source=lib/common.sh
. "$ROOT/lib/common.sh"

SIGN=1
CHECK_ONLY=0
ONLY=()
for a in "$@"; do
  case $a in
    --no-sign) SIGN=0 ;;
    --check) CHECK_ONLY=1 ;;
    -h|--help) sed -n '2,/^set -euo/p' "$0" | sed '$d; s/^# \{0,1\}//'; exit 0 ;;
    -*) echo "unknown option $a" >&2; exit 2 ;;
    *) ONLY+=("$a") ;;
  esac
done

export SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH:-$(git -C "$ROOT" log -1 --format=%ct 2>/dev/null || date +%s)}

die() { echo "build: $*" >&2; exit 1; }

# field FILE NAME - value of a (possibly folded) field of a control file.
field() {
  awk -v want="$2" '
    /^[^ \t#][^:]*:/ {
      name = $0; sub(/:.*/, "", name)
      on = (tolower(name) == tolower(want))
      if (on) { v = $0; sub(/^[^:]*:[ \t]*/, "", v); out = v }
      next
    }
    /^[ \t]/ { if (on) out = out " " $0; next }
    { on = 0 }
    END { gsub(/[ \t]+/, " ", out); print out }
  ' "$1"
}

# names of the packages a Depends value refers to
dep_names() {
  tr ',|' '\n\n' <<<"$1" | sed 's/[[(].*//; s/^ *//; s/ *$//' | grep -v '^$' || true
}

ALL=()
for d in "$ROOT"/packages/*/; do ALL+=("$(basename "$d")"); done
[ ${#ONLY[@]} -gt 0 ] || ONLY=("${ALL[@]}")

# --- check ---------------------------------------------------------------------

check_package() {
  local name=$1 dir=$ROOT/packages/$1 c
  c=$dir/control
  [ -f "$c" ] || die "$name: control is missing"
  [ -f "$dir/copyright" ] || die "$name: copyright is missing"
  [ "$(field "$c" Package)" = "$name" ] || die "$name: Package field differs from directory name"
  local f
  for f in Version Architecture Maintainer Description X-Clawbook-Art; do
    [ -n "$(field "$c" "$f")" ] || die "$name: field $f is missing"
  done
  case $(field "$c" Architecture) in all|amd64) ;; *) die "$name: Architecture must be all or amd64" ;; esac
  local art
  art=$(field "$c" X-Clawbook-Art)
  case "$name:$art" in
    clawbook-*:technik) ;;
    kurs-*:kurs) ;;
    *) die "$name: names clawbook-* need X-Clawbook-Art: technik, kurs-* need kurs" ;;
  esac
  local dep
  for dep in $(dep_names "$(field "$c" Depends)"); do
    case $dep in
      clawbook-*|kurs-*) [ -d "$ROOT/packages/$dep" ] || die "$name: depends on unknown package $dep" ;;
    esac
  done
  if [ "$art" = kurs ]; then
    # Course packages only bundle technology packages and describe the course.
    for f in files fetch.sh versions.env preinst postinst prerm postrm triggers vscode-extensions.list; do
      [ ! -e "$dir/$f" ] || die "$name: a course package must not contain $f"
    done
    for dep in $(dep_names "$(field "$c" Depends)"); do
      case $dep in clawbook-*) ;; *) die "$name: a course package may only depend on clawbook-* packages ($dep)" ;; esac
    done
    [ "$(field "$c" Architecture)" = all ] || die "$name: a course package is Architecture: all"
    python3 - "$dir/vscode.json" "$name" <<'PY' || die "$name: vscode.json is not valid"
import json, sys
path, name = sys.argv[1], sys.argv[2]
d = json.load(open(path, encoding="utf-8"))
def need(cond, msg):
    if not cond:
        sys.exit(f"{path}: {msg}")
need(d.get("format") == 1, "format must be 1")
need(d.get("kennung") == name, "kennung must equal the package name")
need(isinstance(d.get("titel"), str) and d["titel"], "titel is missing")
need(isinstance(d.get("links"), list) and d["links"], "links is missing")
for l in d["links"]:
    need(isinstance(l, dict) and l.get("titel") and str(l.get("url", "")).startswith("https://"),
         "each link needs titel and an https url")
for side in ("windows", "container"):
    need(isinstance(d.get(side, {}).get("erweiterungen"), list), f"{side}.erweiterungen must be a list")
need(isinstance(d.get("einstellungen", {}), dict), "einstellungen must be an object")
PY
  else
    [ ! -e "$dir/vscode.json" ] || die "$name: only course packages carry vscode.json"
  fi
  if [ -f "$dir/vscode-extensions.list" ]; then
    grep -v '^\s*\(#\|$\)' "$dir/vscode-extensions.list" | grep -qvE '^\s*[A-Za-z0-9-]+\.[A-Za-z0-9.-]+\s*(#.*)?$' \
      && die "$name: vscode-extensions.list has an invalid line"
  fi
  return 0
}

for p in "${ALL[@]}"; do check_package "$p"; done
echo "build: ${#ALL[@]} package definitions ok"
[ "$CHECK_ONLY" = 0 ] || exit 0

for tool in dpkg-deb apt-ftparchive gpg gpgv python3 curl xz gzip unzip; do
  command -v "$tool" >/dev/null || die "$tool is missing"
done

# --- packages ------------------------------------------------------------------

rm -rf "$OUT"
mkdir -p "$OUT/pool/$COMPONENT" "$WORK" "$DOWNLOADS"

build_package() {
  local name=$1 dir=$ROOT/packages/$1
  local stage=$WORK/stage/$name
  local version arch
  version=$(field "$dir/control" Version)
  arch=$(field "$dir/control" Architecture)
  echo "build: $name $version ($arch)"
  rm -rf "$stage"
  mkdir -p "$stage/DEBIAN"

  [ ! -d "$dir/files" ] || cp -a "$dir/files/." "$stage/"
  install -D -m 0644 "$dir/copyright" "$stage/usr/share/doc/$name/copyright"
  if [ -f "$dir/vscode-extensions.list" ]; then
    install -D -m 0644 "$dir/vscode-extensions.list" \
      "$stage/usr/share/clawbook/vscode-extensions.d/$name.list"
  fi
  if [ -f "$dir/vscode.json" ]; then
    install -D -m 0644 "$dir/vscode.json" "$stage/usr/share/clawbook/kurse/$name/vscode.json"
  fi
  if [ -f "$dir/fetch.sh" ]; then
    ( cd "$dir" && STAGE=$stage PACKAGE=$name WORKDIR=$WORK/tmp/$name bash ./fetch.sh ) \
      || die "$name: fetch.sh failed"
  fi

  local s
  for s in preinst postinst prerm postrm; do
    [ ! -f "$dir/$s" ] || install -m 0755 "$dir/$s" "$stage/DEBIAN/$s"
  done
  for s in triggers conffiles; do
    [ ! -f "$dir/$s" ] || install -m 0644 "$dir/$s" "$stage/DEBIAN/$s"
  done

  # Files: no group/other write; everything readable.
  chmod -R u+w,go-w,a+rX "$stage"
  # Stable timestamps make rebuilds of unchanged content comparable.
  find "$stage" -newermt "@$SOURCE_DATE_EPOCH" -print0 \
    | xargs -0r touch -h -d "@$SOURCE_DATE_EPOCH"

  local size
  size=$(( $(du -sk "$stage" | cut -f1) - $(du -sk "$stage/DEBIAN" | cut -f1) ))
  {
    grep -v '^\s*#' "$dir/control" | sed '/^\s*$/d'
    echo "Installed-Size: $size"
  } > "$stage/DEBIAN/control"

  local deb=$OUT/pool/$COMPONENT/$name/${name}_${version}_${arch}.deb
  mkdir -p "$(dirname "$deb")"
  dpkg-deb --root-owner-group -Zxz --build "$stage" "$deb" >/dev/null
  rm -rf "$stage" "$WORK/tmp/$name"
}

for p in "${ONLY[@]}"; do
  [ -d "$ROOT/packages/$p" ] || die "unknown package $p"
  build_package "$p"
done

# Packages from upstream publishers, taken over unchanged (checksum pinned).
for envfile in "$ROOT"/upstream/*.env; do
  [ -f "$envfile" ] || continue
  (
    # shellcheck source=/dev/null
    . "$envfile"
    require PACKAGE VERSION ARCH URL SHA256
    f=$(fetch "$URL" "sha256:$SHA256")
    [ "$(dpkg-deb -f "$f" Package)" = "$PACKAGE" ] || die "$envfile: Package differs"
    [ "$(dpkg-deb -f "$f" Version)" = "$VERSION" ] || die "$envfile: Version differs"
    [ "$(dpkg-deb -f "$f" Architecture)" = "$ARCH" ] || die "$envfile: Architecture differs"
    mkdir -p "$OUT/pool/$COMPONENT/$PACKAGE"
    cp "$f" "$OUT/pool/$COMPONENT/$PACKAGE/${PACKAGE}_${VERSION}_${ARCH}.deb"
    echo "build: $PACKAGE $VERSION ($ARCH, upstream)"
  )
done

# --- repository ----------------------------------------------------------------

cd "$OUT"
BIN=dists/$CODENAME/$COMPONENT/binary-$ARCH
mkdir -p "$BIN"
apt-ftparchive --arch "$ARCH" packages "pool/$COMPONENT" > "$BIN/Packages"
gzip -9nk "$BIN/Packages"
xz -k "$BIN/Packages"

apt-ftparchive \
  -o APT::FTPArchive::Release::Origin=clawbook-apt \
  -o APT::FTPArchive::Release::Label=clawbook-apt \
  -o APT::FTPArchive::Release::Suite="$SUITE" \
  -o APT::FTPArchive::Release::Codename="$CODENAME" \
  -o APT::FTPArchive::Release::Architectures="$ARCH" \
  -o APT::FTPArchive::Release::Components="$COMPONENT" \
  -o APT::FTPArchive::Release::Description="clawbook-lehre: Technikpakete und Kurse" \
  release "dists/$CODENAME" > "$WORK/Release"
mv "$WORK/Release" "dists/$CODENAME/Release"

# Public key, armored and binary (for Signed-By).
cp "$PUBLIC_KEY" "$OUT/clawbook-apt.asc"
gpg --dearmor < "$PUBLIC_KEY" > "$OUT/clawbook-apt.gpg"

if [ "$SIGN" = 1 ]; then
  require APT_SIGNING_FPR
  FPR=${APT_SIGNING_FPR// /}
  if [ -n "${APT_SIGNING_KEY:-}" ]; then
    GNUPGHOME=$(mktemp -d)
    export GNUPGHOME
    trap 'gpgconf --kill all >/dev/null 2>&1 || true; rm -rf "$GNUPGHOME"' EXIT
    gpg --batch --quiet --import <<<"$APT_SIGNING_KEY"
  fi
  gpg --batch --list-secret-keys "$FPR" >/dev/null 2>&1 || die "signing key $FPR not in keyring"
  gpg --batch --with-colons --show-keys "$PUBLIC_KEY" | grep -q "^fpr:*$FPR:" \
    || die "$PUBLIC_KEY does not contain the signing key $FPR"
  REL=dists/$CODENAME
  gpg --batch --yes --pinentry-mode loopback --local-user "$FPR" --digest-algo SHA512 \
    --clearsign --output "$REL/InRelease" "$REL/Release"
  gpg --batch --yes --pinentry-mode loopback --local-user "$FPR" --digest-algo SHA512 \
    --armor --detach-sign --output "$REL/Release.gpg" "$REL/Release"
  out=$(gpgv --keyring "$OUT/clawbook-apt.gpg" "$REL/InRelease" 2>&1) \
    || die "InRelease does not verify against $PUBLIC_KEY: $out"
  out=$(gpgv --keyring "$OUT/clawbook-apt.gpg" "$REL/Release.gpg" "$REL/Release" 2>&1) \
    || die "Release.gpg does not verify against $PUBLIC_KEY: $out"
  echo "build: signed with $FPR"
else
  echo "build: repository NOT signed (--no-sign)"
fi

python3 "$ROOT/lib/index.py" "$BIN/Packages" > "$OUT/index.html"
echo "build: done -> $OUT"
