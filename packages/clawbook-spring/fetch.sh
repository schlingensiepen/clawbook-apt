#!/bin/bash
# Spring Boot CLI from Maven Central into /opt/spring, checksum pinned.
set -euo pipefail
. "$CLAWBOOK_APT_ROOT/lib/common.sh"
. ./versions.env
require SPRING_CLI_VERSION SPRING_CLI_SHA256

v=$SPRING_CLI_VERSION
tgz=$(fetch "https://repo1.maven.org/maven2/org/springframework/boot/spring-boot-cli/$v/spring-boot-cli-$v-bin.tar.gz" \
  "sha256:$SPRING_CLI_SHA256")
mkdir -p "$WORKDIR" "$STAGE/opt" "$STAGE/usr/bin" "$STAGE/usr/share/doc/$PACKAGE/spring-boot-cli"
tar -xzf "$tgz" -C "$WORKDIR"
mv "$WORKDIR/spring-$v" "$STAGE/opt/spring"
rm -f "$STAGE"/opt/spring/bin/*.bat
ln -s /opt/spring/bin/spring "$STAGE/usr/bin/spring"
install -D -m 0644 "$STAGE/opt/spring/shell-completion/bash/spring" \
  "$STAGE/usr/share/bash-completion/completions/spring"
cp "$STAGE/opt/spring/LICENSE.txt" "$STAGE/opt/spring/legal/open_source_licenses.txt" \
  "$STAGE/usr/share/doc/$PACKAGE/spring-boot-cli/"
