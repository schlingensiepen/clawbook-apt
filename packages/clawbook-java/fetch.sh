#!/bin/bash
# Gradle from gradle.org into /opt/gradle, checksum pinned in versions.env.
set -euo pipefail
. "$CLAWBOOK_APT_ROOT/lib/common.sh"
. ./versions.env
require GRADLE_VERSION GRADLE_SHA256

zip=$(fetch "https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip" "sha256:$GRADLE_SHA256")
mkdir -p "$WORKDIR" "$STAGE/opt" "$STAGE/usr/bin" "$STAGE/usr/share/doc/$PACKAGE/gradle"
unzip -q "$zip" -d "$WORKDIR"
mv "$WORKDIR/gradle-$GRADLE_VERSION" "$STAGE/opt/gradle"
rm -f "$STAGE"/opt/gradle/bin/*.bat
ln -s /opt/gradle/bin/gradle "$STAGE/usr/bin/gradle"
for f in LICENSE NOTICE README; do
  [ ! -f "$STAGE/opt/gradle/$f" ] || cp "$STAGE/opt/gradle/$f" "$STAGE/usr/share/doc/$PACKAGE/gradle/"
done
