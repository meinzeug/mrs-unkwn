# Nächster Schritt: Phase 4 – Client-SDK für Drittanbieter-API

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 abgeschlossen ✓
- Phase 2 abgeschlossen ✓
- Phase 3 Milestone 1 abgeschlossen ✓
- Phase 3 Milestone 2 abgeschlossen ✓
- Phase 3 Milestone 3 abgeschlossen ✓
- Phase 3 Milestone 4 abgeschlossen ✓
- Phase 4 Milestone 1 abgeschlossen ✓
- Phase 4 Milestone 2 abgeschlossen ✓
- Phase 4 Milestone 3 abgeschlossen ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`
- `backend/third_party_api.md`

## Nächste Aufgabe
Client-SDK für die Drittanbieter-API erstellen.

### Vorbereitungen
- Anforderungen an Client-Bibliotheken prüfen.
- Zielplattform (z.B. TypeScript) festlegen.

### Implementierungsschritte
- SDK-Grundgerüst im Ordner `backend/sdk/` erstellen.
- Beispiel-Funktion für `GET /api/external/health` implementieren.

### Validierung
- `python -m py_compile` auf geänderten Python-Dateien ausführen.
- `npm test` und `flutter test` ausführen (falls vorhanden).

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte generiert. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
