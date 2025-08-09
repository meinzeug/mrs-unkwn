# Nächster Schritt: Family Settings Management

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 Milestone 4: Family Creation UI Screen abgeschlossen ✓
- Phase 1 Milestone 4: Family Model und Data Classes abgeschlossen ✓
- Phase 1 Milestone 4: Family Repository Implementation abgeschlossen ✓
- Phase 1 Milestone 4: Family BLoC State Management abgeschlossen ✓
- Phase 1 Milestone 4: Family Member Invitation System abgeschlossen ✓
- Phase 1 Milestone 4: QR Code Invitation Feature abgeschlossen ✓
- Phase 1 Milestone 4: Family Settings Management offen ✗

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Familien-Einstellungen-Verwaltung implementieren.

### Vorbereitungen
- `README.md` und Roadmap prüfen.

### Implementierungsschritte
- `family_settings_page.dart` mit Kategorien (Study-Rules, Screen-Time-Limits, Bedtime-Schedule, App-Restrictions) erstellen.
- Toggle-Switches, Sliders und Time-Picker für verschiedene Settings einbauen.
- `FamilySettings` Model-Klasse mit Serialization implementieren.
- Settings-Update-API-Calls mit Optimistic-Updates umsetzen.
- Settings-Vererbung zwischen Family-Level und Member-Level behandeln.

### Validierung
- Entsprechende Tests (z. B. `npm test`, `pytest codex/tests`, `flutter test`) ausführen.

### Selbstgenerierung
- Nach jeder Wartungsaufgabe neuen Prompt erstellen.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte beim Ausführen automatisch erzeugt. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
