# clawbook-modeling — Modellieren mit PlantUML

Dieses Paket bringt PlantUML und Graphviz mit. Damit beschreiben Sie
UML-Diagramme als Text und lassen sie als Bild erzeugen — ohne
Internet, alles läuft im Container.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| PlantUML (MIT-Fassung) | 1.2026.8 | `plantuml` | Herausgeber, unter `/opt/plantuml` |
| Graphviz | 2.42 | `dot` | Debian |
| Java-Laufzeit | 25 | (für PlantUML) | Debian |

VS-Code-Erweiterungen im Container: PlantUML (`jebbs.plantuml`).

## Installieren

Das Paket kommt mit dem Kurs `kurs-swe`. Einzeln installieren Sie es im
Container so:

```bash
clawbook pakete add clawbook-modeling
```

Oder im clawbook-Menü **6 Pakete und Kurse**, dann `t`. Wie Kurse und
Technikpakete funktionieren, steht in
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch
`clawbook pakete info clawbook-modeling`.

## Erste Schritte

Ein Sequenzdiagramm als Text, in `~/source/hallo-uml/bestellung.puml`:

```plantuml
@startuml
actor Kunde
participant Shop
database Datenbank
Kunde -> Shop: bestellen
Shop -> Datenbank: speichern
Shop --> Kunde: Bestätigung
@enduml
```

Bild erzeugen:

```bash
cd ~/source/hallo-uml
plantuml bestellung.puml           # erzeugt bestellung.png
plantuml -tsvg bestellung.puml     # erzeugt bestellung.svg
```

**In VS Code:** Öffnen Sie die `.puml`-Datei und drücken Sie `Alt+D`.
Die Vorschau erscheint daneben und folgt jeder Änderung. Exportieren
geht über die Befehlspalette (`Strg+Umschalt+P`), **PlantUML: Export
Current Diagram**.

Graphviz allein, für Graphen:

```bash
echo 'digraph G { Start -> Ende }' > graph.dot
dot -Tpng graph.dot -o graph.png
```

## Wer macht was

**Das erledigt clawbook:** PlantUML, Graphviz und Java installieren.
Im Kurs `kurs-swe` stellt das VSCodePack die Erweiterung so ein, dass
sie lokal mit dem mitgelieferten PlantUML rendert
(`plantuml.render: Local`); Ihre Diagramme verlassen den Container
nicht.

**Falls die Automatik nicht geht:** Ohne Kurs (Paket einzeln
installiert) tragen Sie in den VS-Code-Einstellungen
`"plantuml.render": "Local"` und
`"plantuml.jar": "/opt/plantuml/plantuml.jar"` ein. Fehlt die
Erweiterung, in der Erweiterungsansicht (`Strg+Umschalt+X`) „PlantUML"
(Herausgeber jebbs) suchen und **In SSH: clawbook installieren**.

## Wenn etwas nicht geht

- **„Syntax Error?" im Bild** — PlantUML zeigt die fehlerhafte Zeile
  rot. Häufig fehlt `@startuml` oder `@enduml`.
- **Die Vorschau in VS Code bleibt leer** — Einstellung
  `plantuml.render` muss `Local` sein (siehe oben); danach VS Code neu
  laden.
- **„Dot executable … does not exist"** bei Klassen- oder
  Komponentendiagrammen — Graphviz fehlt oder ist beschädigt:
  `sudo apt-get install --reinstall graphviz`.
- **Umlaute fehlen im Bild** — die `.puml`-Datei muss als UTF-8
  gespeichert sein (Standard in VS Code).
