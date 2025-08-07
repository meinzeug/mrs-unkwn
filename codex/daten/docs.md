# Projektunterlagen – Mrs-Unkwn

## Projektname
Mrs-Unkwn

## Hauptziel der Anwendung
AI-gestützte Family Learning Platform, die AI-Tutoring, Parental Control und Homework Detection kombiniert, um Eltern Transparenz über Lernaktivitäten ihrer Kinder zu geben.

## Technische Anforderungen
- Cross-Platform Apps: iOS, Android, Web, Windows, macOS, Linux
- Backend: Node.js mit Express und PostgreSQL
- Frontend: Flutter (mindestens Version 3.16.0)
- DSGVO-konforme Datenverarbeitung
- Adaptive Learning und Echtzeit-Analytics

## Spezielle Features
- Sokratische AI-Tutoring Engine
- Multi-Subject Support und Adaptive Learning
- Parental Control mit Device Monitoring und Alerts
- Homework Detection mit AI Content und Plagiate-Erkennung
- Community-Features für Eltern und Schüler

## Externe APIs & Frameworks
### OpenAI API
- Endpoint: https://api.openai.com/v1/chat/completions
- Authentifizierung via `OPENAI_API_KEY`
- Beispiel (Python):
```python
import openai
openai.api_key = "<OPENAI_API_KEY>"
openai.ChatCompletion.create(model="gpt-4o", messages=[{"role": "user", "content": "Hallo"}])
```

### Flutter Packages
- `dio` – HTTP Client
- `flutter_bloc` – State Management
- `get_it` – Dependency Injection
- `flutter_secure_storage` – sichere lokale Speicherung
- `go_router` – Routing
- `hive` – lokale Datenbank
- `json_annotation` – JSON Serialisierung

### Node.js Packages
- `express`, `cors`, `helmet`, `morgan`
- `dotenv` für Environment Variablen
- `bcrypt`, `jsonwebtoken`, `express-validator`

## Dependencies & Tools
- Flutter SDK ≥ 3.16.0
- Node.js ≥ 18
- PostgreSQL ≥ 14
- Git

