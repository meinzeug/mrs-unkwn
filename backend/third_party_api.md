# Drittanbieter API

## Authentifizierung
Alle Anfragen müssen den Header `x-api-key` mit einem gültigen Schlüssel enthalten. Schlüssel können über das Developer-Portal generiert werden.

### API-Key erstellen
`POST /api/developer/keys`

Body:
```json
{ "partnerName": "Acme Corp" }
```

Antwort:
```json
{ "key": "GENERATED_KEY" }
```

## Endpunkte
- `GET /api/external/health` – Prüft den API-Status.
- `GET /api/external/users/:id` – Liefert Basisinformationen zu einem Benutzer.

### Beispielaufrufe
```bash
# Gesundheitscheck
curl -H "x-api-key: <API_KEY>" http://localhost:3000/api/external/health

# Benutzer abrufen
curl -H "x-api-key: <API_KEY>" http://localhost:3000/api/external/users/123
```

## Fehlercodes
- `401 Unauthorized` – Fehlender oder ungültiger API-Key.
- `404 Not Found` – Ressource existiert nicht.
- `429 Too Many Requests` – Rate Limit überschritten.

## Developer-Portal
- `GET /api/developer` – Einfache Oberfläche zur Verwaltung von API-Schlüsseln.
- `GET /api/developer/keys` – Liste aller Schlüssel.
- `POST /api/developer/keys` – Erstellt einen neuen Schlüssel (`{ partnerName }`).
- `POST /api/developer/keys/:key/revoke` – Widerruft einen Schlüssel.

## Rate Limiting
Alle externen Endpunkte sind auf 100 Anfragen pro Minute begrenzt. Für Tests kann dies über die Umgebungsvariable `RATE_LIMIT_MAX` angepasst werden.

## Beispielskript
Führe `ts-node scripts/example_api_client.ts` aus, um API-Key-Erstellung und Anfragen zu demonstrieren. Das Skript erzeugt alle benötigten Artefakte automatisch; es werden keine Binärdateien im Repository gespeichert.

## Client SDK
Das Skript `scripts/build_sdk.sh` erzeugt das JavaScript-SDK sowie die zugehörigen TypeScript-Typdefinitionen (`.d.ts`) im Verzeichnis `backend/sdk/dist`. Die generierten Dateien werden nicht versioniert und müssen vor der Verwendung erstellt werden.

Weitere Endpunkte folgen.

