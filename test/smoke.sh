#!/bin/bash
# Smoke test of all packages, run as root inside a running clawbook
# container (s6 as PID 1) with the repository at REPO_URL.
#
#   REPO_URL   apt source (default file:///srv/clawbook-apt)
#   KEY_FILE   public key to trust (default <repo>/clawbook-apt.gpg)
#   PACKAGES   packages to install (default: all courses + clawbook-python)
set -uo pipefail

REPO_URL=${REPO_URL:-file:///srv/clawbook-apt}
KEY_FILE=${KEY_FILE:-}
PACKAGES=${PACKAGES:-"kurs-inf kurs-swe kurs-iot clawbook-python"}
FAILS=0

ok()  { printf 'OK    %s\n' "$*"; }
bad() { printf 'FAIL  %s\n' "$*"; FAILS=$((FAILS + 1)); }
# check DESCRIPTION COMMAND... (command runs as student in a login shell)
check() {
  local desc=$1 out; shift
  if out=$(runuser -l student -c "$*" 2>&1); then
    ok "$desc: $(printf '%s' "$out" | head -n 1)"
  else
    bad "$desc: $(printf '%s' "$out" | tail -n 3 | tr '\n' ' ')"
  fi
}
# wait_for SECONDS COMMAND...
wait_for() {
  local n=$1; shift
  for _ in $(seq "$n"); do "$@" >/dev/null 2>&1 && return 0; sleep 1; done
  return 1
}

echo "== apt source $REPO_URL"
if [ -n "$KEY_FILE" ]; then
  install -m 0644 "$KEY_FILE" /usr/share/keyrings/clawbook-apt.gpg
else
  curl -fsSL "$REPO_URL/clawbook-apt.gpg" -o /usr/share/keyrings/clawbook-apt.gpg 2>/dev/null \
    || cp "${REPO_URL#file://}/clawbook-apt.gpg" /usr/share/keyrings/clawbook-apt.gpg
fi
cat > /etc/apt/sources.list.d/clawbook.sources <<EOF
Types: deb
URIs: $REPO_URL
Suites: trixie
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/clawbook-apt.gpg
EOF
upd=$(apt-get update 2>&1)
if grep -qiE '^(W|E):|NO_PUBKEY|not signed|BADSIG' <<<"$upd"; then
  bad "apt-get update: $(grep -iE '^(W|E):' <<<"$upd" | head -n 3 | tr '\n' ' ')"
else
  ok "apt-get update (signature valid)"
fi
apt-cache policy kurs-inf | sed -n '1,4p'

echo "== install: $PACKAGES"
start=$(date +%s)
# shellcheck disable=SC2086
if DEBIAN_FRONTEND=noninteractive apt-get install -y -q $PACKAGES > /tmp/install.log 2>&1; then
  ok "apt-get install ($(( $(date +%s) - start )) s)"
else
  bad "apt-get install"; tail -n 30 /tmp/install.log
fi
grep -iE 'warn|error' /tmp/install.log | grep -v 'debconf' | head -n 10
dpkg-query -W -f='${Package}\t${Version}\t${X-Clawbook-Art}\t${Installed-Size}\n' 'clawbook-*' 'kurs-*' hurl

echo "== clawbook-python"
check "ruff"            ruff --version
check "pytest"          pytest --version
echo "== clawbook-java"
check "java 25"         "java -version 2>&1 | grep -q '\"25' && java -version 2>&1 | head -n 1"
check "maven"           "mvn -v | head -n 1"
check "gradle"          "gradle --version --no-daemon | grep -E '^Gradle '"
echo "== clawbook-spring"
check "spring"          spring --version
echo "== clawbook-dotnet"
check "dotnet"          dotnet --version
check "dotnet ef (first use, no warning)" 'rm -rf ~/.dotnet; out=$(dotnet ef --version 2>&1); echo "$out" | tr "\n" " "; ! echo "$out" | grep -qi "issue was encountered"'
check "telemetry off (login shell)" 'test "$DOTNET_CLI_TELEMETRY_OPTOUT" = 1 && echo DOTNET_CLI_TELEMETRY_OPTOUT=$DOTNET_CLI_TELEMETRY_OPTOUT'
if grep -q '^DOTNET_CLI_TELEMETRY_OPTOUT=1' /etc/environment; then ok "telemetry off (/etc/environment)"; else bad "telemetry not in /etc/environment"; fi
# Non-interactive SSH session without login shell, as VS Code Remote-SSH starts it.
check "telemetry off (ssh, no login shell)" 'ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -i ~/.ssh/id_ed25519 student@127.0.0.1 "echo DOTNET_CLI_TELEMETRY_OPTOUT=\$DOTNET_CLI_TELEMETRY_OPTOUT" | grep -x "DOTNET_CLI_TELEMETRY_OPTOUT=1"'
check "dotnet new + run" "rm -rf /tmp/dn && dotnet new console -o /tmp/dn >/dev/null && dotnet run --project /tmp/dn"
echo "== clawbook-db-postgres"
if wait_for 30 test -S /run/postgresql/.s.PGSQL.5432; then ok "postgres socket"; else bad "postgres socket missing"; fi
check "psql (peer)"     "psql -Atc 'select version()'"
check "psql (tcp)"      "psql -h localhost -d postgres -Atc 'select current_user'"
check "data in home"    "test -s ~/.local/share/postgresql/17/PG_VERSION && echo ~/.local/share/postgresql/17"
check "no /var/lib cluster" "test -z \"\$(pg_lsclusters -h)\" && echo none"
echo "== clawbook-db-sqlite"
check "sqlite3"         "sqlite3 :memory: 'select sqlite_version()'"
echo "== clawbook-webapi"
check "httpie"          http --version
check "xh"              xh --version
check "hurl"            "hurl --version | head -n 1"
echo "== clawbook-modeling"
check "plantuml"        "plantuml -version | head -n 1"
check "plantuml render" "printf '@startuml\nA -> B: test\n@enduml\n' | plantuml -pipe -tpng | head -c 4 | od -An -c | tr -d ' ' | grep -q PNG && echo PNG ok"
check "graphviz"        "dot -V 2>&1"
echo "== clawbook-embedded"
check "pio"             pio --version
check "esptool"         "(command -v esptool || command -v esptool.py) && (esptool version 2>/dev/null || esptool.py version) | tail -n 1"
check "pyserial"        "python3 -c 'import serial; print(\"pyserial\", serial.__version__)'"
echo "== clawbook-iot"
check "mosquitto_pub"   "mosquitto_pub --help | head -n 1"
check "paho-mqtt"       "python3 -c 'import paho.mqtt; print(\"paho-mqtt\", paho.mqtt.__version__)'"
echo "== clawbook-nodered"
if wait_for 60 curl -fs http://127.0.0.1:1880/; then ok "node-red http 200 on 127.0.0.1:1880"; else bad "node-red not answering"; fi
listen=$(ss -ltn 2>/dev/null | awk '$4 ~ /:1880$/ { print $4 }')
if [ "$listen" = "127.0.0.1:1880" ]; then ok "node-red listens only on $listen"; else bad "node-red listens on '$listen'"; fi
check "node-red user dir" "test -d ~/.node-red && echo ~/.node-red"
echo "== clawbook-security"
check "nmap"            "nmap --version | head -n 1"
check "dumpcap caps"    "/usr/sbin/getcap /usr/bin/dumpcap"
check "student in wireshark" "id -nG | tr ' ' '\n' | grep -x wireshark"
check "tshark -D"       "tshark -D | head -n 1"
check "capture as student" "timeout 10 tshark -i lo -c 1 -f 'tcp port 1880' -q -w /tmp/cap.pcap & sleep 2; curl -s http://127.0.0.1:1880/ >/dev/null; wait; test -s /tmp/cap.pcap && echo captured"
apt-get install -y -q --reinstall wireshark-common >/dev/null 2>&1
if getcap /usr/bin/dumpcap | grep -q 'cap_net_raw=eip' && [ "$(stat -c %U:%G:%a /usr/bin/dumpcap)" = root:wireshark:754 ]; then
  ok "trigger after reinstall of wireshark-common: $(getcap /usr/bin/dumpcap), $(stat -c %U:%G:%a /usr/bin/dumpcap)"
else
  bad "trigger: $(getcap /usr/bin/dumpcap) $(stat -c %U:%G:%a /usr/bin/dumpcap)"
fi
echo "== VS Code lists and course descriptions"
ls /usr/share/clawbook/vscode-extensions.d/
check "clawbook stand"  "clawbook stand --json | python3 -c 'import json,sys; d=json.load(sys.stdin); print(len(d[\"pakete\"]), \"Pakete,\", len(d[\"vscode\"][\"container\"][\"erweiterungen\"]), \"Erweiterungen\")'"
for k in kurs-inf kurs-swe kurs-iot; do
  check "clawbook kurs vscode $k" "clawbook kurs vscode $k | head -n 1"
done

echo "== removal of the service packages"
apt-get remove -y -q clawbook-db-postgres clawbook-nodered kurs-swe kurs-iot >/dev/null 2>&1
sleep 3
if [ ! -e /run/service/postgresql ] && [ ! -e /run/service/node-red ]; then ok "services unregistered"; else bad "service dirs still in /run/service"; fi
if ! pgrep -x postgres >/dev/null && ! pgrep -f node-red/red.js >/dev/null; then ok "services stopped"; else bad "processes still running"; fi
apt-get remove -y -q clawbook-dotnet >/dev/null 2>&1
if ! grep -q clawbook-dotnet /etc/environment; then ok "dotnet block removed from /etc/environment"; else bad "dotnet block left in /etc/environment"; fi

echo "== result: $FAILS failure(s)"
[ "$FAILS" = 0 ]
