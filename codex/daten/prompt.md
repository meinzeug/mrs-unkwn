# Nächster Schritt: QR Code Invitation Feature

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 Milestone 4: Family Creation UI Screen abgeschlossen ✓
- Phase 1 Milestone 4: Family Model und Data Classes abgeschlossen ✓
- Phase 1 Milestone 4: Family Repository Implementation abgeschlossen ✓
- Phase 1 Milestone 4: Family BLoC State Management abgeschlossen ✓
- Phase 1 Milestone 4: Family Member Invitation System abgeschlossen ✓
- Phase 1 Milestone 4: QR Code Invitation Feature offen ✗

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
QR-Code-Einladungsfunktion implementieren.

### Vorbereitungen
- `README.md` und Roadmap prüfen.

### Implementierungsschritte
- Dependencies `qr_flutter` und `qr_code_scanner` hinzufügen.
- QR-Code im Invite-Member-Screen erzeugen, der den Einladungstoken enthält.
- QR-Scanner-Screen für Einladungsannahme implementieren.
- Kamera-Berechtigungen und Scanner-Fehler behandeln.
- Gescannten QR-Code validieren und Einladung automatisch verarbeiten.

### Validierung
- Entsprechende Tests (z. B. `npm test`, `pytest codex/tests`, `flutter test`) ausführen.

### Selbstgenerierung
- Nach jeder Wartungsaufgabe neuen Prompt erstellen.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte beim Ausführen automatisch erzeugt. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
