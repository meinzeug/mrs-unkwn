# Nächster Schritt: Phase 1 – `Express Server Basis-Konfiguration`

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

## Referenzen
- `/README.md`
- `/codex/AGENTS.md`
- `/codex/daten/roadmap.md`
- `/codex/daten/changelog.md`

## Nächste Aufgabe: `Express Server Basis-Konfiguration`

### Vorbereitungen
- Navigiere zum Projekt-Root `backend/`.

### Implementierungsschritte
- In `src/index.ts` benötigte Module importieren: `express`, `cors`, `helmet`, `morgan`.
- Express-App Instanz `const app = express()` erstellen.
- Middleware konfigurieren: `app.use(cors())`, `app.use(helmet())`, `app.use(morgan('combined'))`, `app.use(express.json())`.
- Port definieren: `const PORT = process.env.PORT || 3000`.
- Server starten: `app.listen(PORT, callback)`.
- Health-Check-Endpoint `app.get('/health', handler)` hinzufügen.

### Validierung
- `npx tsc --noEmit`
- `npx ts-node src/index.ts` (Server starten)
- In neuem Terminal: `curl http://localhost:3000/health`

### Selbstgenerierung
- Schreibe nach Abschluss dieses Schrittes automatisch den nächsten Prompt in `/codex/daten/prompt.md`.

*Hinweis: Codex kann keine Binärdateien mergen. Benötigte Dateien müssen durch Skripte generiert werden. Halte den Codeumfang dieses Sprints unter 500 Zeilen.*
