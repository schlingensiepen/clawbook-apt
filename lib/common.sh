# Shared helpers for build.sh and the fetch.sh scripts of the packages.
# Sourced, not executed.

# fetch URL ALGO:HASH [NAME]
# Downloads URL into $DOWNLOADS (once), checks the pinned hash and prints
# the path of the file. Stops the build when the hash does not match.
fetch() {
  local url=$1 pin=$2 name=${3:-}
  local algo=${pin%%:*} sum=${pin#*:}
  [ -n "$name" ] || name=$(basename "${url%%\?*}")
  case "$algo" in
    sha256|sha512) ;;
    *) echo "fetch: unsupported hash '$algo' for $url" >&2; return 1 ;;
  esac
  [ -n "$sum" ] && [ "$sum" != "$pin" ] || { echo "fetch: no hash pinned for $url" >&2; return 1; }
  mkdir -p "$DOWNLOADS"
  local dest=$DOWNLOADS/$name
  if [ -f "$dest" ] && echo "$sum  $dest" | "${algo}sum" -c --quiet - >/dev/null 2>&1; then
    echo "$dest"
    return 0
  fi
  echo "fetch: $url" >&2
  curl -fsSL --retry 3 --retry-delay 5 -o "$dest.part" "$url"
  if ! echo "$sum  $dest.part" | "${algo}sum" -c --quiet - >/dev/null 2>&1; then
    echo "fetch: CHECKSUM MISMATCH for $url" >&2
    echo "fetch:   expected $algo $sum" >&2
    echo "fetch:   got      $("${algo}sum" "$dest.part" | cut -d' ' -f1)" >&2
    rm -f "$dest.part"
    return 1
  fi
  mv "$dest.part" "$dest"
  echo "$dest"
}

# require VAR... - stops when one of the variables is empty.
require() {
  local v
  for v in "$@"; do
    [ -n "${!v:-}" ] || { echo "missing variable $v (versions.env)" >&2; return 1; }
  done
}
