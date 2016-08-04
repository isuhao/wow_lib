if select(2,UnitClass("player")) ~= "MONK" then return end

local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")

local Geodew = AceAddon:GetAddon("Geodew")

local AceDB = LibStub("AceDB-3.0")
local Geodew_ReM = AceAddon:NewAddon("Geodew_ReM", "AceEvent-3.0","AceTimer-3.0")
local grid
local SpellID = 119611

function Geodew_ReM:OnInitialize()
	self.db = AceDB:New("Geodew_ReMDB",Geodew.Module.hot())
	self.grid=Geodew.UI:CreateGrid(self.db)
	grid = self.grid
	grid:SetTexture(GetSpellTexture(SpellID))
end

function Geodew_ReM:OnEnable()
	grid:Update()
	self:PLAYER_SPECIALIZATION_CHANGED()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
end

local UnitInRaid = UnitInRaid
local UnitInParty = UnitInParty
local GetTime = GetTime
local GetNumGroupMembers = GetNumGroupMembers
local string_format = string.format
local UnitBuff = UnitBuff
local ReMInfo = GetSpellInfo(SpellID)
local select = select
local UnitGUID = UnitGUID
local pairs = pairs

local unordered_map = {}
local start_event_time
function Geodew_ReM:COMBAT_LOG_EVENT_UNFILTERED(...)
	local spell_caster = select(5, ...)
	local player_guid = UnitGUID("player")
	if spell_caster == player_guid  then
		local event_time = select(2,...)
		local battle_message = select(3, ...)
		local spell_id  =  select(13, ...)
		local dst_guid = select(9,...)
		local dst_name = select(10,...)
		if spell_id == 119611 and dst_guid ~= player_guid then
			if battle_message == "SPELL_AURA_REMOVED" then
				unordered_map[dst_name] = nil
			elseif battle_message == "SPELL_AURA_APPLIED" then
				if(start_event_time==nil) then
					start_event_time = GetTime() - event_time
				end
				unordered_map[dst_name] = event_time + start_event_time +20
			end
		end
	end
end

function Geodew_ReM:TimerFeedback()
	grid:SetCD(115151)
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
	local gtime = GetTime()
	local k,v
	local unordered_map_counts = 0
	for k,v in pairs(unordered_map) do
		if UnitInRaid(k) or UnitInParty(k) then
			unordered_map[k] = nil
		else
			if gtime<=v and v<=gtime+20 then
				unordered_map_counts = unordered_map_counts + 1
			else
				unordered_map[k] = nil
			end
		end
	end
	local counts = unordered_map_counts
	local i
	local min_duration = gtime+30
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
		local d = select(7, UnitBuff(u, ReMInfo, nil, "player"))
		if d~=nil and gtime<=d then
			counts = counts + 1
			if (d<min_duration) then
				min_duration = d
			end
		end
	end
	if counts == 0 then
		grid:Hide()
	else
		grid.center_text:SetText(counts)
		if counts == unordered_map_counts then
			grid.bottom_text:Hide()
		else
			grid.bottom_text:SetText(string_format("%.1f",min_duration-gtime))
			grid.bottom_text:Show()
		end
		grid:Show()
	end
end

function Geodew_ReM:PLAYER_SPECIALIZATION_CHANGED()
	if GetSpecialization() == 2 then
		if self.timer then
			self:CancelTimer(self.timer)
		end
		self.timer = self:ScheduleRepeatingTimer("TimerFeedback", self.db.profile.timer)
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		if self.timer then
			self:CancelTimer(self.timer)
			self.timer = nil
			grid:Hide()
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			wipe(unordered_map)
		end
	end
end