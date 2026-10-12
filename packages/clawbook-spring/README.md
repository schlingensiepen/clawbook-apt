# clawbook-spring — Spring Boot

Dieses Paket bringt die Spring-Boot-CLI mit. Damit legen Sie neue
Spring-Boot-Projekte mit einem Befehl an. Java, Maven und Gradle kommen
über `clawbook-java` mit.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| Spring-Boot-CLI | 4.1.1 | `spring` | Maven Central, unter `/opt/spring` |
| Java, Maven, Gradle | siehe [clawbook-java](https://github.com/schlingensiepen/clawbook-apt/blob/main/packages/clawbook-java/README.md) | | als Abhängigkeit |

VS-Code-Erweiterungen im Container: Spring Boot Extension Pack
(`vmware.vscode-boot-dev-pack`), dazu die Java-Erweiterungen aus
`clawbook-java`.

## Installieren

Das Paket kommt mit den Kursen `kurs-inf` und `kurs-swe`. Einzeln
installieren Sie es im Container so:

```bash
clawbook pakete add clawbook-spring
```

Oder im clawbook-Menü **6 Pakete und Kurse**, dann `t`. Wie Kurse und
Technikpakete funktionieren, steht in
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch
`clawbook pakete info clawbook-spring`.

## Erste Schritte

Ein Web-Projekt anlegen (die CLI holt die Vorlage bei
start.spring.io, Sie brauchen also Internet):

```bash
cd ~/source
spring init --dependencies=web --build=maven --java-version=25 \
  --package-name=de.beispiel.hallo --name=hallo hallo-spring
cd hallo-spring
```

Einen Endpunkt ergänzen, in
`src/main/java/de/beispiel/hallo/HalloController.java`:

```java
package de.beispiel.hallo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HalloController {

    @GetMapping("/hallo")
    public String hallo() {
        return "Hallo aus Spring Boot!";
    }
}
```

Starten:

```bash
./mvnw spring-boot:run
```

Nach einigen Sekunden steht im Terminal „Tomcat started on port
8080". In einem zweiten Terminal prüfen Sie:

```bash
curl localhost:8080/hallo      # Hallo aus Spring Boot!
```

Im Browser unter Windows: VS Code bemerkt den Port 8080 und leitet ihn
weiter (Hinweis unten rechts, Reiter **Ports**). Dann öffnen Sie
<http://localhost:8080/hallo>. `Strg+C` im ersten Terminal beendet die
Anwendung.

## Wer macht was

**Das erledigt clawbook:** die CLI und Java installieren; die
Erweiterungen kommen mit dem VSCodePack eines Kurses (einzeln
installiert: im Verwaltungs-Skript **[10]**, dann **[1]**).

**Das tun Sie selbst:** Projekte anlegen und starten. Die Abhängigkeiten
eines Projekts lädt Maven beim ersten Start aus dem Netz.

**Falls die Automatik nicht geht:** Leitet VS Code den Port nicht von
selbst weiter, öffnen Sie den Reiter **Ports**, wählen **Port
weiterleiten (Forward a Port)** und geben `8080` ein.

## Wenn etwas nicht geht

- **`spring init` meldet einen Verbindungsfehler** — die CLI braucht
  start.spring.io. Internet prüfen; Alternative: Projekt in VS Code mit
  **Spring Initializr: Create a Maven Project** anlegen (braucht
  ebenfalls Internet).
- **„Port 8080 was already in use"** — die Anwendung läuft noch in
  einem anderen Terminal. Dort mit `Strg+C` beenden, oder in
  `src/main/resources/application.properties` `server.port=8081`
  setzen.
- **Unter `/` kommt „Whitelabel Error Page"** — normal, solange es für
  `/` keinen Endpunkt gibt. Rufen Sie `/hallo` auf.
- **<http://localhost:8080> geht unter Windows nicht** — steht 8080 im
  Reiter **Ports** von VS Code? Ist VS Code mit clawbook verbunden?
