local lplr = game.Players.LocalPlayer
local skidstore = {
	cheatengine = {"Solara", "Celery", "Feather", "MantiWPF", "Octane", "Nyx", "Appleware", "Salad", "Nova", "Rebel", "Ignite", "Incognito", "Scythex", "Jules", "Cubix iOS", "Delta iOS", "Nezur", "Xeno", "Maven"},
	skidver = "Next-Gen",
	skiduser = lplr.Name,
	skiduserid = lplr.UserId
}

local function AntiLog()
	local request = http_request or request or HttpPost or syn.request or fluxus.request
	local oldfunc
	oldfunc = hookfunction(request, function(requestData,...)
		if string.find(requestData.Url, 'discord') or string.find(requestData.Url, 'webhook') or string.find(requestData.Url, 'ipv4') or string.find(requestData.Url, 'paypal') or string.find(requestData.Url, 'roblox') or string.find(requestData.Url, 'voidware') then
			requestData.Url = 'jewish syop shit'
		end

		return oldfunc(requestData,...)
	end)
end

setmetatable(skidstore, {
	__index = {
		AntiLog = AntiLog
	}
})

return skidstore
