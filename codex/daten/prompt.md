# Nächster Schritt: CI-Build für Android-APK einrichten

## Status
- Phase 0 abgeschlossen ✓
- Produktions-Setup-Skript erstellt ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
GitHub Actions Workflow erstellen, der `flutter build apk --release` ausführt und das APK als Artefakt bereitstellt.

### Vorbereitungen
- README und Roadmap prüfen.

### Implementierungsschritte
- Workflow-Datei `.github/workflows/build-apk.yml` anlegen.
- Container `cirrusci/flutter:stable` verwenden.
- APK unter `dist/app-release.apk` erzeugen und hochladen.

### Validierung
- `npm test`
- `pytest codex/tests`
- `flutter test`

### Selbstgenerierung
- Nach Abschluss neuen Prompt erstellen.
