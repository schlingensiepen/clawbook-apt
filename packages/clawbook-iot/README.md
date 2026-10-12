# clawbook-iot — MQTT

Dieses Paket bringt Werkzeuge für MQTT mit, das Nachrichtenprotokoll
vieler IoT-Geräte: Kommandozeilen-Clients zum Senden und Empfangen und
eine Python-Bibliothek für eigene Programme.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| Mosquitto-Clients | 2.0.21 | `mosquitto_pub`, `mosquitto_sub` | Debian |
| paho-mqtt | 2.1.0 | (Python-Bibliothek) | Debian |

Einen eigenen MQTT-Broker (Server) bringt das Paket nicht mit. Sie
verbinden sich mit dem Broker, den Sie verwenden, zum Ausprobieren zum
Beispiel mit dem öffentlichen Test-Broker `test.mosquitto.org`.

VS-Code-Erweiterungen: keine.

## Installieren

Das Paket kommt mit dem Kurs `kurs-iot`. Einzeln installieren Sie es
auf einem dieser Wege:

- **Unter Windows** im Verwaltungs-Skript: PowerShell öffnen und den
  Befehl von der Startseite von clawbook ausführen:

  ```powershell
  irm https://raw.githubusercontent.com/schlingensiepen/clawbook-lehre/main/get-clawbook.ps1 | iex
  ```

  Dann Menüpunkt **[11] Kurse und Technikpakete**, `t` und die Nummer
  von `clawbook-iot`.
- **Im Container** (Terminal, siehe „Erste Schritte“):

  ```bash
  clawbook pakete add clawbook-iot
  ```

Ausführlich beschreibt das die Seite
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info clawbook-iot`.

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

Öffnen Sie zwei Terminals. Wählen Sie ein Thema (Topic), das sonst
niemand benutzt, etwa mit Ihrem Namen.

Terminal 1 — empfangen:

```bash
mosquitto_sub -h test.mosquitto.org -t 'clawbook/erika/temperatur' -v
```

Terminal 2 — senden:

```bash
mosquitto_pub -h test.mosquitto.org -t 'clawbook/erika/temperatur' -m '21.5'
```

In Terminal 1 erscheint `clawbook/erika/temperatur 21.5`. `Strg+C`
beendet `mosquitto_sub`.

**Mit Python:** `empfangen.py`

```python
import paho.mqtt.subscribe as subscribe

msg = subscribe.simple("clawbook/erika/temperatur", hostname="test.mosquitto.org")
print(msg.topic, msg.payload.decode())
```

und `senden.py`

```python
import paho.mqtt.publish as publish

publish.single("clawbook/erika/temperatur", "22.0", hostname="test.mosquitto.org")
```

Starten Sie zuerst `python3 empfangen.py`, dann in einem zweiten
Terminal `python3 senden.py`.

Öffentliche Test-Broker sind für alle lesbar. Schicken Sie dort nichts
Persönliches.

## Wer macht was

**Das erledigt clawbook:** die Clients und paho-mqtt installieren.

**Das tun Sie selbst:** einen Broker wählen. Braucht Ihr Broker
Benutzername und Passwort, geben Sie sie mit `-u <name> -P <passwort>`
an (in Python: `auth={"username": …, "password": …}`).

**Falls die Automatik nicht geht:** Fehlt ein Befehl oder die
Python-Bibliothek, installieren Sie das Paket erneut:
`sudo apt-get install --reinstall mosquitto-clients python3-paho-mqtt`.

## Wenn etwas nicht geht

- **„Error: Connection refused"** oder keine Antwort — Broker-Adresse
  oder Port (Standard 1883) stimmt nicht, oder das Netz blockiert den
  Port. Adresse prüfen oder es aus einem anderen Netz versuchen.
- **`mosquitto_sub` zeigt nichts** — Sender und Empfänger müssen exakt
  dasselbe Topic verwenden (Groß-/Kleinschreibung zählt). Zum Testen
  `-t 'clawbook/erika/#'` abonnieren: `#` steht für alles darunter.
- **Python-Empfänger bekommt nichts** — er muss laufen, *bevor* die
  Nachricht gesendet wird.
- **„ModuleNotFoundError: No module named 'paho'"** in einer
  virtuellen Umgebung — dort `pip install paho-mqtt` ausführen; die
  Bibliothek aus dem Paket gilt nur für das System-Python.
