# clawbook-dotnet — .NET mit Entity Framework

Dieses Paket bringt das .NET SDK und das Werkzeug für Entity Framework
Core mit. Damit schreiben Sie im clawbook-Container Programme in C#
und arbeiten mit Datenbanken.

## Was drin ist

| Werkzeug | Version | Befehl | Herkunft |
|---|---|---|---|
| .NET SDK (LTS) | 10.0.401 | `dotnet` | Microsoft, unter `/usr/lib/dotnet` |
| Entity-Framework-Werkzeug | 10.0.12 | `dotnet ef` | nuget.org, systemweit |

Die Telemetrie der .NET-CLI ist abgeschaltet.

VS-Code-Erweiterungen im Container: C# (`ms-dotnettools.csharp`) und
C# Dev Kit (`ms-dotnettools.csdevkit`).

## Installieren

Das Paket kommt mit dem Kurs `kurs-swe`. Einzeln installieren Sie es im
Container so:

```bash
clawbook pakete add clawbook-dotnet
```

Oder im clawbook-Menü **6 Pakete und Kurse**, dann `t`. Wie Kurse und
Technikpakete funktionieren, steht in
[Kurse und Technikpakete](https://github.com/schlingensiepen/clawbook-lehre/blob/main/docs/kurse-und-pakete.md).
Diese Doku zeigt Ihnen im Container auch
`clawbook pakete info clawbook-dotnet`.

## Erste Schritte

**Hello World:**

```bash
cd ~/source
dotnet new console -o HalloDotnet
cd HalloDotnet
dotnet run            # Hello, World!
```

**Entity Framework Core mit SQLite:** Ein Programm speichert Bücher in
einer Datenbankdatei.

```bash
cd ~/source
dotnet new console -o Bibliothek
cd Bibliothek
dotnet add package Microsoft.EntityFrameworkCore.Sqlite --version 10.0.*
dotnet add package Microsoft.EntityFrameworkCore.Design --version 10.0.*
```

`Program.cs` ersetzen durch:

```csharp
using Microsoft.EntityFrameworkCore;

using var db = new BibliothekContext();
db.Buecher.Add(new Buch { Titel = "Der Hobbit" });
db.SaveChanges();
foreach (var b in db.Buecher)
    Console.WriteLine($"{b.Id}: {b.Titel}");

public class Buch
{
    public int Id { get; set; }
    public string Titel { get; set; } = "";
}

public class BibliothekContext : DbContext
{
    public DbSet<Buch> Buecher => Set<Buch>();

    protected override void OnConfiguring(DbContextOptionsBuilder options)
        => options.UseSqlite("Data Source=bibliothek.db");
}
```

Datenbank aus dem Modell erzeugen und das Programm starten:

```bash
dotnet ef migrations add Anfang    # legt den Ordner Migrations/ an
dotnet ef database update          # erzeugt bibliothek.db
dotnet run                         # 1: Der Hobbit
```

Mit `sqlite3 bibliothek.db 'select * from Buecher;'` sehen Sie den
Inhalt (`sqlite3` kommt mit `clawbook-db-sqlite`, etwa im Kurs
`kurs-swe`).

## Wer macht was

**Das erledigt clawbook:** .NET SDK und `dotnet ef` installieren, die
Telemetrie abschalten (auch für VS Code); die Erweiterungen kommen mit
dem VSCodePack des Kurses (einzeln installiert: im Verwaltungs-Skript
**[10]**, dann **[1]**).

**Das tun Sie selbst:** Bibliotheken je Projekt mit `dotnet add
package` hinzufügen; sie kommen aus dem Netz (nuget.org). Für
`dotnet ef` muss das Projekt `Microsoft.EntityFrameworkCore.Design`
enthalten. Das C# Dev Kit steht unter einer eigenen Lizenz von
Microsoft; für Studium und Lehre ist es kostenlos.

**Falls die Automatik nicht geht:** Fehlen die Erweiterungen, in
VS Code „C# Dev Kit" in der Erweiterungsansicht (`Strg+Umschalt+X`)
suchen und **In SSH: clawbook installieren**. `dotnet tool install
dotnet-ef` ist nicht nötig.

## Wenn etwas nicht geht

- **„Your startup project '…' doesn't reference
  Microsoft.EntityFrameworkCore.Design"** — das Paket fehlt im
  Projekt: `dotnet add package Microsoft.EntityFrameworkCore.Design
  --version 10.0.*`.
- **„No migrations were found"** oder die Tabelle fehlt — erst
  `dotnet ef migrations add <Name>`, dann `dotnet ef database update`.
- **`dotnet add package` scheitert** — nuget.org ist nicht erreichbar.
  Internet prüfen und erneut versuchen.
- **Versionskonflikt bei den EF-Paketen** — alle
  `Microsoft.EntityFrameworkCore.*` eines Projekts brauchen dieselbe
  Hauptversion (hier 10); daher `--version 10.0.*`.
