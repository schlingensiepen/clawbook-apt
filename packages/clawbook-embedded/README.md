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

Das Paket kommt mit dem Kurs `kurs-iot`. Einzeln installieren Sie es
auf einem dieser Wege:

- **Unter Windows** im Verwaltungs-Skript: PowerShell öffnen und den
  Befehl von der Startseite von clawbook ausführen:

  ```powershell
  irm https://raw.githubusercontent.com/schlingensiepen/clawbook-lehre/main/get-clawbook.ps1 | iex
  ```

  Dann Menüpunkt **[11] Kurse und Technikpakete**, `t` und die Nummer
  von `clawbook-embedded`.
- **Im Container** (Terminal, siehe „Erste Schritte“):

  ```bash
  clawbook pakete add clawbook-embedded
  ```

Ausführlich beschreibt das die Seite
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info clawbook-embedded`.

Nach der Installation fragt clawbook, ob es die ESP32-Plattform jetzt
vorladen soll (etwa 6 GB, 2 bis 20 Minuten). Später geht das im
Container mit:

```bash
clawbook pakete vorladen
```

## Erste Schritte

**Wo Sie tippen:** Alle Befehle auf dieser Seite tippen Sie im
Terminal des Containers, nicht in Windows. Am einfachsten in VS Code:
VS Code über das Verwaltungs-Skript (**[9] VS Code starten**) oder den
Startmenü-Eintrag „clawbook VS Code“ öffnen, dann im Menü **Terminal →
Neues Terminal** (englisch *Terminal → New Terminal*). Weitere
Terminals öffnet das Plus-Symbol im Terminalbereich. Alternativ in
PowerShell `ssh clawbook`. Ihre Projekte legen Sie unter `~/source` an,
dem Projektordner in Ihrem Home (`~` steht für `/home/student`).
Begriffe wie Container, Home oder VSCodePack erklärt das
[Glossar](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/README.md#begriffe).

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
und Projekte anlegen. Zum Hochladen auf ein Board: Der Container sieht
keine USB-Geräte Ihres Rechners. Der Upload braucht deshalb einen Weg
über das Netz — ein eigenes Werkzeug, das den seriellen Anschluss des
Boards von Windows aus bereitstellt, ist in Vorbereitung — oder ein
Update über WLAN (OTA), sobald das Board ein Programm mit OTA-Funktion
trägt.

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
