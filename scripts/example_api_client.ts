/**
 * Beispielskript zur Verwendung der Drittanbieter-API.
 *
 * Das Skript erzeugt einen neuen API-Key über das Developer-Portal
 * und ruft anschließend einen Benutzerendpunkt mit diesem Schlüssel auf.
 * Es werden keine Binärdateien eingecheckt – benötigte Artefakte
 * entstehen erst beim Ausführen.
 */

import { randomUUID } from 'crypto';

const API_BASE = process.env.API_BASE_URL ?? 'http://localhost:3000';

async function createApiKey(partnerName: string): Promise<string> {
  const res = await fetch(`${API_BASE}/api/developer/keys`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ partnerName }),
  });

  if (!res.ok) {
    throw new Error(`Failed to create API key: ${res.status} ${res.statusText}`);
  }

  const data = (await res.json()) as { key: string };
  return data.key;
}

async function getUser(id: string, apiKey: string) {
  const res = await fetch(`${API_BASE}/api/external/users/${id}`, {
    headers: { 'x-api-key': apiKey },
  });

  if (!res.ok) {
    throw new Error(`Request failed: ${res.status} ${res.statusText}`);
  }

  return res.json();
}

async function main() {
  try {
    const partner = process.argv[2] ?? `example-${randomUUID()}`;
    const apiKey = await createApiKey(partner);
    console.log('Generated API key:', apiKey);

    const user = await getUser('1', apiKey);
    console.log('Fetched user:', user);
  } catch (err) {
    console.error('Example client failed:', err);
  }
}

main();

