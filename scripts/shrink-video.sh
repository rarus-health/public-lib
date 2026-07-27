#!/usr/bin/env bash
# shrink-video.sh -- re-encode a dialog clip to the Rarus WhatsApp standard.
#
# THE standard (do not improvise new settings; change them here or nowhere):
#   360p H.264, CRF 28, preset veryslow, AAC 48 kbps mono, +faststart
#
# Established in public-lib commit f8ab3e8 ("media: shrink dialog videos again
# for cellular loading"): talking-head content stays sharp at phone size,
# streams at ~130 kbps (smooth on 3G), and lands far under WhatsApp's 16 MB
# media cap. 16:9 input comes out exactly 640x360; other aspect ratios keep
# their proportions at 360p height (no distortion, no padding).
#
# Usage:
#   scripts/shrink-video.sh input.mp4              # replace input in place
#   scripts/shrink-video.sh input.mp4 output.mp4   # write to output
#
# Requires ffmpeg (brew install ffmpeg).

set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "usage: $0 input.mp4 [output.mp4]" >&2
  exit 1
fi

in="$1"
out="${2:-$in}"

if [[ ! -f "$in" ]]; then
  echo "error: input not found: $in" >&2
  exit 1
fi

before=$(stat -f%z "$in" 2>/dev/null || stat -c%s "$in")

tmp="$(mktemp -t shrink-video).mp4"
trap 'rm -f "$tmp"' EXIT

ffmpeg -hide_banner -loglevel error -i "$in" \
  -c:v libx264 -crf 28 -preset veryslow -vf "scale=-2:360" \
  -c:a aac -b:a 48k -ac 1 \
  -movflags +faststart \
  -y "$tmp"

mv "$tmp" "$out"
trap - EXIT

after=$(stat -f%z "$out" 2>/dev/null || stat -c%s "$out")
printf '%s: %d -> %d bytes (%d%% of original)\n' \
  "$out" "$before" "$after" $(( after * 100 / before ))

if (( after >= 16000000 )); then
  echo "WARNING: $out is >=16 MB -- WhatsApp will reject it. Trim or split the clip." >&2
  exit 2
fi
