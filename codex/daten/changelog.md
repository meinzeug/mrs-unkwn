# Mrs-Unkwn Changelog

## [Unreleased]

### Phase 0: Initialisierung - 2025-08-07
- README.md vollständig analysiert
- Basisverzeichnisstruktur für Mrs-Unkwn erstellt
- __init__.py in allen Python-Paketen angelegt
- requirements.txt erstellt mit Dependencies: openai==1.17.0, requests==2.31.0, python-dotenv==1.0.0
- .gitignore erstellt
- AGENTS.md mit detaillierten Entwicklungsrichtlinien angelegt
- Hoch detaillierte Roadmap mit Phasen und Unterpunkten erstellt
- Projektspezifische Dokumentation in docs.md gesammelt

### Phase 1: Flutter SDK Installation und Entwicklungsumgebung - 2025-08-07
- Flutter SDK 3.32.8 installiert und Grundkonfiguration durchgeführt
- `flutter --version` und `flutter doctor` ausgeführt (fehlende Komponenten: Android SDK, Chrome, clang, GTK)

### Phase 1: Flutter-Projekt mit Multi-Platform-Support - 2025-08-07
- Skript `scripts/create_flutter_project.sh` hinzugefügt, das das Projekt automatisch erzeugt und anpasst

### Phase 1: pubspec.yaml mit Dependencies konfiguriert - 2025-08-07
- `scripts/create_flutter_project.sh` erweitert, um benötigte Dependencies und Dev-Dependencies in `pubspec.yaml` automatisch einzutragen

### Phase 1: Basis App-Struktur mit Material App konfigurieren - 2025-08-07
- `lib/app.dart` angelegt und `lib/main.dart` angepasst, um `MaterialApp` mit `MrsUnkwnApp` zu verwenden

### Phase 1: Core-Ordnerstruktur mit Basis-Klassen erstellen - 2025-08-07
- `AppConstants`, `Failure`-Klassen, `NetworkInfo` Interface und `AppTheme` implementiert

### Phase 1: Dependency Injection mit GetIt einrichten - 2025-08-07
- `service_locator.dart` erstellt und `configureDependencies()` eingebunden
- `main.dart` angepasst, um `configureDependencies()` vor `runApp` aufzurufen

### Phase 1: Flutter BLoC Setup mit Basis-Strukturen - 2025-08-07
- Basis-BLoC Klassen (`BaseEvent`, `BaseState`, `BaseBloc`) und `AppBlocObserver` erstellt

### Phase 1: HTTP Client mit Dio konfigurieren - 2025-08-07
- `DioClient` als Singleton mit Basisoptionen, JWT- und Log-Interceptor sowie CRUD-Methoden implementiert

### Phase 1: Secure Storage Service implementieren - 2025-08-07
- `SecureStorageService` hinzugefügt mit Methoden für Speichern, Lesen, Löschen und vollständiges Entfernen von Daten
- Android `encryptedSharedPreferences` aktiviert für erhöhte Sicherheit

### Phase 1: Basis-Routing mit GoRouter einrichten - 2025-08-07
- `AppRouter` mit statischer `GoRouter` Instanz und Routen erstellt
- Route-Konstanten definiert und Navigations-Guards sowie Redirect-Logik implementiert

### Phase 1: Environment Configuration System - 2025-08-07
- `Environment` Klasse und spezifische Konfigurationsdateien für `dev`, `staging` und `prod` hinzugefügt

### Phase 1: Error Handling und Logging System - 2025-08-07
- `Logger` Klasse mit verschiedenen Log-Leveln implementiert
- Globales `ErrorHandler.handleError` für benutzerfreundliche Fehlermeldungen erstellt

### Phase 1: JSON Serialization Setup - 2025-08-07
- `build.yaml` für `json_serializable` konfiguriert
- `BaseModel` mit `fromJson` und `toJson` implementiert
- `flutter packages pub run build_runner build` ausgeführt
- `.gitignore` angepasst, um `build.yaml` zu versionieren
### Phase 1: Node.js Express Server initialisieren - 2025-08-07
- `backend` Verzeichnis erstellt und Node-Projekt mit `npm init -y` initialisiert
- Dependencies installiert: express, cors, helmet, morgan, dotenv, bcrypt, jsonwebtoken, express-validator
- Dev-Dependencies installiert: nodemon, typescript, @types/node, @types/express, ts-node
- `tsconfig.json` mit Node.js Standardkonfiguration hinzugefügt
- `src/index.ts` als Entry-Point angelegt

### Phase 1: Express Server Basis-Konfiguration - 2025-08-07
- Express-App mit `cors`, `helmet`, `morgan` und JSON-Parsing konfiguriert
- Health-Check-Endpoint `/health` implementiert
- Serverstart auf konfigurierbarem Port umgesetzt

### Phase 1: Environment Variables Setup - 2025-08-07
- `.env.example` mit notwendigen Variablen erstellt
- `src/config/config.ts` hinzugefügt und Variablenvalidierung implementiert
- `.gitignore` erweitert, um `.env`-Dateien auszuschließen
- `src/index.ts` lädt Konfiguration und protokolliert aktuelles Environment

### Phase 1: Database Connection Setup mit PostgreSQL - 2025-08-07
- Dependencies `pg` und `knex` sowie Dev-Dependency `@types/pg` hinzugefügt
- `src/database/connection.ts` mit Knex-Konfiguration und `testConnection()` erstellt
- Verzeichnis `src/database/migrations/` angelegt

### Phase 1: User-Tabelle Migration erstellen - 2025-08-07
- `knexfile.ts` für Migrationskonfiguration hinzugefügt
- Migration zur Erstellung der `users` Tabelle mit UUID, Namen, E-Mail, Passwort-Hash und Rollenfeldern erstellt
- `knex migrate:latest` und `knex migrate:rollback` erfolgreich ausgeführt

### Phase 1: Family-Tabellen Migration erstellen - 2025-08-07
- Migration für `families` und `family_members` Tabellen implementiert
- Spalten, Fremdschlüssel-Constraints und Indexe hinzugefügt
- `knex migrate:latest` und `knex migrate:rollback` ausgeführt (fehlgeschlagen: Unable to acquire a connection)

### Phase 1: JWT Authentication Service implementieren - 2025-08-08
- `AuthService` mit Token-Erstellung, Verifikation, Refresh und Blacklisting erstellt
- `types.d.ts` um Deklaration für `jsonwebtoken` erweitert
- Roadmap aktualisiert

### Phase 1: Password Hashing Service implementieren - 2025-08-08
- `PasswordService` mit bcrypt Hashing, Passwort-Validierung und Vergleichsfunktion hinzugefügt
- Roadmap aktualisiert

### Phase 1: User Repository Pattern implementieren - 2025-08-08
- `UserRepository` in `backend/src/repositories/user.repository.ts` erstellt
- CRUD-Methoden (`create`, `findByEmail`, `findById`, `update`, `delete`) mit Knex umgesetzt
- Roadmap aktualisiert

### Phase 1: Request Validation Middleware - 2025-08-08
- `validateRequest` Middleware mit feldspezifischem Fehlerformat erstellt
- Validierungsschemas für Registrierung und Login hinzugefügt
- Roadmap aktualisiert

### Phase 1: Authentication Middleware implementiert - 2025-08-08
- `auth.middleware.ts` mit Token-Verifizierung, Rollen- und Optional-Auth-Funktionen erstellt
- Express `Request` Typ um `user` Feld erweitert
- Roadmap aktualisiert

### Phase 1: Basic API Routes Setup - 2025-08-08
- `auth.routes.ts` mit Endpunkten für Registrierung, Login, Token-Refresh und Logout erstellt
- `user.routes.ts` mit Profilabruf, Profilaktualisierung und Account-Löschung implementiert
- Haupt-Router `routes/index.ts` hinzugefügt und unter `/api` in `src/index.ts` eingebunden
- Roadmap aktualisiert

### Phase 1: Error Handling Middleware - 2025-08-08
- Globale Fehlerbehandlungs-Middleware `error.middleware.ts` erstellt
- Einheitliches Fehlerformat `{ error: { message, code, details } }` implementiert
- Middleware in `src/index.ts` registriert und Roadmap aktualisiert

### Phase 1: API Response Standardization - 2025-08-08
- Einheitliche Response-Helfer in `response.util.ts` implementiert
- Response-Wrapper-Middleware registriert und bestehende Routen angepasst
- Roadmap aktualisiert

### Phase 1: Login Screen UI Layout - 2025-08-08
- Login-Layout in `lib/features/auth/presentation/pages/login_page.dart` erstellt
- Roadmap aktualisiert

### Phase 1: Login Form Validation implementieren - 2025-08-08
- Formularvalidierung mit `GlobalKey<FormState>` und RegExp für Email umgesetzt
- Passwortfeld mit Mindestlänge und Toggle für Sichtbarkeit ergänzt
- `_validateAndSubmit()` Methode hinzugefügt
- `dart format` und `flutter analyze` (Dependencies fehlen) ausgeführt

### Phase 1: Login BLoC State Management - 2025-08-08
- `auth_bloc.dart` mit Events, States und AuthBloc implementiert
- Roadmap aktualisiert

### Phase 1: Login API Integration - 2025-08-08
- `auth_repository_impl.dart` mit Login- und Logout-Logik erstellt
- Tokens werden nach erfolgreichem Login sicher gespeichert
- `dart format` und `flutter analyze` (Werkzeuge nicht verfügbar) ausgeführt

### Phase 1: Login Loading States UI - 2025-08-08
- UI in `login_page.dart` mit `BlocConsumer` um BLoC-Stati erweitert
- Navigation bei Erfolg und SnackBar bei Fehler implementiert
- Login-Button zeigt Ladeindikator und ist während Loading deaktiviert

### Phase 1: Register Screen UI Layout - 2025-08-08
- `register_page.dart` mit Feldern für Vorname, Nachname, Email, Passwortbestätigung und Rollenwahl erstellt
- Checkbox für Nutzungsbedingungen mit Validierung hinzugefügt
- Roadmap aktualisiert

### Phase 1: Registration BLoC Events/States - 2025-08-08
- `AuthEvent` um `RegisterRequested` erweitert
- `AuthState` um `RegisterSuccess` und `RegisterFailure` ergänzt
- `AuthBloc` um Handler `_onRegisterRequested` erweitert
- `AuthRepository` um `register` Methode ergänzt
- Roadmap aktualisiert

### Phase 1: Registration API Integration - 2025-08-08
- `AuthRepositoryImpl` mit `register` Methode für `/api/auth/register` erweitert
- Tokens aus API-Response gespeichert und Fehlerfälle behandelt
- `dart format` und `flutter analyze` ausgeführt (Werkzeuge nicht verfügbar)
- Roadmap aktualisiert

### Phase 1: Password Strength Indicator - 2025-08-08
- `PasswordStrengthIndicator` Widget erstellt mit farblicher Anzeige und Verbesserungsvorschlägen
- Roadmap und Prompt aktualisiert

### Phase 1: OpenAI API Integration Setup - 2025-08-08
- `OpenAIService` mit `sendChatRequest` und Exponential Backoff erstellt
- Service im `service_locator` registriert
- Roadmap und Prompt aktualisiert

### Phase 1: Chat Message Model und Serialization - 2025-08-08
- `ChatMessage` Modell mit JSON-Serialisierung und Unterstützung für Text, Bild und Datei-Anhänge erstellt
- Roadmap aktualisiert

### Phase 1: AI Prompt Engineering für Sokratische Methode - 2025-08-08
- `socratic_prompts.dart` mit fachspezifischen, altersgerechten System-Prompts erstellt
- Kontext- und Tokenlimit-Management für Gesprächsverläufe implementiert
- Roadmap aktualisiert

### Phase 1: Chat UI Interface Implementation - 2025-08-08
- `chat_page.dart` mit Chat-Bubbles, Eingabefeld, Auto-Scroll und Typing-Indikator erstellt
- Statusanzeigen für Nachrichten (Sending, Sent, Error) umgesetzt
- `dart format` und `flutter analyze` ausgeführt (Werkzeuge nicht verfügbar)

### Phase 1: AI Response Generation Service - 2025-08-08
- `AIResponseService` mit Streaming-Ausgabe, Content-Filterung und Response-Caching erstellt
- Service im `service_locator` registriert
- Roadmap aktualisiert

### Phase 1: Subject Classification System - 2025-08-08
- `SubjectClassificationService` mit Schlüsselwort-basierter Klassifikation und Fachwechsel-Erkennung erstellt
- Historien-Tracking vorbereitet und Platzhalter für ML-basierte Klassifikation hinzugefügt
- Service im `service_locator` registriert, Roadmap und Prompt aktualisiert

### Phase 1: Learning Session Management - 2025-08-08
- `LearningSession` Modell mit Start/End-Logik und Dauerberechnung erstellt
- Metriken für Fragen, Themen und AI-Interaktionen hinzugefügt
- Platzhalter für lokale Speicherung und Backend-Sync implementiert
- Roadmap und Prompt aktualisiert

### Phase 1: AI Tutoring BLoC State Management - 2025-08-08
- `TutoringBloc` mit Events für Nachrichten, Sitzungsstart und -ende implementiert
- AI-Integration über `AIResponseService` und Fachklassifikation via `SubjectClassificationService`
- Optimistische UI-Updates und Sitzungsmetriken integriert
- Roadmap und Prompt aktualisiert

### Phase 1: Voice Input Integration - 2025-08-08
- `scripts/create_flutter_project.sh` fügt `speech_to_text` Dependency hinzu
- `VoiceInputService` mit Sprach-zu-Text und Sprach­erkennung für Deutsch/Englisch erstellt
- `chat_page.dart` um Aufnahme-Timer, Wellenform und Sprachbefehle zum Senden oder Leeren ergänzt
- Roadmap und Prompt aktualisiert

### Phase 1: Basic Content Moderation - 2025-08-08
- `ContentModerationService` mit Keyword-Listen für Profanity, Gewalt und Adult-Content erstellt
- `TutoringBloc` prüft Nachrichten und AI-Antworten, speichert Moderations-Logs und benachrichtigt Eltern
- Roadmap und Prompt aktualisiert

### Phase 1: Learning Progress Analytics - 2025-08-08
- `LearningAnalyticsService` zur Aggregation von Sitzungen und Metrikberechnung implementiert
- `ProgressPage` und `ProgressChart` zur Visualisierung des Lernfortschritts erstellt
- `TutoringBloc` überträgt beendete Sitzungen an den Analytics-Service
- Roadmap und Prompt aktualisiert

### Phase 1: Chat History und Persistence - 2025-08-08
- `ChatHistoryService` mit Hive-Speicherung, Verschlüsselung, Suche, Export, Cleanup sowie Backup/Restore erstellt
- `TutoringBloc` integriert Chat-History, Such-, Export- und Backup-Events
- `service_locator.dart` registriert ChatHistoryService und SecureStorageService für Schlüsselverwaltung
- `scripts/create_flutter_project.sh` um `hive_flutter` erweitert

### Phase 1: Unit Testing Setup für Flutter - 2025-08-08
- Testverzeichnisstruktur `test/unit`, `test/widget`, `test/integration` und `test/helpers` angelegt
- Basis-Testhelfer mit Mock-Services und Datenfabriken in `test/helpers/test_helpers.dart` erstellt
- `scripts/create_flutter_project.sh` um automatische Eintragung von `bloc_test` erweitert
- Skript `run_flutter_tests.sh` für Coverage-Ausführung hinzugefügt
- `dart format` und `flutter analyze` (Werkzeuge evtl. unvollständig) ausgeführt

### Phase 1: Widget Testing für UI Components - 2025-08-08
- Widget-Tests für Login- und Chat-UI erstellt
- Golden-Tests hinzugefügt und Skript `generate_goldens.sh` zum Erstellen der Assets erstellt
- `.gitignore` erweitert, um generierte Golden-Dateien auszuschließen
- Roadmap und Prompt aktualisiert

### Phase 1: BLoC Testing Implementation - 2025-08-08
- BLoC-Tests für Auth- und Tutoring-BLoCs mit `bloc_test` hinzugefügt
- Repository-Abhängigkeiten mit `mocktail` gemockt und Fehlerfälle abgedeckt
- `dart format`, `flutter analyze` und `flutter test` ausgeführt (Werkzeuge nicht verfügbar)
- Roadmap und Prompt aktualisiert
### Phase 1: API Integration Testing - 2025-08-08
- `scripts/create_flutter_project.sh` um `mockito` ergänzt
- `AuthRepositoryImpl` um Token-Refresh erweitert
- `FamilyRepository` und API-Integrationstests mit `mockito` hinzugefügt
- Roadmap und Prompt aktualisiert
### Phase 1: E2E Testing mit Integration Tests - 2025-08-08
- `integration_test` Paket konfiguriert und E2E-Szenarien für Registrierung-bis-Chat sowie Family-Setup-bis-Monitoring hinzugefügt
- `scripts/create_flutter_project.sh` um `integration_test` erweitert
- `.gitignore` angepasst, um `integration_test`-Verzeichnis einzubinden

### Phase 1: Performance Testing und Profiling - 2025-08-08
- Integrationstest `performance_test.dart` misst Startzeit, Navigation und Speicherverbrauch
- Skript `run_performance_tests.sh` erzeugt Performance-Reports automatisch
- Roadmap und Prompt aktualisiert

### Phase 1: Security Testing Implementation - 2025-08-08
- Sicherheits-Testskript `run_security_tests.sh` hinzugefügt
- Backend-Tests für Authentifizierung, Token-Prüfung und Input-Sanitization implementiert
- Secure-Storage-Test für lokale Datenverschlüsselung erstellt
- Roadmap und Prompt aktualisiert
### Phase 1: Automated Testing in CI/CD - 2025-08-08
- GitHub Actions Workflow `flutter_ci.yml` mit Testmatrix für mehrere Flutter-Versionen und Plattformen hinzugefügt
- Retry-Logik für flackernde Tests sowie Coverage-Upload zu Codecov implementiert
- Artefakt-Upload und Fehlbenachrichtigung bei Testfehlschlägen konfiguriert
### Phase 1: Manual Testing Procedures - 2025-08-08
- Verzeichnis `codex/tests/manual` mit Checklisten, UAT-Szenarien, Beta-Programm, Bug-Reporting, Usability-Plan sowie Qualitäts-Gates erstellt
- Skript `scripts/generate_manual_testing_assets.sh` generiert CSV-Vorlagen für Checkliste und Bug-Reports
- Roadmap und Prompt aktualisiert

### Phase 1: Monitoring und Crash Reporting - 2025-08-08
- `MonitoringService` mit Firebase Crashlytics und Performance integriert
- `MonitoringDashboardPage` mit Feedback-Funktion erstellt
- Skript `setup_firebase_config.sh` generiert benötigte Firebase-Konfigurationsdateien
- Roadmap und Prompt aktualisiert

### Phase 2: Advanced Homework Detection Service - 2025-08-09
- `HomeworkDetectionService` und `/homework/detect` Route hinzugefügt
- Skript `setup_homework_detection.sh` zum automatischen Download des Modells erstellt
- Tests erweitert und package.json angepasst
- Roadmap und Prompt aktualisiert

### Phase 2: ML-Modell-Integration für präzisere Erkennung - 2025-08-09
- HomeworkDetectionService lädt Modellgewichte und ersetzt heuristische Erkennung.
- Tests angepasst, um Modellinferenz zu validieren.
- Roadmap und Prompt aktualisiert.

### Phase 2: Modell-Evaluierung & Feedback - 2025-08-09
- Evaluationsfunktion zur Genauigkeitsberechnung und Feedback-Logging implementiert.
- Feedback-Endpoint `/homework/feedback` ergänzt und Tests erweitert.
- Roadmap und Prompt aktualisiert.

### Phase 2: Modell-Retraining mit Feedback-Daten - 2025-08-09
- `retrainModel` Routine implementiert, die Feedback-Logs einliest und Modellgewichte anpasst.
- Skript `scripts/retrain_homework_model.ts` erstellt, um das Retraining auszuführen und Modell-Datei zu generieren.
- Tests in `backend/tests/homework.test.ts` erweitert und Feedback-Logbereinigung geprüft.
- Roadmap und Prompt aktualisiert.

### Phase 2: Automatisierte Modell-Bereitstellung - 2025-08-09
- GitHub Action konfiguriert wöchentlichen Retrain-Lauf und stellt Modell als Artefakt bereit.
- NPM-Skript `retrain-model` und Versionstracking für das Modell eingeführt.
- `setup_homework_detection.sh` legt `model_version.json` automatisch an.

### Phase 2: API für Modellinformationen - 2025-08-09
- Endpoint `/homework/model` liefert aktuelle Modellversion und letztes Retrain-Datum.
- Service speichert `lastRetrained` in `model_version.json`.
- Tests, Skripte und Dokumentation aktualisiert.

### Phase 3: Roadmap Planung - 2025-08-09
- Phase-3-Ziele mit Meilensteinen (Multi-Language, Schul-Integrationen, Analytics, B2B) zur `roadmap.md` hinzugefügt
- `prompt.md` auf nächsten Schritt aktualisiert

### Phase 3: Multi-Language Support Infrastruktur - 2025-08-09
- Flutter-App mit Lokalisierungs-Framework und ARB-Dateien für Deutsch/Englisch erweitert
- Backend um Spracheinstellungen inkl. Migration und API-Updates ergänzt
- Skript `scripts/generate_translations.sh` zur automatischen Generierung von Übersetzungsdateien erstellt
- Roadmap und Prompt aktualisiert

### Phase 3: Schul-Integrationen - 2025-08-09
- LDAP- und SSO-Schnittstellen im Backend hinzugefügt
- Skript `scripts/setup_school_integrations.sh` erzeugt benötigte Konfigurationsdatei und installiert Abhängigkeiten
- Roadmap und Prompt aktualisiert

### Phase 3: Advanced Analytics Dashboard - 2025-08-09
- `AnalyticsDashboardPage` visualisiert aggregierte Lernmetriken und ermöglicht CSV-Export
- Skript `scripts/generate_analytics_data.sh` generiert Demo-Datensätze
- Roadmap und Prompt aktualisiert

### Phase 3: B2B Features - 2025-08-09
- Organisations-Accounts und Rollenverwaltung implementiert
- Skript `scripts/create_sample_organizations.sh` erstellt Beispiel-Organisationen
- Backend-Migration, Repositories, Services und Routen für Organisationen hinzugefügt
- Flutter-Service und Modell zur Organisationsverwaltung erstellt

### Phase 4: Drittanbieter API vorbereitet - 2025-08-10
- Tabelle `api_keys` mit Migration hinzugefügt
- `ApiKeyRepository`, `ApiKeyService`, Middleware und externe Routen implementiert
- Dokumentation `backend/third_party_api.md` erstellt
- Roadmap und Prompt aktualisiert

### Phase 4: Developer-Portal & Rate-Limiting - 2025-08-10
- Developer-Portal mit HTML-Oberfläche und API-Routen zur Verwaltung von Schlüsseln erstellt
- Rate-Limiting für externe Endpunkte mit `express-rate-limit` hinzugefügt
- Test für Rate-Limiting und Dokumentation erweitert

### Phase 4: API-Dokumentation & Beispielskripte - 2025-08-10
- Dokumentation `backend/third_party_api.md` um Authentifizierungsbeispiele, Fehlercodes und Nutzungshinweise erweitert
- Skript `scripts/example_api_client.ts` demonstriert API-Key-Erstellung und API-Abfragen
- Roadmap und Prompt aktualisiert

### Phase 4: Automatisierte API-Tests - 2025-08-10
- Testdatei `backend/tests/external_api.test.ts` prüft externe Endpunkte mit gültigem und ungültigem API-Key
- NPM-Skript `test:external` zum Ausführen der externen API-Tests hinzugefügt
- Roadmap und Prompt aktualisiert

### Phase 4: Client-SDK für Drittanbieter-API - 2025-08-10
- SDK-Grundgerüst unter `backend/sdk/` mit `healthCheck` Funktion erstellt
- Skript `scripts/build_sdk.sh` generiert JavaScript-Dateien automatisch
- Roadmap und Prompt aktualisiert

### Phase 4: TypeScript-Typdefinitionen für Client-SDK - 2025-08-10
- `build_sdk.sh` erzeugt nun `.d.ts` Dateien im SDK `dist` Ordner
- `ThirdPartyApiClient.healthCheck` liefert typisierten `HealthResponse`
- Dokumentation zu `backend/third_party_api.md` um Hinweis auf SDK-Build erweitert
- Roadmap und Prompt aktualisiert
### Phase 5: Roadmap Planung - 2025-08-10
- Phase 5 mit Gamification- und Adaptive-Learning-Zielen in `roadmap.md` ergänzt
- `prompt.md` für nächsten Schritt angepasst

### Phase 5: Gamification Badge Script - 2025-08-10
- Konzeptdokument `codex/daten/gamification_engine.md` hinzugefügt
- Skript `scripts/generate_badge_assets.sh` erstellt, das Platzhalter-Badge-Icons generiert
- Roadmap und Prompt aktualisiert

### Phase 5: Gamification Engine Basisklassen - 2025-08-11
- `PointsManager`, `LevelManager` und `BadgeManager` im Backend unter `services/gamification` erstellt
- Dokumentation `gamification_engine.md` mit Link zum Badge-Generator-Skript erweitert
- Roadmap und Prompt aktualisiert

### Phase 5: Adaptive Learning Paths Grundstruktur - 2025-08-11
- `AdaptivePathService` und `LearningPathNode` Modell unter `backend/src/services/adaptive` erstellt
- Konzeptdokument `adaptive_learning_paths.md` ergänzt
- Skript `scripts/train_adaptive_model.sh` erzeugt Modellgewichte automatisch
- Roadmap und Prompt aktualisiert

### Phase 5: Adaptive Learning Paths Algorithm & API - 2025-08-11
- Algorithmus zur Pfadberechnung basierend auf Nutzerfortschritt erweitert
- REST-Route `POST /api/adaptive/progress` implementiert
- Tests für Service und Route ergänzt und `package.json` aktualisiert
- `scripts/train_adaptive_model.sh` erzeugt nun Platzhalter-Datensatz
- Dokumentation, Roadmap und Prompt aktualisiert

### Phase 5: Projektabschluss – Review & Feinschliff - 2025-08-11
- Offene TODO-Kommentare bereinigt und JWT-Token-Abfrage in den HTTP-Client integriert
- Roadmap und Prompt aktualisiert
- Backend-Tests mit `npm test` ausgeführt

### Wartungscheck - 2025-08-08
- Repository auf neue Issues geprüft
- `npm test` und `pytest codex/tests` ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-08 (erneut)
- Repository auf neue Issues geprüft
- `npm test` und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-08 (erneut 2)
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-08 (erneut 3)
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-08 (erneut 4)
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-08 (erneut 5)
- Repository auf neue Issues geprüft
- Fehler in `backend/tests/homework.test.ts` behoben, der durch ein bereits trainiertes Modell unbestimmte Ergebnisse lieferte
- `npm test` (im `backend/`) und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-09
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden
### Wartungscheck - 2025-08-10
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-11
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-12
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-13
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-14
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden
### Wartungscheck - 2025-08-15
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-16
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` erneut ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-17
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-18
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
### Wartungscheck - 2025-08-19
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-20
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-21
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-22
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-23
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-24
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-25
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-26
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden

### Wartungscheck - 2025-08-27
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt

### Wartungscheck - 2025-08-28
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt

### Wartungscheck - 2025-08-29
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt
### Wartungscheck - 2025-08-30
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt

### Wartungscheck - 2025-08-31
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt

### Wartungscheck - 2025-09-01
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt

### Wartungscheck - 2025-09-02
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt
### Wartungscheck - 2025-09-03
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt

### Wartungscheck - 2025-09-04
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt
### Wartungscheck - 2025-09-05
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt

### Wartungscheck - 2025-09-06
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt
### Wartungscheck - 2025-09-07
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt
### Wartungscheck - 2025-09-08
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt
### Wartungscheck - 2025-09-09
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt

### Wartungscheck - 2025-09-10
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt
### Wartungscheck - 2025-09-11
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt
### Wartungscheck - 2025-09-12
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt
### Wartungscheck - 2025-09-13
- Repository auf neue Issues geprüft
- `npm test` (im `backend/`) und `pytest codex/tests` ausgeführt – keine Fehler gefunden
- Keine Binärdateien versioniert; notwendige Artefakte werden über Skripte erzeugt

### Phase 1: Biometric Authentication Setup - 2025-09-14
- `local_auth` Dependency in `pubspec.yaml` aufgenommen
- `BiometricService` implementiert und im Service Locator registriert
- Login-Screen zeigt biometrischen Login bei unterstützten Geräten

### Phase 1: Auto-Login auf App-Start - 2025-09-14
- `AppStartEvent` im `AuthBloc` hinzugefügt und Sessionprüfung integriert
- `AuthRepositoryImpl` validiert und erneuert Tokens automatisch
- `service_locator.dart` und `app.dart` für automatischen Login-Check erweitert
- Unit-Tests für Auto-Login in `auth_bloc_test.dart` ergänzt
- Roadmap und Prompt aktualisiert

### Phase 1: Logout Functionality - 2025-09-14
- Server-seitiges Logout mit Token-Invalidation und lokalem Storage-Clear implementiert
- `AuthBloc` reagiert auf `LogoutRequested` und funktioniert auch offline
- `HomePage` mit Logout-Button und Bestätigungsdialog ergänzt
- Unit-Tests für Logout-Szenarien hinzugefügt
- Roadmap und Prompt aktualisiert

### Phase 1: Forgot Password Flow - 2025-09-14
- `forgot_password_page.dart` mit Email-Formular erstellt
- `AuthBloc` um `ForgotPasswordRequested` und `ResetPasswordRequested` Events erweitert
- Repository-Methoden für `/api/auth/forgot-password` und `/api/auth/reset-password` implementiert
- Routing, Tests und UI für Passwort-Zurücksetzen hinzugefügt

### Phase 1: Family Creation UI Screen - 2025-09-14
- `create_family_page.dart` mit Multi-Step-Wizard erstellt
- Routing über `AppRouter` angebunden und `FamilyRepository` im Service Locator registriert
- Roadmap und Prompt aktualisiert

### Phase 1: Family Model und Data Classes - 2025-09-14
- `Family` und `FamilyMember` Modelle mit `@JsonSerializable` implementiert
- Enums `FamilyRole` und `SubscriptionTier` hinzugefügt
- Roadmap und Prompt aktualisiert

### Phase 1: Family Repository Implementation - 2025-09-14
- `FamilyRepositoryImpl` mit Methoden für Erstellen, Abrufen, Aktualisieren und Löschen von Familien implementiert
- Request-Modelle `CreateFamilyRequest` und `UpdateFamilyRequest` hinzugefügt
- Roadmap und Prompt aktualisiert

### Phase 1: Family BLoC State Management - 2025-09-14
- `FamilyBloc` mit Events und States zur Verwaltung von Familienzuständen erstellt
- Optimistic Updates für Aktualisieren und Löschen umgesetzt
- `FamilyRepository` Interface eingeführt und Service Locator angepasst
- Roadmap und Prompt aktualisiert

### Phase 1: Family Member Invitation System - 2025-09-14
- `invite_member_page.dart` mit Formular für E-Mail und Rolle erstellt
- `FamilyBloc` um `InviteMemberRequested` und `AcceptInvitationRequested` erweitert
- `FamilyRepository` und Backend-Routen für `/api/family/invite` und `/invite/accept` implementiert
- Einladungs-Tokens mit 24h-Gültigkeit generiert und Annahme-Flow ergänzt
- Roadmap und Prompt aktualisiert

### Phase 1: QR Code Invitation Feature - 2025-09-14
- Dependencies `qr_flutter` und `qr_code_scanner` hinzugefügt
- QR-Code-Generierung im Einladungsscreen implementiert
- QR-Scanner-Seite zur automatischen Einladungsannahme erstellt
- Roadmap und Prompt aktualisiert

### Phase 1: Family Settings Management - 2025-09-15
- `family_settings_page.dart` mit UI-Elementen für Studienregeln, Bildschirmzeit, Schlafenszeit und App-Beschränkungen erstellt
- `FamilySettings` Modell sowie Repository-Methoden zum Laden und Aktualisieren der Einstellungen implementiert
- `FamilyBloc` um Events und States zur Verwaltung der Einstellungen erweitert
- Routen und Navigation für `FamilySettingsPage` ergänzt
- Roadmap und Prompt aktualisiert

### Phase 1: Family Member Management UI - 2025-09-15
- `family_members_page.dart` erstellt mit Liste, Rollen- und Rechteverwaltung sowie Entfernen von Mitgliedern
- `FamilyRepository` und `FamilyBloc` um Member-Management-Funktionen erweitert
- Routing und Konstanten für `FamilyMembersPage` hinzugefügt
- Roadmap und Prompt aktualisiert

### Phase 1: Family Dashboard Overview - 2025-09-16
- `family_dashboard_page.dart` als Übersichtsseite mit Statistiken und Quick-Actions erstellt
- Routen- und Navigationslogik für Family Dashboard ergänzt
- Roadmap und Prompt aktualisiert

### Phase 1: Family Role-Based Permissions - 2025-09-16
- `family_permissions.dart` mit Permission-Enums und `hasPermission` Funktion erstellt
- UI-Elemente in `family_dashboard_page.dart` und `family_members_page.dart` nutzen Berechtigungsprüfungen
- Backend-Middleware `authorizeFamilyPermission` schützt `/api/family/invite`
- Unit-Test `family_permissions_test.dart` hinzugefügt
- Roadmap und Prompt aktualisiert

### Phase 1: Family Subscription Management - 2025-09-16
- `subscription_page.dart` mit Planübersicht, Feature-Vergleich und Nutzungs-Limits erstellt
- Schnellzugriff im Family Dashboard sowie Route für Abonnementverwaltung hinzugefügt
- Roadmap und Prompt aktualisiert

### Phase 1: Family Data Synchronization - 2025-09-16
- `FamilyService` mit WebSocket-Verbindung und Hive-Caching implementiert
- `family_dashboard_page.dart` zeigt Sync-Status an und lädt Updates automatisch
- `service_locator.dart`, `family_bloc.dart` und `pubspec.yaml` entsprechend erweitert

### Phase 1: Platform Channel Setup für Device Monitoring - 2025-09-16
- `device_monitoring.dart` mit MethodChannel und Mock-Implementierung angelegt
- Roadmap und Prompt aktualisiert

### Phase 1: Android Native Code für App Usage Tracking - 2025-09-17
- `DeviceMonitoringPlugin.kt` erstellt, nutzt `UsageStatsManager` und fordert `PACKAGE_USAGE_STATS` Berechtigung an
- Roadmap und Prompt aktualisiert

### Phase 1: iOS Native Code für Screen Time Integration - 2025-09-18
- `DeviceMonitoringPlugin.swift` hinzugefügt mit AuthorizationCenter und Platzhalter für Screen-Time-Daten
- `.gitignore` angepasst, um Swift-Datei zu versionieren
- Roadmap und Prompt aktualisiert

### Phase 1: Permission Request Flow für Device Monitoring - 2025-09-19
- `device_permissions_page.dart` mit Berechtigungsanfrage und Deep-Link zu Einstellungen erstellt
- `DeviceMonitoring` MethodChannel um Berechtigungsfunktionen erweitert
- Android- und iOS-Plugins unterstützen `hasPermission` und `requestPermission`
- Roadmap und Prompt aktualisiert

### Phase 1: App Usage Statistics UI Display - 2025-09-20
- `app_usage_page.dart` mit Balken-, Linien- und Kreisdiagrammen erstellt
- `fl_chart` als Dependency in `pubspec.yaml` aufgenommen
- Roadmap und Prompt aktualisiert

### Phase 1: Real-time Activity Monitoring Service - 2025-09-21
- Hintergrunddienst sammelt alle 15 Minuten App-Nutzungsdaten in Hive
- Tages- und Wochenaggregation sowie Batch-Upload zum Backend implementiert
- `ActivityMonitoringService` im Service Locator registriert
- Roadmap und Prompt aktualisiert

### Phase 1: Android MainActivity Manifest Configuration - 2025-09-22
- AndroidManifest in `flutter_app/mrs_unkwn_app` um MainActivity mit `singleTop`, `exported` und Theme-Metadaten erweitert
- Prompt aktualisiert

### Phase 1: App Installation/Uninstallation Detection - 2025-09-23
- BroadcastReceiver und EventChannel für Installations- und Deinstallationsereignisse hinzugefügt
- `InstallMonitoringService` speichert Historie in Hive und informiert Eltern bei neuen Apps
- Roadmap und Prompt aktualisiert

### Phase 1: Basic Screen Time Tracking Implementation - 2025-09-24
- `ScreenTimeTracker` Dienst berechnet tägliche Bildschirmzeit pro App und Gesamt
- Limits mit Elternbenachrichtigung bei Überschreitung umgesetzt
- Service Locator und Tests ergänzt

### Phase 1: Device Information Collection - 2025-09-25
- `device_info_plus`, `battery_plus` und `disk_space` als Dependencies hinzugefügt
- `DeviceInfoService` sammelt Geräte-, Speicher- und Akkudaten in Hive
- Service Locator und Skript `create_flutter_project.sh` erweitert
- Unit-Test `device_info_service_test.dart` erstellt
- Roadmap und Prompt aktualisiert

### Phase 1: Network Activity Monitoring - 2025-09-26
- MethodChannel und Android-Plugin um Netzwerkstatistiken erweitert
- `NetworkActivityService` speichert Daten getrennt nach Mobilfunk und WLAN
- Ungewöhnliche Datennutzung löst Elternbenachrichtigung aus
- Service Locator und Unit-Test `network_activity_service_test.dart` ergänzt
- Roadmap und Prompt aktualisiert

### Phase 1: Location Tracking Service (Optional) - 2025-09-27
- `geolocator` als Dependency und `LocationTrackingService` mit Safe-Zones umgesetzt
- Standortverlauf in Hive gespeichert und automatische Bereinigung ergänzt
- Service Locator und Skript `create_flutter_project.sh` erweitert
- Roadmap und Prompt aktualisiert

### Phase 1: Monitoring Data Synchronization - 2025-09-28
- `MonitoringSyncService` synchronisiert Monitoring-Daten stündlich im Batch
- Daten werden vor dem Upload komprimiert und AES-verschlüsselt
- Retry-Logik, Offline-Queue und Sync-Status implementiert
- Service Locator und Unit-Test `monitoring_sync_service_test.dart` hinzugefügt
- Roadmap und Prompt aktualisiert
