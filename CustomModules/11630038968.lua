local cloneref = cloneref or function(val)
    return val
end
local run = function(func)
    func()
end

local GuiLibrary = shared.GuiLibrary
local wingui = shared.wingui
local playersService = cloneref(game:GetService('Players'))
local textService = cloneref(game:GetService('TextService'))
local lightingService = cloneref(game:GetService('Lighting'))
local textChatService = cloneref(game:GetService('TextChatService'))
local inputService = cloneref(game:GetService('UserInputService'))
local runService = cloneref(game:GetService('RunService'))
local tweenService = cloneref(game:GetService('TweenService'))
local collectionService = cloneref(game:GetService('CollectionService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer

local vapeConnections = {}
local vapeCachedAssets = {}
local vapeEvents = setmetatable({}, {
	__index = function(self, index)
		self[index] = Instance.new('BindableEvent')
		return self[index]
	end
})
local vapeInjected = true
local entitylib = shared.vapeentity
local targetinfo = shared.VapeTargetInfo

local bd = {}
local store = {
	blocks = {},
	serverBlocks = {}
}

local function getTool()
	return lplr.Character and lplr.Character:FindFirstChildWhichIsA('Tool', true) or nil
end

local function warningNotification(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title, text, delay, 'assets/WarningNotification.png')
		frame.Frame.Frame.ImageColor3 = Color3.new(255, 255, 255)
		return frame
	end)
	return (suc and res)
end

-- me when laziness gets the best of you
for _, v in {'SilentAim', 'Reach', 'MouseTP', 'AutoClicker', 'HitBoxes', 'LongJump', 'Killaura', 'TriggerBot', 'AutoLeave', 'ClientKickDisabler', 'AntiVoid'} do
	GuiLibrary.RemoveObject(v)
end

warningNotification('Vape', 'solara vs xeno: battle of the crap executors!!', 3)
error('not finished!!', 2)