# Nächster Schritt: Phase 2 – Modell-Retraining mit Feedback-Daten

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 abgeschlossen ✓
- Phase 2 gestartet: Basissystem implementiert ✓
- Phase 2: ML-Modell integriert ✓
- Phase 2: Modell-Evaluierung & Feedback ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`
- `backend/src/services/homework.service.ts`
- `backend/tests/homework.test.ts`
- `scripts/setup_homework_detection.sh`

## Nächste Aufgabe
Nutze gesammelte Feedback-Daten zur Aktualisierung des Modells und automatisiere das Retraining.

### Vorbereitungen
- Feedback-Logdateien analysieren.
- Skript oder Routine für Modelltraining vorbereiten.

### Implementierungsschritte
- Trainingsskript erstellen, das Feedback-Daten einbezieht.
- Modell nach Training als Datei generieren.
- Tests und Dokumentation anpassen.

### Validierung
- `bash -n scripts/setup_homework_detection.sh`
- `npm test --prefix backend`

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte generiert. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
