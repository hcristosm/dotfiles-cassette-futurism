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
- **Icons** (`icons/yet-another-monochrome-icon-set/`) — vendored copy of
  [Yet Another Monochrome Icon Set](https://bitbucket.org/dirn-typo/yet-another-monochrome-icon-set)
  (YAMIS) by dirn-typo (GPLv3): pure black/white, shape-only icons that
  auto-invert per background (`FollowsColorScheme=true`) — one icon theme
  covers both the dark and light variant. It inherits from
  [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
  (installed by the script, folders recolored orange via
  [papirus-folders](https://github.com/PapirusDevelopmentTeam/papirus-folders))
  as a fallback for any icon it doesn't have.
- **Cursor** —
  [Bibata Original Amber](https://github.com/ful1e5/Bibata_Cursor). Not
  vendored; fetched by the installer.
- **Fonts** (`fonts/`) — Space Mono (UI/system font) and VT323 (terminal/CRT
  display font), both Google Fonts (OFL licensed).
- **Konsole** (`konsole/`) — existing terminal profile/colorscheme, kept here
  for convenience so a fresh install doesn't lose it.
- **Global Theme** (`look-and-feel/`) — two Plasma "Look and Feel" packages
  (`com.hcristosm.cassettefuturism.dark`/`.light`) that bundle the color
  scheme, wallpaper, icon theme, cursor and panel layout together so they
  show up as single selectable entries in System Settings → Appearance →
  Global Theme.
- **Panel layout** — thin top bar (audio visualizer on the left, clock —
  time only, no date — dead center between two spacers, system tray on the
  right) plus a bottom panel trimmed to launcher/pager/taskbar only. Baked
  into the Global Theme packages' `layouts/org.kde.plasma.desktop-layout.js`,
  and also applied directly by `install.sh` via `qdbus-qt6`.
- **Desktop widgets** — a weather widget (BBC provider, preconfigured for
  Guarulhos, SP) stacked above a small custom date-only readout (weekday +
  day + month + year, no clock face — self-themed off the active color
  scheme's highlight/text colors). Both positioned top-left, also baked into
  the layout script.
- **Widgets** (`plasmoids/`) — see `plasmoids/README.md` for details on
  each: the vendored `Audio.Wave.Widget` (fallback visualizer),
  `com.hcristosm.cassettefuturism.datewidget` (the date-only readout,
  vendored), and optional **Kurve** (preferred visualizer, not vendored —
  needs a native build, instructions in that file).

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

# light
plasma-apply-colorscheme CassetteFuturismLight
plasma-apply-wallpaperimage ~/.local/share/wallpapers/CassetteFuturismLight/contents/images/5328x3000.jpg
```

The icon theme (`yet-another-monochrome-icon-set`) doesn't need to change
between variants — it self-adapts. Then re-run `kbuildsycoca6 --noincremental`
or log out/in.

## Notes

- Built for Plasma 6.7 on Fedora 44. `plasma-apply-colorscheme`,
  `plasma-apply-wallpaperimage`, and `kwriteconfig6` are part of
  `plasma-workspace`; no extra packages beyond `curl` and `tar` are required
  to run the installer.
- Wallpapers are third-party images from Wallhaven, used here for personal
  desktop background use only — check the source links above before any
  other kind of redistribution.
- Weather location is hardcoded to Guarulhos, SP — edit the `writeConfig`
  calls in the layout scripts (or just reconfigure the widget) if you move.
