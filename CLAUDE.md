# public-lib

Public media assets served to WhatsApp dialogs (no PHI). `media/**` on the `qa`
branch is CI-synced to `gs://rarus-public-lib-prod-iac/qa/media/` on push.

## Video encoding standard (MANDATORY)

Every dialog clip committed under `media/dialog/` uses ONE encode standard:

**360p H.264, CRF 28, preset veryslow, AAC 48 kbps mono, +faststart**
(16:9 input comes out 640x360; ~130 kbps, streams on 3G, far under WhatsApp's 16 MB cap)

Never hand-roll ffmpeg flags. Run the routine instead:

```bash
scripts/shrink-video.sh input.mp4              # replace in place
scripts/shrink-video.sh input.mp4 output.mp4   # write elsewhere
```

If a clip needs different settings, change `scripts/shrink-video.sh` itself (one
standard for all clips), never a one-off command.

## Layout

`media/dialog/<LOOP>/<key>/<locale>.mp4` (e.g. `media/dialog/L-001/welcome/es.mp4`).
The dialog step's `videoAssetKey` is the path relative to `media/dialog/`,
filename included.
