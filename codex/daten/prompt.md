# Nächster Schritt: Family Model und Data Classes

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 Milestone 4: Family Creation UI Screen abgeschlossen ✓
- Phase 1 Milestone 4: Family Model und Data Classes offen ✗

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Family- und FamilyMember-Modelklassen erstellen.

### Vorbereitungen
- `README.md` und Roadmap prüfen.

### Implementierungsschritte
- Datei `lib/features/family/data/models/family.dart` mit `Family` und `FamilyMember` Klassen erstellen.
- `@JsonSerializable()` verwenden und `fromJson`/`toJson` implementieren.
- Enums für `FamilyRole` und `SubscriptionTier` definieren.

### Validierung
- Entsprechende Tests (z. B. `npm test`, `pytest codex/tests`, `flutter test`) ausführen.

### Selbstgenerierung
- Nach jeder Wartungsaufgabe neuen Prompt erstellen.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte beim Ausführen automatisch erzeugt. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
