if select(2,UnitClass("player")) ~= "MONK" then return end

local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")

local Geodew = AceAddon:GetAddon("Geodew")

local AceDB = LibStub("AceDB-3.0")
local Geodew_Lifecycles = AceAddon:NewAddon("Geodew_Lifecycles", "AceEvent-3.0","AceTimer-3.0")
local grid

function Geodew_Lifecycles:OnInitialize()
	self.db = AceDB:New("Geodew_LifecyclesDB",Geodew.Module.hot())
	self.grid=Geodew.UI:CreateGrid(self.db)
	grid = self.grid
	grid:Hide()
end

function Geodew_Lifecycles:OnEnable()
	grid:Update()
	self:PLAYER_SPECIALIZATION_CHANGED()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	self:RegisterEvent("PLAYER_TALENT_UPDATE","PLAYER_SPECIALIZATION_CHANGED")
end
local UnitAura = UnitAura
local GetSpellInfo = GetSpellInfo
local Lifecycle_vivify = GetSpellInfo(197916)
local Lifecycle_em = GetSpellInfo(197919)
local GetTime = GetTime
local string_format = string.format
local select = select

function Geodew_Lifecycles:TimerFeedback()
	local name, rank, icon, count, dispelType, duration, expires = UnitAura("PLAYER",Lifecycle_vivify,nil, "player")
	if name == nil then
		name, rank, icon, count, dispelType, duration, expires = UnitAura("PLAYER",Lifecycle_em,nil, "player")
		if name == nil then
			grid:Hide()
			return
		end
	end
	local c = expires - GetTime()
	if 0 < c then
		grid:SetTexture(icon)
		grid.center_text:SetText(string_format("%.0f",c))
		grid.cooldown:SetCooldown(expires-duration,duration)
		grid:Show()
	else
		grid:Hide()
	end
end

function Geodew_Lifecycles:PLAYER_SPECIALIZATION_CHANGED()
	if GetSpecialization() == 2 and select(5,GetTalentInfo(3,1,1)) == true then
		if self.timer then
			self:CancelTimer(self.timer)
		end
		self.timer = self:ScheduleRepeatingTimer("TimerFeedback", self.db.profile.timer)
	else
		if self.timer then
			self:CancelTimer(self.timer)
			self.timer = nil
			grid:Hide()
		end
	end
end