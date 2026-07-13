# media/

Public media assets served to WhatsApp (dialog videos, etc.). **No PHI.**

On every push to `qa` touching `media/**`, CI syncs this tree to
`gs://rarus-public-lib-prod-iac/qa/media/` (see `.github/workflows/sync-media.yml`).
Dialog steps resolve clips as:

```
https://storage.googleapis.com/rarus-public-lib-prod-iac/qa/media/dialog/<videoAssetKey>/<locale>.mp4
```

Layout: `media/dialog/<LOOP>/<key>/<locale>.mp4`, e.g. `media/dialog/L-001/welcome/es.mp4`.
Keep clips ≤16 MB so WhatsApp plays them inline.
