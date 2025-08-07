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
