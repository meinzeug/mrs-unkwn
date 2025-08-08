# Nächster Schritt: Phase 2 – Automatisierte Modell-Bereitstellung

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 abgeschlossen ✓
- Phase 2 gestartet: Basissystem implementiert ✓
- Phase 2: ML-Modell integriert ✓
- Phase 2: Modell-Evaluierung & Feedback ✓
- Phase 2: Modell-Retraining automatisiert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`
- `backend/src/services/homework.service.ts`
- `backend/tests/homework.test.ts`
- `scripts/setup_homework_detection.sh`
- `scripts/retrain_homework_model.ts`

## Nächste Aufgabe
Automatisiere das Deployment des retrainierten Modells und plane regelmäßige Trainingsläufe.

### Vorbereitungen
- Zeitplan für regelmäßiges Retraining definieren.
- Mechanismus zur Modellversionierung entwerfen.

### Implementierungsschritte
- NPM-Skript oder CI-Job anlegen, der `retrain_homework_model.ts` periodisch ausführt.
- Modellversions-Tracking in Datenordner integrieren.
- Dokumentation aktualisieren.

### Validierung
- `bash -n scripts/setup_homework_detection.sh`
- `npm test --prefix backend`

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte generiert. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
