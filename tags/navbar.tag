<navbar>
    <nav class="navbar navbar-default navbar-static-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="/">health.js</a>
            <a class="navbar-brand pull-right" href="#" onclick={ toggleMenu }>
                <i class="fa fa-fw fa-bars"></i>
            </a>
        </div>
    </nav>

    <div class="container-fluid" show={ menuToggled }>
        <ul class="nav nav-pills nav-justified" style="margin-bottom: 20px;">
            <li class={ onCurrentHash("#tracker", "active") }><a href="#tracker"><i class="fa fa-fw fa-heartbeat"></i> tracker</a></li>
            <li class={ onCurrentHash("#settings", "active") }><a href="#settings"><i class="fa fa-fw fa-gears"></i> settings</a></li>
            <li class={ onCurrentHash("#analytics", "active") }><a href="#analytics"><i class="fa fa-fw fa-dashboard"></i> analytics</a></li>
            <li class={ onCurrentHash("#backups", "active") }><a href="#backups"><i class="fa fa-fw fa-file-archive-o"></i> backups</a></li>
        </ul>
    </div>

    this.menuToggled = false
    toggleMenu(e) {
        this.menuToggled = !this.menuToggled
    }

    onCurrentHash(target, class_) {
        return window.location.hash === target ? class_ : undefined
    }
</navbar>
