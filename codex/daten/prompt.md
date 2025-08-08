# Nächster Schritt: Phase 1 – `Voice Input Integration`

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
- Register Screen UI Layout implementiert ✓
- Registration BLoC Events/States implementiert ✓
- Registration API Integration implementiert ✓
- Password Strength Indicator implementiert ✓
- OpenAI API Integration Setup implementiert ✓
- Chat Message Model und Serialization implementiert ✓
- AI Prompt Engineering für Sokratische Methode implementiert ✓
- Chat UI Interface Implementation implementiert ✓
- AI Response Generation Service implementiert ✓
- Subject Classification System implementiert ✓
- Learning Session Management implementiert ✓
- AI Tutoring BLoC State Management implementiert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Voice Input Integration`

### Vorbereitungen
- Navigiere zum Projekt-Root `flutter_app/mrs_unkwn_app`.

### Implementierungsschritte
- `speech_to_text` Package in `pubspec.yaml` hinzufügen.
- Voice-Recording-UI mit Wellenform und Aufnahme-Timer implementieren.
- Speech-to-Text-Konvertierung mit Fehlerbehandlung für unklare Sprache umsetzen.
- Sprachenerkennung für Deutsch und Englisch integrieren.
- Voice-Kommandos (Senden, Chat leeren) einbauen.
- Mikrofon-Berechtigungen und Datenschutz beachten.

### Validierung
- `dart format` auf geänderten Dateien ausführen.
- `flutter analyze`.

### Selbstgenerierung
- Nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md` schreiben.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
