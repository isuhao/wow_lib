if select(2,UnitClass("player")) ~= "MONK" then return end

local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")

local Geodew = AceAddon:GetAddon("Geodew")

local AceDB = LibStub("AceDB-3.0")
local Geodew_Revival = AceAddon:NewAddon("Geodew_Revival", "AceEvent-3.0","AceTimer-3.0")
local grid
local bar
local SpellID = 115310

function Geodew_Revival:OnInitialize()
	self.db = AceDB:New("Geodew_RevivalDB",Geodew.Module.raid_cd())
	self.grid=Geodew.UI:CreateGrid(self.db)
	grid = self.grid
	self.bar=Geodew.UI:CreateBar(self.db)
	bar = self.bar
	bar:Set(0,1)
	grid:SetTexture(GetSpellTexture(SpellID))
end

function Geodew_Revival:OnEnable()
	grid:Update()
	bar:Update()
	self:PLAYER_SPECIALIZATION_CHANGED()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
end

local UnitInRaid = UnitInRaid
local UnitInParty = UnitInParty
local GetNumGroupMembers = GetNumGroupMembers
local string_format = string.format
local UnitBuff = UnitBuff
local select = select
local pairs = pairs
local unit_in_40y = Geodew.unit_in_40y
local spell_power= Geodew.spell_power
local unit_health_deficit = Geodew.unit_health_deficit
local predict = Geodew.predict
local predict_total = Geodew.predict_total
local min = min
local GetCritChance = GetCritChance
local UnitIsPVP = UnitIsPVP
local GetTime = GetTime

local function ready()
	local start, duration = GetSpellCooldown(SpellID)
	local gtime = GetTime()
	return (start == 0 or duration <= 10) or start+duration<= gtime + Geodew_Revival.db.profile.raid_cd_prepare_time
end

function Geodew_Revival:TimerFeedback()
	if ready() ~= true then
		grid:Hide()
		bar:Hide()
		return
	end
	grid:SetCD(SpellID)
	local format_str
	local members
	if UnitInRaid("player") then
		format_str = "raid"
		members = GetNumGroupMembers()
	elseif UnitInParty("player") then
		format_str = "party"
		members = GetNumGroupMembers()
	else
		format_str="player"
		members = 1
	end
	local counts = 0
	local i
	local spell = spell_power() * 7.2
	local health_deficits = 0
	local crit = GetCritChance() /100
	local pvp = UnitIsPVP("player")
	for i = 1,members,1 do
		local u
		if i == members then
			if format_str == "raid" then
				u = string_format("%s%d",format_str,i)
			else
				u = "player"
			end
		else
			u = string_format("%s%d",format_str,i)
		end
		if unit_in_40y(u) == true then
			counts = counts + 1
			health_deficits = health_deficits + predict(u,spell,crit,pvp)
		end
	end
	if counts == 0 then
		grid:Hide()
		bar:Hide()
	else
		grid.center_text:SetText(counts)
		bar:Set(health_deficits,predict_total(spell,counts,crit,pvp))
		grid:Show()
		bar:Show()
	end
end

function Geodew_Revival:PLAYER_SPECIALIZATION_CHANGED()
	if GetSpecialization() == 2 then
		if self.timer then
			self:CancelTimer(self.timer)
		end
		self.timer = self:ScheduleRepeatingTimer("TimerFeedback", self.db.profile.timer)
		bar:Show()
		grid:Show()
	else
		if self.timer then
			self:CancelTimer(self.timer)
			self.timer = nil
			bar:Hide()
			grid:Hide()
		end
	end
end