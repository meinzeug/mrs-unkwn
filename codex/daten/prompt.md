# Nächster Schritt: Phase 3 – B2B Features implementieren

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 abgeschlossen ✓
- Phase 2 abgeschlossen ✓
- Phase 3 Milestone 1 abgeschlossen ✓
- Phase 3 Milestone 2 abgeschlossen ✓
- Phase 3 Milestone 3 abgeschlossen ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Organisations-Accounts und Rollenverwaltung einführen.

### Vorbereitungen
- Backend- und Flutter-Strukturen für Nutzerverwaltung prüfen.

### Implementierungsschritte
- Organisations-Accounts und Rollenverwaltung einführen.
- Skript `scripts/create_sample_organizations.sh` erstellen, das Beispiel-Organisationen anlegt.

### Validierung
- `python -m py_compile` auf geänderten Python-Dateien ausführen.
- `flutter test` und `npm test` ausführen (falls vorhanden).

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte generiert. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
