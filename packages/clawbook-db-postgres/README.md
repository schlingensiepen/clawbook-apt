# clawbook-db-postgres — PostgreSQL

Dieses Paket bringt den Datenbankserver PostgreSQL in Ihren
clawbook-Container. Er läuft als Dienst — als Programm im
Hintergrund, das clawbook selbst startet, ohne dass Sie es aufrufen —
unter Ihrem Benutzer `student` und ist ohne Passwort erreichbar.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| PostgreSQL-Server | 17 | läuft als Dienst | Debian |
| Kommandozeile | 17 | `psql`, `createdb`, `pg_dump` | Debian |

VS-Code-Erweiterungen im Container: PostgreSQL von Microsoft
(`ms-ossdata.vscode-pgsql`).

## Installieren

Das Paket kommt mit dem Kurs `kurs-swe`. Einzeln installieren Sie es
auf einem dieser Wege:

- **Unter Windows** im Verwaltungs-Skript: PowerShell öffnen und den
  Befehl von der Startseite von clawbook ausführen:

  ```powershell
  irm https://raw.githubusercontent.com/schlingensiepen/clawbook-lehre/main/get-clawbook.ps1 | iex
  ```

  Dann Menüpunkt **[11] Kurse und Technikpakete**, `t` und die Nummer
  von `clawbook-db-postgres`.
- **Im Container** (Terminal, siehe „Erste Schritte“):

  ```bash
  clawbook pakete add clawbook-db-postgres
  ```

Ausführlich beschreibt das die Seite
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info clawbook-db-postgres`.

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
psql                     # verbindet mit der Datenbank "student"; \q beendet
createdb uebung          # neue Datenbank anlegen
psql -d uebung
```

In `psql` eine Tabelle anlegen und füllen:

```sql
CREATE TABLE studierende (id serial PRIMARY KEY, name text NOT NULL);
INSERT INTO studierende (name) VALUES ('Erika Mustermann'), ('Max Mustermann');
SELECT * FROM studierende;
```

`\l` zeigt alle Datenbanken, `\dt` die Tabellen, `\q` beendet `psql`.

**Verbindung aus VS Code** (Erweiterung PostgreSQL, Symbol in der
linken Leiste, **Add Connection**):

| Feld | Wert |
|---|---|
| Server / Host | `localhost` |
| Port | `5432` |
| Benutzer | `student` |
| Passwort | leer lassen |
| Datenbank | `uebung` (oder `student`) |

Dieselben Angaben gelten für Ihre Programme, etwa in Spring Boot
`spring.datasource.url=jdbc:postgresql://localhost:5432/uebung` mit
Benutzer `student`.

## Wer macht was

**Das erledigt clawbook:** Den Server installieren und als Dienst
starten — sofort nach der Installation und bei jedem Start des
Containers. Beim ersten Start legt der Dienst die Datenbank `student`
an (einige Sekunden). Die Daten liegen in Ihrem Home
(`~/.local/share/postgresql/17`); sie überstehen Aktualisierungen von
clawbook und sind in jeder Sicherung enthalten. Die Erweiterung kommt
mit dem VSCodePack des Kurses (einzeln installiert: im
Verwaltungs-Skript **[10]**, dann **[1]**).

**Das tun Sie selbst:** Datenbanken und Tabellen anlegen. Ein Passwort
brauchen Sie nicht: Der Server ist nur im Container erreichbar. Lassen
Sie das so: Leiten Sie Port 5432 **nicht** in VS Code weiter und
veröffentlichen Sie ihn nicht — ohne Passwort käme sonst jeder an Ihre
Daten, der den Port erreicht. Taucht 5432 im Reiter **Ports** von
VS Code auf, beenden Sie die Weiterleitung (Rechtsklick, **Stop
Forwarding Port**). Die Erweiterung PostgreSQL braucht keine
Weiterleitung, sie läuft selbst im Container.

**Falls die Automatik nicht geht:** Läuft der Dienst nicht
(`pgrep -a postgres` zeigt nichts), starten Sie den Container neu: im
Verwaltungs-Skript **[7] anhalten**, dann **[1] starten und
verbinden**.
Entfernen Sie das Paket, bleiben Ihre Daten im Home; endgültig löschen
Sie sie mit `rm -rf ~/.local/share/postgresql`.

## Wenn etwas nicht geht

- **`psql: error: connection to server on socket … failed`** direkt
  nach der Installation — der Dienst legt noch die Datenbank an. Einige
  Sekunden warten und erneut versuchen.
- **„database "…" does not exist"** — die Datenbank erst mit
  `createdb <name>` anlegen; `psql -l` zeigt, welche es gibt.
- **VS Code fragt nach einem Passwort** — Feld leer lassen; Host muss
  `localhost` sein, Benutzer `student`.
- **Ein Programm unter Windows erreicht die Datenbank nicht** — so
  gewollt: Der Server ist ohne Passwort und deshalb nur im Container
  erreichbar. Arbeiten Sie im Container oder über VS Code.
