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
			timer = 0.1,
			radius_factor = 0.95,
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