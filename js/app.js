/*
 * app.js for health.js
 * by lenormf
 */

"use strict";

(function () {
    const DEFAULT = {
        ROUTE: "tracker",
        SETTINGS: {
            gender: "male",
            age: 25,
            weight: 180,
            height: 6.4,
        },
    };
    var settings = window.healthDatabase.GetSettings();

    if (!settings) {
        settings = DEFAULT.SETTINGS;
        window.healthDatabase.SetSettings(settings);
    }

    riot.compile(function () {
        riot.route("tracker", function () {
            riot.mount("navbar");
            riot.mount("tracker", {
                DB: window.healthDatabase,
                SETTINGS: settings,
            });
        });
        riot.route.start(true);
        riot.route(DEFAULT.ROUTE);
    });
})();
