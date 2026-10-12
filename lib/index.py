#!/usr/bin/env python3
"""Writes a small German index.html for the repository from a Packages file."""

import html
import sys

URL = "https://schlingensiepen.github.io/clawbook-apt"
REPO = "https://github.com/schlingensiepen/clawbook-apt"


def read_packages(path):
    entries, cur, last = [], {}, None
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.rstrip("\n")
            if not line:
                if cur:
                    entries.append(cur)
                cur, last = {}, None
            elif line[0] in " \t" and last:
                cur[last] += "\n" + line.strip()
            else:
                key, _, value = line.partition(":")
                cur[key] = value.strip()
                last = key
    if cur:
        entries.append(cur)
    return entries


def row(p):
    size = int(p.get("Size", "0")) / 1e6
    summary = p.get("Description", "").split("\n", 1)[0]
    return (f"<tr><td><code>{html.escape(p['Package'])}</code></td>"
            f"<td>{html.escape(p['Version'])}</td>"
            f"<td>{html.escape(summary)}</td>"
            f"<td>{size:.1f} MB</td></tr>")


def table(title, items):
    if not items:
        return ""
    rows = "\n".join(row(p) for p in sorted(items, key=lambda p: p["Package"]))
    return (f"<h2>{title}</h2>\n<table><tr><th>Paket</th><th>Version</th>"
            f"<th>Inhalt</th><th>Download</th></tr>\n{rows}\n</table>\n")


def main():
    pkgs = read_packages(sys.argv[1])
    kurse = [p for p in pkgs if p.get("X-Clawbook-Art") == "kurs"]
    technik = [p for p in pkgs if p.get("X-Clawbook-Art") == "technik"]
    andere = [p for p in pkgs if p.get("X-Clawbook-Art") not in ("kurs", "technik")]
    sources = (f"Types: deb\nURIs: {URL}\nSuites: trixie\nComponents: main\n"
               "Architectures: amd64\nSigned-By: /usr/share/keyrings/clawbook-apt.gpg")
    print(f"""<!doctype html>
<html lang="de"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>clawbook-apt</title>
<style>
:root {{ color-scheme: light dark; --fg: #1a1a1a; --bg: #fff; --muted: #666; --line: #ddd; }}
@media (prefers-color-scheme: dark) {{ :root {{ --fg: #e8e8e8; --bg: #161616; --muted: #aaa; --line: #333; }} }}
body {{ font: 16px/1.5 system-ui, sans-serif; color: var(--fg); background: var(--bg);
       max-width: 60rem; margin: 0 auto; padding: 1rem; }}
table {{ border-collapse: collapse; width: 100%; display: block; overflow-x: auto; }}
th, td {{ text-align: left; padding: .3rem .6rem; border-bottom: 1px solid var(--line); vertical-align: top; }}
pre {{ overflow-x: auto; padding: .6rem; border: 1px solid var(--line); }}
small {{ color: var(--muted); }}
</style></head><body>
<h1>clawbook-apt</h1>
<p>Signiertes apt-Repository mit Technikpaketen und Kursen für clawbook-lehre
(Debian 13 „trixie“, amd64). Quelltext und Anleitung: <a href="{REPO}">{REPO}</a></p>
<p>Schlüssel: <a href="clawbook-apt.asc">clawbook-apt.asc</a> ·
<a href="clawbook-apt.gpg">clawbook-apt.gpg</a></p>
<pre>{html.escape(sources)}</pre>
{table("Kurse", kurse)}{table("Technikpakete", technik)}{table("Mitgelieferte Fremdpakete", andere)}
<p><small>Erzeugt von build.sh.</small></p>
</body></html>""")


if __name__ == "__main__":
    main()
