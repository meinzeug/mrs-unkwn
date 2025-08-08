# Drittanbieter API

## Authentifizierung
Alle Anfragen müssen den Header `x-api-key` mit einem gültigen Schlüssel enthalten.

## Endpunkte
- `GET /api/external/health` – Prüft den API-Status.
- `GET /api/external/users/:id` – Liefert Basisinformationen zu einem Benutzer.

## Developer-Portal
- `GET /api/developer` – Einfache Oberfläche zur Verwaltung von API-Schlüsseln.
- `GET /api/developer/keys` – Liste aller Schlüssel.
- `POST /api/developer/keys` – Erstellt einen neuen Schlüssel (`{ partnerName }`).
- `POST /api/developer/keys/:key/revoke` – Widerruft einen Schlüssel.

## Rate Limiting
Alle externen Endpunkte sind auf 100 Anfragen pro Minute begrenzt. Für Tests kann dies über die Umgebungsvariable `RATE_LIMIT_MAX` angepasst werden.

Weitere Endpunkte folgen.
