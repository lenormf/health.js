<backups>
    <div class="container-fluid">
        <div class="row-fluid">
            <div class=" col-sm-8 col-sm-offset-2">
                <div id="saveDataPanel" class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">save data</h3>
                    </div>
                    <div class="panel-body">
                        <div class="row-fluid">
                            <div class="col-sm-3" style="text-align: center;">
                                <a id="downloadBackupButton" class="btn btn-primary" download="healthjs.bak"><i class="fa fa-2x fa-cloud-download"></i> save</a>
                            </div>
                            <div class="col-sm-8">
                                Download a backup of all the items added to the application, as well as the settings
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row-fluid">
            <div class=" col-sm-8 col-sm-offset-2">
                <div id="restoreDataPanel" class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">restore data</h3>
                    </div>
                    <div class="panel-body">
                        <div class="row-fluid">
                            <div class="col-sm-3" style="text-align: center;">
                                <button class="btn btn-primary"><i class="fa fa-2x fa-cloud-upload"></i> restore</button>
                            </div>
                            <div class="col-sm-8">
                                <div class="row-fluid">
                                    Restore the database of items backed-up to a save file, including the settings
                                </div>
                                <div class="row-fluid">
                                    <input type="file">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    this.DB = opts.DB

    // https://developer.mozilla.org/en-US/docs/Web/API/WindowBase64/btoa
    function utf8_to_b64(str) {
        return window.btoa(unescape(encodeURIComponent(str)))
    }
    function b64_to_utf8(str) {
        return decodeURIComponent(escape(window.atob(str)))
    }

    this.downloadBackupButton.setAttribute("href", "data:application/octet-stream;charset=utf-16le;base64," + utf8_to_b64(this.DB.GetBackup()))
</backups>
