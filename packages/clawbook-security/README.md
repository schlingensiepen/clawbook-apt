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

Das Paket kommt mit dem Kurs `kurs-iot`. Einzeln installieren Sie es im
Container so:

```bash
clawbook pakete add clawbook-security
```

Oder im clawbook-Menü **6 Pakete und Kurse**, dann `t`. Wie Kurse und
Technikpakete funktionieren, steht in
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch
`clawbook pakete info clawbook-security`.

**Wichtig:** Untersuchen Sie nur Ihren eigenen Container und Netze, für
die Sie eine Erlaubnis haben. Fremde Rechner zu scannen oder
mitzuschneiden kann verboten sein.

## Erste Schritte

**Offene Ports im eigenen Container:**

```bash
nmap localhost                   # die 1000 häufigsten Ports
nmap -p 1880,5432 localhost      # gezielt bestimmte Ports
```

**Datenverkehr mitschneiden:** Terminal 1 lauscht auf der
Loopback-Schnittstelle `lo` (Verkehr innerhalb des Containers):

```bash
tshark -D                                 # Schnittstellen auflisten
tshark -i lo -c 6 -f 'tcp port 8000'      # 6 Pakete auf Port 8000
```

Terminal 2 erzeugt Verkehr:

```bash
python3 -m http.server 8000 &
curl -s localhost:8000/ > /dev/null
```

TShark zeigt den Verbindungsaufbau (`SYN`, `SYN, ACK`, `ACK`) und die
Zeile `GET / HTTP/1.1`. Mit `-w mitschnitt.pcap` speichern Sie den
Mitschnitt; die Datei können Sie in Wireshark unter Windows öffnen.

**Datei verschlüsseln:**

```bash
echo "Treffen um 10 Uhr" > nachricht.txt
gpg --symmetric nachricht.txt        # fragt nach einem Passwort
gpg --decrypt nachricht.txt.gpg
```

## Wer macht was

**Das erledigt clawbook:** die Werkzeuge installieren und Ihnen das
Mitschneiden ohne `sudo` erlauben: Sie kommen in die Gruppe
`wireshark`, und das Mitschnitt-Programm `dumpcap` bekommt genau das
nötige Recht (`cap_net_raw`). Nach jedem Update von Wireshark setzt das
Paket das Recht von selbst neu.

**Das tun Sie selbst:** Nach der Installation einmal ab- und wieder
anmelden (`exit`, dann neu verbinden); erst dann gilt die neue Gruppe.

## Wenn etwas nicht geht

- **„You don't have permission to capture on that device"** — die
  Gruppe gilt erst nach einer neuen Anmeldung. `id -nG` muss
  `wireshark` zeigen; sonst abmelden und neu verbinden.
- **„You requested a scan type which requires root privileges"** —
  Scans wie `nmap -sS` oder `-O` brauchen `sudo`. Für die Übungen
  genügt meist der Standard-Scan ohne Optionen.
- **`tshark` zeigt nichts und wartet** — auf der Schnittstelle kommt
  kein passender Verkehr an. Schnittstelle (`-i lo` für Verkehr im
  Container) und Filter prüfen; `Strg+C` beendet.
- **`nmap localhost` zeigt einen Port nicht** — er gehört nicht zu den
  1000 häufigsten. Mit `-p <port>` oder `-p-` (alle Ports) scannen.
