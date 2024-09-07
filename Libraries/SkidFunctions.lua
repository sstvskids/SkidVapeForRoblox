local skidstore = {
	cheatengine = {"Solara", "Celery", "Feather", "MantiWPF", "Octane", "Nyx", "Appleware", "Salad", "Nova", "Rebel", "Ignite", "Incognito", "Scythex", "Jules", "Cubix iOS"},
	skidver = "Next-Gen",
	skiduser = game.Players.LocalPlayer.Username,
	whitelist = shared.vapewhitelist
}

skidstore.CheatEngineCheck = function({
	if identifyexecutor then
	    local executor = string.lower(identifyexecutor())
	    for i, v in pairs(skidstore.cheatengine) do
	        if string.find(executor, string.lower(v)) then
				local frame = GuiLibrary.CreateNotification("Vape", "Executor is not supported. Check console for more information, regarding unsupported executors. ("..executorid..") ", 60, "assets/WarningNotification.png")
				frame.Frame.Frame.ImageColor3 = Color3.fromRGB(255, 255, 255)			
			end
	    end
	end
})

skidstore.VersionCheck = function({
	warningNotification("Skid-Vape "..skidstore.skidver.."", "Logged in as "..skidstore.skiduser.." Whitelist: "..skidstore.whitelist.."", 6.25)
})

getgenv().SkidStore = SkidStore;
return SkidStore
