if select(2,UnitClass("player")) ~= "MONK" then return end

local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")

local Geodew = AceAddon:GetAddon("Geodew")

local AceDB = LibStub("AceDB-3.0")
local Geodew_Vivify = AceAddon:NewAddon("Geodew_Vivify", "AceEvent-3.0","AceTimer-3.0")
local bar

function Geodew_Vivify:OnInitialize()
	self.db = AceDB:New("Geodew_VivifyDB",Geodew.Module.generic())
	self.bar=Geodew.UI:CreateBar(self.db)
	bar = self.bar
end

function Geodew_Vivify:Timer()
	if Geodew_Vivify.timer ~=nil then
		Geodew_Vivify:CancelTimer(Geodew_Vivify.timer)
	end
	Geodew_Vivify.timer = Geodew_Vivify:ScheduleRepeatingTimer("TimerFeedback", Geodew_Vivify.db.profile.timer)
end

function Geodew_Vivify:OnEnable()
	bar:Update()
	self:PLAYER_SPECIALIZATION_CHANGED()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
end

local UnitInRaid = UnitInRaid
local UnitInParty = UnitInParty
local UnitIsFriend = UnitIsFriend
local distance = {}
local wipe = wipe
local string_format = string.format
local UnitPosition = UnitPosition
local pairs = pairs
local GetCritChance = GetCritChance
local UnitInRange = UnitInRange
local GetMasteryEffect = GetMasteryEffect
local UnitAura = UnitAura
local UnitIsVisible = UnitIsVisible

local UpliftingTranceInfo = GetSpellInfo(197206)

local spell_power = Geodew.spell_power
local predict = Geodew.predict
local unit_is_injured = Geodew.unit_is_injured
local predict_total = Geodew.predict_total
local predict_crit_pvp = Geodew.predict_crit_pvp
local unit_in_party = Geodew.unit_in_party

function Geodew_Vivify:TimerFeedback()
	local format_str
	local members
	local mouseover
	local mover
	local members
	if UnitInRaid("player") then
		format_str = "raid"
		mouseover = UnitInRaid("mouseover")
		if mouseover == nil then
			bar:Hide()
			return
		end
		mover = string_format("%s%d",format_str,mouseover)
		members = GetNumGroupMembers()
	elseif UnitInParty("player") then
		format_str = "party"
		mouseover = unit_in_party("mouseover")
		members = GetNumGroupMembers()
		if mouseover == nil then
			bar:Hide()
			return
		elseif mouseover == members then
			mover = "player"
		else
			mover = string_format("%s%d",format_str,mouseover)
		end
	else
		bar:Hide()
		return
	end
	
	if UnitIsVisible(mover) == nil then
		bar:Hide()
		return
	end
	local x,y = UnitPosition(mover)
	local crit = GetCritChance()/100
	local spellpower = spell_power()
	local GoM = GetMasteryEffect()/100 * spellpower
	local pvp = UnitIsPVP("player")
	if UnitAura("PLAYER",UpliftingTranceInfo,nil, "player") then
		spellpower = spellpower * 1.4
	end
	local total = predict(mover,2.75*spellpower + GoM,crit,pvp)
	wipe(distance)
	
	local spell_radius = 40 * self.db.profile.radius_factor
	local spell_radius_sq = spell_radius * spell_radius
	local i
	for i = 1,members,1 do
		if i ~= mouseover then
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
			if unit_is_injured(u)==true then
				local dx,dy = UnitPosition(u)
				dx = dx - x
				dy = dy - y
				local ds_sqr = dx*dx + dy * dy
				if ds_sqr < spell_radius then
					distance[u] = ds_sqr
				end
			end
		end
	end
	local k,v
	local mn_k = nil
	local mn_v = spell_radius
	for k,v in pairs(distance) do
		if v < mn_v then
			mn_v = v
			mn_k = k
		end
	end
	if mn_k then
		distance[mn_k] = nil
		total = total + predict(mn_k,2.75*spellpower,crit,pvp)
		mn_v = spell_radius
		mn_k = nil
		for k,v in pairs(distance) do
			if v < mn_v then
				mn_v = v
				mn_k = k
			end
		end
		if mn_k then
			total = total + predict(mn_k,2.75*spellpower,crit,pvp)
		end
	end
	bar:Set(total,(GoM+2.75*3*spellpower)*predict_crit_pvp(crit,pvp))
	bar:Show()
end

function Geodew_Vivify:PLAYER_SPECIALIZATION_CHANGED()
	if GetSpecialization() == 2 then
		if self.timer then
			self:CancelTimer(self.timer)
		end
		self.timer = self:ScheduleRepeatingTimer("TimerFeedback", self.db.profile.timer)
	else
		if self.timer then
			self:CancelTimer(self.timer)
			self.timer = nil
			bar:Hide()
		end
	end
end