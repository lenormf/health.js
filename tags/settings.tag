<settings>
    <div class="container-fluid">
        <form id="settingsForm" class="form-horizontal" onsubmit={ updateSettings }>
            <div class="form-group">
                <label for="settingGender" class="col-xs-2 control-label">gender</label>
                <div class="col-xs-10">
                    <select id="settingGender" class="form-control" onchange={ activateSaveButton }>
                        <option selected={ settings.gender === "male" }>male</option>
                        <option selected={ settings.gender === "female" }>female</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="settingAge" class="col-xs-2 control-label">age</label>
                <div class="col-xs-10">
                    <input id="settingAge" type="number" class="form-control" placeholder="age (years)" value={ settings.age } oninput={ activateSaveButton }>
                </div>
            </div>
            <div class="form-group">
                <label for="settingHeight" class="col-xs-2 control-label">height</label>
                <div class="col-xs-10">
                    <input id="settingHeight" type="number" step="0.1" class="form-control" placeholder="height (feet.inches)" value={ settings.height } oninput={ activateSaveButton }>
                </div>
            </div>
            <div class="form-group">
                <label for="settingWeight" class="col-xs-2 control-label">weight</label>
                <div class="col-xs-10">
                    <input id="settingWeight" type="number" step="0.1" class="form-control" placeholder="weight (lbs)" value={ settings.weight } oninput={ activateSaveButton }>
                </div>
            </div>
            <div class="form-group">
                <div class="col-xs-offset-2 col-xs-10">
                    <button id="settingsSave" type="submit" class="btn btn-primary" disabled>saved</button>
                </div>
            </div>
        </form>
    </div>

    this.DB = opts.DB
    this.settings = this.DB.GetSettings()

    activateSaveButton(e) {
        if (this.settingsSave.hasAttribute("disabled")) {
            this.settingsSave.value = "save"
            this.settingsSave.removeAttribute("disabled")
        }
    }

    disactivateSaveButton(e) {
        if (!this.settingsSave.hasAttribute("disabled")) {
            this.settingsSave.value = "saved"
            this.settingsSave.setAttribute("disabled", true)
        }
    }

    updateSettings(e) {
        var settingGender = this.settingGender.value,
            settingAge = this.settingAge.value,
            settingHeight = this.settingHeight.value,
            settingWeight = this.settingWeight.value

        this.settingAge.parentNode.parentNode.classList.remove('has-error')
        this.settingHeight.parentNode.parentNode.classList.remove('has-error')
        this.settingWeight.parentNode.parentNode.classList.remove('has-error')

        if (settingAge && settingHeight && settingWeight) {
            settingAge = parseInt(settingAge, 10)
            settingHeight = parseFloat(settingHeight)
            settingWeight = parseFloat(settingWeight)

            this.DB.SetSettings(settingGender, settingAge, settingHeight, settingWeight)
            this.disactivateSaveButton()
        } else {
            if (!settingAge)
                this.settingAge.parentNode.parentNode.classList.add('has-error')
            if (!settingHeight)
                this.settingHeight.parentNode.parentNode.classList.add('has-error')
            if (!settingWeight)
                this.settingWeight.parentNode.parentNode.classList.add('has-error')
        }
    }
</settings>
