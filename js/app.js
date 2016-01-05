/*
 * app.js for health.js
 * by lenormf
 */

"use strict";

(function () {
    const DEFAULT = {
        ROUTE_AVAILABLE: [
            "tracker",
            "settings",
        ],
        ROUTE: "tracker",
        SETTINGS: {
            gender: "male",
            age: 25,
            height: 6.4,
            weight: 180.5,
        },
    };
    const DB = window.healthDatabase;

    if (!DB.GetSettings())
        DB.SetSettings(DEFAULT.SETTINGS.gender, DEFAULT.SETTINGS.age, DEFAULT.SETTINGS.height, DEFAULT.SETTINGS.weight);

    riot.compile(function () {
        const view = document.getElementById("view");

        riot.mount("navbar");
        for (var route_idx in DEFAULT.ROUTE_AVAILABLE) {
            const route = DEFAULT.ROUTE_AVAILABLE[route_idx];

            // Each route has its own tag with the exact same name
            riot.route(route, function () {
                riot.mount(view, route, {
                    DB: DB,
                });
            });
        }

        riot.route.start(true);
        if (!window.location.hash)
            riot.route(DEFAULT.ROUTE);
    });
})();
