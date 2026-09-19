#!/usr/bin/env bash
# Clean up scanned/photographed images (denoise, deblur, descan) without
# the GAN hallucination artifacts that RealESRGAN_x4plus introduces.
# Uses realesr-general-x4v3, which testing showed does not invent fake
# blocky texture the way the GAN models do.
#
# Usage:
#   scripts/clean_scan.sh <input file or dir> [output dir] [denoise 0-1] [outscale]
#
# Examples:
#   scripts/clean_scan.sh ~/Downloads/photo.jpg
#   scripts/clean_scan.sh ~/Downloads/photo.jpg ~/Desktop/cleaned 0.3
#   scripts/clean_scan.sh ~/Downloads/scans ~/Desktop/cleaned 1.0 2
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

INPUT="${1:?usage: clean_scan.sh <input> [output_dir] [denoise 0-1] [outscale]}"
OUTPUT="${2:-$HOME/Desktop/cleaned}"
DENOISE="${3:-1.0}"
OUTSCALE="${4:-1}"

source "$SCRIPT_DIR/.venv/bin/activate"

python "$SCRIPT_DIR/inference_realesrgan.py" \
  -n realesr-general-x4v3 \
  -dn "$DENOISE" \
  -i "$INPUT" \
  -o "$OUTPUT" \
  --outscale "$OUTSCALE" \
  --tile 400

echo "Done. Output in: $OUTPUT"
