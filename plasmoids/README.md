# Plasmoids

## Vendored (installed automatically by `install.sh`)

- **`Audio.Wave.Widget`** — [Audio Wave Widget](https://github.com/zayronxio/Audio-Wave-Widget)
  by zayronxio (GPLv3). MPRIS track info + a 9-band FFT visualizer. Ships a
  prebuilt x86-64 binary that talks to ALSA/D-Bus directly — no build step,
  works as long as `libasound.so.2` / `libdbus-1.so.3` exist (default on
  Fedora KDE). Used as a fallback if Kurve (below) isn't installed.
- **`com.hcristosm.cassettefuturism.datewidget`** — small custom plasmoid
  (source in this repo) that shows weekday + day + month + year, no clock
  face. Self-themes off `Kirigami.Theme.highlightColor`/`textColor`, so it
  follows whichever Global Theme (Dark/Light) is active.
- **`com.hcristosm.cassettefuturism.globewidget`** — slow-spinning wireframe
  globe (eDEX-UI inspired), with an optional satellite overlay (ISS, Hubble,
  Tiangong) via the free [N2YO](https://www.n2yo.com/api/) API. **Not**
  added to the baked panel/desktop layout — install it and add it yourself
  via *Add Widgets* if you want it, since desktop placement is a personal
  choice this repo doesn't want to force.

  Deliberately built cheap: plain 2D `Canvas` at ~5-6fps (no OpenGL), static
  precomputed continent data (no runtime parsing), and satellite positions
  fetched via QML's built-in `XMLHttpRequest` on a timer — default every 10
  minutes, configurable in the widget's settings, never per-frame. No
  spawned processes. This is a direct reaction to two things this repo
  almost shipped: `Audio.Wave.Widget`'s 25ms `dbus-monitor` polling loop,
  and Kurve's continuous OpenGL rendering (which was traced to real Chrome
  GPU-process crashes on this machine). Leave the API key empty for a
  decorative-only globe with no network activity at all.

## Optional: Kurve (audio visualizer, preferred)

The panel layout defaults to
[Kurve](https://github.com/luisbocanegra/kurve) by luisbocanegra (formerly
`plasma-audio-visualizer`) instead of Audio Wave Widget — more visualizer
styles, CAVA-powered. It's **not vendored** because it needs a native Qt/KF6
build with system dependencies:

```sh
sudo dnf install -y git gcc-c++ cmake extra-cmake-modules libplasma-devel \
  cava qt6-qtwebsockets-devel python3-websockets \
  kf6-kcoreaddons-devel kf6-kconfig-devel kf6-ki18n-devel \
  kf6-kdeclarative-devel kf6-kguiaddons-devel \
  qt6-qtdeclarative-devel qt6-qtbase-devel

git clone https://github.com/luisbocanegra/kurve.git
cd kurve

# widget itself
cmake -B build/plasmoid -S . -DINSTALL_PLASMOID=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local"
cmake --build build/plasmoid
cmake --install build/plasmoid
chmod 700 "$HOME/.local/share/plasma/plasmoids/luisbocanegra.audio.visualizer/contents/ui/tools/commandMonitor"

# C++ QML plugin (process monitor), installed user-local — no sudo needed
cmake -B build/plugin -S . -DBUILD_PLUGIN=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local"
cmake --build build/plugin
cmake --install build/plugin

mkdir -p ~/.config/plasma-workspace/env
echo 'export QML_IMPORT_PATH="$HOME/.local/lib64/qml:$HOME/.local/lib/qml:$QML_IMPORT_PATH"' \
  >> ~/.config/plasma-workspace/env/path.sh
chmod +x ~/.config/plasma-workspace/env/path.sh
```

Log out/in afterwards (or `kquitapp6 plasmashell && plasmashell &` with
`QML_IMPORT_PATH` exported in that shell) so the new QML import path takes
effect. If Kurve isn't installed, the Global Theme's layout script falls
back to Audio Wave Widget automatically.
