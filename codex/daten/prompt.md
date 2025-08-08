# Nächster Schritt: Phase 1 – `Register Screen UI Layout`

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
- Login API Integration implementiert ✓
- Login Loading States UI implementiert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Register Screen UI Layout`

### Vorbereitungen
- Navigiere zum Projekt-Root `flutter_app/`.

### Implementierungsschritte
- Neue Datei `lib/features/auth/presentation/pages/register_page.dart` erstellen.
- Layout analog zur `LoginPage` mit zusätzlichen Feldern `firstName`, `lastName`, `confirmPassword`.
- `DropdownButtonFormField` für User-Role (Parent/Child) einfügen.
- Checkbox für Terms-Acceptance mit Link zur Terms-Page hinzufügen.
- Validierung: Password-Bestätigung und Terms-Akzeptanz müssen erfüllt sein.

### Validierung
- `dart format lib/features/auth/presentation/pages/register_page.dart`.
- `flutter analyze`.

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*

