# Nächster Schritt: Phase 1 – `Environment Configuration System`

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

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Environment Configuration System`

### Vorbereitungen
- Navigiere zu `flutter_app/mrs_unkwn_app/lib/core`.

### Implementierungsschritte
- Erstelle `config/environment.dart` mit `Environment` Klasse.
- Implementiere statische Methoden: `String get apiBaseUrl`, `bool get isProduction`, `String get appName`.
- Definiere Environment-Typen: `dev`, `staging`, `prod`.
- Lege separate Konfigurationsdateien in `lib/config/`: `dev_config.dart`, `staging_config.dart`, `prod_config.dart` an.
- Nutze `--dart-define` für Build-Zeit-Konfiguration.

### Validierung
- `ls flutter_app/mrs_unkwn_app/lib/core/config`
- `grep -n "class Environment" flutter_app/mrs_unkwn_app/lib/core/config/environment.dart`

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md`.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
