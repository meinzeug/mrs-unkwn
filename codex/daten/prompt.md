# Nächster Schritt: Phase 1 – `User-Tabelle Migration erstellen`

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
- Database Connection Setup mit PostgreSQL ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `User-Tabelle Migration erstellen`

### Vorbereitungen
- Navigiere zum Projekt-Root `backend/`.

### Implementierungsschritte
- `npx knex migrate:make create_users_table` ausführen.
- In der generierten Migration `users` Tabelle mit Spalten `id`, `name`, `email`, `password`, `created_at`, `updated_at` erstellen.
- `email` als einzigartigen Index definieren.
- In `down()` die Tabelle wieder entfernen.

### Validierung
- `npx tsc --noEmit`.
- `npx knex migrate:latest` (führt Migration aus).
- `npx knex migrate:rollback` (setzt Migration zurück).

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
