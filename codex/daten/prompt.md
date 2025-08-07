# Nächster Schritt: Phase 1 – `Flutter BLoC Setup mit Basis-Strukturen`

## Status
- Phase 0 abgeschlossen ✓
- Flutter SDK installiert (3.32.8)
- `pubspec.yaml` mit Dependencies konfiguriert
- Material App Grundstruktur implementiert
- Core-Ordnerstruktur mit Basis-Klassen erstellt ✓
- Dependency Injection mit GetIt eingerichtet ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Flutter BLoC Setup mit Basis-Strukturen`

### Vorbereitungen
- Navigiere zu `flutter_app/mrs_unkwn_app/lib/core`.

### Implementierungsschritte
- Erstelle `bloc/base_event.dart` und `bloc/base_state.dart` mit abstrakten Klassen.
- Implementiere `bloc/base_bloc.dart` mit Standard-Error-Handling und Logging.
- Erstelle `bloc/bloc_observer.dart` zur globalen BLoC-Überwachung.

### Validierung
- `ls flutter_app/mrs_unkwn_app/lib/core/bloc`
- `grep -n "class BaseBloc" flutter_app/mrs_unkwn_app/lib/core/bloc/base_bloc.dart`

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md`.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
