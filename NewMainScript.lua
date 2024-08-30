if getgenv and not getgenv().shared then getgenv().shared = {} end
local errorPopupShown = false
local setidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end
local getidentity = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity or function() return 8 end
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local delfile = delfile or function(file) writefile(file, "") end
local cheatengineexecutors = {"Solara", "Celery", "Feather", "MantiWPF", "Octane", "Nyx", "Appleware", "Salad", "Nova"}

local function displayErrorPopup(text, func)
	local oldidentity = getidentity()
	setidentity(8)
	local ErrorPrompt = getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.ErrorPrompt)
	local prompt = ErrorPrompt.new("Default")
	prompt._hideErrorCode = true
	local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	prompt:setErrorTitle("Vape")
	prompt:updateButtons({{
		Text = "OK",
		Callback = function() 
			prompt:_close() 
			if func then func() end
		end,
		Primary = true
	}}, 'Default')
	prompt:setParent(gui)
	prompt:_open(text)
	setidentity(oldidentity)
end

local function vapeGithubRequest(scripturl)
	if not isfile("vape/"..scripturl) then
		local suc, res
		task.delay(15, function()
			if not res and not errorPopupShown then 
				errorPopupShown = true
				displayErrorPopup("The connection to github is taking a while, Please be patient.")
			end
		end)
		suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/sstvskids/SkidVapeForRoblox/"..readfile("vape/commithash.txt").."/"..scripturl, true) end)
		if not suc or res == "404: Not Found" then
			displayErrorPopup("Failed to connect to github : vape/"..scripturl.." : "..res)
			error(res)
		end
		if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
		writefile("vape/"..scripturl, res)
	end
	return readfile("vape/"..scripturl)
end

if not shared.VapeDeveloper then 
	local commit = "main"
	for i,v in pairs(game:HttpGet("https://github.com/sstvskids/SkidVapeForRoblox"):split("\n")) do 
		if v:find("commit") and v:find("fragment") then 
			local str = v:split("/")[5]
			commit = str:sub(0, str:find('"') - 1)
			break
		end
	end
	if commit then
		if isfolder("vape") then 
			if ((not isfile("vape/commithash.txt")) or (readfile("vape/commithash.txt") ~= commit or commit == "main")) then
				for i,v in pairs({"vape/Universal.lua", "vape/MainScript.lua", "vape/GuiLibrary.lua"}) do 
					if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
						delfile(v)
					end 
				end
				if isfolder("vape/CustomModules") then 
					for i,v in pairs(listfiles("vape/CustomModules")) do 
						if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
							delfile(v)
						end 
					end
				end
				if isfolder("vape/Libraries") then 
					for i,v in pairs(listfiles("vape/Libraries")) do 
						if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
							delfile(v)
						end 
					end
				end
				writefile("vape/commithash.txt", commit)
			end
		else
			makefolder("vape")
			writefile("vape/commithash.txt", commit)
		end
	else
		displayErrorPopup("Failed to connect to github, please try using a VPN.")
		error("Failed to connect to github, please try using a VPN.")
	end
end

pcall(function()
	if identifyexecutor then
	    local executor = string.lower(identifyexecutor())
	    for i, v in pairs(cheatengineexecutors) do
	        if string.find(executor, string.lower(v)) then
	            warn("Executors who fake their UNC (Claim to be 100% UNC), or are level 3 or whom which broke a function will NOT be supported. This means that "..identifyexecutor().." executor will not be supported.")
				game:GetService("StarterGui"):SetCore("SendNotification", {
					Title = "Skid-Vxpe",
					Text = ""..identifyexecutor().." not supported! Check console for more information, or wait until a warning appears for more info!",
					Duration = 10,
					Icon = "rbxassetid://76015764869546"
				})					
			end
	    end
	end
end)

return loadstring(vapeGithubRequest("MainScript.lua"))()
print("Skid-Vxpe | NewMainScript.lua")
