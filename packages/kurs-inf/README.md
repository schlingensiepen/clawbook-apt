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

**Unter Windows (empfohlen):**

1. PowerShell öffnen und den Befehl von der Startseite von clawbook
   ausführen (im selben Fenster genügt später Pfeiltaste nach oben und
   Enter):

   ```powershell
   irm https://raw.githubusercontent.com/schlingensiepen/clawbook-lehre/main/get-clawbook.ps1 | iex
   ```

2. Menüpunkt **[11] Kurse und Technikpakete** wählen. Das Skript öffnet
   jetzt das Menü **im Container**: Die Zeilen, die Sie sehen, kommen
   von clawbook im Container, nicht mehr von Windows.
3. Die Nummer von `kurs-inf` eingeben, Enter; die Rückfrage der
   Paketverwaltung mit Enter bestätigen. Der Download umfasst etwa
   0,8 GB.
4. Mit Enter das Menü im Container verlassen. Sie sind zurück im
   Verwaltungs-Skript unter Windows; es fragt, ob es das VSCodePack
   „Ingenieurinformatik“ einrichten soll — Enter bestätigt.

**Im Container** geht es auch, im clawbook-Menü **6 Pakete und Kurse**
oder direkt mit `clawbook pakete add kurs-inf`. Das VSCodePack richtet
aber nur das Verwaltungs-Skript unter Windows ein (dort **[10] VSCodePacks
einrichten**, dann **[1]**).

Ausführlich beschreibt das die Seite
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info kurs-inf`.

## Erste Schritte

**Wo Sie tippen:** Die Befehle unten tippen Sie im Terminal des
Containers, nicht in Windows. Starten Sie VS Code über das VSCodePack
„Ingenieurinformatik“ — im Verwaltungs-Skript **[9] VS Code starten** oder über den
Startmenü-Eintrag „clawbook VS Code – Ingenieurinformatik“ — und öffnen Sie im Menü
**Terminal → Neues Terminal** (englisch *Terminal → New Terminal*).
Alternativ in PowerShell `ssh clawbook`. Ihre Projekte gehören nach
`~/source`, den Projektordner in Ihrem Home. Begriffe wie Container,
Home oder VSCodePack erklärt das [Glossar](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/README.md#begriffe).

Prüfen Sie, ob alles da ist:

```bash
clawbook kurse          # kurs-inf  Ingenieurinformatik  (…)
java -version           # openjdk version "25…"
spring --version        # Spring CLI v4.1.1
sqlite3 --version
http --version
```

Ein erstes Spring-Boot-Projekt zeigt die Doku von
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
