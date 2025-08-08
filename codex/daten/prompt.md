# Nächster Schritt: Phase 3 – Schul-Integrationen implementieren

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 abgeschlossen ✓
- Phase 2 abgeschlossen ✓
- Phase 3 Milestone 1 abgeschlossen ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Implementiere grundlegende Schnittstellen zu Schulverwaltungssystemen.

### Vorbereitungen
- Bestehende Backend-Architektur analysieren.

### Implementierungsschritte
- Schnittstellen zu gängigen Schulverwaltungssystemen (z.B. LDAP, SSO) hinzufügen.
- Skript `scripts/setup_school_integrations.sh` erstellen, das benötigte Konnektoren automatisch einrichtet.

### Validierung
- `python -m py_compile` auf geänderten Python-Dateien ausführen.
- `flutter test` und `npm test` ausführen (falls vorhanden).

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte generiert. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
