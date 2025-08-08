# Nächster Schritt: Phase 1 – `Login API Integration`

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
- Password Hashing Service implementiert ✓
- User Repository Pattern implementiert ✓
- Request Validation Middleware implementiert ✓
- Authentication Middleware implementiert ✓
- Basic API Routes Setup implementiert ✓
- Error Handling Middleware implementiert ✓
- API Response Standardization implementiert ✓
- Login Screen UI Layout erstellt ✓
- Login Form Validation implementiert ✓
- Login BLoC State Management implementiert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Login API Integration`

### Vorbereitungen
- Navigiere zum Projekt-Root `flutter_app/`.

### Implementierungsschritte
- Datei `lib/features/auth/data/repositories/auth_repository_impl.dart` erstellen.
- `login(String email, String password)` Methode implementieren.
- POST-Request zu `/api/auth/login` mit Email/Password im Body senden.
- Erfolgsantwort parsen, Tokens in `SecureStorageService` speichern.
- Fehlerantworten abfangen und passende Exception mit Fehlermeldung werfen.

### Validierung
- `dart format lib/features/auth/data/repositories/auth_repository_impl.dart`.
- `flutter analyze`.

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*

