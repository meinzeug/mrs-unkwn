# Nächster Schritt: Phase 1 – `Dependency Injection mit GetIt einrichten`

## Status
- Phase 0 abgeschlossen ✓
- Flutter SDK installiert (3.32.8)
- `pubspec.yaml` mit Dependencies konfiguriert
- Material App Grundstruktur implementiert
- Core-Ordnerstruktur mit Basis-Klassen erstellt ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Dependency Injection mit GetIt einrichten`

### Vorbereitungen
- Führe bei Bedarf `scripts/create_flutter_project.sh` aus.
- Navigiere zu `flutter_app/mrs_unkwn_app/lib/core`.

### Implementierungsschritte
- Erstelle `di/service_locator.dart` mit globalem `sl` (`GetIt.instance`).
- Implementiere `configureDependencies()` zur Registrierung aller Services.
- Lege Hilfsfunktionen `_registerCore()`, `_registerFeatures()`, `_registerExternal()` an.
- Rufe `configureDependencies()` in `main.dart` vor `runApp()` auf.

### Validierung
- `ls flutter_app/mrs_unkwn_app/lib/core/di` (verifiziere Datei)
- `grep -n "configureDependencies" flutter_app/mrs_unkwn_app/lib/main.dart`

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt zum Weiterarbeiten in `/codex/daten/prompt.md`.

*Hinweis: Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
