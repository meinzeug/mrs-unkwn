# Nächster Schritt: Forgot Password Flow

## Status
- Phase 0 abgeschlossen ✓
- Phase 1 Milestone 3: Auto-Login auf App-Start abgeschlossen ✓
- Phase 1 Milestone 3: Logout Functionality abgeschlossen ✓
- Phase 1 Milestone 3: Forgot Password Flow offen ✗

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe
Forgot-Password-Flow implementieren.

### Vorbereitungen
- `README.md` und Roadmap prüfen.

### Implementierungsschritte
- `forgot_password_page.dart` mit Email-Input erstellen.
- `ForgotPasswordRequested` Event und States im AuthBloc ergänzen.
- Backend-API `/api/auth/forgot-password` ansprechen.
- Erfolgs- und Fehlermeldungen darstellen.

### Validierung
- Entsprechende Tests (z. B. `npm test`, `pytest codex/tests`, `flutter test`) ausführen.

### Selbstgenerierung
- Nach jeder Wartungsaufgabe neuen Prompt erstellen.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien werden durch Skripte beim Ausführen automatisch erzeugt. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
