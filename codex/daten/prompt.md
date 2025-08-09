# Nächster Schritt: Family Role-Based Permissions

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
- Phase 1 Milestone 4: Family Role-Based Permissions offen ✗

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Family Role-Based Permissions definieren und integrieren.

### Vorbereitungen
- `README.md` und Roadmap prüfen.

### Implementierungsschritte
- `lib/core/permissions/family_permissions.dart` mit Permission-Enums erstellen.
- `hasPermission(FamilyRole, Permission)` Funktionen implementieren.
- Permission-Checks in UI integrieren.

### Validierung
- Entsprechende Tests (z. B. `npm test`, `pytest codex/tests`, `flutter test`) ausführen.

### Selbstgenerierung
- Nach jeder Wartungsaufgabe neuen Prompt erstellen.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte beim Ausführen automatisch erzeugt. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
