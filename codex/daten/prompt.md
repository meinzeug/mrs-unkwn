# Nächster Schritt: Phase 2 – Modellversions-API

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 abgeschlossen ✓
- Phase 2 gestartet: Basissystem implementiert ✓
- Phase 2: ML-Modell integriert ✓
- Phase 2: Modell-Evaluierung & Feedback ✓
- Phase 2: Modell-Retraining automatisiert ✓
- Phase 2: Modell-Bereitstellung automatisiert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`
- `backend/package.json`
- `backend/src/services/homework.service.ts`
- `backend/tests/homework.test.ts`
- `scripts/setup_homework_detection.sh`
- `scripts/retrain_homework_model.ts`
- `.github/workflows/retrain_model.yml`

## Nächste Aufgabe
Implementiere einen API-Endpunkt, der die aktuelle Modellversion und das letzte Retrain-Datum zurückgibt.

### Vorbereitungen
- Route und Rückgabeformat definieren.
- Quelle für Retrain-Zeitpunkt festlegen.

### Implementierungsschritte
- Route und Controller für Modellinformationen erstellen.
- Service um Abfrage von Version und Datum erweitern.
- Tests und Dokumentation aktualisieren.

### Validierung
- `npm test --prefix backend`

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte generiert. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
