# Nächster Schritt: Phase 1 – `Error Handling und Logging System`

## Status
- Phase 0 abgeschlossen ✓
- Flutter SDK installiert (3.32.8)
- `pubspec.yaml` mit Dependencies konfiguriert
- Material App Grundstruktur implementiert
- Core-Ordnerstruktur mit Basis-Klassen erstellt ✓
- Dependency Injection mit GetIt eingerichtet ✓
- Flutter BLoC Basisklassen implementiert ✓
- HTTP Client mit Dio konfiguriert ✓
- Secure Storage Service implementiert ✓
- Basis-Routing mit GoRouter eingerichtet ✓
- Environment Configuration System implementiert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Error Handling und Logging System`

### Vorbereitungen
- Navigiere zu `flutter_app/mrs_unkwn_app/lib/core`.

### Implementierungsschritte
- Erstelle `utils/logger.dart` mit `Logger` Klasse basierend auf `dart:developer`.
- Implementiere Log-Level: `debug()`, `info()`, `warning()`, `error()`.
- Konfiguriere unterschiedliche Ausgabe für Debug/Release-Builds.
- Erstelle `errors/error_handler.dart` für globales Exception-Handling.
- Implementiere `handleError()` Funktion für verschiedene Exception-Typen und User-Messages.

### Validierung
- `ls flutter_app/mrs_unkwn_app/lib/core/utils`
- `grep -n "class Logger" flutter_app/mrs_unkwn_app/lib/core/utils/logger.dart`

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md`.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
