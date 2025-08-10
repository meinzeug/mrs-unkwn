# Nächster Schritt: Release-Build nach AGP 8.6.0 Upgrade stabilisieren

## Status
- geolocator_android Plugin gepatcht (toARGB32 -> value)
- build_android_release.sh generiert L10n-Dateien und patcht Plugin
- Android settings.gradle auf AGP 8.6.0 angehoben
- Release-Build weiterhin fehlgeschlagen (Abhängigkeits-/Gradle-Probleme)

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Release-Build erneut ausführen und verbliebene Build-Probleme analysieren.

### Vorbereitungen
- README und Roadmap prüfen.

### Implementierungsschritte
- `flutter clean`
- `flutter pub get`
- `flutter gen-l10n`
- `scripts/patch_geolocator_android.sh`
- `dart run tool/fix_android_namespaces.dart`
- `flutter build apk --release`

### Validierung
- `npm test`
- `pytest codex/tests`
- `flutter test`

### Selbstgenerierung
- Nach Abschluss neuen Prompt erstellen.
