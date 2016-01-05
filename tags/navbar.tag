<navbar>
    <nav class="navbar navbar-default navbar-static-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="#tracker">health.js</a>
            <a class="navbar-brand pull-right" onclick={ toggleMenu }>
                <i class="fa fa-fw fa-bars"></i>
            </a>
        </div>
    </nav>

    <div class="container-fluid" show={ menuToggled }>
        <ul class="nav nav-pills nav-justified" style="margin-bottom: 20px;">
            <li class={ onCurrentHash("#tracker", "active") }><a onclick={ routeTo("tracker") }><i class="fa fa-fw fa-heartbeat"></i> tracker</a></li>
            <li class={ onCurrentHash("#settings", "active") }><a onclick={ routeTo("settings") }><i class="fa fa-fw fa-gears"></i> settings</a></li>
            <li class={ onCurrentHash("#analytics", "active") }><a onclick={ routeTo("analytics") }><i class="fa fa-fw fa-dashboard"></i> analytics</a></li>
            <li class={ onCurrentHash("#backups", "active") }><a onclick={ routeTo("backups") }><i class="fa fa-fw fa-file-archive-o"></i> backups</a></li>
        </ul>
    </div>

    // Boolean that controls displaying of the navigation bar
    this.menuToggled = false
    toggleMenu(e) {
        this.menuToggled = !this.menuToggled
    }

    // Hide the menu and route to the given location
    routeTo(next_location) {
        return function (e) {
            this.toggleMenu()
            riot.route(next_location)
        }
    }

    // Return the given class if the page is on the target location
    onCurrentHash(target, class_) {
        return window.location.hash === target ? class_ : undefined
    }
</navbar>
