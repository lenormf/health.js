/*
 * database.js for health.js
 * by lenormf
 */

"use strict";

(function () {
    if (!window.localStorage) {
        console.notice("localStorage is not supported, using a compatibility layer");

        // https://developer.mozilla.org/en-US/docs/Web/API/Storage/LocalStorage
        window.localStorage = {
            getItem: function (sKey) {
                if (!sKey || !this.hasOwnProperty(sKey)) { return null; }
                return unescape(document.cookie.replace(new RegExp("(?:^|.*;\\s*)" + escape(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=\\s*((?:[^;](?!;))*[^;]?).*"), "$1"));
            },
            key: function (nKeyId) {
                return unescape(document.cookie.replace(/\s*\=(?:.(?!;))*$/, "").split(/\s*\=(?:[^;](?!;))*[^;]?;\s*/)[nKeyId]);
            },
            setItem: function (sKey, sValue) {
                if(!sKey) { return; }
                document.cookie = escape(sKey) + "=" + escape(sValue) + "; expires=Tue, 19 Jan 2038 03:14:07 GMT; path=/";
                this.length = document.cookie.match(/\=/g).length;
            },
            length: 0,
            removeItem: function (sKey) {
                if (!sKey || !this.hasOwnProperty(sKey)) { return; }
                document.cookie = escape(sKey) + "=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/";
                this.length--;
            },
            hasOwnProperty: function (sKey) {
                return (new RegExp("(?:^|;\\s*)" + escape(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=")).test(document.cookie);
            }
        };
        window.localStorage.length = (document.cookie.match(/\=/g) || window.localStorage).length;
    }

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
