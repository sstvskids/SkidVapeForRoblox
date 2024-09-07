local GuiLibrary = shared.GuiLibrary;
local function warningNotification(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(255, 255, 255)
		return frame
	end)
	return (suc and res)
end
local skidstore = {
	cheatengine = {"Solara", "Celery", "Feather", "MantiWPF", "Octane", "Nyx", "Appleware", "Salad", "Nova", "Rebel", "Ignite", "Incognito", "Scythex", "Jules", "Cubix iOS"},
	skidver = "Next-Gen",
	skiduser = game.Players.LocalPlayer.Name,
	whitelist = shared.vapewhitelist
}

skidstore.cheatenginecheck = function()
	if identifyexecutor then
	    local executor = string.lower(identifyexecutor())
	    for i, v in pairs(skidstore.cheatengine) do
	        if string.find(executor, string.lower(v)) then
				warningNotification("Vape", "Executor is not supported. Check console for more information, regarding unsupported executors. ("..identifyexecutor()..") ", 60, "assets/WarningNotification.png")		
			end
	    end
	end
end

skidstore.versioncheck = function()
	warningNotification("Skid-Vape "..skidstore.skidver.."", "Logged in as "..skidstore.skiduser.." Whitelist: "..skidstore.whitelist.."", 6.25)
end

getgenv().skidstore = skidstore;
return skidstore
