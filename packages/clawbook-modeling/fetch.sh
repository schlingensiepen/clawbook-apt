#!/bin/bash
# PlantUML jar (MIT edition) into /opt/plantuml, checksum pinned.
set -euo pipefail
. "$CLAWBOOK_APT_ROOT/lib/common.sh"
. ./versions.env
require PLANTUML_VERSION PLANTUML_SHA256 PLANTUML_LICENSE_SHA256

v=$PLANTUML_VERSION
jar=$(fetch "https://github.com/plantuml/plantuml/releases/download/v$v/plantuml-mit-$v.jar" "sha256:$PLANTUML_SHA256")
lic=$(fetch "https://raw.githubusercontent.com/plantuml/plantuml/v$v/plantuml-mit/mit-license.txt" \
  "sha256:$PLANTUML_LICENSE_SHA256" "plantuml-$v-mit-license.txt")
install -D -m 0644 "$jar" "$STAGE/opt/plantuml/plantuml.jar"
install -D -m 0644 "$lic" "$STAGE/usr/share/doc/$PACKAGE/plantuml/mit-license.txt"
