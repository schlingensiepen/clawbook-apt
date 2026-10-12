# clawbook-embedded — Mikrocontroller mit PlatformIO

Dieses Paket bringt PlatformIO mit, das Werkzeug für Programme auf
Mikrocontrollern wie dem ESP32. Sie schreiben C++ mit dem
Arduino-Framework und bauen es im Container.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| PlatformIO Core | 6.2.0 | `pio`, `platformio` | PyPI, unter `/opt/platformio` |
| esptool | 4.7 | `esptool` | Debian |
| pyserial | 3.5 | (Python-Bibliothek) | Debian |

VS-Code-Erweiterungen im Container: PlatformIO IDE
(`platformio.platformio-ide`).

Die ESP32-Plattform selbst (Compiler, Arduino-Framework, etwa 6 GB) ist
**nicht** im Paket. PlatformIO lädt sie nach `~/.platformio` in Ihr
Home — beim Vorladen durch clawbook oder beim ersten Build.

## Installieren

Das Paket kommt mit dem Kurs `kurs-iot`. Einzeln installieren Sie es im
Container so:

```bash
clawbook pakete add clawbook-embedded
```

Oder im clawbook-Menü **6 Pakete und Kurse**, dann `t`. Wie Kurse und
Technikpakete funktionieren, steht in
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch
`clawbook pakete info clawbook-embedded`.

Nach der Installation fragt clawbook, ob es die ESP32-Plattform jetzt
vorladen soll (etwa 6 GB, 2 bis 20 Minuten). Später geht das mit:

```bash
clawbook pakete vorladen
```

## Erste Schritte

Ein Projekt für ein ESP32-Board (hier `esp32dev`) mit dem
Arduino-Core 3.x von pioarduino anlegen:

```bash
mkdir -p ~/source/blink && cd ~/source/blink
pio project init
```

`platformio.ini` ersetzen durch:

```ini
[env:esp32dev]
platform = https://github.com/pioarduino/platform-espressif32/releases/download/stable/platform-espressif32.zip
board = esp32dev
framework = arduino
monitor_speed = 115200
```

`src/main.cpp` anlegen:

```cpp
#include <Arduino.h>

void setup() {
  Serial.begin(115200);
}

void loop() {
  Serial.println("Hallo vom ESP32");
  delay(1000);
}
```

Prüfen und bauen:

```bash
pio project config     # zeigt die Einstellungen von env:esp32dev
pio run                # baut das Programm
```

Ist die Plattform noch nicht vorgeladen, lädt `pio run` beim ersten
Mal die etwa 6 GB; das dauert. Danach baut es in Sekunden und ohne
Internet.

In VS Code öffnen Sie den Projektordner; die PlatformIO-Erweiterung
zeigt unten in der Statusleiste Symbole für **Build** (Haken) und
**Upload** (Pfeil).

## Wer macht was

**Das erledigt clawbook:** PlatformIO, esptool und pyserial
installieren; auf Nachfrage die ESP32-Plattform vorladen. Im Kurs
`kurs-iot` stellt das VSCodePack die Erweiterung auf das mitgelieferte
`pio` um (`platformio-ide.useBuiltinPIOCore: false`).

**Das tun Sie selbst:** Entscheiden, ob Sie vorladen (Platz und Zeit),
und Projekte anlegen. Ein Board per USB anschließen: Der Container
sieht die USB-Anschlüsse Ihres Rechners nicht von selbst. Wie das Board
zum Hochladen erreichbar wird, sagt Ihnen Ihre Lehrveranstaltung.

**Falls die Automatik nicht geht:** Ohne Kurs (Paket einzeln
installiert) tragen Sie in den VS-Code-Einstellungen
`"platformio-ide.useBuiltinPIOCore": false` und
`"platformio-ide.useBuiltinPython": false` ein. Sonst installiert die
Erweiterung ein zweites PlatformIO in Ihr Home.

## Wenn etwas nicht geht

- **Der erste `pio run` dauert sehr lange** — er lädt die Plattform
  (etwa 6 GB). Warten oder vorher `clawbook pakete vorladen`.
- **„Das Vorladen hat nicht geklappt (pio …)"** — meist Verbindung
  abgebrochen oder Platz knapp. `clawbook pakete vorladen` mit stabiler
  Verbindung wiederholen; `df -h ~` zeigt den freien Platz.
- **„UnknownBoard"** — der Name hinter `board =` stimmt nicht. Gültige
  Namen zeigt `pio boards esp32` (nach dem Vorladen).
- **`pio device list` zeigt kein Board** — der Container sieht kein
  USB (siehe oben).
- **Das Home wird voll** — `~/.platformio` belegt etwa 6 GB. Brauchen
  Sie PlatformIO nicht mehr: `rm -rf ~/.platformio`.
