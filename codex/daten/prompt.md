# Nächster Schritt: Phase 1 – `Core-Ordnerstruktur mit Basis-Klassen erstellen`

## Status
- Phase 0 abgeschlossen ✓
- Flutter SDK installiert (3.32.8)
- `pubspec.yaml` mit Dependencies konfiguriert
- Material App Grundstruktur implementiert

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Core-Ordnerstruktur mit Basis-Klassen erstellen`

### Vorbereitungen
- Führe bei Bedarf `scripts/create_flutter_project.sh` aus.
- Navigiere zu `flutter_app/mrs_unkwn_app/lib/core`.

### Implementierungsschritte
- Erstelle `constants/app_constants.dart` mit Klasse `AppConstants` und statischen Strings `appName`, `version`, `apiBaseUrl`.
- Erstelle `errors/failures.dart` mit abstrakter Klasse `Failure` sowie `ServerFailure`, `NetworkFailure`, `AuthFailure`.
- Erstelle `network/network_info.dart` Interface für Netzwerk-Konnektivität.
- Erstelle `theme/app_theme.dart` mit `AppTheme` Klasse für einheitliches Styling.

### Validierung
- `ls flutter_app/mrs_unkwn_app/lib/core` (verifiziere angelegte Dateien)

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt zum Weiterarbeiten in `/codex/daten/prompt.md`.

*Hinweis: Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
