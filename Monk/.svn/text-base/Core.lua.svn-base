local Geodew = LibStub("AceAddon-3.0"):GetAddon("Geodew")

local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsVisible = UnitIsVisible
local UnitDistanceSquared = UnitDistanceSquared
local UnitInRange = UnitInRange
local GetSpellInfo = GetSpellInfo

function Geodew.unit_is_visible(u)
	return UnitIsDeadOrGhost(u)==false and UnitIsVisible(u) == true
end
local unit_is_visible = Geodew.unit_is_visible
function Geodew.unit_in_range(u,range)
	return unit_is_visible(u) and UnitDistanceSquared(u)<range
end

function Geodew.unit_in_40y(u)
	return UnitIsDeadOrGhost(u)==false and IsSpellInRange(GetSpellInfo(115151),u) == 1
end

function Geodew.unit_is_injured(u)
	return UnitIsDeadOrGhost(u)==false and UnitHealth(u)<UnitHealthMax(u)
end

function Geodew.unit_health_deficit(u)
	return UnitHealthMax(u) - UnitHealth(u)
end

local GetSpellBonusHealing = GetSpellBonusHealing
local GetCombatRatingBonus = GetCombatRatingBonus
local CR_VERSATILITY_DAMAGE_DONE = CR_VERSATILITY_DAMAGE_DONE

function Geodew.spell_power()
	return GetSpellBonusHealing() * (1+ GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)/100)
end

local spell_power = Geodew.spell_power
local UnitIsPVP = UnitIsPVP
local UnitIsUnit = UnitIsUnit
local GetCritChance = GetCritChance
local GetNumGroupMembers = GetNumGroupMembers
local string_format = string.format
function Geodew.spell_power_total()
	if UnitIsPVP("player") then
		return spell_power() * (1 + GetCritChance()/100)
	else
		return spell_power() * (1 + GetCritChance()/200)
	end
end

function Geodew.unit_in_party(u)
	local i
	local num = GetNumGroupMembers()
	for i=1,num do
		if UnitIsUnit(u,string_format("party%d",i)) then
			return i
		end
	end
end

function Geodew.predict(u,base,crit,pvp)
	local maxhealth = UnitHealthMax(u) - UnitHealth(u)
	if pvp == true then
		if maxhealth < base then
			return maxhealth
		elseif maxhealth < base * 1.5 then
			return base * (1-crit) + crit * maxhealth
		else
			return base * (1+crit * 0.5)
		end
	else
		if maxhealth < base then
			return maxhealth
		elseif maxhealth < base * 2 then
			return base * (1-crit) + crit * maxhealth
		else
			return base * (1+crit)
		end
	end
end

function Geodew.predict_crit_pvp(crit,pvp)
	if pvp == true then
		return (1+crit * 0.5)
	else
		return (1+crit)
	end
end
local predict_crit_pvp = Geodew.predict_crit_pvp
function Geodew.predict_total(base,counts,crit,pvp)
	return base * counts * predict_crit_pvp(crit,pvp)
end