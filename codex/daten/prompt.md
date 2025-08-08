# Nächster Schritt: Phase 1 – `Password Hashing Service`

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
- Node.js Express Server initialisiert ✓
- Express Server Basis-Konfiguration implementiert ✓
- Environment Variables Setup implementiert ✓
- Database Connection Setup mit PostgreSQL ✓
- User-Tabelle Migration erstellt ✓
- Family-Tabellen Migration erstellt ✓
- JWT Authentication Service implementiert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Password Hashing Service`

### Vorbereitungen
- Navigiere zum Projekt-Root `backend/`.

### Implementierungsschritte
- `src/services/password.service.ts` erstellen.
- `PasswordService` mit statischen Methoden `hashPassword(password: string): Promise<string>` und `comparePassword(password: string, hash: string): Promise<boolean>` implementieren.
- `bcrypt` verwenden mit 12 Runden.
- Passwort-Strength-Validation: mindestens 8 Zeichen, je 1 Großbuchstabe, Kleinbuchstabe, Zahl und Sonderzeichen.

### Validierung
- `npx tsc --noEmit`.
- `npm test` (falls Tests vorhanden).

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
