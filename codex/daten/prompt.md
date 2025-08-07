# Nächster Schritt: Phase 1 – `JSON Serialization Setup`

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
- Error Handling und Logging System implementiert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `JSON Serialization Setup`

### Vorbereitungen
- Navigiere zum Projekt-Root `flutter_app/mrs_unkwn_app`.

### Implementierungsschritte
- Erstelle `build.yaml` für `json_serializable` Konfiguration mit `explicit_to_json: true` und `create_to_json: true`.
- Erstelle `lib/core/models/base_model.dart` mit `@JsonSerializable()` Annotation.
- Implementiere `fromJson()` und `toJson()` Methoden.
- Führe `flutter packages pub run build_runner build` aus, um Dateien zu generieren.

### Validierung
- `ls flutter_app/mrs_unkwn_app/lib/core/models`
- `grep -n "class BaseModel" flutter_app/mrs_unkwn_app/lib/core/models/base_model.dart`

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md`.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
