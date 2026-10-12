# clawbook-apt

Signiertes apt-Repository mit **Technikpaketen** und **Kursen** für
[clawbook-lehre](https://github.com/schlingensiepen/clawbook-lehre), den
Arbeitsrechner im Container für die Arbeit mit KI-Agenten (Debian 13
„trixie“, amd64).

clawbook selbst ist der allgemeine Kern. Was eine Technik oder ein Kurs
zusätzlich braucht, kommt als Debian-Paket aus diesem Repository:

- Ein **Technikpaket** (`clawbook-…`) bringt die Werkzeuge einer Technik
  mit: Abhängigkeiten auf Debian-Pakete und, wo Debian nichts Passendes
  hat, Dateien des Herausgebers mit fester Version und Prüfsumme. Dazu kommt
  die Liste der VS-Code-Erweiterungen, die im Container gebraucht werden.
- Ein **Kurs** (`kurs-…`) ist ein Meta-Paket, das nur von Technikpaketen
  abhängt. Es liefert die Kursbeschreibung für das VSCodePack unter Windows.
  Mehrere Kurse lassen sich nebeneinander installieren; apt vereinigt ihre
  Abhängigkeiten.

Im Container installiert man Pakete am einfachsten mit dem Menü von
`clawbook`. Mit apt geht es direkt so: `sudo apt install kurs-inf`.

Jedes Paket hat eine Nutzer-Doku unter `packages/<paket>/README.md`
(verlinkt in den Tabellen unten). Sie liegt im Paket auch unter
`/usr/share/doc/<paket>/README.md`; im Container zeigt sie
`clawbook pakete info <paket>`. (Debian-Slim-Images lassen
`/usr/share/doc` beim Installieren weg; das clawbook-Image nimmt die
READMEs dieser Pakete mit einer dpkg-Regel wieder auf. Fehlt die Datei,
zeigt `clawbook` die Adresse im Netz.)

Das Repository liegt auf GitHub Pages:
<https://schlingensiepen.github.io/clawbook-apt/>

## Einbindung

Der öffentliche Schlüssel und die Quelle gehören ins Image (im clawbook-Image
ist beides schon eingetragen). Von Hand:

```sh
sudo curl -fsSLo /usr/share/keyrings/clawbook-apt.gpg \
  https://schlingensiepen.github.io/clawbook-apt/clawbook-apt.gpg
sudo tee /etc/apt/sources.list.d/clawbook.sources >/dev/null <<'EOF'
Types: deb
URIs: https://schlingensiepen.github.io/clawbook-apt
Suites: trixie
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/clawbook-apt.gpg
EOF
sudo apt update
```

Prüfe nach dem Herunterladen den Fingerabdruck des Schlüssels mit
`gpg --show-keys /usr/share/keyrings/clawbook-apt.gpg`. Er muss so lauten:

```
BCE0 078E 3FAE 6F4D 0F37  060F F521 38F6 DF26 721B
clawbook-apt signing key <noreply@github.com>   (ed25519, gültig bis 2029-10-11)
```

Der Schlüssel liegt auch in diesem Repository unter `keys/`, einmal als
Text (`clawbook-apt.asc`) und einmal binär (`clawbook-apt.gpg`).

## Pakete

| Paket | Inhalt | Herkunft der Bestandteile | VS-Code-Erweiterungen im Container |
|---|---|---|---|
| [`clawbook-python`](packages/clawbook-python/README.md) | pytest, ruff | Debian; ruff vom Herausgeber (Astral) | ms-python.python, ms-python.debugpy, ms-python.vscode-pylance, charliermarsh.ruff |
| [`clawbook-java`](packages/clawbook-java/README.md) | OpenJDK 25, Maven, Gradle 9 | Debian; Gradle von gradle.org nach `/opt/gradle` | vscjava.vscode-java-pack |
| [`clawbook-spring`](packages/clawbook-spring/README.md) | Spring-Boot-CLI (`spring`), hängt von `clawbook-java` ab | Maven Central nach `/opt/spring` | vmware.vscode-boot-dev-pack |
| [`clawbook-dotnet`](packages/clawbook-dotnet/README.md) | .NET SDK 10.0 (LTS), `dotnet-ef` | Microsoft-Tarball, umgepackt nach `/usr/lib/dotnet`; dotnet-ef von nuget.org | ms-dotnettools.csharp, ms-dotnettools.csdevkit |
| [`clawbook-db-postgres`](packages/clawbook-db-postgres/README.md) | PostgreSQL 17 als Dienst für `student` | Debian | ms-ossdata.vscode-pgsql |
| [`clawbook-db-sqlite`](packages/clawbook-db-sqlite/README.md) | sqlite3 | Debian | zknpr.sqlite-explorer |
| [`clawbook-webapi`](packages/clawbook-webapi/README.md) | httpie, xh, hurl, curl | Debian; hurl vom Herausgeber (Orange) | humao.rest-client, anweber.vscode-httpyac |
| [`clawbook-modeling`](packages/clawbook-modeling/README.md) | PlantUML (`plantuml`), Graphviz, Java-25-Laufzeit | Debian; PlantUML-Jar (MIT-Fassung) nach `/opt/plantuml` | jebbs.plantuml |
| [`clawbook-embedded`](packages/clawbook-embedded/README.md) | PlatformIO Core (`pio`), esptool, pyserial | Debian; PlatformIO von PyPI in einer festen Python-Umgebung unter `/opt/platformio` | platformio.platformio-ide |
| [`clawbook-iot`](packages/clawbook-iot/README.md) | mosquitto-clients, paho-mqtt | Debian | – |
| [`clawbook-nodered`](packages/clawbook-nodered/README.md) | Node-RED als Dienst für `student` | npm (Lockfile) nach `/usr/lib/clawbook/node-red` | – |
| [`clawbook-security`](packages/clawbook-security/README.md) | nmap, tshark, gnupg; Mitschneiden ohne sudo | Debian | – |
| `hurl` | unverändertes Paket des Herausgebers | GitHub-Release von Orange | – |

| Kurs | Titel | Technikpakete |
|---|---|---|
| [`kurs-inf`](packages/kurs-inf/README.md) | Ingenieurinformatik | clawbook-spring (mit clawbook-java), clawbook-webapi, clawbook-db-sqlite |
| [`kurs-swe`](packages/kurs-swe/README.md) | Softwareengineering | clawbook-spring, clawbook-dotnet, clawbook-db-postgres, clawbook-db-sqlite, clawbook-webapi, clawbook-modeling |
| [`kurs-iot`](packages/kurs-iot/README.md) | IoT | clawbook-embedded, clawbook-iot, clawbook-nodered, clawbook-security, clawbook-webapi |

Die Versionen der Fremdbestandteile stehen in `packages/<paket>/versions.env`
und in den Lockfiles (`requirements.txt`, `package-lock.json`).

### Hinweise zu einzelnen Paketen

- **Dienste** (`clawbook-db-postgres`, `clawbook-nodered`) laufen unter
  s6-overlay als Benutzer `student`. Das Paket meldet den Dienst beim
  Installieren sofort an und beim Entfernen wieder ab. s6-overlay liest
  `/etc/services.d` sonst nur beim Containerstart.
- **PostgreSQL:** Die Daten liegen in `~/.local/share/postgresql/17` und
  überstehen damit ein neues Image. Beim ersten Start legt der Dienst die
  Datenbank `student` an (dauert einige Sekunden); danach genügt `psql`.
  Über TCP (`localhost:5432`, etwa für VS Code) geht es ohne Passwort, weil
  der Container nur einen Benutzer hat. Der Port darf deshalb nicht nach
  außen veröffentlicht werden. Den Standard-Cluster unter
  `/var/lib/postgresql` entfernt das Paket. Bei einer neuen Hauptversion
  (künftiges Debian) braucht es `pg_upgrade`.
- **Node-RED:** Der Editor hat keine Anmeldung und hört deshalb nur auf
  `127.0.0.1:1880`. In VS Code erreicht man ihn über „Ports“ →
  Weiterleitung. Die Flows liegen in `~/.node-red`. Node.js (ab 22.9) kommt
  aus dem clawbook-Image und ist darum keine Paketabhängigkeit.
- **.NET:** `DOTNET_CLI_TELEMETRY_OPTOUT=1` und `DOTNET_NOLOGO=1` stehen in
  `/etc/profile.d/clawbook-dotnet.sh` und in einem markierten Block in
  `/etc/environment`. So gelten sie auch für SSH-Sitzungen ohne Login-Shell,
  wie VS Code sie startet. `dotnet-ef` liegt unter `/usr/lib/dotnet-tools`.
- **tshark:** `dumpcap` bekommt nur die Fähigkeit `cap_net_raw`, gehört
  `root:wireshark` (Modus 0754), und `student` kommt in die Gruppe
  `wireshark`. Debians eigener Weg setzt zusätzlich `cap_net_admin`; Docker
  erlaubt diese Fähigkeit standardmäßig nicht, deshalb würde `dumpcap` dann
  gar nicht starten. Ein dpkg-Trigger setzt die Rechte nach jedem Update von
  `wireshark-common` neu. Die neue Gruppe gilt ab der nächsten Anmeldung.
- **PlatformIO:** Plattformen und Toolchains (für ESP32 mit pioarduino etwa 6 GB, nur auf Nachfrage vorgeladen) lädt
  PlatformIO selbst nach `~/.platformio`, beim ersten Build oder durch
  `clawbook`. Ein gemeinsames, schreibgeschütztes Verzeichnis unterstützt
  PlatformIO nicht. Die Kursbeschreibung von `kurs-iot` stellt die
  Erweiterung auf den mitgelieferten `pio` um
  (`platformio-ide.useBuiltinPIOCore: false`).
- **Gradle, Maven:** `maven` zieht in Debian zusätzlich OpenJDK 21 mit; `java`
  zeigt trotzdem auf 25.

## Aufbau dieses Repositorys

```
build.sh                    baut alle Pakete und das signierte Repository nach public/
lib/                        Hilfsfunktionen (Download mit Prüfsumme, index.html)
keys/                       öffentlicher Signaturschlüssel
packages/<paket>/
  control                   Paketfelder, u. a. X-Clawbook-Art: technik | kurs
  README.md                 Nutzer-Doku (landet unter /usr/share/doc/<paket>/)
  copyright                 Lizenzen (landet unter /usr/share/doc/<paket>/)
  vscode-extensions.list    VS-Code-Erweiterungen im Container (Technikpakete)
  vscode.json               Kursbeschreibung, Format 1 (nur Kurse)
  files/                    mitgelieferte Dateien, so wie sie im System liegen
  versions.env, fetch.sh    Fremdbestandteile: Version, Prüfsumme, Einbau
  postinst, prerm, ...      Maintainer-Skripte, wo nötig
upstream/<paket>.env        unverändert übernommene .deb von Herausgebern
test/                       lokaler Test mit Docker (Bau und Installation)
.github/workflows/          publish.yml (main → Pages), check.yml (Pull Requests)
```

`build.sh` legt die Dateien eines Pakets so ab:

- `vscode-extensions.list` → `/usr/share/clawbook/vscode-extensions.d/<paket>.list`
- `vscode.json` → `/usr/share/clawbook/kurse/<kennung>/vscode.json`

Die Pakete baut `dpkg-deb`, den Index `apt-ftparchive`, signiert wird mit
`gpg` (`InRelease` und `Release.gpg`). Suite `stable`, Codename `trixie`,
Komponente `main`, Architektur `amd64`.

## Bauen und testen

Die CI baut bei jedem Push nach `main`. Sie läuft in einem
Debian-trixie-Container, signiert mit dem Schlüssel aus den Secrets
`APT_SIGNING_KEY` und `APT_SIGNING_FPR` und veröffentlicht nach GitHub
Pages. Bei Pull Requests baut sie unsigniert und veröffentlicht nichts.

Lokal mit Docker:

```sh
test/run-docker.sh                 # bauen (Testschlüssel) und in clawbook-lehre:local testen
./build.sh --check                 # nur die Paketdefinitionen prüfen
```

Der lokale Bau signiert mit einem Wegwerf-Schlüssel. Das Ergebnis in
`public/` darf deshalb nicht veröffentlicht werden. `build.sh` prüft, dass
der Signaturschlüssel zu `keys/clawbook-apt.asc` passt; nur der Test setzt
dafür ausdrücklich `PUBLIC_KEY` auf den Testschlüssel. `clawbook-embedded`
muss als root in einem frischen Container gebaut werden: Die
Python-Umgebung entsteht an ihrem endgültigen Ort `/opt/platformio`, denn
eine venv lässt sich nicht verschieben.

## Versionen aktualisieren

1. In `packages/<paket>/versions.env` Version **und** Prüfsumme des
   Herausgebers eintragen. Bei PlatformIO `requirements.txt` neu erzeugen
   (`uv pip compile --generate-hashes --python-version 3.13`), bei Node-RED
   `package.json` und `package-lock.json`. Weicht eine Prüfsumme ab, bricht
   der Bau ab.
2. Im `control` die Paketversion erhöhen, z. B. `0.8.0-1` → `0.8.0-2`. Ohne
   neue Version spielt apt die Änderung nicht ein.
3. Pull Request; nach dem Merge veröffentlicht die CI.

## Einen Kurs ergänzen (Pull Request)

Kurs-Repositories ergänzen ihren Kurs per Pull Request hier, nicht über eine
eigene Paketquelle.

1. Verzeichnis `packages/kurs-<kürzel>/` anlegen. Die Kennung heißt wie das
   Kurs-Repository.
2. `control` nach dem Muster von `packages/kurs-inf/control`:
   `Package` = Kennung, `Architecture: all`, `X-Clawbook-Art: kurs`,
   `Depends:` nur auf `clawbook-…`-Pakete. Kurzbeschreibung `Kurs <Titel>`.
3. `copyright` wie bei den anderen Kursen, `README.md` (Nutzer-Doku)
   nach dem Muster von `packages/kurs-inf/README.md`.
4. `vscode.json` (Format 1) mit diesen Feldern:
   - `kennung` = Paketname
   - `titel`
   - `ordner` (`/home/student/source`)
   - `links`: zuerst das Kurs-Repository, dann
     `https://github.com/schlingensiepen/lehre`
   - `windows.erweiterungen` (mindestens `ms-vscode-remote.remote-ssh`)
   - `container.erweiterungen`: nur Zusätze, die kein Technikpaket schon
     mitbringt
   - `einstellungen`
5. `./build.sh --check` ausführen.

Ein Kurs-Paket enthält keine eigenen Dateien außer der Kursbeschreibung
und der Doku,
keine Maintainer-Skripte, keine fremden Quellen und keine fremden
Schlüssel; `build.sh --check` prüft das. Fehlt ein Werkzeug, gehört es in
ein (neues) Technikpaket.

## Lizenz

Die Paketierung (Skripte, Paketdefinitionen) steht unter der Apache
License 2.0 (`LICENSE`). Die mitgelieferten Fremdbestandteile behalten ihre
eigenen Lizenzen; sie stehen in `/usr/share/doc/<paket>/copyright` des
jeweiligen Pakets.
