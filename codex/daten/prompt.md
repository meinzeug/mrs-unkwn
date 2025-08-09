# Nächster Schritt: Family Member Invitation System

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 Milestone 4: Family Creation UI Screen abgeschlossen ✓
- Phase 1 Milestone 4: Family Model und Data Classes abgeschlossen ✓
- Phase 1 Milestone 4: Family Repository Implementation abgeschlossen ✓
- Phase 1 Milestone 4: Family BLoC State Management abgeschlossen ✓
- Phase 1 Milestone 4: Family Member Invitation System offen ✗

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Einladungssystem für Familienmitglieder implementieren.

### Vorbereitungen
- `README.md` und Roadmap prüfen.

### Implementierungsschritte
- Datei `invite_member_page.dart` mit Email-Input und Rollenwahl erstellen.
- `InviteMemberRequested` Event im `FamilyBloc` ergänzen und Handler implementieren.
- Backend-Endpoint `/api/family/invite` in Repository integrieren.
- Invitation-Token mit 24h-Gültigkeit generieren und E-Mail-Versand auslösen.
- Flow zum Annehmen der Einladung mit Token-Validierung implementieren.
- Familienmitgliederliste nach erfolgreicher Einladung aktualisieren.

### Validierung
- Entsprechende Tests (z. B. `npm test`, `pytest codex/tests`, `flutter test`) ausführen.

### Selbstgenerierung
- Nach jeder Wartungsaufgabe neuen Prompt erstellen.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte beim Ausführen automatisch erzeugt. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
