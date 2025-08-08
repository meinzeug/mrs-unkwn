import { request as httpsRequest } from 'https';
import { request as httpRequest } from 'http';
import { URL } from 'url';

export interface HealthResponse {
  status: string;
}

export class ThirdPartyApiClient {
  constructor(private baseUrl: string, private apiKey: string) {}

  async healthCheck(): Promise<HealthResponse> {
    const url = new URL('/api/external/health', this.baseUrl);
    const requester = url.protocol === 'https:' ? httpsRequest : httpRequest;
    return new Promise((resolve, reject) => {
      const req = requester(
        url,
        {
          method: 'GET',
          headers: { 'x-api-key': this.apiKey },
        },
        res => {
          let data = '';
          res.on('data', chunk => (data += chunk));
          res.on('end', () => {
            if (res.statusCode && res.statusCode >= 200 && res.statusCode < 300) {
              try {
                resolve(JSON.parse(data) as HealthResponse);
              } catch {
                reject(new Error('Invalid JSON in health check response'));
              }
            } else {
              reject(new Error(`Request failed with status ${res.statusCode}`));
            }
          });
        }
      );
      req.on('error', reject);
      req.end();
    });
  }
}
