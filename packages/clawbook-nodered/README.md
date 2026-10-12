# clawbook-nodered — Node-RED

Dieses Paket bringt Node-RED mit, ein Werkzeug, in dem Sie Abläufe
(Flows) aus Bausteinen im Browser zusammenklicken — beliebt für IoT,
MQTT und kleine Web-Dienste. Node-RED läuft als Dienst im Container:
als Programm im Hintergrund, das clawbook selbst startet, ohne dass Sie
es aufrufen.

## Was drin ist

| Werkzeug | Version | Herkunft |
|---|---|---|
| Node-RED | 5.0.8 | npm, unter `/usr/lib/clawbook/node-red` |
| Node.js | 22 | schon im Image |

Der Editor ist eine Webseite im Container unter Port 1880.

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
  von `clawbook-nodered`.
- **Im Container** (Terminal, siehe „Erste Schritte“):

  ```bash
  clawbook pakete add clawbook-nodered
  ```

Ausführlich beschreibt das die Seite
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info clawbook-nodered`.

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

**Editor öffnen** (über VS Code, denn Node-RED ist nur im Container
erreichbar):

1. VS Code über das Verwaltungs-Skript (**[9] VS Code starten**) oder
   den Startmenü-Eintrag „clawbook VS Code“ starten; es verbindet sich
   mit clawbook.
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
3. Doppelklick auf **template**: den vorgegebenen Text durch
   `Hallo aus Node-RED!` ersetzen.
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

**Falls die Automatik nicht geht:** Antwortet Node-RED nicht (`curl`
oben gibt nicht `200` aus), starten Sie den Container neu: im
Verwaltungs-Skript **[7] anhalten**, dann **[1] starten und
verbinden**.

## Wenn etwas nicht geht

- **<http://localhost:1880> geht nicht** — ist VS Code verbunden, und
  steht 1880 im Reiter **Ports**? Gibt `curl` im Container `200` aus?
- **`curl` meldet „Connection refused"** — der Dienst startet noch
  (einige Sekunden nach der Installation) oder ist abgestürzt. Kurz
  warten; sonst siehe „Falls die Automatik nicht geht“.
- **Der Editor fragt nicht nach einem Passwort** — so gewollt: Er ist
  nur im Container erreichbar. Leiten Sie den Port nicht an andere
  Rechner weiter.
- **Nach dem Deploy antwortet `/hallo` mit 404** — URL im Knoten
  **http in** prüfen (mit `/` am Anfang), und ob **http response**
  angeschlossen ist.
