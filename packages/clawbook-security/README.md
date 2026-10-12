# clawbook-security — Netzwerk und Sicherheit

Dieses Paket bringt Werkzeuge zum Untersuchen von Netzwerken und zum
Verschlüsseln mit: Ports prüfen, Datenverkehr mitschneiden, Dateien
verschlüsseln und signieren.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| Nmap | 7.95 | `nmap` | Debian |
| TShark (Wireshark auf der Kommandozeile) | 4.4 | `tshark` | Debian |
| GnuPG | 2.4 | `gpg` | Debian |

VS-Code-Erweiterungen: keine.

## Installieren

Das Paket kommt mit dem Kurs `kurs-iot`. Einzeln installieren Sie es
auf einem dieser Wege:

- **Unter Windows** im Verwaltungs-Skript: PowerShell öffnen und den
  Befehl von der Startseite von clawbook ausführen:

  ```powershell
  irm https://raw.githubusercontent.com/schlingensiepen/clawbook-lehre/main/get-clawbook.ps1 | iex
  ```

  Dann Menüpunkt **[11] Kurse und Technikpakete**, `t` und die Nummer
  von `clawbook-security`.
- **Im Container** (Terminal, siehe „Erste Schritte“):

  ```bash
  clawbook pakete add clawbook-security
  ```

Ausführlich beschreibt das die Seite
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch `clawbook pakete info clawbook-security`.

## Verantwortungsvoll einsetzen

Mit `nmap` und `tshark` untersuchen Sie Netzwerke und lesen
Datenverkehr mit. Setzen Sie sie nur ein für Ihre eigenen Systeme — etwa
Ihren clawbook-Container — oder für Netze und Rechner, für die Sie eine
ausdrückliche Erlaubnis haben (zum Beispiel in einer Übung). Fremde
Rechner zu scannen oder fremden Verkehr mitzuschneiden kann verboten
sein und Ärger mit dem Netzbetreiber bringen; das gilt auch für das
Netz Ihrer Hochschule.

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

**Offene Ports im eigenen Container:**

```bash
nmap localhost                   # die 1000 häufigsten Ports
nmap -p 1880,5432 localhost      # gezielt bestimmte Ports
```

**Datenverkehr mitschneiden** — dafür brauchen Sie drei Terminals
(Plus-Symbol im Terminalbereich von VS Code).

Terminal 1 startet einen kleinen Webserver als Gegenstelle:

```bash
python3 -m http.server 8000      # läuft, bis Sie Strg+C drücken
```

Terminal 2 lauscht auf der Loopback-Schnittstelle `lo` (Verkehr
innerhalb des Containers):

```bash
tshark -D                                 # Schnittstellen auflisten
tshark -i lo -c 6 -f 'tcp port 8000'      # 6 Pakete auf Port 8000
```

Terminal 3 erzeugt Verkehr:

```bash
curl -s localhost:8000/ > /dev/null
```

TShark in Terminal 2 zeigt den Verbindungsaufbau (`SYN`, `SYN, ACK`,
`ACK`) und die Zeile `GET / HTTP/1.1` und endet nach sechs Paketen.
Mit `-w mitschnitt.pcap` speichern Sie den Mitschnitt; die Datei
können Sie in Wireshark unter Windows öffnen. Den Webserver beenden Sie
in Terminal 1 mit `Strg+C`.

**Datei verschlüsseln** (mit Passwort, ohne Schlüsselpaar):

```bash
mkdir -p ~/source/hallo-gpg && cd ~/source/hallo-gpg
echo "Treffen um 10 Uhr" > nachricht.txt
gpg --symmetric --pinentry-mode loopback nachricht.txt   # fragt nach dem Passwort
gpg --pinentry-mode loopback --decrypt nachricht.txt.gpg
```

`--pinentry-mode loopback` lässt `gpg` das Passwort direkt im Terminal
abfragen; das funktioniert im Terminal von VS Code und nach
`ssh clawbook` gleichermaßen.

## Wer macht was

**Das erledigt clawbook:** die Werkzeuge installieren und Ihnen das
Mitschneiden ohne `sudo` erlauben: Sie kommen in die Gruppe
`wireshark`, und das Mitschnitt-Programm `dumpcap` bekommt genau das
nötige Recht (`cap_net_raw`). Nach jedem Update von Wireshark setzt das
Paket das Recht von selbst neu.

**Das tun Sie selbst:** Nach der Installation einmal neu verbinden;
erst dann gilt die neue Gruppe. In VS Code: das VS-Code-Fenster
schließen und über das Verwaltungs-Skript (**[9] VS Code starten**)
neu öffnen. Nach `ssh clawbook`: `exit` und erneut `ssh clawbook`.

**Falls die Automatik nicht geht:** Zeigt `id -nG` auch nach dem neuen
Verbinden kein `wireshark`, nehmen Sie sich selbst in die Gruppe auf
und verbinden danach erneut:

```bash
sudo usermod -aG wireshark student
```

## Wenn etwas nicht geht

- **„You don't have permission to capture on that device"** — die
  Gruppe gilt erst nach einem neuen Verbinden. `id -nG` muss
  `wireshark` zeigen; sonst siehe „Das tun Sie selbst“ und „Falls die
  Automatik nicht geht“.
- **„You requested a scan type which requires root privileges"** —
  Scans wie `nmap -sS` oder `-O` brauchen `sudo`. Für die Übungen
  genügt meist der Standard-Scan ohne Optionen.
- **`tshark` zeigt nichts und wartet** — auf der Schnittstelle kommt
  kein passender Verkehr an. Schnittstelle (`-i lo` für Verkehr im
  Container) und Filter prüfen; `Strg+C` beendet.
- **`nmap localhost` zeigt einen Port nicht** — er gehört nicht zu den
  1000 häufigsten. Mit `-p <port>` oder `-p-` (alle Ports) scannen.
- **`gpg` meldet „Screen or window too small“ oder „Inappropriate ioctl
  for device“** — `--pinentry-mode loopback` wie im Beispiel angeben.
