# Nächster Schritt: Auto-Login auf App-Start

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 Milestone 3: Biometric Authentication Setup abgeschlossen ✓
- Phase 1 Milestone 3: Auto-Login auf App-Start offen ✗

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Auto-Login beim Start der App implementieren.

### Vorbereitungen
- `README.md` und Roadmap prüfen.

### Implementierungsschritte
- `AppStartEvent` in `AuthBloc` hinzufügen und beim App-Start dispatchen.
- Gespeicherte Tokens auslesen und mit Backend validieren.
- Bei gültigen Tokens Nutzer automatisch einloggen, sonst Logout.

### Validierung
- Entsprechende Tests (z. B. `npm test`, `pytest codex/tests`) ausführen.

### Selbstgenerierung
- Nach jeder Wartungsaufgabe neuen Prompt erstellen.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte beim Ausführen automatisch erzeugt. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
