# Nächster Schritt: iOS Native Code für Screen Time Integration

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 Milestone 4: Family Creation UI Screen abgeschlossen ✓
- Phase 1 Milestone 4: Family Model und Data Classes abgeschlossen ✓
- Phase 1 Milestone 4: Family Repository Implementation abgeschlossen ✓
- Phase 1 Milestone 4: Family BLoC State Management abgeschlossen ✓
- Phase 1 Milestone 4: Family Member Invitation System abgeschlossen ✓
- Phase 1 Milestone 4: QR Code Invitation Feature abgeschlossen ✓
- Phase 1 Milestone 4: Family Settings Management abgeschlossen ✓
- Phase 1 Milestone 4: Family Member Management UI abgeschlossen ✓
- Phase 1 Milestone 4: Family Dashboard Overview abgeschlossen ✓
- Phase 1 Milestone 4: Family Role-Based Permissions abgeschlossen ✓
- Phase 1 Milestone 4: Family Subscription Management abgeschlossen ✓
- Phase 1 Milestone 4: Family Data Synchronization abgeschlossen ✓
- Phase 1 Milestone 5: Platform Channel Setup für Device Monitoring abgeschlossen ✓
- Phase 1 Milestone 5: Android Native Code für App Usage Tracking abgeschlossen ✓
- Phase 1 Milestone 5: iOS Native Code für Screen Time Integration offen ✗

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
iOS Native Code für Screen Time Integration implementieren.

### Vorbereitungen
- `README.md` und Roadmap prüfen.

### Implementierungsschritte
- `ios/Runner/DeviceMonitoringPlugin.swift` erstellen.
- FamilyControls-Framework-Berechtigungen anfordern.
- Screen-Time-API nutzen und Daten als JSON an Flutter liefern.

### Validierung
- Entsprechende Tests (z. B. `npm test`, `pytest codex/tests`, `flutter test`) ausführen.

### Selbstgenerierung
- Nach jeder Wartungsaufgabe neuen Prompt erstellen.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte beim Ausführen automatisch erzeugt. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
