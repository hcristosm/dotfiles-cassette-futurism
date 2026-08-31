// Deliberately low-resolution continent outlines (a few dozen points per
// landmass), hand-simplified for a decorative wireframe globe — NOT meant
// for geographic accuracy. Kept tiny on purpose: this is baked-in static
// data, never parsed/loaded at runtime, so it costs nothing per frame.
//
// Each entry is a closed-ish polyline of [lat, lon] pairs in degrees.
.pragma library

var CONTINENTS = [
    // Africa
    [[37,10],[32,-10],[21,-17],[15,-17],[4,-8],[4,9],[-2,9],[-5,12],
     [-18,12],[-25,15],[-34,18],[-34,26],[-25,33],[-11,40],[0,42],
     [4,48],[11,51],[12,43],[30,35],[31,32],[37,10]],

    // North America
    [[70,-160],[60,-165],[55,-130],[48,-125],[32,-117],[15,-95],
     [9,-84],[9,-77],[25,-97],[30,-81],[45,-67],[47,-52],[60,-64],
     [70,-160]],

    // South America
    [[12,-72],[5,-77],[-4,-81],[-18,-70],[-33,-71],[-55,-68],
     [-53,-58],[-34,-58],[-23,-43],[-8,-35],[0,-50],[5,-52],[12,-72]],

    // Europe
    [[60,5],[55,-5],[48,-5],[43,-9],[36,-6],[38,15],[45,13],
     [45,30],[60,30],[70,25],[60,5]],

    // Asia
    [[70,60],[55,60],[45,45],[30,48],[25,55],[8,77],[6,80],
     [1,104],[10,109],[22,120],[35,129],[43,131],[52,140],
     [60,160],[70,170],[70,60]],

    // Australia
    [[-11,131],[-18,122],[-31,115],[-35,118],[-38,141],[-33,151],
     [-25,153],[-15,145],[-11,131]]
];

// Satellite NORAD IDs kept fixed and small on purpose (scope control):
var SATELLITES = [
    { id: 25544, name: "ISS" },
    { id: 20580, name: "HST" },
    { id: 48274, name: "TIANGONG" }
];
