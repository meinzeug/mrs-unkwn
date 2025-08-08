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
