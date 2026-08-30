# Cassette Futurism — KDE Plasma rice

Retro-analog tech aesthetic (amber CRT terminal dark mode / beige industrial
light mode) for KDE Plasma 6, built on Fedora KDE.

## What's included

- **Color schemes** (`color-schemes/`) — `CassetteFuturismDark` (amber on
  near-black) and `CassetteFuturismLight` (rust/burnt-orange on warm beige).
- **Wallpapers** (`wallpapers/`) — matching retro-sun/perspective-grid SVG
  renders for each variant.
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

```sh
# dark (default)
plasma-apply-colorscheme CassetteFuturismDark
plasma-apply-wallpaperimage ~/.local/share/wallpapers/CassetteFuturismDark/contents/images/1920x1080.png
kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Dark

# light
plasma-apply-colorscheme CassetteFuturismLight
plasma-apply-wallpaperimage ~/.local/share/wallpapers/CassetteFuturismLight/contents/images/1920x1080.png
kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Light
```

Then re-run `kbuildsycoca6 --noincremental` or log out/in.

## Notes

- Built for Plasma 6.7 on Fedora 44. `plasma-apply-colorscheme`,
  `plasma-apply-wallpaperimage`, and `kwriteconfig6` are part of
  `plasma-workspace`; no extra packages beyond `curl` and `tar` are required
  to run the installer.
- Wallpaper source SVGs weren't kept — the shipped PNGs (1920x1080) are the
  only copies. Regenerate at higher resolution if needed.
