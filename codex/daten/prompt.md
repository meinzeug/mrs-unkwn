# Nächster Schritt: Phase 2 – Homework Detection Model Integration

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 abgeschlossen ✓
- Phase 2 gestartet: Basissystem implementiert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`
- `scripts/setup_homework_detection.sh`
- `backend/src/services/homework.service.ts`

## Nächste Aufgabe
Integriere ein echtes ML-Modell in den HomeworkDetectionService, um AI-generierte Texte zuverlässiger zu erkennen.

### Vorbereitungen
- `scripts/setup_homework_detection.sh` ausführen, um das Modell zu laden.
- Bestehenden Service und Route prüfen.

### Implementierungsschritte
- Modell laden und initialisieren.
- Heuristische Erkennung durch Modellaufruf ersetzen.
- Tests und Validierungen anpassen.

### Validierung
- `bash -n scripts/setup_homework_detection.sh`
- `npm test --prefix backend`

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte generiert. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
