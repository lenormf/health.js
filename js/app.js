/*
 * app.js for health.js
 * by lenormf
 */

"use strict";

(function () {
    const DEFAULT = {
        ROUTES_AVAILABLE: [
            "tracker",
            "settings",
            "backups",
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
        for (var route of DEFAULT.ROUTES_AVAILABLE) {
            // Each route has its own tag with the exact same name
            riot.route(route, (function (name_tag) {
                return function () {
                    riot.mount(view, name_tag, {
                        DB: DB,
                    });
                }
            })(route));
        }

        riot.route.start(true);
        if (!window.location.hash)
            riot.route(DEFAULT.ROUTE);
    });
})();
