# Nächster Schritt: Phase 3 – Multi-Language Support implementieren

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 abgeschlossen ✓
- Phase 2 abgeschlossen ✓
- Phase 3 Roadmap erstellt ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Implementiere die grundlegende Infrastruktur für Multi-Language Support.

### Vorbereitungen
- Bestehende App- und Backend-Struktur analysieren.

### Implementierungsschritte
- Lokalisierungsframework im Flutter-Projekt einrichten.
- Backend um Spracheinstellungen erweitern.
- Skript `scripts/generate_translations.sh` erstellen, das Übersetzungsdateien automatisch generiert.

### Validierung
- `python -m py_compile` auf geänderten Python-Dateien ausführen.
- `flutter test` und `npm test` ausführen (falls vorhanden).

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte generiert. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*

