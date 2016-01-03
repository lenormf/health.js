<tracker>
    <div class="container-fluid">
        <div class="row-fluid">
            <div class="panel panel-default">
                <div id="infoPanel" class="panel-body">
                    <div class="col-sm-6">
                        <b>Totals:</b> <span class="label label-primary" title="{ reducerCalories() } kilo calories">{ reducerCalories() } kcal</span>
                        <span class="label label-info" title="{ reducerProteins() } protein units">{ reducerProteins() } u</span>
                    </div>

                    <div id="datePickerWrapper" class="col-sm-6">
                        <a href="#" onclick={ shiftDayBackward } title="previous day"><i class="fa fa-fw fa-arrow-circle-left"></i></a>
                        <a id="datePicker" href="#" title="pick a date">{ this.datePickerObj.getDate().toDateString() }</a>
                        <a href="#" onclick={ setTodaysDate } title="set to today's date"><i class="fa fa-fw fa-bullseye"></i></a>
                        <a href="#" onclick={ shiftDayForward } title="next day"><i class="fa fa-fw fa-arrow-circle-right"></i></a>
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
                        <td><i class={ categoryToIcon(item.category) } title={ item.category }></i></td>
                        <td>
                            <span class="label label-primary" title="{ item.nutrition[0] } kilo calories">{ item.nutrition[0] } kcal</span>
                            <span class="label label-info" title="{ item.nutrition[1] } protein units">{ item.nutrition[1] } u</span>
                        </td>
                        <td><a href="#"><i class="fa fa-fw fa-edit"></i></a><a href="#" onclick={ removeItem }><i class="fa fa-fw fa-times-circle-o"></i></a></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    this.DB = opts.DB
    this.dateNow = new Date()
    this.datePickerObj = new Pikaday({
        field: this.datePicker,
        setDefaultDate: true,
        defaultDate: this.dateNow,
        onSelect: function (date) {
            document.getElementById('datePicker').innerHTML = date.toDateString()
        },
    })
    this.itemCategoriesRef = {
        "alcohol": "pe-is-f-beer-bottle-f",
        "fruit": "pe-is-f-banana",
        "vegetables": "pe-is-f-carrot",
        "soda": "pe-is-f-can-2",
        "cheese": "pe-is-f-cheese-1",
        "meat": "pe-is-f-chicken-2",
        "fish": "pe-is-f-fish-1",
        "desserts": "pe-is-f-piece-of-cake-1",
        "junk food": "pe-is-f-burger-2",
        "candies": "pe-is-f-candy",
        "other": "pe-is-f-flatware-4",
    }

    categoryToIcon(category) {
        return this.itemCategoriesRef[category]
    }

    nowTimestamp() {
        return parseInt(this.datePickerObj.getDate().getTime() / 1000 / 3600 / 24)
    }

    reducerCalories() {
        var items = this.DB.GetItems(this.nowTimestamp())

        return items.length ? items.reduce((acc, cur) => acc + cur.nutrition[0], 0) : 0
    }

    reducerProteins() {
        var items = this.DB.GetItems(this.nowTimestamp())

        return items.length ? items.reduce((acc, cur) => acc + cur.nutrition[1], 0) : 0
    }

    setTodaysDate(e) {
        this.datePickerObj.setDate(this.dateNow)
    }

    shiftDayBackward(e) {
        var now = this.datePickerObj.getDate()

        now.setDate(now.getDate() - 1)
        this.datePickerObj.setDate(now)
    }

    shiftDayForward(e) {
        var now = this.datePickerObj.getDate()

        now.setDate(now.getDate() + 1)
        this.datePickerObj.setDate(now)
    }

    resetItemForm() {
        this.newItemName.value = this.newItemCategory.value = this.newItemCalories.value = this.newItemProteins.value = ''
    }

    addItem(e) {
        var newItemName = this.newItemName.value,
            newItemCategory = this.newItemCategory.value,
            newItemCalories = this.newItemCalories.value,
            newItemProteins = this.newItemProteins.value

        this.newItemName.parentNode.classList.remove('has-error');
        this.newItemCalories.parentNode.classList.remove('has-error');
        this.newItemProteins.parentNode.classList.remove('has-error');

        if (newItemName.length && newItemCategory && newItemCalories && newItemProteins) {
            newItemCalories = parseInt(newItemCalories, 10)
            newItemProteins = parseInt(newItemProteins, 10)

            this.DB.AddItem(this.nowTimestamp(), newItemName, newItemCategory, newItemCalories, newItemProteins)
            this.resetItemForm()
        } else {
            if (!newItemName)
                this.newItemName.parentNode.classList.add('has-error');
            if (!newItemCalories.length)
                this.newItemCalories.parentNode.classList.add('has-error');
            if (!newItemProteins.length)
                this.newItemProteins.parentNode.classList.add('has-error');
        }
    }

    removeItem(e) {
        this.DB.RemoveItem(this.nowTimestamp(), e.item.item)
    }
</tracker>
