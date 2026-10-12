# clawbook-nodered — Node-RED

Dieses Paket bringt Node-RED mit, ein Werkzeug, in dem Sie Abläufe
(Flows) aus Bausteinen im Browser zusammenklicken — beliebt für IoT,
MQTT und kleine Web-Dienste. Node-RED läuft als Dienst im Container.

## Was drin ist

| Werkzeug | Version | Herkunft |
|---|---|---|
| Node-RED | 5.0.8 | npm, unter `/usr/lib/clawbook/node-red` |
| Node.js | 22 | schon im Image |

Der Editor ist eine Webseite im Container unter Port 1880.

VS-Code-Erweiterungen: keine.

## Installieren

Das Paket kommt mit dem Kurs `kurs-iot`. Einzeln installieren Sie es im
Container so:

```bash
clawbook pakete add clawbook-nodered
```

Oder im clawbook-Menü **6 Pakete und Kurse**, dann `t`. Wie Kurse und
Technikpakete funktionieren, steht in
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch
`clawbook pakete info clawbook-nodered`.

## Erste Schritte

**Editor öffnen** (über VS Code, denn Node-RED ist nur im Container
erreichbar):

1. VS Code mit clawbook verbinden.
2. Unten den Reiter **Ports** öffnen, **Port weiterleiten (Forward a
   Port)** wählen, `1880` eingeben, Enter.
3. Im Browser unter Windows <http://localhost:1880> öffnen.

Ob der Dienst läuft, prüfen Sie im Terminal:

```bash
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:1880/   # 200
```

**Ein erster Flow — ein kleiner Web-Dienst:**

1. Aus der Palette links ziehen Sie **http in**, **template** und
   **http response** auf die Fläche und verbinden sie in dieser
   Reihenfolge.
2. Doppelklick auf **http in**: Method `GET`, URL `/hallo`.
3. Doppelklick auf **template**: Text `Hallo aus Node-RED!`.
4. Oben rechts **Deploy**.

Prüfen:

```bash
curl http://127.0.0.1:1880/hallo     # Hallo aus Node-RED!
```

## Wer macht was

**Das erledigt clawbook:** Node-RED installieren und als Dienst starten —
sofort und bei jedem Start des Containers. Ihre Flows speichert
Node-RED in `~/.node-red` in Ihrem Home; sie überstehen
Aktualisierungen von clawbook und sind in jeder Sicherung enthalten.

**Das tun Sie selbst:** Den Port 1880 in VS Code weiterleiten (Schritt 2
oben). Die Weiterleitung gilt, solange VS Code verbunden ist.
Zusätzliche Bausteine installieren Sie im Editor über das Menü
(rechts oben) **Manage palette**.

## Wenn etwas nicht geht

- **<http://localhost:1880> geht nicht** — ist VS Code verbunden, und
  steht 1880 im Reiter **Ports**? Gibt `curl` im Container `200` aus?
- **`curl` meldet „Connection refused"** — der Dienst startet noch
  (einige Sekunden nach der Installation) oder ist abgestürzt. Kurz
  warten; sonst den Container neu starten (im Verwaltungs-Skript
  **[7] anhalten**, dann **[1] starten und verbinden**).
- **Der Editor fragt nicht nach einem Passwort** — so gewollt: Er ist
  nur im Container erreichbar. Leiten Sie den Port nicht an andere
  Rechner weiter.
- **Nach dem Deploy antwortet `/hallo` mit 404** — URL im Knoten
  **http in** prüfen (mit `/` am Anfang), und ob **http response**
  angeschlossen ist.
