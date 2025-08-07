# Nächster Schritt: Phase 1 – `Basis App-Struktur mit Material App konfigurieren`

## Status
- Phase 0 abgeschlossen ✓
- Flutter SDK installiert (3.32.8)
- `pubspec.yaml` mit Dependencies konfiguriert
- Flutter-Projekt wird bei Bedarf durch `scripts/create_flutter_project.sh` erzeugt

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Basis App-Struktur mit Material App konfigurieren`

### Vorbereitungen
- Führe bei Bedarf `scripts/create_flutter_project.sh` aus, um die Projektstruktur zu generieren.
- Navigiere zu `flutter_app/mrs_unkwn_app/lib`.

### Implementierungsschritte
- Erstelle `lib/app.dart`.
- Implementiere `MrsUnkwnApp` Klasse, die `StatelessWidget` erweitert.
- Gib in `build()` `MaterialApp` zurück mit `title: 'Mrs-Unkwn'`, `theme: ThemeData(primarySwatch: Colors.blue)`, `home: Placeholder()`.
- Importiere `app.dart` in `lib/main.dart` und rufe `runApp(MrsUnkwnApp())` in `main()` auf.

### Validierung
- `grep MrsUnkwnApp lib/main.dart` (innerhalb des Projektordners)

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt zum Weiterarbeiten in `/codex/daten/prompt.md`.
