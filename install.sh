#!/bin/sh
# Cassette Futurism rice — installer for KDE Plasma
# Reproduces: color schemes, wallpapers, icons (Papirus + orange folders),
# cursor (Bibata Original Amber), fonts (Space Mono + VT323), konsole profile.
set -e

DOTDIR="$(cd "$(dirname "$0")" && pwd)"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"

echo "==> Color schemes"
mkdir -p "$DATA/color-schemes"
cp "$DOTDIR"/color-schemes/*.colors "$DATA/color-schemes/"

echo "==> Wallpapers"
mkdir -p "$DATA/wallpapers"
cp -r "$DOTDIR"/wallpapers/CassetteFuturismDark "$DATA/wallpapers/"
cp -r "$DOTDIR"/wallpapers/CassetteFuturismLight "$DATA/wallpapers/"

echo "==> Fonts (Space Mono + VT323)"
mkdir -p "$DATA/fonts"
cp "$DOTDIR"/fonts/*.ttf "$DATA/fonts/"
fc-cache -f "$DATA/fonts" >/dev/null

echo "==> Icons: Papirus"
TMP="$(mktemp -d)"
DESTDIR="$DATA/icons" sh -c "$(curl -sL https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install.sh)"

echo "==> Recoloring Papirus folders to orange/amber"
curl -sL https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders -o "$TMP/papirus-folders"
chmod +x "$TMP/papirus-folders"
"$TMP/papirus-folders" -t Papirus-Dark -C orange -u
"$TMP/papirus-folders" -t Papirus-Light -C orange -u
"$TMP/papirus-folders" -t Papirus -C orange -u

echo "==> Cursor: Bibata Original Amber"
curl -sL https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Original-Amber.tar.xz -o "$TMP/bibata.tar.xz"
tar -xf "$TMP/bibata.tar.xz" -C "$TMP"
rm -rf "$DATA/icons/Bibata-Original-Amber"
mv "$TMP/Bibata-Original-Amber" "$DATA/icons/"
rm -rf "$TMP"

echo "==> Konsole profile"
mkdir -p "$DATA/konsole"
cp "$DOTDIR"/konsole/*.profile "$DATA/konsole/" 2>/dev/null || true
cp "$DOTDIR"/konsole/*.colorscheme "$DATA/konsole/" 2>/dev/null || true

echo "==> Applying Plasma settings (dark variant by default)"
kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Dark
kwriteconfig6 --file kcminputrc --group Mouse --key cursorTheme Bibata-Original-Amber
kwriteconfig6 --file kcminputrc --group Mouse --key cursorSize 24
kwriteconfig6 --file kdeglobals --group General --key font "Space Mono,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key fixed "Space Mono,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key smallestReadableFont "Space Mono,8,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key toolBarFont "Space Mono,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kdeglobals --group General --key menuFont "Space Mono,10,-1,5,50,0,0,0,0,0"
kwriteconfig6 --file kwinrc --group WindowTitleBar --key Font "Space Mono,10,-1,5,63,0,0,0,0,0"

plasma-apply-colorscheme CassetteFuturismDark
plasma-apply-wallpaperimage "$DATA/wallpapers/CassetteFuturismDark/contents/images/3840x2160.png"

kbuildsycoca6 --noincremental >/dev/null 2>&1 || true

echo ""
echo "Done. Log out/in for the cursor theme to fully apply everywhere."
echo "To switch to the light variant:"
echo "  plasma-apply-colorscheme CassetteFuturismLight"
echo "  plasma-apply-wallpaperimage $DATA/wallpapers/CassetteFuturismLight/contents/images/5328x3000.jpg"
echo "  kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Light"
