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

            var ret = window.localStorage.getItem(key);
            return (ret !== null) ? JSON.parse(ret) : null;
        },
        setItem: function (key, value) {
            if (typeof(key) !== undefined) {
                window.localStorage.setItem(key, JSON.stringify(value));
            }
        },
    };

    const PREFIX_DB = "_health_";
    window.healthDatabase = {
        GetSettings: function () {
            return localStorageWrapper.getItem(PREFIX_DB + "settings");
        },
        // gender: "male" or "female"
        // age: integer
        // weight: float
        // height: float
        SetSettings: function (gender, age, weight, height) {
            localStorageWrapper.setItem(PREFIX_DB + "settings", {
                gender: gender,
                age: age,
                weight: weight,
                height: height,
            });
        },
        // date: timestamp (day, month and year only)
        GetItems: function (date) {
            return localStorageWrapper.getItem(PREFIX_DB + "items_" + date.toString()) || [];
        },
        // date: timestamp (day, month and year only)
        SetItems: function (date, items) {
            if (typeof(items) !== undefined) {
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
                    nutrition: [ calories, proteins ],
                });
                this.SetItems(date, items);
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
                        && items[i].nutrition[0] === item.nutrition[0]
                        && items[i].nutrition[1] === item.nutrition[1]) {
                        idx = i;
                        break;
                    }
                }

                if (idx > -1) {
                    items.splice(idx, 1);
                    this.SetItems(date, items);
                }
            }
        },
    };
})();
