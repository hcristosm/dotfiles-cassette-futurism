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

// Top bar: audio visualizer on the left, clock dead center between two
// expanding spacers, system tray / notifications on the right.
var top = new Panel();
top.location = "top";
top.height = 26;
top.addWidget("Audio.Wave.Widget");
top.addWidget("org.kde.plasma.panelspacer");
top.addWidget("org.kde.plasma.digitalclock");
top.addWidget("org.kde.plasma.panelspacer");
top.addWidget("org.kde.plasma.systemtray");
