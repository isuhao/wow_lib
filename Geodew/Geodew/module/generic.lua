local Geodew = LibStub("AceAddon-3.0"):GetAddon("Geodew")
local Geodew_UI = Geodew["UI"]
local Geodew_Module = Geodew["Module"]
local properity
local pairs = pairs
local setmetatable = setmetatable

function Geodew_Module.generic()
	if properity == nil then
		local p =
		{
			timer = 0.1
		}
		local bar_pr = Geodew_UI.GetBarProperity()
		local k,v
		for k,v in pairs(bar_pr) do
			p[k]=v
		end
		properity=
		{
			profile = p
		}
	end
	return properity
end

local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsDeadOrGhost = UnitIsDeadOrGhost

function Geodew.unit_is_injured(u)
	return UnitIsDeadOrGhost(u)==false and UnitHealth(u)<UnitHealthMax(u)
end

local GetSpellBonusHealing = GetSpellBonusHealing
local GetCombatRatingBonus = GetCombatRatingBonus
local CR_VERSATILITY_DAMAGE_DONE = CR_VERSATILITY_DAMAGE_DONE

function Geodew.spell_power()
	return GetSpellBonusHealing() * (1+ GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)/100)
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