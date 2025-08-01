#!/bin/bash

# Wrapper for running PiShrink inside Docker
# Usage:
#   ./run-pishrink.sh path/to/image.img         (no compression)
#   ./run-pishrink.sh path/to/image.img --xz    (with xz compression)

# --- Argument Parsing ---
if [ -z "$1" ]; then
    echo "❌ Usage: $0 <path-to-image.img> [--xz]"
    exit 1
fi

IMG_PATH="$1"
COMPRESS=false

if [ "$2" == "--xz" ]; then
    COMPRESS=true
fi

ABS_PATH="$(cd "$(dirname "$IMG_PATH")" && pwd)"
IMG_FILE="$(basename "$IMG_PATH")"

# --- File Check ---
if [ ! -f "$IMG_PATH" ]; then
    echo "❌ File not found: $IMG_PATH"
    exit 1
fi

# --- PiShrink Options ---
PISHRINK_OPTS=""
if $COMPRESS; then
    echo "📦 Enabling xz compression with multithreading"
    PISHRINK_OPTS="$PISHRINK_OPTS -Z -a"
fi

# --- Run PiShrink ---
echo "🚀 Running PiShrink on: $IMG_FILE"
docker run --rm --privileged -v /dev:/dev -v "$ABS_PATH:/data" pishrink $PISHRINK_OPTS -n "$IMG_FILE"

# --- Check Output (if xz enabled) ---
if $COMPRESS && [ ! -f "$ABS_PATH/$IMG_FILE.xz" ]; then
    echo "❌ Compression failed – output .xz not found."
    exit 1
fi

echo "✅ Done!"
exit 0
