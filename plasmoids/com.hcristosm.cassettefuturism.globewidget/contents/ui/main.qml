import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import "GlobeData.js" as GlobeData

// Cassette Futurism rotating globe.
//
// Deliberately built cheap, after a session spent chasing a system
// stability issue caused by a different desktop widget doing continuous
// OpenGL rendering. This one uses only a 2D Canvas at ~5-6fps, precomputed
// static point data, and a satellite-position fetch that runs once every
// several minutes (not per frame). No native binaries, no spawned
// processes.
PlasmoidItem {
    id: root

    Layout.minimumWidth: 220
    Layout.minimumHeight: 220
    Layout.preferredWidth: 320
    Layout.preferredHeight: 320

    readonly property real rotationStepDeg: plasmoid.configuration.reduceMotion ? 0 : 0.6
    readonly property int refreshIntervalMs: Math.max(5, plasmoid.configuration.refreshIntervalMinutes) * 60 * 1000
    readonly property string apiKey: plasmoid.configuration.apiKey
    readonly property real homeLat: parseFloat(plasmoid.configuration.homeLat)
    readonly property real homeLon: parseFloat(plasmoid.configuration.homeLon)
    readonly property bool hasHome: !isNaN(root.homeLat) && !isNaN(root.homeLon)

    property real rotationDeg: 0
    property var satellites: [] // [{ name, lat, lon }]

    function deg2rad(d) { return d * Math.PI / 180; }

    // Projects a [lat, lon] point (degrees) to canvas coordinates, given
    // the current rotation. Returns null if the point is on the far side
    // of the globe (simple back-face cull, gives the natural horizon cutoff).
    function project(lat, lon, cx, cy, radius, rotRad) {
        var latR = deg2rad(lat);
        var lonR = deg2rad(lon) + rotRad;
        var x = Math.cos(latR) * Math.sin(lonR);
        var y = Math.sin(latR);
        var z = Math.cos(latR) * Math.cos(lonR);
        if (z < 0) return null;
        return { x: cx + x * radius, y: cy - y * radius };
    }

    function fetchSatellites() {
        if (!root.apiKey || root.apiKey.length === 0) {
            root.satellites = [];
            return;
        }
        var results = [];
        var pending = GlobeData.SATELLITES.length;
        GlobeData.SATELLITES.forEach(function (sat) {
            var url = "https://api.n2yo.com/rest/v1/satellite/positions/" +
                sat.id + "/0/0/0/1/&apiKey=" + root.apiKey;
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState !== XMLHttpRequest.DONE) return;
                pending--;
                try {
                    if (xhr.status === 200) {
                        var data = JSON.parse(xhr.responseText);
                        if (data.positions && data.positions.length > 0) {
                            results.push({
                                name: sat.name,
                                lat: data.positions[0].satlatitude,
                                lon: data.positions[0].satlongitude
                            });
                        }
                    }
                } catch (e) {
                    // Malformed/unexpected response — skip silently, this
                    // is a decorative overlay, never worth surfacing errors.
                }
                if (pending === 0) {
                    root.satellites = results;
                }
            };
            xhr.open("GET", url);
            xhr.send();
        });
    }

    Timer {
        id: rotationTimer
        interval: 180
        running: true
        repeat: true
        onTriggered: root.rotationDeg = (root.rotationDeg + root.rotationStepDeg) % 360
    }

    Timer {
        id: satelliteTimer
        interval: root.refreshIntervalMs
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.fetchSatellites()
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        anchors.margins: 8
        renderStrategy: Canvas.Cooperative

        property color lineColor: Kirigami.Theme.textColor
        property color satColor: Kirigami.Theme.highlightColor

        Connections {
            target: root
            function onRotationDegChanged() { canvas.requestPaint(); }
            function onSatellitesChanged() { canvas.requestPaint(); }
            function onHasHomeChanged() { canvas.requestPaint(); }
        }

        onPaint: {
            var ctx = getContext("2d");
            var w = width, h = height;
            ctx.clearRect(0, 0, w, h);

            var cx = w / 2, cy = h / 2;
            var radius = Math.min(w, h) / 2 - 4;
            var rotRad = root.deg2rad(root.rotationDeg);

            // Outer limb
            ctx.strokeStyle = canvas.lineColor;
            ctx.globalAlpha = 0.5;
            ctx.lineWidth = 1;
            ctx.beginPath();
            ctx.arc(cx, cy, radius, 0, 2 * Math.PI);
            ctx.stroke();

            // Graticule: meridians every 30deg, parallels every 30deg
            ctx.globalAlpha = 0.25;
            for (var lon = -180; lon < 180; lon += 30) {
                ctx.beginPath();
                var started = false;
                for (var lat = -90; lat <= 90; lat += 5) {
                    var p = root.project(lat, lon, cx, cy, radius, rotRad);
                    if (!p) { started = false; continue; }
                    if (!started) { ctx.moveTo(p.x, p.y); started = true; }
                    else ctx.lineTo(p.x, p.y);
                }
                ctx.stroke();
            }
            for (var lat2 = -60; lat2 <= 60; lat2 += 30) {
                ctx.beginPath();
                var started2 = false;
                for (var lon2 = -180; lon2 <= 180; lon2 += 5) {
                    var p2 = root.project(lat2, lon2, cx, cy, radius, rotRad);
                    if (!p2) { started2 = false; continue; }
                    if (!started2) { ctx.moveTo(p2.x, p2.y); started2 = true; }
                    else ctx.lineTo(p2.x, p2.y);
                }
                ctx.stroke();
            }

            // Continents
            ctx.globalAlpha = 0.85;
            ctx.lineWidth = 1.2;
            GlobeData.CONTINENTS.forEach(function (poly) {
                ctx.beginPath();
                var started3 = false;
                for (var i = 0; i < poly.length; i++) {
                    var pt = root.project(poly[i][0], poly[i][1], cx, cy, radius, rotRad);
                    if (!pt) { started3 = false; continue; }
                    if (!started3) { ctx.moveTo(pt.x, pt.y); started3 = true; }
                    else ctx.lineTo(pt.x, pt.y);
                }
                ctx.stroke();
            });

            // Satellites
            ctx.globalAlpha = 1.0;
            ctx.fillStyle = canvas.satColor;
            ctx.font = "10px \"Space Mono\"";
            root.satellites.forEach(function (sat) {
                var sp = root.project(sat.lat, sat.lon, cx, cy, radius, rotRad);
                if (!sp) return;
                ctx.beginPath();
                ctx.arc(sp.x, sp.y, 2.5, 0, 2 * Math.PI);
                ctx.fill();
                ctx.fillText(sat.name, sp.x + 5, sp.y - 4);
            });

            // Home marker — red diamond, distinct from the amber satellite dots
            if (root.hasHome) {
                var hp = root.project(root.homeLat, root.homeLon, cx, cy, radius, rotRad);
                if (hp) {
                    ctx.globalAlpha = 1.0;
                    ctx.fillStyle = "#e0483a";
                    var s = 4;
                    ctx.beginPath();
                    ctx.moveTo(hp.x, hp.y - s);
                    ctx.lineTo(hp.x + s, hp.y);
                    ctx.lineTo(hp.x, hp.y + s);
                    ctx.lineTo(hp.x - s, hp.y);
                    ctx.closePath();
                    ctx.fill();
                }
            }
        }
    }

    Component.onDestruction: {
        rotationTimer.stop();
        satelliteTimer.stop();
    }
}
