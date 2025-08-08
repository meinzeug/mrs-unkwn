# Nächster Schritt: Phase 2 – Modell-Evaluierung & Feedback

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 abgeschlossen ✓
- Phase 2 gestartet: Basissystem implementiert ✓
- Phase 2: ML-Modell integriert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`
- `backend/src/services/homework.service.ts`
- `backend/tests/homework.test.ts`

## Nächste Aufgabe
Bewerte die Genauigkeit des HomeworkDetectionService anhand von Testdaten und implementiere einen Feedback-Mechanismus zur Verbesserung.

### Vorbereitungen
- Repräsentative Testdatensätze definieren.
- Logging für Fehlklassifikationen vorbereiten.

### Implementierungsschritte
- Evaluationsfunktion erstellen, die die Erkennungsgenauigkeit berechnet.
- Feedback-Mechanismus ergänzen (z. B. Logging oder Endpoint).
- Tests und Validierungen erweitern.

### Validierung
- `bash -n scripts/setup_homework_detection.sh`
- `npm test --prefix backend`

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte generiert. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
