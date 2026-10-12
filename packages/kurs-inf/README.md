# kurs-inf — Ingenieurinformatik

Dieses Kurs-Paket richtet Ihren clawbook-Container für die
Lehrveranstaltung Ingenieurinformatik ein: Java mit Spring Boot,
Web-APIs und SQLite.

## Was drin ist

Der Kurs bringt diese Technikpakete mit; deren Dokus erklären die
Werkzeuge mit Beispielen:

| Technikpaket | Wofür |
|---|---|
| [clawbook-spring](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-spring/README.md) | Spring Boot (`spring`) |
| [clawbook-java](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-java/README.md) | Java 25, Maven, Gradle (kommt mit `clawbook-spring`) |
| [clawbook-webapi](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-webapi/README.md) | Web-APIs testen: `http`, `xh`, `hurl`, `curl` |
| [clawbook-db-sqlite](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-db-sqlite/README.md) | SQLite (`sqlite3`) |

Dazu kommt die Kursbeschreibung für das VSCodePack
„Ingenieurinformatik": ein eigenes VS Code unter Windows mit den
Erweiterungen aller Technikpakete.

## Installieren

Am einfachsten im Verwaltungs-Skript unter Windows, Menüpunkt **[11]
Kurse und Technikpakete**, dann die Nummer von `kurs-inf`. Im Container
geht es im clawbook-Menü **6 Pakete und Kurse** oder direkt:

```bash
clawbook pakete add kurs-inf
```

Der Download umfasst etwa 0,8 GB. Alles Weitere — auch das VSCodePack —
beschreibt
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info kurs-inf`.

## Erste Schritte

Prüfen Sie im Container, ob alles da ist:

```bash
clawbook kurse          # kurs-inf  Ingenieurinformatik  (…)
java -version           # openjdk version "25…"
spring --version        # Spring CLI v4.1.1
sqlite3 --version
http --version
```

Starten Sie danach VS Code über das VSCodePack „Ingenieurinformatik"
(Verwaltungs-Skript **[9] VS Code starten** oder Startmenü „clawbook
VS Code – Ingenieurinformatik"). Ein erstes Spring-Boot-Projekt zeigt
die Doku von
[clawbook-spring](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-spring/README.md).

## Wer macht was

**Das erledigt clawbook:** alle Technikpakete installieren, sie nach
einer Aktualisierung von clawbook wiederherstellen und das VSCodePack
zum Kurs einrichten (das Verwaltungs-Skript fragt danach).

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
- **Kein VSCodePack „Ingenieurinformatik"** — Verwaltungs-Skript
  **[10]**, dann **[1]**.
- **Nach einer Aktualisierung fehlen Werkzeuge** — die
  Wiederherstellung läuft noch im Hintergrund; `clawbook status` zeigt
  den Fortschritt.
- Probleme mit einem einzelnen Werkzeug: siehe „Wenn etwas nicht geht"
  in der Doku des jeweiligen Technikpakets (Tabelle oben).

## Links

- Kurs-Repository: <https://github.com/schlingensiepen/kurs-inf>
- Alle Kurse: <https://github.com/schlingensiepen/lehre>
