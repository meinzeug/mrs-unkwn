# Nächster Schritt: Phase 1 – `HTTP Client mit Dio konfigurieren`

## Status
- Phase 0 abgeschlossen ✓
- Flutter SDK installiert (3.32.8)
- `pubspec.yaml` mit Dependencies konfiguriert
- Material App Grundstruktur implementiert
- Core-Ordnerstruktur mit Basis-Klassen erstellt ✓
- Dependency Injection mit GetIt eingerichtet ✓
- Flutter BLoC Basisklassen implementiert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `HTTP Client mit Dio konfigurieren`

### Vorbereitungen
- Navigiere zu `flutter_app/mrs_unkwn_app/lib/core`.

### Implementierungsschritte
- Erstelle `network/dio_client.dart` mit Singleton `DioClient`.
- Konfiguriere `Dio` mit `BaseOptions` (`baseUrl`, `connectTimeout`, `receiveTimeout`).
- Füge Entwicklungs `LogInterceptor` und JWT-Interceptor hinzu.
- Implementiere Methoden `get()`, `post()`, `put()`, `delete()` mit Fehlerbehandlung.

### Validierung
- `ls flutter_app/mrs_unkwn_app/lib/core/network`
- `grep -n "class DioClient" flutter_app/mrs_unkwn_app/lib/core/network/dio_client.dart`

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md`.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
