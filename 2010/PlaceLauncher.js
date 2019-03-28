Type.registerNamespace('Roblox.Launch');

Roblox.Launch._LaunchGamePage = null;
Roblox.Launch._Timer = null;
Roblox.Launch._ClientMetricType = null;
Roblox.Launch._Launcher = null;

Roblox.Launch.RequestGame = function(behaviorID, placeID) {
    Roblox.PlaceLauncher.Service.LogJoinClick();
    Roblox.Launch._Timer = new Date();
    Roblox.Launch._ClientMetricType = "WebPlay";
    if (checkRobloxInstall()) {
        if (Roblox.Launch._Launcher == null) {
            Roblox.Launch._Launcher = new RBX.PlaceLauncher(behaviorID);
        }
        Roblox.Launch._Launcher.RequestGame(placeID);
    }
}
Roblox.Launch.RequestGroupBuildGame = function(behaviorID, placeID) {
    Roblox.PlaceLauncher.Service.LogJoinClick();
    Roblox.Launch._Timer = new Date();
    Roblox.Launch._ClientMetricType = "WebPlay";
    if (checkRobloxInstall()) {
        if (Roblox.Launch._Launcher == null) {
            Roblox.Launch._Launcher = new RBX.PlaceLauncher(behaviorID);
        }
        Roblox.Launch._Launcher.RequestGroupBuildGame(placeID);
    }
}

Roblox.Launch.RequestGameJob = function(behaviorID, gameJobID) {
    Roblox.PlaceLauncher.Service.LogJoinClick();
    Roblox.Launch._Timer = new Date();
    Roblox.Launch._ClientMetricType = "WebJoin";
    if (checkRobloxInstall()) {
        if (Roblox.Launch._Launcher == null) {
            Roblox.Launch._Launcher = new RBX.PlaceLauncher(behaviorID);
        }
        Roblox.Launch._Launcher.RequestGameJob(gameJobID);
    }
}

Roblox.Launch.RequestFollowUser = function(behaviorID, userId) {
    Roblox.PlaceLauncher.Service.LogJoinClick();
    Roblox.Launch._Timer = new Date();
    Roblox.Launch._ClientMetricType = "WebFollow";
    if (checkRobloxInstall()) {
        if (Roblox.Launch._Launcher == null) {
            Roblox.Launch._Launcher = new RBX.PlaceLauncher(behaviorID);
        }
        Roblox.Launch._Launcher.RequestFollowUser(userId);
    }
}

Roblox.Launch.StartGame = function(visitUrl, type, authenticationUrl, authenticationTicket) {
    urchinTracker("Visit/Try/" + type);

    var prefix = null;
    try {
        prefix = "RobloxProxy/";
        var launcher = Roblox.Client.CreateLauncher();
        if (!launcher) {
            if (window.external) {
                try {
                    // Must be in the roblox app
                    window.external.StartGame(authenticationTicket, authenticationUrl, visitUrl);
                }
                catch (ex) {
                    throw "window.external fallback failed, Roblox must not be installed or IE cannot access ActiveX";
                }
            }
            else {
                throw "launcher is null or undefined and external is missing";
            }
        }
        else {
            //launcher is non-null
            prefix = "RobloxProxy/StartGame/";
            try {
                try {
                    launcher.AuthenticationTicket = authenticationTicket;
                }
                catch (err) {
                    // This is an older version of the Launcher. Ignore the error
                }
                launcher.StartGame(authenticationUrl, visitUrl);
            }
            catch (err) {
                Roblox.Client.ReleaseLauncher(launcher);
                throw err;
            }
            Roblox.Client.ReleaseLauncher(launcher);
        }
    }
    catch (err) {
        var message = err.message;

        if (message == "User cancelled") {
            urchinTracker("Visit/UserCancelled/" + type);
            return false;
        }
        try {
            var y = new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch (err3) {
            message = "FailedXMLHTTP/" + message;
        }

        if (!Roblox.Client.isRobloxBrowser()) {
            urchinTracker("Visit/Redirect/" + prefix + encodeURIComponent(message));
            window.location = Roblox.Launch._LaunchGamePage;
        }
        else
            urchinTracker("Visit/Fail/" + prefix + encodeURIComponent(message));

        return false;
    }

    urchinTracker("Visit/Success/" + type);
    return true;
}

Roblox.Launch.CheckRobloxInstall = function(installPath) {
    if (!Roblox.Client.IsRobloxInstalled()) {
        window.location = installPath;
    }
    else {
        Roblox.Client.Update();
        return true;
    }
}

Type.registerNamespace('RBX');

RBX.PlaceLauncher = function(modalDialogueID) {
    this._cancelled = false;
    this._popup = $('#' + modalDialogueID);
}

RBX.PlaceLauncher.prototype = {

    // TODO: This should only be called once.  What if you call it again???
    RequestGame: function(placeID) {

        this._showDialog();

        // Now send a request to the Grid...
        var onGameSuccess = function(result, context) { context._onGameStatus(result); };
        var onGameError = function(result, context) { context._onError(result); };
        var self = this;
        var gameDelegate = function() { Roblox.PlaceLauncher.Service.RequestGame(placeID, onGameSuccess, onGameError, self); };

        this._startUpdatePolling(gameDelegate);

        return false;
    },

    // TODO: This should only be called once.  What if you call it again???
    RequestGroupBuildGame: function(placeID) {

        this._showDialog();

        // Now send a request to the Grid...
        var onGameSuccess = function(result, context) { context._onGameStatus(result, true); };
        var onGameError = function(result, context) { context._onError(result); };
        var self = this;
        var gameDelegate = function() { Roblox.PlaceLauncher.Service.RequestGroupBuildGame(placeID, onGameSuccess, onGameError, self); };

        this._startUpdatePolling(gameDelegate);

        return false;
    },
    // TODO: This should only be called once.  What if you call it again???
    RequestFollowUser: function(userId) {

        this._showDialog();

        // Now send a request to the Grid...
        var onGameSuccess = function(result, context) { context._onGameStatus(result); };
        var onGameError = function(result, context) { context._onError(result); };
        var self = this;
        var gameDelegate = function() { Roblox.PlaceLauncher.Service.RequestFollowUser(userId, onGameSuccess, onGameError, self); };

        this._startUpdatePolling(gameDelegate);

        return false;
    },

    // TODO: This should only be called once.  What if you call it again???
    RequestGameJob: function(gameJobID) {

        this._showDialog();

        // Now send a request to the Grid...
        var onGameSuccess = function(result, context) { context._onGameStatus(result); };
        var onGameError = function(result, context) { context._onError(result); };
        var self = this;
        var gameDelegate = function() { Roblox.PlaceLauncher.Service.RequestGameJob(gameJobID, onGameSuccess, onGameError, self); };

        this._startUpdatePolling(gameDelegate);

        return false;
    },

    CancelLaunch: function() {
        this._cancelled = true;
        $.modal.close();
        return false;
    },

    _reportDuration: function(duration, result) {

        $.ajax({
            type: "GET",
            async: true,
            cache: false,
            timeout: 50000,
            url: "/Game/JoinRate.ashx?c=" + Roblox.Launch._ClientMetricType + "&r=" + result + "&d=" + duration,
            success: function(data) {

            }
        });
    },

    _onGameStatus: function(result) {
        if (this._cancelled) {
            //report length of time between click of join and cancelling joining a game.
            var c_duration = new Date().getTime() - Roblox.Launch._Timer.getTime();
            this._reportDuration(c_duration, "Cancel");
            return;
        }

        this._updateStatus(result.status);

        if (result.status == 2) {
            Roblox.Launch.StartGame(result.joinScriptUrl, "Join", result.authenticationUrl, result.authenticationTicket);
            $.modal.close();

            //report length of time between click of join and successfully joining a game.
            var s_duration = new Date().getTime() - Roblox.Launch._Timer.getTime();
            this._reportDuration(s_duration, "Success");

        }
        else if (result.status < 2 || result.status == 6) {
            // Try again
            var onSuccess = function(result, context) { context._onGameStatus(result); };
            var onError = function(result, context) { context._onGameError(result); };
            var self = this;
            var call = function() { Roblox.PlaceLauncher.Service.CheckGameJobStatus(result.jobId, onSuccess, onError, self); };
            window.setTimeout(call, 2000);
        } else if (result.status == 4) { //error 
            //report length of time between click of join and failed joining a game.
            var f_duration = new Date().getTime() - Roblox.Launch._Timer.getTime();
            this._reportDuration(f_duration, "Failure");

        }
    },

    _updateStatus: function(status) {
        $(this._popup).find('#Starting').css("display", 'none');
        $(this._popup).find('#Spinner').css("display", ((status < 3 || status == 7 || status == 8 || status == 6) ? 'block' : 'none'));
        $(this._popup).find('#Waiting').css("display", (status == 0 ? 'inline' : 'none'));
        $(this._popup).find('#Loading').css("display", (status == 1 ? 'inline' : 'none'));
        $(this._popup).find('#Joining').css("display", (status == 2 ? 'inline' : 'none'));
        $(this._popup).find('#Expired').css("display", (status == 3 ? 'inline' : 'none'));
        $(this._popup).find('#Error').css("display", (status == 4 ? 'inline' : 'none'));
        $(this._popup).find('#GameEnded').css("display", (status == 5 ? 'inline' : 'none'));
        $(this._popup).find('#GameFull').css("display", (status == 6 ? 'inline' : 'none'));
        $(this._popup).find('#Updating').css("display", (status == 7 ? 'inline' : 'none'));
        $(this._popup).find('#Updated').css("display", (status == 8 ? 'inline' : 'none'));
    },

    _onGameError: function(result) {
        this._updateStatus(4);
    },

    _startUpdatePolling: function(joinGameDelegate) {
        try {
            var launcher = Roblox.Client.CreateLauncher();
            var result = launcher.IsUpToDate;

            if (result || result == undefined) {
                //                try {
                //                    launcher.PreStartGame();
                //                }
                //                catch (e)
                //                { }

                joinGameDelegate();
                return;
            }

            //Now we need to poll until it is finished
            var onSuccess = function(result, launcher, context) { context._onUpdateStatus(result, launcher, joinGameDelegate); };
            var onError = function(result, context) { context._onUpdateError(result); };
            var self = this;

            this.CheckUpdateStatus(onSuccess, onError, launcher, joinGameDelegate, self);
        }
        catch (e) {
            //alert("Missing IsUpToDate, falling back");
            Roblox.Client.ReleaseLauncher(launcher);
            //Something went wrong, fall back to the old method of Update + Join in parallel
            joinGameDelegate();
        }
    },

    CheckUpdateStatus: function(onSuccess, onError, launcher, joinGameDelegate, self) {
        try {
            launcher.PreStartGame();

            var result = launcher.IsUpToDate;
            if (result || result == undefined) {
                onSuccess(8, launcher, self);
            }
            else {
                onSuccess(7, launcher, self);
            }
        }
        catch (e) {
            //We have the old DLL loaded, so just pretend it was succesful like in the olden days
            onSuccess(8, launcher, self);
        }
    },


    _onUpdateStatus: function(result, launcher, joinGameDelegate) {
        if (this._cancelled)
            return;

        this._updateStatus(result);

        if (result == 8) {
            Roblox.Client.ReleaseLauncher(launcher);
            joinGameDelegate();
        }
        else if (result == 7) {
            // Try again
            var onSuccess = function(result, launcher, context) { context._onUpdateStatus(result, launcher, joinGameDelegate); };
            var onError = function(result, context) { context._onUpdateError(result); };
            var self = this;
            var call = function() { self.CheckUpdateStatus(onSuccess, onError, launcher, joinGameDelegate, self); };
            window.setTimeout(call, 2000);
        }
        else {
            alert("Unknown status from CheckUpdateStatus");
        }
    },

    _onUpdateError: function(result) {
        this._updateStatus(2);
    },

    _showDialog: function() {
        this._cancelled = false;
        // http://www.ericmmartin.com/projects/simplemodal/
        $(this._popup).modal({ escClose: true,
            opacity: 80,
            overlayCss: { backgroundColor: "#000" }
        });

        // bind our cancel button
        var RBXPlaceLauncher = this;
        $('.CancelPlaceLauncherButton').click(function() { RBXPlaceLauncher.CancelLaunch(); });
    },

    dispose: function() {
        RBX.PlaceLauncher.callBaseMethod(this, 'dispose');
    }
}

RBX.PlaceLauncher.registerClass('RBX.PlaceLauncher', null, Sys.IDisposable);