# clawbook-python — Werkzeuge für Python

Dieses Paket ergänzt das Python im clawbook-Container um zwei
Werkzeuge: `pytest` zum Testen und `ruff` zum Prüfen und Formatieren
Ihres Codes.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| Python | 3.13 | `python3` | schon im Image |
| pytest | 8.3 | `pytest` | Debian |
| ruff | 0.17.0 | `ruff` | Astral (Herausgeber) |

VS-Code-Erweiterungen im Container: Python (`ms-python.python`),
Python Debugger (`ms-python.debugpy`), Pylance
(`ms-python.vscode-pylance`), Ruff (`charliermarsh.ruff`).

## Installieren

Das Paket gehört derzeit zu keinem Kurs. Sie installieren es im
Container einzeln:

```bash
clawbook pakete add clawbook-python
```

Oder im clawbook-Menü **6 Pakete und Kurse**, dann `t` für die
einzelnen Technikpakete. Wie Kurse und Technikpakete funktionieren,
steht in [Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch
`clawbook pakete info clawbook-python`.

## Erste Schritte

Legen Sie ein kleines Projekt mit einer Funktion und einem Test an:

```bash
mkdir -p ~/source/hallo-python && cd ~/source/hallo-python
cat > rechner.py <<'EOF'
def addiere(a, b):
    return a + b
EOF
cat > test_rechner.py <<'EOF'
from rechner import addiere


def test_addiere():
    assert addiere(2, 3) == 5
EOF
```

Testen, prüfen, formatieren:

```bash
pytest          # findet test_*.py von selbst: "1 passed"
ruff check .    # meldet Fehler und Stilprobleme: "All checks passed!"
ruff format .   # formatiert alle .py-Dateien einheitlich
```

Bauen Sie einen Fehler ein, etwa `import os` ohne Verwendung, meldet
`ruff check .` ihn als `F401`. `ruff check --fix .` behebt solche
Fehler selbst, wo das gefahrlos geht.

In VS Code zeigt die Ruff-Erweiterung dieselben Meldungen direkt im
Editor; die Tests finden Sie in der Ansicht **Testing** (Kolben-Symbol).

## Wer macht was

**Das erledigt clawbook:** `pytest` und `ruff` installieren; die
VS-Code-Erweiterungen kommen in Ihre VSCodePacks, sobald Sie im
Verwaltungs-Skript **[10] VSCodePacks einrichten**, dann **[1]**
wählen.

**Das tun Sie selbst:** Für eigene Bibliotheken eines Projekts eine
virtuelle Umgebung anlegen, zum Beispiel
`python3 -m venv .venv && . .venv/bin/activate`, danach
`pip install <paket>`. Mit `uv` (im Image) geht das schneller:
`uv venv` und `uv pip install <paket>`.

**Falls die Automatik nicht geht:** Fehlt eine Erweiterung in VS Code,
installieren Sie sie in der Erweiterungsansicht (`Strg+Umschalt+X`)
mit **In SSH: clawbook installieren**.

## Wenn etwas nicht geht

- **`pip install` meldet „externally-managed-environment"** — Debian
  verbietet Installationen ins System-Python. Legen Sie eine virtuelle
  Umgebung an (oben).
- **`pytest` findet keine Tests** — Dateien müssen `test_*.py` heißen,
  Funktionen `test_…`. Rufen Sie `pytest` im Projektordner auf.
- **`ModuleNotFoundError` in den Tests** — `pytest` im Ordner starten,
  in dem auch der getestete Code liegt, oder die virtuelle Umgebung
  aktivieren, in der die Bibliothek installiert ist.
- **VS Code nimmt das falsche Python** — unten rechts in der
  Statusleiste auf die Python-Version klicken und `.venv` wählen.
