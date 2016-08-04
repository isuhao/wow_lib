local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local Geodew = AceAddon:GetAddon("Geodew")
local Geodew_Options = AceAddon:GetAddon("Geodew_Options")

local optionsFrames = {}

function Geodew_Options:OnInitialize()
	local options = Geodew_Options : get_table()

--[[	options.args.profile = AceDBOptions:GetOptionsTable(Geodew.db)
	options.args.profile.order = -1
	AceConfig:RegisterOptionsTable("Geodew", options, nil)
	optionsFrames.general = AceConfigDialog:AddToBlizOptions("Geodew", "Geodew")
	Geodew.db.RegisterCallback(Geodew, "OnProfileChanged", "OnEnable")
	Geodew.db.RegisterCallback(Geodew, "OnProfileCopied", "OnEnable")
	Geodew.db.RegisterCallback(Geodew, "OnProfileReset", "OnEnable")]]
end