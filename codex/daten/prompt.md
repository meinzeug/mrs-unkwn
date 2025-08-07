# Nächster Schritt: Phase 1 – `Node.js Express Server initialisieren`

## Status
- Phase 0 abgeschlossen ✓
- Flutter SDK installiert (3.32.8)
- `pubspec.yaml` mit Dependencies konfiguriert ✓
- Material App Grundstruktur implementiert ✓
- Core-Ordnerstruktur mit Basis-Klassen erstellt ✓
- Dependency Injection mit GetIt eingerichtet ✓
- Flutter BLoC Basisklassen implementiert ✓
- HTTP Client mit Dio konfiguriert ✓
- Secure Storage Service implementiert ✓
- Basis-Routing mit GoRouter eingerichtet ✓
- Environment Configuration System implementiert ✓
- Error Handling und Logging System implementiert ✓
- JSON Serialization Setup implementiert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Node.js Express Server initialisieren`

### Vorbereitungen
- Navigiere zum Projekt-Root `backend/`.

### Implementierungsschritte
- `npm init -y` ausführen.
- Dependencies installieren: `express cors helmet morgan dotenv bcrypt jsonwebtoken express-validator`.
- Dev-Dependencies installieren: `nodemon typescript @types/node @types/express ts-node`.
- `tsconfig.json` mit Node.js Standardkonfiguration erstellen.
- Ordner `src/` mit Datei `index.ts` als Entry-Point anlegen.

### Validierung
- `ls backend`
- `ls backend/src`
- `npx tsc --noEmit`

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md`.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
