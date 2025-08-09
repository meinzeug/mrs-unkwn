# Nächster Schritt: Family Member Management UI

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 Milestone 4: Family Creation UI Screen abgeschlossen ✓
- Phase 1 Milestone 4: Family Model und Data Classes abgeschlossen ✓
- Phase 1 Milestone 4: Family Repository Implementation abgeschlossen ✓
- Phase 1 Milestone 4: Family BLoC State Management abgeschlossen ✓
- Phase 1 Milestone 4: Family Member Invitation System abgeschlossen ✓
- Phase 1 Milestone 4: QR Code Invitation Feature abgeschlossen ✓
- Phase 1 Milestone 4: Family Settings Management abgeschlossen ✓
- Phase 1 Milestone 4: Family Member Management UI offen ✗

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Familien-Mitgliedsverwaltung im UI implementieren.

### Vorbereitungen
- `README.md` und Roadmap prüfen.

### Implementierungsschritte
- `family_members_page.dart` mit Member-Liste und Aktionen (Rollen ändern, Rechte bearbeiten, Mitglied entfernen) erstellen.
- Role-based UI für Eltern und Kinder umsetzen.
- Bestätigungsdialoge für destruktive Aktionen integrieren.
- Echtzeit-Status-Updates der Mitglieder anzeigen.

### Validierung
- Entsprechende Tests (z. B. `npm test`, `pytest codex/tests`, `flutter test`) ausführen.

### Selbstgenerierung
- Nach jeder Wartungsaufgabe neuen Prompt erstellen.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte beim Ausführen automatisch erzeugt. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
