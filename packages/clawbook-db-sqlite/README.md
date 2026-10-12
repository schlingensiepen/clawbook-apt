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
installieren Sie es im Container so:

```bash
clawbook pakete add clawbook-db-sqlite
```

Oder im clawbook-Menü **6 Pakete und Kurse**, dann `t`. Wie Kurse und
Technikpakete funktionieren, steht in
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch
`clawbook pakete info clawbook-db-sqlite`.

## Erste Schritte

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
