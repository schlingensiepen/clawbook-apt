# kurs-swe — Softwareengineering

Dieses Kurs-Paket richtet Ihren clawbook-Container für die
Lehrveranstaltung Softwareengineering ein: Java mit Spring Boot, .NET
mit Entity Framework, PostgreSQL und SQLite, Web-APIs und Modellierung
mit PlantUML.

## Was drin ist

Der Kurs bringt diese Technikpakete mit; deren Dokus erklären die
Werkzeuge mit Beispielen:

| Technikpaket | Wofür |
|---|---|
| [clawbook-spring](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-spring/README.md) | Spring Boot (`spring`) |
| [clawbook-java](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-java/README.md) | Java 25, Maven, Gradle (kommt mit `clawbook-spring`) |
| [clawbook-dotnet](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-dotnet/README.md) | .NET 10 mit `dotnet ef` |
| [clawbook-db-postgres](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-db-postgres/README.md) | PostgreSQL 17 als Dienst, `psql` |
| [clawbook-db-sqlite](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-db-sqlite/README.md) | SQLite (`sqlite3`) |
| [clawbook-webapi](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-webapi/README.md) | Web-APIs testen: `http`, `xh`, `hurl`, `curl` |
| [clawbook-modeling](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-modeling/README.md) | PlantUML und Graphviz |

Dazu kommt die Kursbeschreibung für das VSCodePack
„Softwareengineering": ein eigenes VS Code unter Windows mit den
Erweiterungen aller Technikpakete; PlantUML rendert darin lokal.

## Installieren

Am einfachsten im Verwaltungs-Skript unter Windows, Menüpunkt **[11]
Kurse und Technikpakete**, dann die Nummer von `kurs-swe`. Im Container
geht es im clawbook-Menü **6 Pakete und Kurse** oder direkt:

```bash
clawbook pakete add kurs-swe
```

Der Download umfasst etwa 1,7 GB. Alles Weitere — auch das VSCodePack —
beschreibt
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info kurs-swe`.

## Erste Schritte

Prüfen Sie im Container, ob alles da ist:

```bash
clawbook kurse          # kurs-swe  Softwareengineering  (…)
java -version           # openjdk version "25…"
spring --version        # Spring CLI v4.1.1
dotnet --version        # 10.0.…
psql -c 'select 1'      # PostgreSQL antwortet
plantuml -version
```

Starten Sie danach VS Code über das VSCodePack „Softwareengineering"
(Verwaltungs-Skript **[9] VS Code starten** oder Startmenü „clawbook
VS Code – Softwareengineering"). Gute erste Beispiele: ein
Spring-Boot-Projekt
([clawbook-spring](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-spring/README.md))
und Entity Framework mit SQLite
([clawbook-dotnet](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-dotnet/README.md)).

## Wer macht was

**Das erledigt clawbook:** alle Technikpakete installieren, PostgreSQL
als Dienst starten, die Pakete nach einer Aktualisierung von clawbook
wiederherstellen und das VSCodePack zum Kurs einrichten (das
Verwaltungs-Skript fragt danach). Ihre Datenbank liegt im Home und
bleibt bei Aktualisierungen erhalten.

**Das tun Sie selbst:** den Kurs einmal auswählen und das VSCodePack
bestätigen. Die Materialien der Lehrveranstaltung holen Sie aus dem
Kurs-Repository (unten).

**Falls die Automatik nicht geht:** Fehlt das VSCodePack oder fehlen
Erweiterungen, im Verwaltungs-Skript **[10] VSCodePacks einrichten**,
dann **[1]** wählen.

## Wenn etwas nicht geht

- **`clawbook kurse` zeigt den Kurs nicht** — die Installation wurde
  abgebrochen. Den Kurs im Menü erneut wählen; Geladenes lädt `apt`
  nicht noch einmal.
- **`psql` meldet direkt nach der Installation keine Verbindung** — der
  Dienst legt beim ersten Start die Datenbank an. Einige Sekunden
  warten.
- **Kein VSCodePack „Softwareengineering"** — Verwaltungs-Skript
  **[10]**, dann **[1]**.
- **Nach einer Aktualisierung fehlen Werkzeuge** — die
  Wiederherstellung läuft noch im Hintergrund; `clawbook status` zeigt
  den Fortschritt.
- Probleme mit einem einzelnen Werkzeug: siehe „Wenn etwas nicht geht"
  in der Doku des jeweiligen Technikpakets (Tabelle oben).

## Links

- Kurs-Repository: <https://github.com/schlingensiepen/kurs-swe>
- Alle Kurse: <https://github.com/schlingensiepen/lehre>
