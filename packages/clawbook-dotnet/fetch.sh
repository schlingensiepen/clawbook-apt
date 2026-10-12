#!/bin/bash
# .NET SDK tarball into /usr/lib/dotnet and dotnet-ef into
# /usr/lib/dotnet-tools, both checksum pinned in versions.env.
# Running dotnet at build time needs libstdc++6 (globalization is switched
# to invariant mode, so no ICU is needed).
set -euo pipefail
. "$CLAWBOOK_APT_ROOT/lib/common.sh"
. ./versions.env
require DOTNET_SDK_VERSION DOTNET_SDK_SHA512 DOTNET_EF_VERSION DOTNET_EF_SHA256

tgz=$(fetch "https://builds.dotnet.microsoft.com/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz" \
  "sha512:$DOTNET_SDK_SHA512")
nupkg=$(fetch "https://api.nuget.org/v3-flatcontainer/dotnet-ef/$DOTNET_EF_VERSION/dotnet-ef.$DOTNET_EF_VERSION.nupkg" \
  "sha256:$DOTNET_EF_SHA256")

DOTNET=$STAGE/usr/lib/dotnet
TOOLS=$STAGE/usr/lib/dotnet-tools
DOC=$STAGE/usr/share/doc/$PACKAGE/dotnet
mkdir -p "$DOTNET" "$TOOLS" "$DOC" "$STAGE/usr/bin" "$WORKDIR/feed" "$WORKDIR/home"
tar -xzf "$tgz" -C "$DOTNET"
ln -s ../lib/dotnet/dotnet "$STAGE/usr/bin/dotnet"
cp "$DOTNET/LICENSE.txt" "$DOTNET/ThirdPartyNotices.txt" "$DOC/"

# dotnet-ef from the pinned package only: a feed with this one file and a
# nuget.config that clears all other sources.
cp "$nupkg" "$WORKDIR/feed/"
cat > "$WORKDIR/nuget.config" <<XML
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
    <add key="pinned" value="$WORKDIR/feed" />
  </packageSources>
</configuration>
XML
export HOME=$WORKDIR/home DOTNET_CLI_HOME=$WORKDIR/home NUGET_PACKAGES=$WORKDIR/home/nuget \
       DOTNET_CLI_TELEMETRY_OPTOUT=1 DOTNET_NOLOGO=1 DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 \
       DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 DOTNET_ROOT=$DOTNET
touch "$WORKDIR/marker"
"$DOTNET/dotnet" tool install dotnet-ef --version "$DOTNET_EF_VERSION" \
  --tool-path "$TOOLS" --configfile "$WORKDIR/nuget.config"
ln -s ../lib/dotnet-tools/dotnet-ef "$STAGE/usr/bin/dotnet-ef"
"$DOTNET/dotnet" --version | grep -qx "$DOTNET_SDK_VERSION"
# Nothing may have been written into the SDK tree by the tool install
# (apart from an empty "metadata" directory the CLI creates; it goes).
rmdir "$DOTNET/metadata" 2>/dev/null || true
touch -r "$WORKDIR/marker" "$DOTNET"
if [ -n "$(find "$DOTNET" -newer "$WORKDIR/marker" -print -quit)" ]; then
  echo "dotnet tool install changed files below /usr/lib/dotnet" >&2
  find "$DOTNET" -newer "$WORKDIR/marker" >&2
  exit 1
fi
mkdir -p "$DOC/../dotnet-ef"
for f in "$TOOLS"/.store/dotnet-ef/*/dotnet-ef/*/*.txt "$TOOLS"/.store/dotnet-ef/*/dotnet-ef/*/LICENSE*; do
  [ ! -f "$f" ] || cp "$f" "$DOC/../dotnet-ef/"
done
