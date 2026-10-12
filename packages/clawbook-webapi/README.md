# clawbook-webapi — Web-APIs testen

Dieses Paket bringt Werkzeuge mit, mit denen Sie Anfragen an Web-APIs
schicken und die Antworten prüfen — auf der Kommandozeile und in
VS Code.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| HTTPie | 3.2.4 | `http`, `https` | Debian |
| xh | 0.24.0 | `xh` | Debian |
| Hurl | 8.0.1 | `hurl` | Orange (Herausgeber) |
| curl | 8.14 | `curl` | Debian |

VS-Code-Erweiterungen im Container: REST Client (`humao.rest-client`)
und httpYac (`anweber.vscode-httpyac`).

## Installieren

Das Paket kommt mit allen drei Kursen: `kurs-inf`, `kurs-swe` und
`kurs-iot`. Einzeln installieren Sie es auf einem dieser Wege:

- **Unter Windows** im Verwaltungs-Skript: PowerShell öffnen und den
  Befehl von der Startseite von clawbook ausführen:

  ```powershell
  irm https://raw.githubusercontent.com/schlingensiepen/clawbook-lehre/main/get-clawbook.ps1 | iex
  ```

  Dann Menüpunkt **[11] Kurse und Technikpakete**, `t` und die Nummer
  von `clawbook-webapi`.
- **Im Container** (Terminal, siehe „Erste Schritte“):

  ```bash
  clawbook pakete add clawbook-webapi
  ```

Ausführlich beschreibt das die Seite
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info clawbook-webapi`.

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

Als Gegenstelle dient ein kleiner Webserver, den Python mitbringt. Er
liefert eine JSON-Datei aus. Terminal 1:

```bash
mkdir -p ~/source/hallo-webapi && cd ~/source/hallo-webapi
echo '{"name": "clawbook", "ok": true}' > status.json
python3 -m http.server 8000      # läuft, bis Sie Strg+C drücken
```

Anfragen schicken Sie aus einem zweiten Terminal (Plus-Symbol), im
selben Ordner:

```bash
cd ~/source/hallo-webapi
http :8000/status.json       # HTTPie: Kopfzeilen und farbiges JSON
xh :8000/status.json         # dasselbe, schneller
curl localhost:8000/status.json
```

`:8000` ist die Kurzform für `http://localhost:8000`.

**Automatisch prüfen mit Hurl:** Legen Sie `status.hurl` an:

```hurl
GET http://localhost:8000/status.json
HTTP 200
[Asserts]
jsonpath "$.name" == "clawbook"
jsonpath "$.ok" == true
```

```bash
hurl --test status.hurl      # "Success status.hurl (1 request(s) …)"
```

**In VS Code:** Legen Sie eine Datei `anfragen.http` an und schreiben
Sie hinein:

```http
GET http://localhost:8000/status.json
```

Über der Zeile erscheint **Send Request** (REST Client) bzw. ein
Startsymbol (httpYac); die Antwort öffnet sich daneben.

Den Webserver beenden Sie in Terminal 1 mit `Strg+C`.

## Wer macht was

**Das erledigt clawbook:** die Werkzeuge installieren; die
Erweiterungen kommen mit dem VSCodePack des Kurses (einzeln
installiert: im Verwaltungs-Skript **[10]**, dann **[1]**).

**Das tun Sie selbst:** den Dienst starten, den Sie testen wollen
(Ihr eigenes Programm oder einen Server wie im Beispiel), und die
Anfragen schreiben.

**Falls die Automatik nicht geht:** Fehlt eine Erweiterung, in VS Code
in der Erweiterungsansicht (`Strg+Umschalt+X`) „REST Client" oder
„httpYac" suchen und **In SSH: clawbook installieren**.

## Wenn etwas nicht geht

- **„Connection refused"** — auf dem Port läuft kein Dienst. Läuft Ihr
  Server noch, und stimmt der Port?
- **In einem Skript schickt `http` oder `xh` ein POST statt GET** —
  ohne Terminal lesen beide die Eingabe als Anfragetext. Im Skript
  `http --ignore-stdin …` bzw. `xh --ignore-stdin …` schreiben.
- **Hurl meldet „Assert failure"** — die Antwort weicht von der
  Erwartung ab; Hurl zeigt darunter den tatsächlichen Wert.
- **„Address already in use" beim Starten des Webservers** — er läuft
  schon (in einem anderen Terminal); dort mit `Strg+C` beenden oder
  einen anderen Port wählen
  (`python3 -m http.server 8001`).
