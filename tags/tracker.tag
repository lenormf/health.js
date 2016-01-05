<tracker>
    <div class="container-fluid">
        <div class="row-fluid">
            <div class="panel panel-default">
                <div id="infoPanel" class="panel-body">
                    <div class="col-sm-6">
                        <b>Totals:</b> <span class="label label-primary" title="{ reducerNutrition('calories') } kilo calories">{ reducerNutrition('calories') } kcal</span>
                        <span class="label label-info" title="{ reducerNutrition('proteins') } protein units">{ reducerNutrition('proteins') } u</span>
                    </div>

                    <div id="datePickerWrapper" class="col-sm-6">
                        <a onclick={ shiftDay(-1) } title="previous day"><i class="fa fa-fw fa-arrow-circle-left"></i></a>
                        <a id="datePicker" title="pick a date">{ datePickerObj.getDate().toDateString() }</a>
                        <a onclick={ setTodaysDate } title="set to today's date"><i class="fa fa-fw fa-bullseye"></i></a>
                        <a onclick={ shiftDay(+1) } title="next day"><i class="fa fa-fw fa-arrow-circle-right"></i></a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row-fluid">
            <form id="newItemForm" class="form-inline" onsubmit={ addItem }>
                <div class="form-group col-sm-5">
                    <label class="sr-only" for="newItemName">item name</label>
                    <input type="text" class="form-control" id="newItemName" placeholder="item">
                </div>
                <div class="form-group col-sm-2">
                    <label class="sr-only" for="newItemCategory"></label>
                    <select class="form-control" id="newItemCategory">
                        <option each={ category, _ in itemCategoriesRef }>{ category }</option>
                    </select>
                </div>
                <div class="form-group col-sm-2">
                    <label class="sr-only" for="newItemCalories"></label>
                    <input type="number" class="form-control" id="newItemCalories" placeholder="calories (kcal)">
                </div>
                <div class="form-group col-sm-2">
                    <label class="sr-only" for="newItemProteins"></label>
                    <input type="number" class="form-control" id="newItemProteins" placeholder="proteins (units)">
                </div>
                <button type="submit" class="btn btn-primary col-xs-12 col-sm-1">add</button>
                <div class="clearfix"></div>
            </form>
        </div>

        <div class="table-responsive" show={ DB.GetItems(nowTimestamp()).length > 0 }>
            <table class="table table-bordered table-centered">
                <thead>
                    <tr>
                        <th>item</th>
                        <th>category</th>
                        <th>nutrition</th>
                        <th>action</th>
                    </tr>
                </thead>

                <tbody>
                    <tr each={ item in DB.GetItems(nowTimestamp()) }>
                        <td>{ item.item }</td>
                        <td><i class={ itemCategoriesRef[item.category] } title={ item.category }></i></td>
                        <td>
                            <span class="label label-primary" title="{ item.nutrition.calories } kilo calories">{ item.nutrition.calories } kcal</span>
                            <span class="label label-info" title="{ item.nutrition.proteins } protein units">{ item.nutrition.proteins } u</span>
                        </td>
                        <td><a><i class="fa fa-fw fa-edit"></i></a><a onclick={ removeItem }><i class="fa fa-fw fa-times-circle-o"></i></a></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    // Save the tag instance to allow the use of `this` in callbacks
    var self = this

    // An instance to the database that contains settings/food etc is passed to the tag
    self.DB = opts.DB

    // Reference `Date` object used to set the default dates in the tracker
    self.dateNow = new Date()
    // Controller of the picker
    self.datePickerObj = new Pikaday({
        field: self.datePicker,
        setDefaultDate: true,
        defaultDate: self.dateNow,
        onSelect: function (date) {
            self.datePicker.innerHTML = date.toDateString()
            self.update()
            self.awesomplete.list = self.getTodaysItems()
        },
    })

    // Return the amount of days passed since the epoch
    nowTimestamp() {
        return parseInt(self.datePickerObj.getDate().getTime() / 1000 / 3600 / 24)
    }

    // Return a list of names of the items that were added on today's date
    getTodaysItems() {
        // Return an array of the `item` member of the array of objects returned by `GetItems`
        // Then filter through it to remove dupes
        return self.DB.GetItems(self.nowTimestamp()).map(function (cur, _, __) {
            return cur.item
        }).filter(function (cur, idx, arr) {
            return arr.indexOf(cur) === idx
        })
    }

    // Automatically fill the form when a completion suggestion is selected
    autoFillForm(e) {
        // Reverse the array of items to be able to complete over the latest elements added
        var items = self.DB.GetItems(self.nowTimestamp()).reverse()
        var item = items.find(function (cur, _, __) {
            return cur.item === e.target.value
        })

        // If an item was already added with the same name, auto fill the form
        if (item) {
            self.newItemCategory.value = item.category
            self.newItemCalories.value = item.nutrition.calories
            self.newItemProteins.value = item.nutrition.proteins
        }
    }

    // Controller of the complete-able item name input
    self.awesomplete = new Awesomplete(self.newItemName, {
        list: self.getTodaysItems(),
        minChars: 3,
        maxItems: 5,
        autoFirst: true,
    })
    self.newItemName.addEventListener('awesomplete-selectcomplete', self.autoFillForm)

    // List of all the categories items can be classified under, and the class with which they will be rendered
    self.itemCategoriesRef = {
        "alcohol": "pe-is-f-beer-bottle-f",
        "candies": "pe-is-f-candy",
        "cheese": "pe-is-f-cheese-1",
        "desserts": "pe-is-f-piece-of-cake-1",
        "fish": "pe-is-f-fish-1",
        "fruit": "pe-is-f-banana",
        "junk food": "pe-is-f-burger-2",
        "meat": "pe-is-f-chicken-2",
        "other": "pe-is-f-flatware-4",
        "soda": "pe-is-f-can-2",
        "vegetables": "pe-is-f-carrot",
    }

    // Sum up all the values of a given field in the `nutrition` array, across all items
    reducerNutrition(which) {
        var items = self.DB.GetItems(self.nowTimestamp())

        return items.length ? items.reduce((acc, cur) => acc + cur.nutrition[which], 0) : 0
    }

    // Set the date to today's when the corresponding button is clicked
    // Refresh the list of suggestions the item name can be completed against
    setTodaysDate(e) {
        self.datePickerObj.setDate(self.dateNow)
        self.awesomplete.list = self.getTodaysItems()
    }

    // Change the date forward/backward when the corresponding buttons are clicked
    shiftDay(direction) {
        return function (e) {
            var now = self.datePickerObj.getDate()

            now.setDate(now.getDate() + direction)
            self.datePickerObj.setDate(now)
            self.awesomplete.list = self.getTodaysItems()
        }
    }

    // Empty out the form that adds items
    resetItemForm() {
        self.newItemName.value = self.newItemCategory.value = self.newItemCalories.value = self.newItemProteins.value = ''
    }

    // Add an item with the given category/nutritional values when the form is submitted
    addItem(e) {
        const els_error_prone = [ "newItemName", "newItemCalories", "newItemProteins" ]
        var newItemName = self.newItemName.value,
            newItemCategory = self.newItemCategory.value,
            newItemCalories = self.newItemCalories.value,
            newItemProteins = self.newItemProteins.value

        // If the fields were highlighted previously because of an error, remove the highlighting
        for (var input of els_error_prone)
            self[input].parentNode.classList.remove('has-error')

        if (newItemName && newItemCategory && newItemCalories && newItemProteins) {
            newItemCalories = parseInt(newItemCalories, 10)
            newItemProteins = parseInt(newItemProteins, 10)

            self.DB.AddItem(self.nowTimestamp(), newItemName, newItemCategory, newItemCalories, newItemProteins)
            self.resetItemForm()
            self.awesomplete.list = self.getTodaysItems()
        } else {
            for (var input of els_error_prone) {
                if (!self[input].value) {
                    self[input].parentNode.classList.add('has-error')
                }
            }
        }
    }

    // Remove a given item when the removal button is clicked
    removeItem(e) {
        self.DB.RemoveItem(self.nowTimestamp(), e.item.item)
        self.awesomplete.list = self.getTodaysItems()
    }
</tracker>
