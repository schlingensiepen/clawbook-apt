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

**Unter Windows (empfohlen):**

1. PowerShell öffnen und den Befehl von der Startseite von clawbook
   ausführen (im selben Fenster genügt später Pfeiltaste nach oben und
   Enter):

   ```powershell
   irm https://raw.githubusercontent.com/schlingensiepen/clawbook-lehre/main/get-clawbook.ps1 | iex
   ```

2. Menüpunkt **[11] Kurse und Technikpakete** wählen. Das Skript öffnet
   jetzt das Menü **im Container**: Die Zeilen, die Sie sehen, kommen
   von clawbook im Container, nicht mehr von Windows.
3. Die Nummer von `kurs-iot` eingeben, Enter; die Rückfrage der
   Paketverwaltung mit Enter bestätigen. Der Download umfasst etwa
   0,35 GB. Danach fragt clawbook, ob es die ESP32-Plattform für
   PlatformIO vorladen soll: etwa **6 GB** in Ihrem Home, 2 bis 20
   Minuten. Antworten Sie `j`, wenn Sie eine stabile Verbindung und
   genug Platz haben; Enter heißt „nein“ — dann später im Container
   mit `clawbook pakete vorladen` oder beim ersten Build.
4. Mit Enter das Menü im Container verlassen. Sie sind zurück im
   Verwaltungs-Skript unter Windows; es fragt, ob es das VSCodePack
   „IoT“ einrichten soll — Enter bestätigt.

**Im Container** geht es auch, im clawbook-Menü **6 Pakete und Kurse**
oder direkt mit `clawbook pakete add kurs-iot`. Das VSCodePack richtet
aber nur das Verwaltungs-Skript unter Windows ein (dort **[10] VSCodePacks
einrichten**, dann **[1]**).

Ausführlich beschreibt das die Seite
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info kurs-iot`.

## Verantwortungsvoll einsetzen

Der Kurs bringt mit `nmap` und `tshark` Werkzeuge zum Untersuchen von
Netzwerken und zum Mitlesen von Datenverkehr mit. Setzen Sie sie nur
ein für Ihre eigenen Systeme — etwa Ihren clawbook-Container — oder für
Netze und Rechner, für die Sie eine ausdrückliche Erlaubnis haben (zum
Beispiel in einer Übung). Fremde Rechner zu scannen oder fremden
Verkehr mitzuschneiden kann verboten sein; das gilt auch für das Netz
Ihrer Hochschule.

## Erste Schritte

**Wo Sie tippen:** Die Befehle unten tippen Sie im Terminal des
Containers, nicht in Windows. Starten Sie VS Code über das VSCodePack
„IoT“ — im Verwaltungs-Skript **[9] VS Code starten** oder über den
Startmenü-Eintrag „clawbook VS Code – IoT“ — und öffnen Sie im Menü
**Terminal → Neues Terminal** (englisch *Terminal → New Terminal*).
Alternativ in PowerShell `ssh clawbook`. Ihre Projekte gehören nach
`~/source`, den Projektordner in Ihrem Home. Begriffe wie Container,
Home oder VSCodePack erklärt das [Glossar](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/README.md#begriffe).

Prüfen Sie, ob alles da ist:

```bash
clawbook kurse          # kurs-iot  IoT  (…)
pio --version           # PlatformIO Core, version 6.2.0
mosquitto_pub --help | head -n 1
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:1880/   # 200 = Node-RED läuft
id -nG                  # enthält "wireshark" (nach neuem Verbinden)
```

Gute erste Beispiele: MQTT senden und empfangen
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
neu verbinden (für `tshark`): das VS-Code-Fenster schließen und über
**[9] VS Code starten** neu öffnen, bzw. nach `ssh clawbook` mit `exit`
abmelden und erneut `ssh clawbook`. Für Node-RED den Port 1880 in
VS Code weiterleiten. Zum Hochladen auf ein ESP32-Board: Der Container
sieht keine USB-Geräte Ihres Rechners; der Upload braucht einen Weg
über das Netz (ein eigenes Werkzeug dafür ist in Vorbereitung) oder OTA
über WLAN, siehe
[clawbook-embedded](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-embedded/README.md).

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
- **`tshark` darf nicht mitschneiden** — neu verbinden wie unter „Das
  tun Sie selbst“; hilft das nicht, siehe
  [clawbook-security](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-security/README.md).
- **Kein VSCodePack „IoT"** — Verwaltungs-Skript **[10]**, dann **[1]**.
- Probleme mit einem einzelnen Werkzeug: siehe „Wenn etwas nicht geht"
  in der Doku des jeweiligen Technikpakets (Tabelle oben).

## Links

- Kurs-Repository: <https://github.com/schlingensiepen/kurs-iot>
- Alle Kurse: <https://github.com/schlingensiepen/lehre>
