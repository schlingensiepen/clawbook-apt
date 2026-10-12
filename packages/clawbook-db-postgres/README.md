# clawbook-db-postgres — PostgreSQL

Dieses Paket bringt den Datenbankserver PostgreSQL in Ihren
clawbook-Container. Er läuft als Dienst im Hintergrund, unter Ihrem
Benutzer `student`, und ist ohne Passwort erreichbar.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| PostgreSQL-Server | 17 | läuft als Dienst | Debian |
| Kommandozeile | 17 | `psql`, `createdb`, `pg_dump` | Debian |

VS-Code-Erweiterungen im Container: PostgreSQL von Microsoft
(`ms-ossdata.vscode-pgsql`).

## Installieren

Das Paket kommt mit dem Kurs `kurs-swe`. Einzeln installieren Sie es im
Container so:

```bash
clawbook pakete add clawbook-db-postgres
```

Oder im clawbook-Menü **6 Pakete und Kurse**, dann `t`. Wie Kurse und
Technikpakete funktionieren, steht in
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch
`clawbook pakete info clawbook-db-postgres`.

## Erste Schritte

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
brauchen Sie nicht: Der Server ist nur im Container erreichbar.

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
