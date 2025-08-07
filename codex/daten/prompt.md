# Nächster Schritt: Phase 1 – `Secure Storage Service implementieren`

## Status
- Phase 0 abgeschlossen ✓
- Flutter SDK installiert (3.32.8)
- `pubspec.yaml` mit Dependencies konfiguriert
- Material App Grundstruktur implementiert
- Core-Ordnerstruktur mit Basis-Klassen erstellt ✓
- Dependency Injection mit GetIt eingerichtet ✓
- Flutter BLoC Basisklassen implementiert ✓
- HTTP Client mit Dio konfiguriert ✓

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Secure Storage Service implementieren`

### Vorbereitungen
- Navigiere zu `flutter_app/mrs_unkwn_app/lib/core`.

### Implementierungsschritte
- Erstelle `storage/secure_storage_service.dart` mit `SecureStorageService` Singleton.
- Verwende `FlutterSecureStorage` mit `encryptedSharedPreferences: true` für Android.
- Implementiere Methoden:
  - `Future<void> store(String key, String value)`
  - `Future<String?> read(String key)`
  - `Future<void> delete(String key)`
  - `Future<void> deleteAll()`
- Definiere Konstanten für Storage-Keys `TOKEN_KEY`, `REFRESH_TOKEN_KEY`, `USER_DATA_KEY`.

### Validierung
- `ls flutter_app/mrs_unkwn_app/lib/core/storage`
- `grep -n "class SecureStorageService" flutter_app/mrs_unkwn_app/lib/core/storage/secure_storage_service.dart`

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md`.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
