# Nächster Schritt: Family BLoC State Management

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 Milestone 4: Family Creation UI Screen abgeschlossen ✓
- Phase 1 Milestone 4: Family Model und Data Classes abgeschlossen ✓
- Phase 1 Milestone 4: Family Repository Implementation abgeschlossen ✓
- Phase 1 Milestone 4: Family BLoC State Management offen ✗

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Family BLoC zur Verwaltung von Familienzuständen implementieren.

### Vorbereitungen
- `README.md` und Roadmap prüfen.

### Implementierungsschritte
- Datei `family_bloc.dart` erstellen.
- Events implementieren: `CreateFamilyRequested`, `LoadFamilyRequested`, `UpdateFamilyRequested`, `DeleteFamilyRequested`.
- States implementieren: `FamilyInitial`, `FamilyLoading`, `FamilyLoaded(Family)`, `FamilyCreated`, `FamilyError(String)`.
- Event-Handler schreiben, die Repository-Methoden nutzen und passende States emittieren.
- Optimistic Updates für bessere UX berücksichtigen.

### Validierung
- Entsprechende Tests (z. B. `npm test`, `pytest codex/tests`, `flutter test`) ausführen.

### Selbstgenerierung
- Nach jeder Wartungsaufgabe neuen Prompt erstellen.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte beim Ausführen automatisch erzeugt. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
