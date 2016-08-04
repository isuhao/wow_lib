if select(2,UnitClass("player")) ~= "MONK" then return end

local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")

local Geodew = AceAddon:GetAddon("Geodew")

local AceDB = LibStub("AceDB-3.0")
local Geodew_EF = AceAddon:NewAddon("Geodew_EF", "AceEvent-3.0","AceTimer-3.0")
local grid
local bar
local SpellID = 191837

function Geodew_EF:OnInitialize()
	self.db = AceDB:New("Geodew_EFDB",Geodew.Module.range())
	self.grid=Geodew.UI:CreateGrid(self.db)
	grid = self.grid
	self.bar=Geodew.UI:CreateBar(self.db)
	bar = self.bar
	bar:Set(0,1)
	grid:SetTexture(GetSpellTexture(SpellID))
end

function Geodew_EF:OnEnable()
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
local unit_in_range = Geodew.unit_in_range
local spell_power_total= Geodew.spell_power_total
local unit_health_deficit = Geodew.unit_health_deficit
local min = min

function Geodew_EF:TimerFeedback()
	grid:SetPlayerChanneling(SpellID)
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
	local injured_counts = 0
	local i
	local spell_radius = 25 * self.db.profile.radius_factor
	local spell_radius_sq = spell_radius * spell_radius
	local spell = spell_power_total() * 3.66
	local health_deficits = 0
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
		if unit_in_range(u,spell_radius_sq) == true then
			counts = counts + 1
			local hd = unit_health_deficit(u)
			if 0 < hd then
				injured_counts = injured_counts + 1
				health_deficits = health_deficits + min(hd,spell)
			end
		end
	end
	grid.center_text:SetText(counts)
	
	if 6 < injured_counts then
		health_deficits = health_deficits / injured_counts * 6
	end
	bar:Set(health_deficits,spell*6)
end

function Geodew_EF:PLAYER_SPECIALIZATION_CHANGED()
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