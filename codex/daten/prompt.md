# Nächster Schritt: Logout Functionality

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 Milestone 3: Auto-Login auf App-Start abgeschlossen ✓
- Phase 1 Milestone 3: Logout Functionality offen ✗

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Logout-Funktion implementieren.

### Vorbereitungen
- `README.md` und Roadmap prüfen.

### Implementierungsschritte
- `LogoutRequested` Event in `AuthBloc` mit Server-Invalidation erweitern.
- Lokale Tokens und Nutzerinformationen entfernen.
- Nutzer nach Bestätigung zum Login umleiten.
- Netzwerkfehler abfangen und dennoch lokalen Logout durchführen.

### Validierung
- Entsprechende Tests (z. B. `npm test`, `pytest codex/tests`) ausführen.

### Selbstgenerierung
- Nach jeder Wartungsaufgabe neuen Prompt erstellen.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte beim Ausführen automatisch erzeugt. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
