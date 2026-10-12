# kurs-iot — IoT

Dieses Kurs-Paket richtet Ihren clawbook-Container für die
Lehrveranstaltung IoT ein: ESP32 mit PlatformIO und Arduino, MQTT,
Node-RED, Netzwerkanalyse und Web-APIs.

## Was drin ist

Der Kurs bringt diese Technikpakete mit; deren Dokus erklären die
Werkzeuge mit Beispielen:

| Technikpaket | Wofür |
|---|---|
| [clawbook-embedded](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-embedded/README.md) | PlatformIO (`pio`) für ESP32, `esptool` |
| [clawbook-iot](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-iot/README.md) | MQTT: `mosquitto_pub`, `mosquitto_sub`, paho-mqtt |
| [clawbook-nodered](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-nodered/README.md) | Node-RED als Dienst (Port 1880) |
| [clawbook-security](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-security/README.md) | `nmap`, `tshark`, `gpg` |
| [clawbook-webapi](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-webapi/README.md) | Web-APIs testen: `http`, `xh`, `hurl`, `curl` |

Dazu kommt die Kursbeschreibung für das VSCodePack „IoT": ein eigenes
VS Code unter Windows mit den Erweiterungen aller Technikpakete; die
PlatformIO-Erweiterung nutzt darin das mitgelieferte PlatformIO.

## Installieren

Am einfachsten im Verwaltungs-Skript unter Windows, Menüpunkt **[11]
Kurse und Technikpakete**, dann die Nummer von `kurs-iot`. Im Container
geht es im clawbook-Menü **6 Pakete und Kurse** oder direkt:

```bash
clawbook pakete add kurs-iot
```

Der Download umfasst etwa 0,35 GB. Danach fragt clawbook, ob es die
ESP32-Plattform für PlatformIO vorladen soll: etwa **6 GB** in Ihrem
Home, 2 bis 20 Minuten. Sagen Sie Ja, wenn Sie eine stabile Verbindung
und genug Platz haben; sonst später mit `clawbook pakete vorladen` oder
beim ersten Build.

Alles Weitere — auch das VSCodePack — beschreibt
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info kurs-iot`.

## Erste Schritte

Prüfen Sie im Container, ob alles da ist:

```bash
clawbook kurse          # kurs-iot  IoT  (…)
pio --version           # PlatformIO Core, version 6.2.0
mosquitto_pub --help | head -n 1
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:1880/   # 200 = Node-RED läuft
id -nG                  # enthält "wireshark" (nach neuer Anmeldung)
```

Starten Sie danach VS Code über das VSCodePack „IoT"
(Verwaltungs-Skript **[9] VS Code starten** oder Startmenü „clawbook
VS Code – IoT"). Gute erste Beispiele: MQTT senden und empfangen
([clawbook-iot](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-iot/README.md))
und der Node-RED-Editor
([clawbook-nodered](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-nodered/README.md)).

## Wer macht was

**Das erledigt clawbook:** alle Technikpakete installieren, Node-RED
als Dienst starten, das Mitschneiden ohne `sudo` erlauben, auf
Nachfrage PlatformIO vorladen, die Pakete nach einer Aktualisierung von
clawbook wiederherstellen und das VSCodePack zum Kurs einrichten (das
Verwaltungs-Skript fragt danach).

**Das tun Sie selbst:** den Kurs einmal auswählen, über das Vorladen
entscheiden und das VSCodePack bestätigen. Nach der Installation einmal
ab- und wieder anmelden (für `tshark`). Für Node-RED den Port 1880 in
VS Code weiterleiten. Wie ein ESP32-Board per USB zum Hochladen
erreichbar wird, sagt Ihnen Ihre Lehrveranstaltung — der Container
sieht die USB-Anschlüsse Ihres Rechners nicht von selbst.

**Falls die Automatik nicht geht:** Fehlt das VSCodePack oder fehlen
Erweiterungen, im Verwaltungs-Skript **[10] VSCodePacks einrichten**,
dann **[1]** wählen. Ist das Vorladen gescheitert:
`clawbook pakete vorladen`.

## Wenn etwas nicht geht

- **`clawbook kurse` zeigt den Kurs nicht** — die Installation wurde
  abgebrochen. Den Kurs im Menü erneut wählen; Geladenes lädt `apt`
  nicht noch einmal.
- **Das Home wird voll** — `~/.platformio` belegt etwa 6 GB. Brauchen
  Sie PlatformIO nicht mehr: `rm -rf ~/.platformio`.
- **`tshark` darf nicht mitschneiden** — abmelden (`exit`) und neu
  verbinden.
- **Kein VSCodePack „IoT"** — Verwaltungs-Skript **[10]**, dann **[1]**.
- Probleme mit einem einzelnen Werkzeug: siehe „Wenn etwas nicht geht"
  in der Doku des jeweiligen Technikpakets (Tabelle oben).

## Links

- Kurs-Repository: <https://github.com/schlingensiepen/kurs-iot>
- Alle Kurse: <https://github.com/schlingensiepen/lehre>
