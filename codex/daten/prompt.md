# Nächster Schritt: GitHub Actions für Android-Release-Build einrichten

## Status
- Phase 0 abgeschlossen ✓
- Produktions-Setup-Skript erstellt ✓
- Disk-Space-Plugin ersetzt & Backend-Build-Skripte ergänzt ✓
- Android namespace Fixer & Release-Build-Skripte hinzugefügt ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
GitHub Actions Workflow erstellen, der `scripts/build_android_release.sh` ausführt und das APK als Artefakt bereitstellt.

### Vorbereitungen
- README und Roadmap prüfen.

### Implementierungsschritte
- Workflow-Datei `.github/workflows/build-android-release.yml` anlegen.
- Container `cirrusci/flutter:stable` verwenden.
- `scripts/build_android_release.sh` ausführen.
- Artefakt `build/app/outputs/flutter-apk/app-release.apk` hochladen.

### Validierung
- `npm test`
- `pytest codex/tests`
- `flutter test`

### Selbstgenerierung
- Nach Abschluss neuen Prompt erstellen.
