/*
 * database.js for health.js
 * by lenormf
 */

"use strict";

(function () {
    // localStorage wrapper that allows storage of objects rather than simple strings
    var localStorageWrapper = {
        getItem: function (key) {
            if (typeof(key) === undefined) {
                return null;
            }

            const ret = window.localStorage.getItem(key);
            return (ret !== null) ? JSON.parse(ret) : null;
        },
        setItem: function (key, value) {
            if (typeof(key) !== undefined) {
                window.localStorage.setItem(key, JSON.stringify(value));
            }
        },
    };

    const PREFIX_DB = "_health_";
    const VERSION_DB = 1.0;

    // Keep track of all the dates on which items were added
    // Instead of fetching the list of all items that are in database everytime we want to add an item,
    // just save the date in a smaller array to allow easier retrieval of all the data in `GetBackup`
    const key_metaidx = "meta_idx";
    var getMetaIndexes = function () {
        return localStorageWrapper.getItem(PREFIX_DB + key_metaidx) || [];
    };
    var addMetaIndex = function (date) {
        var idxs = getMetaIndexes();

        if (idxs.indexOf(date) === -1) {
            idxs.push(date);
            localStorageWrapper.setItem(PREFIX_DB + key_metaidx, idxs);
        }
    };
    var removeMetaIndex = function (date) {
        var idxs = getMetaIndexes();

        if (idxs.indexOf(date) !== -1) {
            idxs.splice(date, 1);
            localStorageWrapper.setItem(PREFIX_DB + key_metaidx, idxs);
        }
    };

    window.healthDatabase = {
        GetSettings: function () {
            return localStorageWrapper.getItem(PREFIX_DB + "settings");
        },
        // gender: "male" or "female"
        // age: integer
        // height: float
        // weight: float
        SetSettings: function (gender, age, height, weight) {
            localStorageWrapper.setItem(PREFIX_DB + "settings", {
                gender: gender,
                age: age,
                height: height,
                weight: weight,
            });
        },
        // date: timestamp (day, month and year only)
        GetItems: function (date) {
            return localStorageWrapper.getItem(PREFIX_DB + "items_" + date.toString()) || [];
        },
        // date: timestamp (day, month and year only)
        SetItems: function (date, items) {
            if (typeof(items) !== undefined) {
                addMetaIndex(date.toString());
                localStorageWrapper.setItem(PREFIX_DB + "items_" + date.toString(), items);
            }
        },
        // date: timestamp (day, month and year only)
        // item: string
        // category: string
        // calories: integer
        // proteins: integer
        AddItem: function (date, item, category, calories, proteins) {
            if (typeof(item) !== undefined) {
                var items = this.GetItems(date);

                items.push({
                    item: item,
                    category: category,
                    nutrition: {
                        "calories": calories,
                        "proteins": proteins,
                    },
                });
                this.SetItems(date, items);
                addMetaIndex(date.toString());
            }
        },
        // date: timestamp (day, month and year only)
        RemoveItem: function (date, item) {
            if (typeof(item) !== undefined) {
                var items = this.GetItems(date);
                var idx = -1;

                for (var i = 0; i < items.length; i++) {
                    if (items[i].item === item.item
                        && items[i].category === item.category
                        && items[i].nutrition.calories === item.nutrition.calories
                        && items[i].nutrition.proteins === item.nutrition.proteins) {
                        idx = i;
                        break;
                    }
                }

                if (idx > -1) {
                    items.splice(idx, 1);
                    this.SetItems(date, items);
                    if (!items.length) {
                        removeMetaIndex(date.toString());
                    }
                }
            }
        },
        GetBackup: function () {
            var backup = {
                meta: {
                    prefix: PREFIX_DB,
                    version: VERSION_DB,
                },
                settings: this.GetSettings(),
                items: {},
            };

            for (var date of getMetaIndexes()) {
                backup.items[date] = this.GetItems(date);
            }

            return JSON.stringify(backup);
        },
        RestoreBackup: function (backup) {
            if (typeof(backup) !== undefined) {
                backup = JSON.parse(backup);
            }
        }
    };
})();
