local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")

local Geodew = AceAddon:NewAddon("Geodew", "AceEvent-3.0","AceConsole-3.0")
Geodew["UI"] = {}
Geodew["Module"] = {}
--------------------------------------------------------------------------------------
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigCmd = LibStub("AceConfigCmd-3.0")
--------------------------------------------------------------------------------------

function Geodew:OnInitialize()
	self:RegisterChatCommand("Geodew", "ChatCommand")
end

function Geodew:ChatCommand(input)
	if IsAddOnLoaded("Geodew_Options") == false then
		local loaded , reason = LoadAddOn("Geodew_Options")
		if loaded == false then
			self:Print("Geodew_Options: "..reason)
			return
		end
	end
	if not input or input:trim() == "" then
		AceConfigDialog:Open("Geodew")
	else
		AceConfigCmd:HandleCommand("Geodew", "Geodew","")
		AceConfigCmd:HandleCommand("Geodew", "Geodew",input)
	end
end