# Nächster Schritt: Phase 4 – Automatisierte API-Tests

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

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`
- `backend/third_party_api.md`
- `scripts/example_api_client.ts`

## Nächste Aufgabe
Automatisierte Tests für die Drittanbieter-API hinzufügen.

### Vorbereitungen
- API-Dokumentation und vorhandene Tests prüfen.
- Testfälle für authentifizierte und nicht authentifizierte Zugriffe definieren.

### Implementierungsschritte
- Datei `backend/tests/external_api.test.ts` erstellen und Endpunkte mit gültigem sowie ungültigem API-Key testen.
- `package.json` im Backend um Skript `test:external` ergänzen, das die neuen Tests ausführt.

### Validierung
- `python -m py_compile` auf geänderten Python-Dateien ausführen.
- `npm test` und `flutter test` ausführen (falls vorhanden).

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte generiert. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*

