# Nächster Schritt: Phase 1 – `pubspec.yaml` mit erforderlichen Dependencies konfigurieren

## Status
- Phase 0 abgeschlossen ✓
- Flutter SDK installiert (3.32.8)
- Flutter-Projekt wird bei Bedarf durch `scripts/create_flutter_project.sh` erzeugt

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `pubspec.yaml` mit erforderlichen Dependencies konfigurieren

### Vorbereitungen
- Führe bei Bedarf `scripts/create_flutter_project.sh` aus, um die Projektstruktur zu generieren.
- Navigiere zu `flutter_app/mrs_unkwn_app`.

### Implementierungsschritte
- Öffne `pubspec.yaml`.
- Füge unter `dependencies:` hinzu: `dio: ^5.3.0`, `flutter_bloc: ^8.1.3`, `get_it: ^7.6.0`, `flutter_secure_storage: ^9.0.0`, `go_router: ^12.0.0`, `hive: ^2.2.3`, `json_annotation: ^4.8.1`.
- Füge unter `dev_dependencies:` hinzu: `build_runner: ^2.4.7`, `json_serializable: ^6.7.1`, `flutter_test:` und `mocktail: ^1.0.0`.
- Speichere die Datei.

### Validierung
- `grep dio pubspec.yaml` (innerhalb des Projektordners)

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt zum Weiterarbeiten in `/codex/daten/prompt.md`.

