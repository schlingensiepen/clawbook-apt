# clawbook-iot — MQTT

Dieses Paket bringt Werkzeuge für MQTT mit, das Nachrichtenprotokoll
vieler IoT-Geräte: Kommandozeilen-Clients zum Senden und Empfangen und
eine Python-Bibliothek für eigene Programme.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| Mosquitto-Clients | 2.0.21 | `mosquitto_pub`, `mosquitto_sub` | Debian |
| paho-mqtt | 2.1.0 | (Python-Bibliothek) | Debian |

Einen eigenen MQTT-Broker (Server) bringt das Paket nicht mit. Zum Üben
genügt ein öffentlicher Test-Broker wie `test.mosquitto.org`, in der
Lehrveranstaltung meist der Broker, den sie Ihnen nennt.

VS-Code-Erweiterungen: keine.

## Installieren

Das Paket kommt mit dem Kurs `kurs-iot`. Einzeln installieren Sie es im
Container so:

```bash
clawbook pakete add clawbook-iot
```

Oder im clawbook-Menü **6 Pakete und Kurse**, dann `t`. Wie Kurse und
Technikpakete funktionieren, steht in
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch
`clawbook pakete info clawbook-iot`.

## Erste Schritte

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

## Wenn etwas nicht geht

- **„Error: Connection refused"** oder keine Antwort — Broker-Adresse
  oder Port (Standard 1883) stimmt nicht, oder das Netz blockiert den
  Port. Mit einem anderen Netz oder dem Broker der Lehrveranstaltung
  versuchen.
- **`mosquitto_sub` zeigt nichts** — Sender und Empfänger müssen exakt
  dasselbe Topic verwenden (Groß-/Kleinschreibung zählt). Zum Testen
  `-t 'clawbook/erika/#'` abonnieren: `#` steht für alles darunter.
- **Python-Empfänger bekommt nichts** — er muss laufen, *bevor* die
  Nachricht gesendet wird.
- **„ModuleNotFoundError: No module named 'paho'"** in einer
  virtuellen Umgebung — dort `pip install paho-mqtt` ausführen; die
  Bibliothek aus dem Paket gilt nur für das System-Python.
