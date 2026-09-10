#!/usr/bin/env bash
# Regenere toutes les icones de l'application a partir du logo OLSx.
#
# A lancer en local uniquement, apres avoir change le logo source. Les
# fichiers produits sont versionnes, la CI n'a donc aucune dependance image.
#
# Sources attendues dans branding/assets/ :
#   logo-square.png   carre, 1024x1024, fond transparent -> icone de l'app
#   logo-wide.png     optionnel, bandeau affiche dans l'interface
#
# Dependance : ImageMagick (paquet imagemagick).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

SQUARE="branding/assets/logo-square.png"
WIDE="branding/assets/logo-wide.png"

command -v convert >/dev/null || { echo "ImageMagick absent : sudo apt install imagemagick" >&2; exit 1; }
[ -f "$SQUARE" ] || { echo "$SQUARE manquant" >&2; exit 1; }

gen() { convert "$SQUARE" -resize "${2}x${2}" -background none -gravity center -extent "${2}x${2}" "$1"; echo "  $1 (${2}px)"; }

echo "Icones de l'application :"
gen res/32x32.png 32
gen res/64x64.png 64
gen res/128x128.png 128
gen "res/128x128@2x.png" 256
gen res/icon.png 512
gen res/mac-icon.png 1024
gen flutter/assets/icon.png 512

echo "Icone Windows :"
convert "$SQUARE" -define icon:auto-resize=256,128,64,48,32,16 res/icon.ico
cp res/icon.ico flutter/windows/runner/resources/app_icon.ico
echo "  res/icon.ico et flutter/windows/runner/resources/app_icon.ico"

echo "Icone macOS :"
# ImageMagick n'a pas toujours le delegue ICNS et ecrit alors un PNG renomme,
# que macOS refuse. On empaquete donc le conteneur nous-memes : un ICNS moderne
# n'est qu'une suite de PNG precedes de leur type et de leur taille.
TMPICNS="$(mktemp -d)"
trap 'rm -rf "$TMPICNS"' EXIT
for size in 16 32 64 128 256 512 1024; do
  convert "$SQUARE" -resize "${size}x${size}" -background none -gravity center \
    -extent "${size}x${size}" "$TMPICNS/$size.png"
done
python3 branding/pack-icns.py "$TMPICNS" flutter/macos/Runner/AppIcon.icns

echo "Bandeau de l'interface :"
if [ -f "$WIDE" ]; then
  cp "$WIDE" flutter/assets/logo.png
  echo "  flutter/assets/logo.png"
else
  cp flutter/assets/icon.png flutter/assets/logo.png
  echo "  flutter/assets/logo.png (repli sur l'icone carree, fournir logo-wide.png pour mieux faire)"
fi

echo
echo "Restent en SVG, a refaire a la main si besoin : res/logo.svg, res/design.svg, flutter/assets/icon.svg"
