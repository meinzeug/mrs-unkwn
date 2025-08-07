# Nächster Schritt: Phase 1 – `Basis-Routing mit GoRouter einrichten`

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

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Basis-Routing mit GoRouter einrichten`

### Vorbereitungen
- Navigiere zu `flutter_app/mrs_unkwn_app/lib/core`.

### Implementierungsschritte
- Erstelle `routing/app_router.dart` mit `AppRouter` Klasse und statischer `GoRouter` Instanz.
- Definiere Route-Konstanten in `routing/route_constants.dart`: `/login`, `/register`, `/home`, `/family-setup`.
- Implementiere grundlegende Routen mit `GoRoute` Objekten.
- Füge Navigation-Guards für authentifizierte Routen hinzu.
- Konfiguriere Redirect-Logik für nicht-authentifizierte Benutzer.

### Validierung
- `ls flutter_app/mrs_unkwn_app/lib/core/routing`
- `grep -n "class AppRouter" flutter_app/mrs_unkwn_app/lib/core/routing/app_router.dart`

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md`.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
