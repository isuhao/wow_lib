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
	self:Timer()
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

function Geodew_Vivify:TimerFeedback()
	local format_str
	local members
	local mouseover
	if UnitInRaid("player") then
		format_str = "raid"
		mouseover = UnitInRaid("mouseover")
		if mouseover == nil then
			bar:Hide()
			return
		end
	elseif UnitInParty("player") then
		format_str = "party"
		mouseover = UnitInParty("mouseover")
		if mouseover == nil then
			bar:Hide()
			return
		end
	else
		bar:Hide()
		return
	end
	local mover = string_format("%s%d",format_str,mouseover)
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
	local members = GetNumGroupMembers()
	local i
	for i = 1,members,1 do
		if i ~= mouseover then
			local u = string_format("%s%d",format_str,i)
			if unit_is_injured(u)==true then
				local dx,dy = UnitPosition(u)
				dx = dx - x
				dy = dy - y
				local ds_sqr = dx*dx + dy * dy
				if ds_sqr < 1225 then
					distance[u] = ds_sqr
				end
			end
		end
	end
	local k,v
	local mn_k = nil
	local mn_v = 1600
	for k,v in pairs(distance) do
		if v < mn_v then
			mn_v = v
			mn_k = k
		end
	end
	if mn_k then
		distance[mn_k] = nil
		total = total + predict(mn_k,2.75*spellpower,crit,pvp)
		mn_v = 1600
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
	bar:Set(total,(GoM+2.75*3*spellpower)*(1+crit))
	bar:Show()
end