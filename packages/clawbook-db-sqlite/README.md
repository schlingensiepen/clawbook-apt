# clawbook-db-sqlite — SQLite

Dieses Paket bringt SQLite mit, eine Datenbank, die in einer einzigen
Datei steckt. Ein Server ist nicht nötig; ideal zum Üben und für kleine
Programme.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| SQLite-Kommandozeile | 3.46 | `sqlite3` | Debian |

VS-Code-Erweiterungen im Container: SQLite Explorer
(`zknpr.sqlite-explorer`).

## Installieren

Das Paket kommt mit den Kursen `kurs-inf` und `kurs-swe`. Einzeln
installieren Sie es auf einem dieser Wege:

- **Unter Windows** im Verwaltungs-Skript: PowerShell öffnen und den
  Befehl von der Startseite von clawbook ausführen:

  ```powershell
  irm https://raw.githubusercontent.com/schlingensiepen/clawbook-lehre/main/get-clawbook.ps1 | iex
  ```

  Dann Menüpunkt **[11] Kurse und Technikpakete**, `t` und die Nummer
  von `clawbook-db-sqlite`.
- **Im Container** (Terminal, siehe „Erste Schritte“):

  ```bash
  clawbook pakete add clawbook-db-sqlite
  ```

Ausführlich beschreibt das die Seite
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info clawbook-db-sqlite`.

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

```bash
mkdir -p ~/source/hallo-sqlite && cd ~/source/hallo-sqlite
sqlite3 uebung.db
```

`sqlite3` legt die Datei `uebung.db` an, sobald Sie etwas speichern.
An der Eingabe `sqlite>`:

```sql
CREATE TABLE notizen (id INTEGER PRIMARY KEY, text TEXT);
INSERT INTO notizen (text) VALUES ('Erste Notiz');
.headers on
.mode column
SELECT * FROM notizen;
.tables
.quit
```

Befehle mit Punkt (`.tables`, `.schema`, `.quit`) steuert `sqlite3`
selbst; alles andere ist SQL und endet mit `;`.

**In VS Code:** Klicken Sie im Explorer auf `uebung.db`. SQLite
Explorer öffnet die Datei und zeigt Tabellen und Inhalte; dort können
Sie auch Abfragen ausführen.

## Wer macht was

**Das erledigt clawbook:** `sqlite3` installieren; die Erweiterung
kommt mit dem VSCodePack des Kurses (einzeln installiert: im
Verwaltungs-Skript **[10]**, dann **[1]**).

**Das tun Sie selbst:** Ihre Datenbankdateien liegen dort, wo Sie sie
anlegen, am besten im Projektordner unter `~/source`.

**Falls die Automatik nicht geht:** Fehlt die Erweiterung, suchen Sie in
VS Code in der Erweiterungsansicht (`Strg+Umschalt+X`) nach „SQLite
Explorer" (Herausgeber zknpr) und wählen **In SSH: clawbook
installieren**.

## Wenn etwas nicht geht

- **„Parse error: no such table"** — falscher Tabellenname oder
  falsche Datei; `.tables` zeigt, was es in dieser Datei gibt.
- **Die Eingabe hängt bei `...>`** — das Semikolon fehlt. `;` eingeben
  und Enter.
- **„database is locked"** — ein anderes Programm (etwa Ihr eigenes
  oder VS Code) schreibt gerade in die Datei. Das andere Programm
  beenden und erneut versuchen.
- **Die Datei `uebung.db` ist leer oder fehlt** — `sqlite3` legt sie
  erst an, wenn Sie eine Tabelle erzeugen.
