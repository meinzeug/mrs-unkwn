# Nächster Schritt: Family Repository Implementation

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 Milestone 4: Family Creation UI Screen abgeschlossen ✓
- Phase 1 Milestone 4: Family Model und Data Classes abgeschlossen ✓
- Phase 1 Milestone 4: Family Repository Implementation offen ✗

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Family Repository für API-Aufrufe implementieren.

### Vorbereitungen
- `README.md` und Roadmap prüfen.

### Implementierungsschritte
- Datei `lib/features/family/data/repositories/family_repository_impl.dart` erstellen.
- `createFamily(CreateFamilyRequest)` mit POST-API-Call implementieren.
- `getFamily(String familyId)` mit GET-API-Call implementieren.
- `updateFamily(String familyId, UpdateFamilyRequest)` mit PUT-API-Call implementieren.
- `deleteFamily(String familyId)` mit DELETE-API-Call implementieren.
- HTTP- und Netzwerkfehler angemessen behandeln.

### Validierung
- Entsprechende Tests (z. B. `npm test`, `pytest codex/tests`, `flutter test`) ausführen.

### Selbstgenerierung
- Nach jeder Wartungsaufgabe neuen Prompt erstellen.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte beim Ausführen automatisch erzeugt. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
