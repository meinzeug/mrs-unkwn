# Mrs-Unkwn Entwicklungsroadmap

## Phase 0: Initialisierung
- [x] README.md analysiert
- [x] Basisverzeichnisse erstellt
- [x] __init__.py Dateien angelegt
- [x] requirements.txt, .gitignore und env.example erstellt
- [x] Dokumentation und Changelog eingerichtet

# Mrs-Unkwn Entwicklungsroadmap - Phase 1 (Monate 1-3)

## Phase 1: Foundation & Core Infrastructure

### Milestone 1: Repository Setup und Basis-Infrastruktur

[x] Git Repository initialisieren und .gitignore konfigurieren:
Details: Erstelle ein neues Git-Repository mit `git init`. Füge eine .gitignore-Datei hinzu die folgende Flutter/Dart-spezifische Ausschlüsse enthält: `build/`, `*.apk`, `*.aab`, `*.ipa`, `*.dSYM/`, `android/.gradle/`, `ios/Pods/`, `ios/.symlinks/`, `pubspec.lock`, `.dart_tool/`, `.packages`, `.metadata`. Erstelle die Ordnerstruktur: `flutter_app/`, `backend/`, `docs/`, `scripts/`, `.github/workflows/`. Initialer Commit mit "Initial project structure".

[x] Flutter SDK installieren und Entwicklungsumgebung einrichten:
Details: Lade Flutter SDK von flutter.dev herunter. Extrahiere das SDK nach `C:\flutter` (Windows) oder `~/flutter` (macOS/Linux). Füge Flutter-Pfad zur PATH-Umgebungsvariable hinzu. Führe `flutter doctor` aus und behebe alle gemeldeten Probleme. Installiere Android Studio oder VS Code mit Flutter/Dart-Erweiterungen. Konfiguriere Android SDK mit API Level 21+ und iOS Deployment Target 11.0+.

[x] Flutter-Projekt mit Multi-Platform-Support erstellen:
Details: Navigiere in den `flutter_app/`-Ordner. Führe `flutter create --org com.mrsunkwn --platforms android,ios,web,windows,macos,linux mrs_unkwn_app` aus. Öffne `pubspec.yaml` und setze `flutter` Version auf minimum "3.16.0". Entferne Standard-Demo-Code aus `lib/main.dart`. Erstelle Basis-Ordnerstruktur in `lib/`: `core/`, `features/`, `shared/`, `platform_channels/`.

[x] pubspec.yaml mit erforderlichen Dependencies konfigurieren:
Details: Öffne `pubspec.yaml` und füge folgende dependencies hinzu unter `dependencies:`: `dio: ^5.3.0` (HTTP client), `flutter_bloc: ^8.1.3` (State Management), `get_it: ^7.6.0` (Dependency Injection), `flutter_secure_storage: ^9.0.0` (Secure Storage), `go_router: ^12.0.0` (Navigation), `hive: ^2.2.3` (Local Database), `json_annotation: ^4.8.1` (JSON Serialization). Unter `dev_dependencies:` füge hinzu: `build_runner: ^2.4.7`, `json_serializable: ^6.7.1`, `flutter_test:`, `mocktail: ^1.0.0`.

[x] Basis App-Struktur mit Material App konfigurieren:
Details: Erstelle neue Datei `lib/app.dart`. Implementiere `MrsUnkwnApp` Klasse die `StatelessWidget` erweitert. Im `build` Methode, gebe `MaterialApp` zurück mit `title: 'Mrs-Unkwn'`, `theme: ThemeData(primarySwatch: Colors.blue)`, `home: Placeholder()`. In `lib/main.dart`, importiere `app.dart` und rufe `runApp(MrsUnkwnApp())` in der main() Funktion auf.

[x] Core-Ordnerstruktur mit Basis-Klassen erstellen:
Details: Erstelle `lib/core/constants/app_constants.dart` mit Klasse `AppConstants` und statischen Strings für App-Name, Version, API-Base-URL. Erstelle `lib/core/errors/failures.dart` mit abstrakten `Failure` Klasse und konkrete Implementierungen `ServerFailure`, `NetworkFailure`, `AuthFailure`. Erstelle `lib/core/network/network_info.dart` Interface für Netzwerk-Konnektivitätsprüfung. Erstelle `lib/core/theme/app_theme.dart` mit `AppTheme` Klasse für einheitliches Styling.

[x] Dependency Injection mit GetIt einrichten:
Details: Erstelle `lib/core/di/service_locator.dart`. Importiere `get_it` Package. Erstelle globale Variable `final sl = GetIt.instance;`. Implementiere `configureDependencies()` Funktion die alle Services registriert. Erstelle `_registerCore()`, `_registerFeatures()`, `_registerExternal()` Hilfsfunktionen. Rufe `configureDependencies()` in `main.dart` vor `runApp()` auf.

[x] Flutter BLoC Setup mit Basis-Strukturen:
Details: Erstelle `lib/core/bloc/base_bloc.dart` mit abstrakten `BaseBloc<Event, State>` Klasse die `Bloc<Event, State>` erweitert. Implementiere Standard-Error-Handling und Logging. Erstelle `lib/core/bloc/base_event.dart` und `base_state.dart` mit abstrakten Basis-Klassen. Erstelle `lib/core/bloc/bloc_observer.dart` die `BlocObserver` erweitert für globales Bloc-Event-Logging.

[x] HTTP Client mit Dio konfigurieren:
Details: Erstelle `lib/core/network/dio_client.dart`. Implementiere `DioClient` Klasse mit Singleton-Pattern. Konfiguriere Dio-Instanz mit `BaseOptions`: `baseUrl` aus Environment-Variable, `connectTimeout: 30000`, `receiveTimeout: 30000`. Füge Interceptors hinzu: `LogInterceptor` für Entwicklung, Custom-Interceptor für JWT-Token-Handling. Implementiere `get()`, `post()`, `put()`, `delete()` Methoden mit Error-Handling.

[x] Secure Storage Service implementieren:
Details: Erstelle `lib/core/storage/secure_storage_service.dart`. Implementiere `SecureStorageService` Klasse mit `FlutterSecureStorage` Instanz. Erstelle Methoden: `Future<void> store(String key, String value)`, `Future<String?> read(String key)`, `Future<void> delete(String key)`, `Future<void> deleteAll()`. Konfiguriere Android-spezifische Optionen: `encryptedSharedPreferences: true`. Definiere Konstanten für Storage-Keys: `TOKEN_KEY`, `REFRESH_TOKEN_KEY`, `USER_DATA_KEY`.

[x] Basis-Routing mit GoRouter einrichten:
Details: Erstelle `lib/core/routing/app_router.dart`. Implementiere `AppRouter` Klasse mit statischen `GoRouter` Instanz. Definiere Route-Konstanten in `lib/core/routing/route_constants.dart`: `/login`, `/register`, `/home`, `/family-setup`. Implementiere grundlegende Routen mit `GoRoute` Objects. Füge Navigation-Guards für authentifizierte Routen hinzu. Konfiguriere Redirect-Logic für nicht-authentifizierte Benutzer.

[x] Environment Configuration System:
Details: Erstelle `lib/core/config/environment.dart` mit `Environment` Klasse. Implementiere statische Methoden: `String get apiBaseUrl`, `bool get isProduction`, `String get appName`. Definiere Environment-Types: `dev`, `staging`, `prod`. Erstelle separate Konfigurationsdateien: `lib/config/dev_config.dart`, `staging_config.dart`, `prod_config.dart`. Verwende `--dart-define` für Build-Zeit-Konfiguration.

[x] Error Handling und Logging System:
Details: Erstelle `lib/core/utils/logger.dart` mit `Logger` Klasse basierend auf `dart:developer`. Implementiere Log-Level: `debug()`, `info()`, `warning()`, `error()`. Konfiguriere unterschiedliche Ausgabe für Debug/Release-Builds. Erstelle `lib/core/error/error_handler.dart` für globales Exception-Handling. Implementiere `handleError()` Funktion die verschiedene Exception-Types behandelt und entsprechende User-Messages zurückgibt.

[x] JSON Serialization Setup:
Details: Erstelle `build.yaml` im Projekt-Root für json_serializable Konfiguration. Definiere Standard-JSON-Serialization-Settings: `explicit_to_json: true`, `create_to_json: true`. Erstelle Beispiel-Model-Klasse `lib/core/models/base_model.dart` mit `@JsonSerializable()` Annotation. Implementiere `fromJson()` und `toJson()` Methoden. Führe `flutter packages pub run build_runner build` aus um Code zu generieren.

### Milestone 2: Backend API Foundation

[x] Node.js Express Server initialisieren:
Details: Navigiere in `backend/` Ordner. Führe `npm init -y` aus. Installiere Dependencies: `npm install express cors helmet morgan dotenv bcrypt jsonwebtoken express-validator`. Installiere Development-Dependencies: `npm install --save-dev nodemon typescript @types/node @types/express ts-node`. Erstelle `tsconfig.json` mit Standard-TypeScript-Konfiguration für Node.js. Erstelle `src/` Ordner mit `index.ts` als Entry-Point.

[x] Express Server Basis-Konfiguration:
Details: In `src/index.ts`, importiere required modules: `express`, `cors`, `helmet`, `morgan`. Erstelle Express-App-Instanz: `const app = express()`. Konfiguriere Middleware: `app.use(cors())`, `app.use(helmet())`, `app.use(morgan('combined'))`, `app.use(express.json())`. Definiere Port: `const PORT = process.env.PORT || 3000`. Starte Server mit `app.listen(PORT, callback)`. Erstelle Health-Check-Endpoint: `app.get('/health', handler)`.

[x] Environment Variables Setup:
Details: Erstelle `.env.example` mit required Variables: `DATABASE_URL`, `JWT_SECRET`, `JWT_REFRESH_SECRET`, `EMAIL_SERVICE_KEY`, `NODE_ENV`. Erstelle `.env` Datei basierend auf Example. In `src/config/config.ts`, implementiere Configuration-Object mit `dotenv` import. Exportiere typed Configuration-Interface mit allen Environment-Variables. Validiere required Variables beim Server-Start.

[x] Database Connection Setup mit PostgreSQL:
Details: Installiere PostgreSQL-Dependencies: `npm install pg knex`. Installiere Types: `npm install --save-dev @types/pg`. Erstelle `src/database/connection.ts` mit Knex-Konfiguration. Definiere Database-Config-Object mit Connection-String aus Environment. Exportiere Knex-Instanz. Erstelle `src/database/migrations/` Ordner für Schema-Migrations. Implementiere Connection-Test-Funktion.

[x] User-Tabelle Migration erstellen:
Details: Führe `npx knex migrate:make create_users_table` aus. In der generierten Migration-Datei, implementiere `up()` Funktion: erstelle `users` Tabelle mit Spalten `id` (UUID, primary), `email` (string, unique), `password_hash` (string), `first_name` (string), `last_name` (string), `role` (enum: parent/child), `created_at` (timestamp), `updated_at` (timestamp). Implementiere `down()` Funktion zum Löschen der Tabelle.

[x] Family-Tabellen Migration erstellen:
Details: Erstelle Migration für `families` Tabelle: `id` (UUID), `name` (string), `created_by` (UUID, foreign key zu users), `subscription_tier` (string), `created_at`, `updated_at`. Erstelle `family_members` Junction-Tabelle: `id` (UUID), `family_id` (UUID, foreign key), `user_id` (UUID, foreign key), `role` (string), `permissions` (JSON), `joined_at` (timestamp). Definiere Foreign-Key-Constraints und Indexes.

[x] JWT Authentication Service implementieren:
Details: Erstelle `src/services/auth.service.ts`. Implementiere `AuthService` Klasse mit Methoden: `generateTokens(userId: string)`, `verifyAccessToken(token: string)`, `verifyRefreshToken(token: string)`, `refreshTokens(refreshToken: string)`. Verwende `jsonwebtoken` Library. Konfiguriere Token-Expiry: Access-Token 15min, Refresh-Token 7 Tage. Implementiere Token-Blacklisting-Logic.

[x] Password Hashing Service:
Details: Erstelle `src/services/password.service.ts`. Implementiere `PasswordService` mit static methods: `async hashPassword(password: string): Promise<string>` mit `bcrypt.hash()` und salt-rounds 12. Implementiere `async comparePassword(password: string, hash: string): Promise<boolean>` mit `bcrypt.compare()`. Füge Password-Strength-Validation hinzu: mindestens 8 Zeichen, 1 Uppercase, 1 Lowercase, 1 Number, 1 Special-Character.

[x] User Repository Pattern implementieren:
Details: Erstelle `src/repositories/user.repository.ts`. Implementiere `UserRepository` Klasse mit Database-Abstraction-Layer. Methoden: `async create(userData: CreateUserDTO): Promise<User>`, `async findByEmail(email: string): Promise<User | null>`, `async findById(id: string): Promise<User | null>`, `async update(id: string, data: UpdateUserDTO): Promise<User>`, `async delete(id: string): Promise<void>`. Verwende Knex Query-Builder.

[x] Request Validation Middleware:
Details: Erstelle `src/middleware/validation.middleware.ts`. Implementiere `validateRequest` Higher-Order-Function die express-validator Rules akzeptiert. Erstelle Validation-Schemas in `src/validation/schemas/`: `userRegistration.schema.ts`, `userLogin.schema.ts`. Jedes Schema definiert Validation-Rules für Request-Body-Fields. Implementiere Error-Response-Format für Validation-Failures mit Field-specific-Messages.

[x] Authentication Middleware implementieren:
Details: Erstelle `src/middleware/auth.middleware.ts`. Implementiere `authenticateToken` Middleware-Funktion die Authorization-Header prüft, JWT-Token extrahiert und verifiziert. Bei gültigem Token, füge User-Data zu `req.user` hinzu. Implementiere `authorizeRoles(...roles)` Middleware für Role-based-Access-Control. Erstelle `optionalAuth` Middleware für Endpoints die sowohl Auth als auch Non-Auth-Requests akzeptieren.

[x] Basic API Routes Setup:
Details: Erstelle `src/routes/` Ordner. Implementiere `auth.routes.ts` mit Express-Router: POST `/register`, POST `/login`, POST `/refresh`, POST `/logout`. Erstelle `user.routes.ts`: GET `/profile`, PUT `/profile`, DELETE `/account`. Erstelle `src/routes/index.ts` als Main-Router der alle Feature-Router kombiniert. Mounten Sie Main-Router in `src/index.ts` unter `/api` Prefix.

[x] Error Handling Middleware:
Details: Erstelle `src/middleware/error.middleware.ts`. Implementiere global Error-Handler-Middleware die alle unhandled Errors abfängt. Unterscheide zwischen verschiedenen Error-Types: ValidationError, DatabaseError, AuthenticationError, etc. Erstelle standardisierte Error-Response-Format: `{error: {message, code, details}}`. Implementiere different Error-Handling für Development vs Production (Stack-Traces nur in Dev).

[x] API Response Standardization:
Details: Erstelle `src/utils/response.util.ts`. Implementiere Helper-Functions: `success(data, message, statusCode)`, `error(message, statusCode, details)`, `paginated(data, pagination)`. Alle API-Responses sollen einheitliches Format haben: `{success: boolean, data/error: object, message: string, timestamp: string}`. Implementiere Response-Wrapper-Middleware die automatisch alle Responses formatiert.

### Milestone 3: Flutter Authentication UI

 [x] Login Screen UI Layout erstellen:
Details: Erstelle `lib/features/auth/presentation/pages/login_page.dart`. Implementiere `LoginPage` als `StatefulWidget`. Erstelle UI-Layout mit `Scaffold`, `AppBar(title: 'Login')`, `SingleChildScrollView` Body. Füge Logo-Container hinzu (150x150), Titel-Text "Willkommen bei Mrs-Unkwn". Implementiere zwei `TextFormField` für Email und Password mit entsprechenden `InputDecoration`. Füge `ElevatedButton` für Login und `TextButton` für "Registrieren" Link hinzu.

[x] Login Form Validation implementieren:
Details: In `LoginPage`, erstelle `GlobalKey<FormState> _formKey`. Wrappen Sie Form-Fields in `Form` Widget mit `key: _formKey`. Für Email-Field: Validation-Function die Email-Format prüft mit RegExp. Für Password-Field: Validation für minimum 6 Zeichen, required Field. Implementiere `obscureText: true` für Password-Field mit Toggle-Icon. Erstelle `_validateAndSubmit()` Methode die `_formKey.currentState?.validate()` aufruft.

[x] Login BLoC State Management:
Details: Erstelle `lib/features/auth/presentation/bloc/auth_bloc.dart`. Definiere `AuthEvent` Klasse mit `LoginRequested(email, password)`, `LogoutRequested`, `AuthStatusChanged` Events. Definiere `AuthState` mit `AuthInitial`, `AuthLoading`, `AuthSuccess(User)`, `AuthFailure(String message)` States. Implementiere `AuthBloc` die Events handled und entsprechende States emittiert. Verwende Repository-Pattern für API-Calls.

[x] Login API Integration:
Details: Erstelle `lib/features/auth/data/repositories/auth_repository_impl.dart`. Implementiere `login(String email, String password)` Methode. Erstelle POST-Request zu `/api/auth/login` mit Email/Password im Body. Handle HTTP-Response: Bei 200 Status, parse JSON und extrahiere Token. Speichere Access-Token und Refresh-Token in Secure-Storage. Bei Error-Response, werfe entsprechende Exception mit Error-Message.

[x] Login Loading States UI:
Details: In `LoginPage`, wrappen Sie gesamte UI in `BlocConsumer<AuthBloc, AuthState>`. Im `listener`, handle `AuthSuccess` State (Navigate zu Home), `AuthFailure` State (Show-SnackBar mit Error). Im `builder`, zeige Loading-Indicator wenn State `AuthLoading` ist. Disable Login-Button während Loading. Replace ElevatedButton-Child mit `CircularProgressIndicator()` bei Loading-State.

[x] Register Screen UI erstellen:
Details: Erstelle `lib/features/auth/presentation/pages/register_page.dart`. Implementiere ähnliches Layout wie Login mit zusätzlichen Fields: `firstName`, `lastName`, `confirmPassword`. Füge `DropdownButtonFormField` für User-Role (Parent/Child) hinzu. Implementiere Checkbox für Terms-Acceptance mit Link zu Terms-Page. Erstelle komplexere Validation-Logic: Password-Confirmation-Match, Terms-Acceptance-Required.

[x] Registration BLoC Events/States:
Details: Erweitere `AuthEvent` um `RegisterRequested(firstName, lastName, email, password, role)` Event. Erweitere `AuthState` um `RegisterSuccess`, `RegisterFailure` States. In `AuthBloc`, implementiere `_onRegisterRequested` Handler der Registration-API aufruft. Handle verschiedene Error-Cases: Email-bereits-verwendet, Invalid-Input, Network-Error. Emittiere entsprechende States mit Error-Messages.

[x] Registration API Integration:
Details: In `AuthRepositoryImpl`, implementiere `register()` Methode. Erstelle POST-Request zu `/api/auth/register` endpoint. Include alle Required-Fields in Request-Body. Handle API-Response: Success-Case mit User-Data, Error-Cases mit spezifischen Messages. Parse Validation-Errors vom Backend und mappen Sie zu User-friendly-Messages. Implementiere Automatic-Login nach successful Registration.

[x] Password Strength Indicator:
Details: Erstelle `lib/shared/widgets/password_strength_indicator.dart` Widget. Implementiere Password-Strength-Calculation basierend auf: Length (>8), Uppercase-Letters, Lowercase-Letters, Numbers, Special-Characters. Zeige visuellen Strength-Indicator mit Colors: Red (Weak), Orange (Medium), Green (Strong). Update Indicator in Real-time während User-Typing. Zeige Improvement-Suggestions unter dem Indicator.

[ ] Biometric Authentication Setup:
Details: Füge `local_auth: ^2.1.6` zu pubspec.yaml hinzu. Erstelle `lib/core/services/biometric_service.dart`. Implementiere `isBiometricAvailable()`, `authenticateWithBiometric()`, `getBiometricTypes()` Methoden. In Login-Screen, zeige Biometric-Login-Option nur wenn Available. Implementiere Biometric-Authentication-Flow: Check-Availability, Prompt-User, Handle-Success/Failure, Auto-Login bei Success.

[ ] Auto-Login auf App-Start:
Details: Erstelle `AppStartEvent` in AuthBloc. In Main-App-Widget, dispatch AppStartEvent beim App-Start. Implementiere `_onAppStarted` Handler in AuthBloc: Check für gespeicherte Tokens, Validate Token mit Backend, Auto-Login wenn Token gültig. Handle Token-Refresh wenn Access-Token expired aber Refresh-Token gültig. Navigate automatisch zu entsprechender Screen basierend auf Auth-Status.

[ ] Logout Functionality:
Details: Implementiere `LogoutRequested` Event-Handler in AuthBloc. Erstelle Logout-API-Call der Server-side-Token-Invalidation durchführt. Clear alle lokalen Storage-Data: Access-Token, Refresh-Token, User-Data, App-Settings. Reset alle BLoCs zu Initial-State. Navigate zurück zu Login-Screen. Zeige Confirmation-Dialog vor Logout-Action. Handle Network-Errors gracefully (Logout auch bei offline).

[ ] Forgot Password Flow:
Details: Erstelle `forgot_password_page.dart` mit Email-Input-Field. Implementiere `ForgotPasswordRequested` Event und entsprechende States. Erstelle Backend-API-Call zu `/api/auth/forgot-password` endpoint. Zeige Success-Message mit "Email gesendet" Confirmation. Implementiere Password-Reset-Page für Deep-Link-Handling. Validate Reset-Token und ermögliche neues Password-Setzen. Update Password über API und auto-login.

### Milestone 4: Familie Management System

[ ] Family Creation UI Screen:
Details: Erstelle `lib/features/family/presentation/pages/create_family_page.dart`. Implementiere Multi-Step-Wizard mit `PageView` und Step-Indicator. Step 1: Family-Name-Input mit Validation. Step 2: Family-Rules-Setup (Study-Hours, Bedtime, etc.). Step 3: Subscription-Plan-Selection mit Pricing-Cards. Step 4: Summary und Confirmation. Implementiere Navigation-Buttons (Next/Previous) mit Form-Validation vor Next-Step.

[ ] Family Model und Data Classes:
Details: Erstelle `lib/features/family/data/models/family.dart`. Implementiere `Family` Model-Klasse mit `@JsonSerializable()` Annotation. Properties: `id`, `name`, `createdBy`, `subscriptionTier`, `settings`, `createdAt`, `updatedAt`. Erstelle `FamilyMember` Model mit `userId`, `role`, `permissions`, `joinedAt`. Implementiere `fromJson()` und `toJson()` Methoden. Definiere Enums für `FamilyRole` und `SubscriptionTier`.

[ ] Family Repository Implementation:
Details: Erstelle `lib/features/family/data/repositories/family_repository_impl.dart`. Implementiere `createFamily(CreateFamilyRequest)` Methode mit POST-API-Call. Implementiere `getFamily(String familyId)` mit GET-API-Call. Implementiere `updateFamily(String familyId, UpdateFamilyRequest)` mit PUT-Call. Implementiere `deleteFamily(String familyId)` mit DELETE-Call. Handle alle HTTP-Error-Cases und Netzwerk-Exceptions.

[ ] Family BLoC State Management:
Details: Erstelle `family_bloc.dart` mit Events: `CreateFamilyRequested`, `LoadFamilyRequested`, `UpdateFamilyRequested`, `DeleteFamilyRequested`. Definiere States: `FamilyInitial`, `FamilyLoading`, `FamilyLoaded(Family)`, `FamilyCreated`, `FamilyError(String)`. Implementiere Event-Handlers die Repository-Calls machen und entsprechende States emittieren. Handle optimistic Updates für bessere UX.

[ ] Family Member Invitation System:
Details: Erstelle `invite_member_page.dart` mit Email-Input und Role-Selection. Implementiere `InviteMemberRequested` Event in FamilyBloc. Erstelle Backend-API für `/api/family/invite` endpoint. Generate Invitation-Token mit Expiry-Date (24h). Send Invitation-Email mit Deep-Link zur App. Implementiere Invitation-Acceptance-Flow mit Token-Validation. Update Family-Members-List nach successful Invitation-Acceptance.

[ ] QR Code Invitation Feature:
Details: Füge `qr_flutter: ^4.1.0` und `qr_code_scanner: ^1.0.1` zu Dependencies hinzu. Erstelle QR-Code-Generation-Feature in Invite-Member-Screen. QR-Code enthält Invitation-Token und Family-Information. Implementiere QR-Scanner-Screen für Invitation-Acceptance. Handle Camera-Permissions und Scanner-Errors. Validate gescannten QR-Code und process Invitation automatisch.

[ ] Family Settings Management:
Details: Erstelle `family_settings_page.dart` mit verschiedenen Setting-Categories: Study-Rules, Screen-Time-Limits, Bedtime-Schedule, App-Restrictions. Implementiere Toggle-Switches, Sliders, und Time-Pickers für verschiedene Settings. Erstelle `FamilySettings` Model-Klasse mit Serialization. Implementiere Settings-Update-API-Calls mit Optimistic-Updates. Handle Settings-Inheritance (Family-Level vs Individual-Member-Level).

[ ] Family Member Management UI:
Details: Erstelle `family_members_page.dart` mit Member-List-View. Zeige Member-Avatar, Name, Role, Last-Active-Status. Implementiere Member-Details-Modal mit Role-Change, Permissions-Edit, Remove-Member-Options. Erstelle Role-Based-UI: Parents können alle Members verwalten, Children können nur eigenes Profil sehen. Implementiere Confirmation-Dialogs für destructive Actions (Remove-Member). Handle real-time Member-Status-Updates.

[ ] Family Dashboard Overview:
Details: Erstelle `family_dashboard_page.dart` als Main-Family-Screen. Implementiere Cards-Layout mit Family-Statistics: Total-Members, Active-Members, Study-Time-Summary. Zeige Quick-Actions: Invite-Member, View-Activity, Manage-Settings. Implementiere Recent-Activity-Feed mit Member-Activities. Add Family-Progress-Charts mit Study-Goals und Achievements. Implementiere Pull-to-Refresh für Data-Updates.

[ ] Family Role-Based Permissions:
Details: Definiere Permission-System in `lib/core/permissions/family_permissions.dart`. Erstelle Enums für verschiedene Permissions: `MANAGE_MEMBERS`, `VIEW_ACTIVITY`, `EDIT_SETTINGS`, `DELETE_FAMILY`. Implementiere Permission-Check-Functions: `hasPermission(FamilyRole, Permission)`. Integrate Permission-Checks in UI (Hide/Show-Buttons basierend auf Role). Implementiere Backend-Permission-Validation für alle Family-APIs.

[ ] Family Subscription Management:
Details: Erstelle `subscription_page.dart` mit Current-Plan-Overview und Upgrade-Options. Implementiere Subscription-Tiers: Basic (Free), Family (€12.99), Premium (€19.99). Zeige Feature-Comparison-Table für verschiedene Plans. Implementiere Subscription-Change-Flow mit Payment-Integration-Placeholder. Handle Subscription-Status-Changes und Feature-Availability basierend auf Plan. Implementiere Usage-Limits-Tracking (Number-of-Children, Features-Usage).

[ ] Family Data Synchronization:
Details: Implementiere Real-time-Data-Sync für Family-Updates using WebSocket-Connection oder Server-Sent-Events. Erstelle `FamilyService` der automatisch Family-Data updated wenn Changes detektiert werden. Handle Offline-Mode mit Local-Data-Caching using Hive-Database. Implementiere Conflict-Resolution für concurrent Family-Updates. Show Sync-Status-Indicator in UI und Handle Sync-Errors gracefully.

### Milestone 5: Basic Device Monitoring Foundation

[ ] Platform Channel Setup für Device Monitoring:
Details: Erstelle `platform_channels/device_monitoring.dart`. Definiere `MethodChannel('com.mrsunkwn/device_monitoring')`. Implementiere Flutter-Methods: `startMonitoring()`, `stopMonitoring()`, `getAppUsageStats()`, `getInstalledApps()`. Handle Platform-specific-Errors und Missing-Method-Implementations. Erstelle Mock-Implementation für Development-Testing ohne native Code.

[ ] Android Native Code für App Usage Tracking:
Details: Erstelle `android/app/src/main/kotlin/DeviceMonitoringPlugin.kt`. Implementiere MethodCallHandler für Flutter-Method-Channel. Request `PACKAGE_USAGE_STATS` Permission. Implementiere `getAppUsageStats()` mit `UsageStatsManager`. Query Usage-Statistics für specified Time-Range. Return JSON-formatted Usage-Data zu Flutter. Handle Permission-Denials und API-Availability-Checks.

[ ] iOS Native Code für Screen Time Integration:
Details: Erstelle `ios/Runner/DeviceMonitoringPlugin.swift`. Implementiere FlutterMethodCallHandler. Request Family-Controls-Framework-Permissions. Implementiere Screen-Time-API-Integration mit `FamilyControls` Framework. Query Device-Activity-Data und App-Usage-Statistics. Convert Native-Data to JSON-Format für Flutter-Consumption. Handle iOS-Version-Compatibility und Permission-Requirements.

[ ] Permission Request Flow für Device Monitoring:
Details: Erstelle `device_permissions_page.dart` mit Step-by-Step-Permission-Explanation. Implementiere Platform-specific-Permission-Requests: Android Usage-Access, iOS Screen-Time-Access. Zeige Permission-Rationale mit Feature-Benefits-Explanation. Handle Permission-Denial-Cases mit Fallback-Options. Implementiere Settings-Deep-Link für manual Permission-Grant. Track Permission-Status und disable Features wenn nicht granted.

[ ] App Usage Statistics UI Display:
Details: Erstelle `app_usage_page.dart` mit Statistics-Overview. Implementiere Charts mit `fl_chart` Package: Daily-Usage-Bar-Chart, App-Category-Pie-Chart, Weekly-Usage-Trend-Line-Chart. Zeige Top-Used-Apps-List mit Usage-Time und Percentage. Implementiere Time-Range-Filter (Today, Week, Month). Handle Data-Loading-States und Empty-Data-Cases. Add Export-Functionality für Usage-Reports.

[ ] Real-time Activity Monitoring Service:
Details: Erstelle Background-Service für continuous App-Usage-Monitoring. Implementiere `MonitoringService` der periodically Usage-Data collected (every 15 minutes). Store collected Data in local Hive-Database with Timestamp. Implement Data-Aggregation-Logic für Daily/Weekly-Summaries. Handle Service-Lifecycle und Battery-Optimization-Exemptions. Implementiere Data-Upload zu Backend in Batches.

[ ] App Installation/Uninstallation Detection:
Details: Implementiere `PackageManager.EXTRA_REPLACING` Listener für Android App-Installation-Events. Erstelle Broadcast-Receiver für `ACTION_PACKAGE_ADDED`, `ACTION_PACKAGE_REMOVED` Intents. Store App-Installation-History mit Timestamp in lokaler Database. Für iOS: Implementiere App-Discovery durch periodic Installed-Apps-Comparison. Notify Parents über neue App-Installations mit Push-Notifications. Implementiere App-Approval-Workflow für restricted Children-Accounts.

[ ] Basic Screen Time Tracking Implementation:
Details: Erstelle `screen_time_tracker.dart` Service. Implementiere Screen-Time-Calculation basierend auf App-Foreground-Time. Track Daily-Screen-Time per App und gesamt. Store Screen-Time-Data in Hive-Database mit Daily-Buckets. Implementiere Screen-Time-Limits-Checking und Warning-Notifications. Handle App-Switching-Events und Accurate-Time-Calculation. Erstelle Screen-Time-Summary-Reports für Parents.

[ ] Device Information Collection:
Details: Implementiere `device_info_plus` Package für Device-Hardware-Information. Collect: Device-Model, OS-Version, Available-Storage, RAM, Battery-Level. Track Device-Usage-Patterns: Boot-Times, Charging-Sessions, Network-Changes. Store Device-Metadata für Parent-Dashboard-Display. Implement Device-Health-Monitoring und Low-Battery/Storage-Alerts. Handle Privacy-Compliance für Device-Data-Collection.

[ ] Network Activity Monitoring:
Details: Implementiere Network-Usage-Tracking per App using Android `NetworkStatsManager`. Track Data-Consumption: Mobile-Data vs WiFi, Upload vs Download, per Time-Period. Erstelle Network-Activity-Charts und Unusual-Usage-Alerts. Implement Network-Access-Control-Integration für App-Level-Restrictions. Monitor für Data-Usage-Limits und Cost-Control-Features. Handle Network-State-Changes und Connectivity-Monitoring.

[ ] Location Tracking Service (Optional):
Details: Implementiere `geolocator` Package für Location-Services. Request Location-Permissions mit clear Purpose-Explanation. Track Safe-Zones (Home, School) und Geofence-Alerts. Implement Location-Sharing zwischen Family-Members mit Privacy-Controls. Store Location-History mit Automatic-Cleanup nach defined Period. Handle Battery-Optimization für Background-Location-Updates. Implement Emergency-Location-Sharing-Features.

[ ] Monitoring Data Synchronization:
Details: Erstelle `monitoring_sync_service.dart` für Backend-Data-Upload. Implement Batch-Upload-Strategy für Efficient-Data-Transfer (every hour). Compress und Encrypt Monitoring-Data before Upload. Handle Upload-Failures mit Retry-Logic und Offline-Queue. Implement Data-Deduplication und Server-side-Data-Validation. Create Sync-Status-Tracking und Error-Recovery-Mechanisms.

[ ] Parent Dashboard für Monitoring Data:
Details: Erstelle `monitoring_dashboard_page.dart` mit Real-time-Monitoring-Overview. Display Active-Children-Status, Current-App-Usage, Screen-Time-Today. Implement Live-Updates using WebSocket-Connection oder Polling. Zeige Quick-Actions: Block-App, Send-Message, Set-Time-Limit. Create Alert-Center für Important-Notifications und Required-Actions. Implement Dashboard-Customization für Different-Parent-Preferences.

[ ] Monitoring Alerts und Notifications:
Details: Implement Alert-System für verschiedene Monitoring-Events: Screen-Time-Limit-Exceeded, Inappropriate-App-Used, Device-Tampering-Detected. Create Alert-Rules-Engine mit Configurable-Thresholds und Conditions. Implement Alert-Delivery-Channels: Push-Notifications, Email, SMS-Integration. Handle Alert-Prioritization und Spam-Prevention. Create Alert-History und Response-Tracking für Parents.

[ ] Privacy und DSGVO Compliance für Monitoring:
Details: Implement Data-Minimization-Principles für Monitoring-Data-Collection. Create Transparent-Privacy-Controls für Parents und Children. Implement Data-Retention-Policies mit Automatic-Deletion nach defined Periods. Handle Data-Portability-Requests und Right-to-be-Forgotten. Create Privacy-Dashboard für Data-Usage-Transparency. Implement Consent-Management für verschiedene Monitoring-Features.

[ ] Monitoring Performance Optimization:
Details: Optimize Background-Service für Minimal-Battery-Impact using JobScheduler/WorkManager. Implement Smart-Monitoring-Intervals basierend auf Usage-Patterns. Create Data-Compression-Strategies für Storage und Network-Efficiency. Implement Caching-Mechanisms für Frequently-Accessed-Monitoring-Data. Handle Memory-Management für Large-Dataset-Processing. Optimize Database-Queries mit proper Indexing-Strategies.

### Milestone 6: Basic AI Tutoring Foundation

[x] OpenAI API Integration Setup:
Details: Installiere `http` Package für API-Requests. Erstelle `lib/core/services/openai_service.dart`. Implementiere `OpenAIService` Klasse mit API-Key aus Environment-Variables. Create Methods: `sendChatRequest(String message, List<ChatMessage> context)`. Handle API-Rate-Limiting mit Exponential-Backoff-Retry. Implement Request-Timeout-Handling (30 seconds). Store API-Usage-Statistics für Cost-Tracking.

[x] Chat Message Model und Serialization:
Details: Erstelle `lib/features/tutoring/data/models/chat_message.dart`. Implementiere `ChatMessage` Model mit Properties: `id`, `role` (user/assistant/system), `content`, `timestamp`, `metadata`. Add `@JsonSerializable()` für Serialization. Implement `fromJson()` und `toJson()` Methods. Create Message-Types: Text, Image, File-Attachment. Handle Message-Threading für Multi-turn-Conversations.

[x] AI Prompt Engineering für Sokratische Methode:
Details: Erstelle `lib/features/tutoring/data/prompts/socratic_prompts.dart`. Define System-Prompts für verschiedene Subjects: Math, Science, Literature, History. Implement Prompt-Templates die Socratic-Questioning fördern: "Instead of giving the answer, ask a guiding question". Create Age-appropriate-Prompts für Different-Grade-Levels. Implement Context-Building für Previous-Conversation-History. Handle Prompt-Length-Limits und Token-Management.

[x] Chat UI Interface Implementation:
Details: Erstelle `lib/features/tutoring/presentation/pages/chat_page.dart`. Implementiere Chat-Bubble-UI mit Sender-Differentiation (Student vs AI). Create Message-Input-Field mit Send-Button und Voice-Input-Option. Implement Auto-Scroll zu newest Messages und Load-More-History. Add Typing-Indicators during AI-Response-Generation. Handle Message-Delivery-Status (Sending, Sent, Error) mit Visual-Indicators.

[x] AI Response Generation Service:
Details: Erstelle `ai_response_service.dart` der OpenAI-API-Calls managed. Implement Request-Building mit Conversation-Context und System-Prompts. Handle Streaming-Responses für Real-time-Message-Display. Implement Content-Filtering für Inappropriate-AI-Responses. Add Response-Caching für Similar-Questions. Handle API-Errors gracefully mit User-friendly-Error-Messages.

[x] Subject Classification System:
Details: Implementiere Subject-Detection-Algorithm für Student-Questions. Create Keyword-Based-Classification für Basic-Subject-Detection: Math-Keywords (equation, solve, calculate), Science-Keywords (experiment, hypothesis), etc. Implement Machine-Learning-Classification für Better-Accuracy. Store Subject-History für Learning-Analytics. Handle Multi-Subject-Questions und Subject-Switching in Conversations.

[x] Learning Session Management:
Details: Erstelle `learning_session.dart` Model für Session-Tracking. Implement Session-Start/End-Logic mit Duration-Calculation. Track Learning-Metrics: Questions-Asked, Topics-Covered, AI-Interactions-Count. Store Session-Data in Local-Database mit Sync-to-Backend. Implement Session-Goals und Progress-Tracking. Handle Session-Interruptions und Resume-Functionality.

[x] AI Tutoring BLoC State Management:
Details: Erstelle `tutoring_bloc.dart` mit Events: `SendMessageRequested`, `LoadChatHistoryRequested`, `StartLearningSessionRequested`, `EndLearningSessionRequested`. Define States: `TutoringInitial`, `TutoringLoading`, `MessagesLoaded`, `MessageSent`, `TutoringError`. Implement Event-Handlers für AI-API-Integration und Local-Data-Management. Handle Optimistic-UI-Updates für Better-User-Experience.

[x] Voice Input Integration:
Details: Add `speech_to_text` Package für Voice-Input-Support. Implement Voice-Recording-UI mit Visual-Feedback (Waveform, Recording-Timer). Handle Speech-to-Text-Conversion mit Error-Handling für unclear Speech. Implement Language-Detection für Multi-language-Support (German, English). Add Voice-Commands für Navigation (Send-Message, Clear-Chat). Handle Microphone-Permissions und Audio-Recording-Privacy.

[x] Basic Content Moderation:
Details: Implement Client-side-Content-Filtering für Student-Messages vor AI-Submission. Create Inappropriate-Content-Detection mit Keyword-Lists: Profanity, Violence, Adult-Content. Implement AI-Response-Filtering für Educational-Appropriateness. Handle Content-Violation-Cases mit Parent-Notifications. Create Content-Appeal-Process für False-Positives. Store Moderation-Logs für Compliance und Improvement.

[x] Learning Progress Analytics:
Details: Erstelle Analytics-Engine für Learning-Progress-Tracking. Implement Metrics-Calculation: Time-Spent-per-Subject, Questions-per-Session, Learning-Velocity. Track Difficulty-Progression und Concept-Mastery über Time. Create Progress-Visualization mit Charts und Trend-Lines. Implement Achievement-System mit Learning-Milestones. Generate Progress-Reports für Parents mit Insights und Recommendations.

[x] Chat History und Persistence:
Details: Implement Chat-History-Storage using Hive-Database für Offline-Access. Create Chat-Export-Functionality für Parent-Review. Implement Search-Functionality für Chat-History mit Keyword und Date-Filters. Handle Chat-Data-Encryption für Privacy-Protection. Implement Automatic-Chat-Cleanup nach defined Retention-Period. Create Chat-Backup-and-Restore-Functionality.

### Milestone 7: Integration und Testing Framework

[x] Unit Testing Setup für Flutter:
Details: Konfiguriere `test/` Directory-Structure: `unit/`, `widget/`, `integration/`. Setup Test-Dependencies in pubspec.yaml: `flutter_test`, `mocktail`, `bloc_test`. Erstelle `test/helpers/` mit Test-Utilities und Mock-Objects. Implement Base-Test-Classes für Common-Test-Patterns. Create Test-Data-Factories für Model-Generation. Setup Code-Coverage-Reporting mit `lcov`.

[x] Widget Testing für UI Components:
Details: Erstelle Widget-Tests für alle Custom-Widgets und Screens. Test Login-Screen: Form-Validation, Button-States, Navigation-Actions. Test Chat-UI: Message-Display, Input-Handling, Scroll-Behavior. Create Golden-Tests für UI-Consistency-Validation. Test Responsive-Layouts für Different-Screen-Sizes. Handle Async-Operations und BLoC-State-Testing in Widget-Tests.

[x] BLoC Testing Implementation:
Details: Use `bloc_test` Package für BLoC-Unit-Testing. Test alle BLoC-Events und entsprechende State-Transitions. Mock Repository-Dependencies with Mocktail. Test Error-Handling und Edge-Cases in BLoCs. Implement Async-Testing für API-Calls und Database-Operations. Create BLoC-Integration-Tests für Complex-User-Flows.

[x] API Integration Testing:
Details: Setup Test-Environment mit Mock-HTTP-Server using `mockito`. Create API-Test-Scenarios: Success-Responses, Error-Responses, Network-Failures. Test Authentication-Flow: Login, Token-Refresh, Logout. Test Family-Management-APIs: Create, Update, Delete, Member-Management. Implement API-Contract-Testing für Backend-Compatibility.

[x] E2E Testing mit Integration Tests:
Details: Setup `integration_test` Package für End-to-End-Testing. Create E2E-Test-Scenarios: User-Registration-to-Chat-Flow, Family-Setup-to-Monitoring-Flow. Test Cross-Platform-Compatibility (Android, iOS, Web). Implement Test-Data-Setup und Cleanup-Procedures. Handle Test-Environment-Configuration und Backend-Mocking.

[x] Performance Testing und Profiling:
Details: Implement Performance-Benchmarks für kritische App-Flows. Test Memory-Usage während Chat-Sessions und Large-Data-Loading. Profile Battery-Consumption für Background-Monitoring-Services. Test App-Startup-Time und Navigation-Performance. Implement Performance-Regression-Testing in CI/CD-Pipeline. Use Flutter-DevTools für Performance-Analysis.

[x] Security Testing Implementation:
Details: Test API-Security: Authentication-Bypass-Attempts, Token-Validation, Input-Sanitization. Test Local-Data-Encryption und Secure-Storage-Implementation. Implement Penetration-Testing für Platform-Channel-Security. Test Privacy-Controls und Data-Access-Permissions. Create Security-Vulnerability-Scanning in CI/CD-Pipeline.

[x] Automated Testing in CI/CD:
Details: Configure GitHub-Actions-Workflow für Automated-Testing. Setup Test-Matrix für Multiple-Flutter-Versions und Platform-Targets. Implement Parallel-Test-Execution für Faster-CI-Runs. Configure Test-Reporting und Coverage-Upload to Codecov. Setup Failure-Notifications und Test-Result-Artifacts. Implement Test-Retry-Logic für Flaky-Tests.

[x] Manual Testing Procedures:
Details: Create Manual-Testing-Checklists für Each-Release. Define User-Acceptance-Testing-Scenarios mit Real-World-Usage-Patterns. Setup Beta-Testing-Program mit Family-Testers. Create Bug-Reporting-Templates und Issue-Tracking-Procedures. Implement Usability-Testing-Sessions mit Target-Demographics. Document Testing-Procedures und Quality-Gates.

[x] Monitoring und Crash Reporting:
Details: Integrate Firebase-Crashlytics für Production-Crash-Reporting. Setup Custom-Error-Tracking für Business-Logic-Errors. Implement Performance-Monitoring mit Firebase-Performance oder Sentry. Create Error-Alerting-System für Critical-Production-Issues. Setup Error-Analysis-Dashboard für Development-Team. Implement User-Feedback-Collection für Issue-Resolution.

# Mrs-Unkwn Entwicklungsroadmap - Phase 2 (Monate 7-12)

## Phase 2: Enhanced Features

### Milestone 1: Advanced Homework Detection

[x] Basissystem für Hausaufgabenerkennung:
Details: Service und Route implementiert, um AI-generierte Inhalte in Hausaufgaben zu erkennen. Skript `setup_homework_detection.sh` lädt benötigtes Modell.

[x] ML-Modell-Integration für präzisere Erkennung:
Details: Echtes ML-Modell eingebunden und heuristische Erkennung ersetzt.

[x] Modell-Evaluierung und Feedback-Mechanismus:
Details: Genauigkeit mit Testdaten prüfen und Verbesserungsfeedback sammeln.

[x] Automatisiertes Modell-Retraining mit Feedback-Daten:
Details: Trainingsskript liest Feedback-Logs ein, aktualisiert Modellgewichte und erzeugt die Modell-Datei.

[x] Automatisierte Modell-Bereitstellung und geplantes Retraining:
Details: NPM-Skript, GitHub Action und Modellversionierung eingeführt.

[x] API-Endpunkt für Modellversion und Retrain-Datum:
Details: Endpoint liefert aktuelle Modellversion und letztes Trainingsdatum.

# Mrs-Unkwn Entwicklungsroadmap - Phase 3 (Monate 13-18)

## Phase 3: Market Expansion & Integrationen

### Milestone 1: Multi-Language Support

- [x] UI- und Backend-Lokalisierung für Deutsch und Englisch
- [x] Skript `scripts/generate_translations.sh` erzeugt Übersetzungsdateien automatisch

### Milestone 2: Schul-Integrationen

- [x] Schnittstellen zu Schulverwaltungssystemen (z.B. LDAP, SSO) implementieren
- [x] Skript `scripts/setup_school_integrations.sh` erstellt benötigte Konnektoren

### Milestone 3: Advanced Analytics Dashboard

 - [x] Dashboard mit aggregierten Lernmetriken und Exportfunktion
 - [x] Skript `scripts/generate_analytics_data.sh` erstellt Demo-Datensätze

### Milestone 4: B2B Features

- [x] Organisations-Accounts und Rollenverwaltung einführen
- [x] Skript `scripts/create_sample_organizations.sh` legt Beispiel-Organisationen an

# Mrs-Unkwn Entwicklungsroadmap - Phase 4 (Monate 19-24)

## Phase 4: Platform Evolution

### Milestone 1: Drittanbieter-API
- [x] Öffentliche API-Endpunkte und Authentifizierung mit API-Schlüsseln
- [x] Developer-Portal und Rate-Limiting implementieren

### Milestone 2: API-Dokumentation & Beispielskripte
- [x] Dokumentation der Drittanbieter-API erweitern
- [x] Beispielskript zur Nutzung des Developer-Portals erstellen

### Milestone 3: Automatisierte API-Tests
- [x] Tests der externen Endpunkte mit gültigem und ungültigem API-Key
- [x] NPM-Skript `test:external` zum Ausführen der Tests hinzufügen

### Milestone 4: Client-SDK für Drittanbieter-API
- [x] JavaScript-SDK mit Beispielaufrufen bereitstellen
- [x] TypeScript-Typdefinitionen veröffentlichen

# Mrs-Unkwn Entwicklungsroadmap - Phase 5 (Monate 25-30)

## Phase 5: Personalisiertes Lernen & Gamification

### Milestone 1: Gamification Engine
- [x] Gamification-Engine zur Motivation der Lernenden implementieren
- [x] Skript `scripts/generate_badge_assets.sh` erzeugt Badge-Icons automatisch

### Milestone 2: Adaptive Learning Paths
- [x] KI-gestützte Lernpfade basierend auf Nutzerleistung entwickeln
- [x] Skript `scripts/train_adaptive_model.sh` erstellt und trainiert notwendige Modelle

### Milestone 3: Projektabschluss & Review
- [x] Abschlussüberprüfung, Dokumentationsabgleich und Code-Checks

# Wartungsmodus
- [x] Wartungscheck am 2025-08-14: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-15: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-16: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-17: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-18: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-19: Tests (`npm test`, `pytest codex/tests`) erfolgreich

- [x] Wartungscheck am 2025-08-20: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-21: Tests (`npm test`, `pytest codex/tests`) erfolgreich

- [x] Wartungscheck am 2025-08-22: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-23: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-24: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-25: Tests (`npm test`, `pytest codex/tests`) erfolgreich

- [x] Wartungscheck am 2025-08-26: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-27: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-28: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-29: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-30: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-08-31: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-09-01: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-09-02: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-09-03: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-09-04: Tests (`npm test`, `pytest codex/tests`) erfolgreich
- [x] Wartungscheck am 2025-09-05: Tests (`npm test`, `pytest codex/tests`) erfolgreich
