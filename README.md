# Cassette Futurism — KDE Plasma rice

Retro-analog tech aesthetic (amber CRT terminal dark mode / beige industrial
light mode) for KDE Plasma 6, built on Fedora KDE.

## What's included

- **Color schemes** (`color-schemes/`) — `CassetteFuturismDark` (amber on
  near-black) and `CassetteFuturismLight` (rust/burnt-orange on warm beige).
- **Wallpapers** (`wallpapers/`) — dark variant is a retro amber-lit sci-fi
  corridor ([source](https://wallhaven.cc/w/gwdgrd)), light variant is an
  isometric grid of vintage pastel Macintoshes
  ([source](https://wallhaven.cc/w/2y77v9)), both from Wallhaven. An
  alternate dark wallpaper (green-toned retro office,
  [source](https://wallhaven.cc/w/qroq77)) is kept in `wallpapers/alt/` if
  you want to swap it in.
- **Icons** — [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
  with folders recolored to orange via
  [papirus-folders](https://github.com/PapirusDevelopmentTeam/papirus-folders).
  Not vendored here (fetched by the installer); only the folder-color choice
  is baked into the script.
- **Cursor** —
  [Bibata Original Amber](https://github.com/ful1e5/Bibata_Cursor). Not
  vendored; fetched by the installer.
- **Fonts** (`fonts/`) — Space Mono (UI/system font) and VT323 (terminal/CRT
  display font), both Google Fonts (OFL licensed).
- **Konsole** (`konsole/`) — existing terminal profile/colorscheme, kept here
  for convenience so a fresh install doesn't lose it.
- **Global Theme** (`look-and-feel/`) — two Plasma "Look and Feel" packages
  (`com.hcristosm.cassettefuturism.dark`/`.light`) that bundle the color
  scheme, wallpaper, icon theme and cursor together so they show up as
  single selectable entries in System Settings → Appearance → Global Theme.

## Install (fresh Fedora KDE system)

```sh
git clone https://github.com/<your-user>/dotfiles-cassette-futurism.git
cd dotfiles-cassette-futurism
./install.sh
```

The script installs everything to `~/.local/share/...` (no root needed),
applies the dark variant, and reloads Plasma config. Log out/in afterwards so
the cursor theme applies everywhere.

## Switching light/dark

The easiest way: **System Settings → Appearance → Global Theme**, pick
"Cassette Futurism Dark" or "Cassette Futurism Light", click Apply — this
switches colors, wallpaper, icons and cursor together.

Or from the command line:

```sh
# dark (default)
plasma-apply-colorscheme CassetteFuturismDark
plasma-apply-wallpaperimage ~/.local/share/wallpapers/CassetteFuturismDark/contents/images/3840x2160.png
kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Dark

# light
plasma-apply-colorscheme CassetteFuturismLight
plasma-apply-wallpaperimage ~/.local/share/wallpapers/CassetteFuturismLight/contents/images/5328x3000.jpg
kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Light
```

Then re-run `kbuildsycoca6 --noincremental` or log out/in.

## Notes

- Built for Plasma 6.7 on Fedora 44. `plasma-apply-colorscheme`,
  `plasma-apply-wallpaperimage`, and `kwriteconfig6` are part of
  `plasma-workspace`; no extra packages beyond `curl` and `tar` are required
  to run the installer.
- Wallpapers are third-party images from Wallhaven, used here for personal
  desktop background use only — check the source links above before any
  other kind of redistribution.
