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
`clawbook-spring`). Einzeln installieren Sie es im Container so:

```bash
clawbook pakete add clawbook-java
```

Oder im clawbook-Menü **6 Pakete und Kurse**, dann `t`. Wie Kurse und
Technikpakete funktionieren, steht in
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch
`clawbook pakete info clawbook-java`.

## Erste Schritte

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
