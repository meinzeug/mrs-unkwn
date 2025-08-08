# Nächster Schritt: Phase 4 – TypeScript-Typdefinitionen für Client-SDK

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
- Phase 4 Milestone 4 (JS-SDK) abgeschlossen ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`
- `backend/third_party_api.md`

## Nächste Aufgabe
TypeScript-Typdefinitionen für das Client-SDK veröffentlichen.

### Vorbereitungen
- Bestehenden SDK-Code analysieren.
- Build-Prozess für Typdefinitionen prüfen.

### Implementierungsschritte
- `build_sdk.sh` erweitern, um `.d.ts` Dateien zu erzeugen.
- Typdefinitionen im Ordner `backend/sdk/dist` ablegen.

### Validierung
- `python -m py_compile` auf geänderten Python-Dateien ausführen.
- `npm test` und `flutter test` ausführen (falls vorhanden).

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte generiert. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
