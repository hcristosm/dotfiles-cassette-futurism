#!/bin/sh
# Cassette Futurism rice — installer for KDE Plasma
# Reproduces: color schemes, wallpapers, icons (monochrome YAMIS + Papirus
# fallback), cursor (Bibata Original Amber), fonts (Space Mono + VT323),
# konsole profile, panel layout (top status bar + trimmed bottom taskbar),
# and desktop widgets (weather for Guarulhos, BR + a date-only readout).
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

echo "==> Icons: Yet Another Monochrome Icon Set (YAMIS, active theme)"
mkdir -p "$DATA/icons"
rm -rf "$DATA/icons/yet-another-monochrome-icon-set"
cp -r "$DOTDIR"/icons/yet-another-monochrome-icon-set "$DATA/icons/"

echo "==> Icons: Papirus (fallback — YAMIS inherits from it for missing icons)"
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

echo "==> Global Theme entries (System Settings > Appearance > Global Theme)"
mkdir -p "$DATA/plasma/look-and-feel"
cp -r "$DOTDIR"/look-and-feel/com.hcristosm.cassettefuturism.dark "$DATA/plasma/look-and-feel/"
cp -r "$DOTDIR"/look-and-feel/com.hcristosm.cassettefuturism.light "$DATA/plasma/look-and-feel/"

echo "==> Widgets: Audio Wave Widget (fallback visualizer) + date-only readout"
mkdir -p "$DATA/plasma/plasmoids"
rm -rf "$DATA/plasma/plasmoids/Audio.Wave.Widget" "$DATA/plasma/plasmoids/com.hcristosm.cassettefuturism.datewidget"
cp -r "$DOTDIR"/plasmoids/Audio.Wave.Widget "$DATA/plasma/plasmoids/"
cp -r "$DOTDIR"/plasmoids/com.hcristosm.cassettefuturism.datewidget "$DATA/plasma/plasmoids/"
echo "  (optional: install Kurve for a nicer visualizer — see plasmoids/README.md)"

echo "==> Applying Plasma settings (dark variant by default)"
kwriteconfig6 --file kdeglobals --group Icons --key Theme yet-another-monochrome-icon-set
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

echo "==> Panel layout + desktop widgets (top bar, bottom taskbar, date, weather)"
if command -v qdbus-qt6 >/dev/null && pgrep -x plasmashell >/dev/null; then
  PANEL_SCRIPT='
var bottom = panels()[0];
var widgets = bottom.widgets();
var toRemove = [];
for (var i = 0; i < widgets.length; i++) {
    var t = widgets[i].type;
    if (t == "org.kde.plasma.digitalclock" || t == "org.kde.plasma.systemtray") {
        toRemove.push(widgets[i]);
    }
}
for (var i = 0; i < toRemove.length; i++) { toRemove[i].remove(); }

var top = new Panel();
top.location = "top";
top.height = 26;

var visualizer = top.addWidget("luisbocanegra.audio.visualizer");
if (!visualizer) {
    top.addWidget("Audio.Wave.Widget");
}
top.addWidget("org.kde.plasma.panelspacer");

var clock = top.addWidget("org.kde.plasma.digitalclock");
clock.currentConfigGroup = ["Appearance"];
clock.writeConfig("showDate", false);

top.addWidget("org.kde.plasma.panelspacer");
top.addWidget("org.kde.plasma.systemtray");

var d = desktopsForActivity(currentActivity())[0];

var weatherWidget = d.addWidget("org.kde.plasma.weather");
weatherWidget.geometry = { x: 16, y: 0, width: 368, height: 352 };
weatherWidget.currentConfigGroup = ["WeatherStation"];
weatherWidget.writeConfig("provider", "bbcukmet");
weatherWidget.writeConfig("placeDisplayName", "Guarulhos, Brazil, BR");
weatherWidget.writeConfig("placeInfo", "Guarulhos, Brazil, BR|3461786");

var dateWidget = d.addWidget("com.hcristosm.cassettefuturism.datewidget");
dateWidget.geometry = { x: 16, y: 352, width: 368, height: 112 };
'
  qdbus-qt6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$PANEL_SCRIPT"
  kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
else
  echo "  (plasmashell not running / qdbus-qt6 missing — skipped; log in and re-run this script, or apply the Global Theme from System Settings, which reproduces the same layout)"
fi

echo "==> Restarting plasmashell so icons/cursor apply without logging out"
if pgrep -x plasmashell >/dev/null; then
  QML_IMPORT_PATH="$HOME/.local/lib64/qml:$HOME/.local/lib/qml:$QML_IMPORT_PATH" sh -c '
    kquitapp6 plasmashell
    sleep 2
    nohup plasmashell >/dev/null 2>&1 &
  '
fi

echo ""
echo "Done. Log out/in if the cursor theme doesn't fully apply everywhere yet."
echo "To switch to the light variant:"
echo "  plasma-apply-colorscheme CassetteFuturismLight"
echo "  plasma-apply-wallpaperimage $DATA/wallpapers/CassetteFuturismLight/contents/images/5328x3000.jpg"
echo "  (icon theme stays yet-another-monochrome-icon-set for both variants — it self-adapts)"
