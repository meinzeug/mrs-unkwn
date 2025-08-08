# Nächster Schritt: Phase 4 – API-Dokumentation & Beispielskripte

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 abgeschlossen ✓
- Phase 2 abgeschlossen ✓
- Phase 3 Milestone 1 abgeschlossen ✓
- Phase 3 Milestone 2 abgeschlossen ✓
- Phase 3 Milestone 3 abgeschlossen ✓
- Phase 3 Milestone 4 abgeschlossen ✓
- Phase 4 Milestone 1 abgeschlossen ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`
- `backend/third_party_api.md`

## Nächste Aufgabe
API-Dokumentation für Drittanbieter erweitern und Beispielskript zur Nutzung des Developer-Portals erstellen.

### Vorbereitungen
- Bestehende Dokumentation prüfen.
- Anforderungen für Beispielskript sammeln.

### Implementierungsschritte
- `backend/third_party_api.md` um detaillierte Anleitung erweitern.
- Skript `scripts/example_api_client.ts` erstellen, das API-Key generiert und Abfrage durchführt.

### Validierung
- `python -m py_compile` auf geänderten Python-Dateien ausführen.
- `npm test` und `flutter test` ausführen (falls vorhanden).

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte generiert. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
