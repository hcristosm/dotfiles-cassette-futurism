loadTemplate("org.kde.plasma.desktop.defaultPanel")

var desktopsArray = desktopsForActivity(currentActivity());
for (var j = 0; j < desktopsArray.length; j++) {
    desktopsArray[j].wallpaperPlugin = 'org.kde.image';
}

// Cassette Futurism panel layout: thin status bar on top, bottom panel
// keeps launcher / pager / taskbar only.
var bottom = panels()[0];
var widgets = bottom.widgets();
var toRemove = [];
for (var i = 0; i < widgets.length; i++) {
    var t = widgets[i].type;
    if (t == "org.kde.plasma.digitalclock" || t == "org.kde.plasma.systemtray") {
        toRemove.push(widgets[i]);
    }
}
for (var i = 0; i < toRemove.length; i++) {
    toRemove[i].remove();
}

// Top bar: audio visualizer on the left, clock (time only, no date)
// dead center between two expanding spacers, system tray on the right.
// "luisbocanegra.audio.visualizer" is Kurve — optional, needs cava + a
// compiled QML plugin, see plasmoids/README.md. Falls back to the
// vendored Audio.Wave.Widget if Kurve isn't installed.
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

// Desktop widgets: weather (top-left) and a date-only readout right below it.
var d = desktopsArray[0];

var weatherWidget = d.addWidget("org.kde.plasma.weather");
weatherWidget.geometry = { x: 16, y: 0, width: 368, height: 352 };
weatherWidget.currentConfigGroup = ["WeatherStation"];
weatherWidget.writeConfig("provider", "bbcukmet");
weatherWidget.writeConfig("placeDisplayName", "Guarulhos, Brazil, BR");
weatherWidget.writeConfig("placeInfo", "Guarulhos, Brazil, BR|3461786");

var dateWidget = d.addWidget("com.hcristosm.cassettefuturism.datewidget");
dateWidget.geometry = { x: 16, y: 352, width: 368, height: 112 };
