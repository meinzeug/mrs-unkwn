import { Router } from 'express';
import { apiKeyService } from '../services/apiKey.service';

const router = Router();

router.get('/', async (_req, res) => {
  const keys = await apiKeyService.listKeys();
  const rows = keys
    .map(
      k => `<tr><td>${k.partner_name}</td><td>${k.key}</td><td>${k.revoked}</td></tr>`,
    )
    .join('');
  res.send(`<!DOCTYPE html><html><head><title>Developer Portal</title></head><body><h1>API Keys</h1><table border="1"><tr><th>Partner</th><th>Key</th><th>Revoked</th></tr>${rows}</table><h2>Create Key</h2><form id="createForm"><input name="partner" placeholder="Partner Name"/><button type="submit">Create</button></form><script>document.getElementById('createForm').addEventListener('submit',async e=>{e.preventDefault();const partner=e.target.partner.value;const res=await fetch('/api/developer/keys',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({partnerName:partner})});const data=await res.json();alert('Key: '+data.data.key);location.reload();});</script></body></html>`);
});

router.get('/keys', async (_req, res) => {
  const keys = await apiKeyService.listKeys();
  res.success(keys);
});

router.post('/keys', async (req, res) => {
  const { partnerName } = req.body;
  if (!partnerName) {
    res.error('partnerName required', 400);
    return;
  }
  const key = await apiKeyService.generateKey(partnerName);
  res.success({ key });
});

router.post('/keys/:key/revoke', async (req, res) => {
  await apiKeyService.revokeKey(req.params.key);
  res.success({ revoked: true });
});

export default router;
