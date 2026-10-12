# clawbook-java — Java mit Maven und Gradle

Dieses Paket bringt alles mit, um im clawbook-Container
Java-Programme zu schreiben, zu bauen und zu starten.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| OpenJDK | 25 | `java`, `javac`, `jshell` | Debian |
| Maven | 3.9.9 | `mvn` | Debian |
| Gradle | 9.8.1 | `gradle` | gradle.org, unter `/opt/gradle` |

VS-Code-Erweiterungen im Container: Extension Pack for Java
(`vscjava.vscode-java-pack`).

## Installieren

Das Paket kommt mit den Kursen `kurs-inf` und `kurs-swe` (dort über
`clawbook-spring`). Einzeln installieren Sie es auf einem dieser Wege:

- **Unter Windows** im Verwaltungs-Skript: PowerShell öffnen und den
  Befehl von der Startseite von clawbook ausführen:

  ```powershell
  irm https://raw.githubusercontent.com/schlingensiepen/clawbook-lehre/main/get-clawbook.ps1 | iex
  ```

  Dann Menüpunkt **[11] Kurse und Technikpakete**, `t` und die Nummer
  von `clawbook-java`.
- **Im Container** (Terminal, siehe „Erste Schritte“):

  ```bash
  clawbook pakete add clawbook-java
  ```

Ausführlich beschreibt das die Seite
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info clawbook-java`.

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

**Mit Maven:** ein Projekt aus der Vorlage „quickstart" anlegen, bauen
und starten.

```bash
cd ~/source
mvn -B archetype:generate \
  -DarchetypeGroupId=org.apache.maven.archetypes \
  -DarchetypeArtifactId=maven-archetype-quickstart \
  -DarchetypeVersion=1.5 \
  -DgroupId=de.beispiel -DartifactId=hallo-maven \
  -DinteractiveMode=false
cd hallo-maven
mvn -B package                               # baut und testet
java -cp target/classes de.beispiel.App      # gibt "Hello World!" aus
```

**Mit Gradle:** ein Anwendungsprojekt anlegen und starten.

```bash
mkdir -p ~/source/hallo-gradle && cd ~/source/hallo-gradle
gradle init --type java-application --dsl kotlin \
  --test-framework junit-jupiter --package de.beispiel \
  --project-name hallo-gradle --java-version 25 \
  --no-split-project --use-defaults
gradle run                                   # gibt "Hello World!" aus
```

Beim ersten Aufruf laden Maven und Gradle Bibliotheken aus dem Netz;
das dauert einen Moment. Danach liegen sie in Ihrem Home (`~/.m2`,
`~/.gradle`).

In VS Code öffnen Sie den Projektordner. Die Java-Erweiterung erkennt
`pom.xml` bzw. `build.gradle.kts`; über **Run** oberhalb von `main`
starten Sie das Programm.

## Wer macht was

**Das erledigt clawbook:** Java, Maven und Gradle installieren; die
VS-Code-Erweiterungen kommen mit dem VSCodePack eines Kurses. Haben
Sie das Paket einzeln installiert, wählen Sie im Verwaltungs-Skript
**[10] VSCodePacks einrichten**, dann **[1]**.

**Das tun Sie selbst:** Projekte anlegen und bauen. Die Bibliotheken
eines Projekts laden Maven und Gradle beim ersten Bau aus dem Netz.

**Falls die Automatik nicht geht:** Fehlt die Erweiterung in VS Code,
installieren Sie „Extension Pack for Java" in der Erweiterungsansicht
(`Strg+Umschalt+X`) mit **In SSH: clawbook installieren**.

## Wenn etwas nicht geht

- **Maven gibt „WARNING: A terminally deprecated method in
  sun.misc.Unsafe …" aus** — harmlos; das Maven aus Debian ist älter
  als Java 25. Der Bau läuft trotzdem.
- **`java -version` zeigt nicht 25** — Maven bringt in Debian
  zusätzlich Java 21 mit. Zurück auf 25 geht es mit
  `sudo update-alternatives --config java`.
- **Das Maven-Projekt baut für eine ältere Java-Version** — die
  Vorlage trägt `<maven.compiler.release>17</maven.compiler.release>`
  in `pom.xml` ein. Für neue Sprachmittel dort `25` eintragen.
- **Der erste Bau bricht mit einem Netzwerkfehler ab** — Maven und
  Gradle brauchen beim ersten Mal Internet. Verbindung prüfen und
  erneut starten.
- **VS Code zeigt „Java: Ready" nicht oder rote Fehler überall** —
  Befehlspalette (`Strg+Umschalt+P`), **Java: Clean Java Language
  Server Workspace**, dann VS Code neu laden.
