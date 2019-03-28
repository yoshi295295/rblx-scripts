

var isIDE_ = 2;

function isIDE()
{
	if (isIDE_==2)
	{
		try
		{
			isIDE_ = window.external.IsRobloxIDE;
		}
		catch (ex)
		{
			isIDE_ = false;
		}
	}
	return isIDE_;
}

function rbxStartGame(urlRoot, visitUrl)
{
	if (checkRobloxInstall()) {
	    try
	    {
	        urchinTracker("VisitTry");
		    var app = new ActiveXObject("Roblox.App");
		    var workspace = app.CreateGame(2);	// Window
    			
		    workspace.ExecUrlScript(urlRoot + visitUrl);
    			
		    workspace = app.NullDispatch;
		    app = app.NullDispatch;
	        urchinTracker("VisitSuccess");
		    return true;
		}
		catch (err)
		{
	        urchinTracker("VisitFail/" + escape(err.message) + "?url=" + escape(visitUrl));
		    return false;
		}
	}
}


