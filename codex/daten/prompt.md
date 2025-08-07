# Nächster Schritt: Phase 1 – `Database Connection Setup mit PostgreSQL`

## Status
- Phase 0 abgeschlossen ✓
- Flutter SDK installiert (3.32.8)
- `pubspec.yaml` mit Dependencies konfiguriert ✓
- Material App Grundstruktur implementiert ✓
- Core-Ordnerstruktur mit Basis-Klassen erstellt ✓
- Dependency Injection mit GetIt eingerichtet ✓
- Flutter BLoC Basisklassen implementiert ✓
- HTTP Client mit Dio konfiguriert ✓
- Secure Storage Service implementiert ✓
- Basis-Routing mit GoRouter eingerichtet ✓
- Environment Configuration System implementiert ✓
- Error Handling und Logging System implementiert ✓
- JSON Serialization Setup implementiert ✓
- Node.js Express Server initialisiert ✓
- Express Server Basis-Konfiguration implementiert ✓
- Environment Variables Setup implementiert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Database Connection Setup mit PostgreSQL`

### Vorbereitungen
- Navigiere zum Projekt-Root `backend/`.

### Implementierungsschritte
- Dependencies `pg` und `knex` installieren.
- Dev-Dependency `@types/pg` installieren.
- `src/database/connection.ts` mit Knex-Konfiguration basierend auf `config.databaseUrl` erstellen.
- Knex-Instanz exportieren und `testConnection()` Funktion implementieren.
- Verzeichnis `src/database/migrations/` anlegen.

### Validierung
- `npx tsc --noEmit`
- `npx ts-node src/database/connection.ts` ausführen und erfolgreiche Verbindung prüfen.

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*

