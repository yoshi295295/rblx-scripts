Type.registerNamespace('Roblox.Launch');

Roblox.Launch._isIDE = null;
Roblox.Launch._isRobloxBrowser = null;
Roblox.Launch._LaunchGamePage = null;

Roblox.Launch.isIDE = function ()
{
    if (Roblox.Launch._isIDE==null)
    {
        Roblox.Launch._isIDE = false;
        Roblox.Launch._isRobloxBrowser = false;
        if (window.external)
        {
            try
            {
                if (window.external.IsRobloxIDE !== undefined)
                {
                    Roblox.Launch._isIDE = window.external.IsRobloxIDE;
				    Roblox.Launch._isRobloxBrowser = true;
				}   
            }
            catch (ex)
            {
            }
        }
    }
    return Roblox.Launch._isIDE;
}

Roblox.Launch.isRobloxBrowser = function()
{
    Roblox.Launch.isIDE();
    return Roblox.Launch._isRobloxBrowser;
}


Roblox.Launch.isVista = function()
{
    return navigator.userAgent.indexOf("Windows NT 6.")!=-1;
}

Roblox.Launch.RequestGame = function (behaviorID, placeID)
{
    if (checkRobloxInstall())
    {
        var launcher = new RBX.PlaceLauncher($find(behaviorID));
        launcher.RequestGame(placeID);
    }
}

Roblox.Launch.RequestGameJob = function (behaviorID, gameJobID)
{
    if (checkRobloxInstall())
    {
        var launcher = new RBX.PlaceLauncher($find(behaviorID));
        launcher.RequestGameJob(gameJobID);
    }
}

Roblox.Launch.StartGame = function (visitUrl, authenticationUrl, type, userID)
{
    if (checkRobloxInstall()) {
        urchinTracker("Visit/Try/" + type + "/" + userID);

        var prefix = null;
        try
        {
            prefix = "IsIDE/";
            if (Roblox.Launch.isIDE())
            {
                // Use the direct embedded way
                prefix = "RobloxBrowser/";
                var app = window.external.GetApp();
                
                prefix = "RobloxBrowser/CreateGame/";
                var workspace = app.CreateGame(2);    // Window
                    
                prefix = "RobloxBrowser/ExecUrlScript/";
                workspace.ExecUrlScript(visitUrl);
            }
            else if (Roblox.Launch.isVista())
            {
                prefix = "RobloxLauncher/";
                var launcher = new ActiveXObject("RobloxLauncher.Launcher");
                if (!launcher)
                    throw "launcher is null or undefined";
                
                prefix = "RobloxLauncher/StartGame/";
                launcher.StartGame(authenticationUrl, visitUrl, null, null, null, null);
            }
            else
            {
                prefix = "App/";
                var app = new ActiveXObject("Roblox.App");
                if (!app)
                    throw "app is null or undefined";
                
                prefix = "App/CreateGame/";
                var workspace = app.CreateGame(2);
                    
                prefix = "App/ExecUrlScript/";
                workspace.ExecUrlScript(visitUrl);
            }
            
        }
        catch (err)
        {
            var message = err.message;

            if (message=="User cancelled")
            {
                urchinTracker("Visit/UserCancelled/" + type + "/" + userID);
                return false;
            }
            
            try
            {
                var y = new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch (err3)
            {
                message = "FailedXMLHTTP/" + message;
            }
            
            if (!Roblox.Launch.isRobloxBrowser())
            {
                urchinTracker("Visit/Redirect/" + prefix + encodeURIComponent(message) + "/" + userID);
   				window.location = Roblox.Launch._LaunchGamePage;
			}
			else
                urchinTracker("Visit/Fail/" + prefix + encodeURIComponent(message) + "/" + userID);
				
            return false;
        }

        urchinTracker("Visit/Success/" + type + "/" + userID);
        return true;
    }
}

Roblox.Launch.CheckRobloxInstall = function(clientVersion, installPath, updatePath) {
	try 
	{
		var robloxUpdater = new ActiveXObject("RobloxInstall.Updater");

		// See if product is out of date
		if (robloxUpdater.Version == "") {
			window.location = updatePath;
			return false;
		}
		if (robloxUpdater.Version != clientVersion) {
			window.location = updatePath;
			return false;
		}
	} 
	catch(e) 
	{
		// failure indicates Roblox is not properly installed - install product:
		window.location = installPath;
		return false;
	}
	return true;
}

Type.registerNamespace('RBX');

RBX.PlaceLauncher = function(modalBehavior) {
    this._modalBehavior = modalBehavior;
    
    this._popup = $get(this._modalBehavior.get_PopupControlID());
    this._cancelButton = $get("Cancel", this._popup);
    this._cancelHandler = null;
    
    this._cancelled = false;
   }

RBX.PlaceLauncher.prototype = {

    // TODO: This should only be called once.  What if you call it again???
    RequestGame: function(placeID) {
   
        if (checkRobloxInstall()) {
        
            this._showDialog();
            
            // Now send a request to the Grid...
            var onSuccess = function (result, context) { context._onGameStatus(result); };
            var onError = function (result, context) { context._onError(result); };
            Roblox.PlaceLauncher.Service.RequestGame(placeID, onSuccess, onError, this);
        }
        return false;
    },

    // TODO: This should only be called once.  What if you call it again???
    RequestGameJob: function(gameJobID) {
   
        checkRobloxInstall();
        
        this._showDialog();
        
        // Now send a request to the Grid...
        var onSuccess = function (result, context) { context._onGameStatus(result); };
        var onError = function (result, context) { context._onError(result); };
        Roblox.PlaceLauncher.Service.CheckGameJobStatus(gameJobID, 3, onSuccess, onError, this);
        return false;
    },

    _onGameStatus : function (result) {
        if (this._cancelled)
            return;
        
        this._updateStatus(result.status);

        if (result.status==2)
        {
            Roblox.Launch.StartGame(result.joinScriptUrl, result.authenticationUrl, "Join");
            this._modalBehavior.hide();
        }
        else if (result.status<2)
        {
            // Try again
            var onSuccess = function (result, context) { context._onGameStatus(result); };
            var onError = function (result, context) { context._onError(result); };
            Roblox.PlaceLauncher.Service.CheckGameJobStatus(result.jobID, 3, onSuccess, onError, this);
        }
    },
    
    _updateStatus : function (status)
    {
        $get("Spinner", this._popup).style.display = status<3 ? 'block' : 'none';
        $get("Requesting", this._popup).style.display = 'none';
        $get("Joining", this._popup).style.display = status==2 ? 'inline' : 'none';
        $get("Waiting", this._popup).style.display = status==0 ? 'inline' : 'none';
        $get("Loading", this._popup).style.display = status==1 ? 'inline' : 'none';
        $get("Error", this._popup).style.display = status==3 ? 'inline' : 'none';
        $get("Expired", this._popup).style.display = status==4 ? 'inline' : 'none';
        $get("GameEnded", this._popup).style.display = status==5 ? 'inline' : 'none';
        $get("GameFull", this._popup).style.display = status==6 ? 'inline' : 'none';
   },

    _onError : function (result)
    {
        this._updateStatus(3);
    },

    _onCancel : function(e) {
        this._cancelled = true;
        this._modalBehavior.hide();
        return false;
    },

    _showDialog : function() {
        // Listen for cancel
        this._cancelHandler = Function.createDelegate(this, this._onCancel);
        $addHandler(this._cancelButton, 'click', this._cancelHandler);
        
        this._modalBehavior.show();
    },

    dispose : function() {
        if (this._cancelHandler && _cancelButton) {
            $removeHandler(_cancelButton, 'click', this._cancelHandler);
            this._cancelHandler = null;
        }
        
        RBX.PlaceLauncher.callBaseMethod(this, 'dispose');
    }
}

RBX.PlaceLauncher.registerClass('RBX.PlaceLauncher', null, Sys.IDisposable);

// Notify ScriptManager that this is the end of the script.
if (typeof(Sys) !== 'undefined') Sys.Application.notifyScriptLoaded(); 
