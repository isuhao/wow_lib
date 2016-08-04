local Geodew = LibStub("AceAddon-3.0"):GetAddon("Geodew")
local Geodew_UI = Geodew["UI"]
local Geodew_Module = Geodew["Module"]
local properity
local pairs = pairs
local setmetatable = setmetatable

function Geodew_Module.hot()
	if properity == nil then
		local p =
		{
			timer = 0.1
		}
		local grid_pr = Geodew_UI.GetGridProperity()
		local k,v
		for k,v in pairs(grid_pr) do
			p[k]=v
		end
		properity=
		{
			profile = p
		}
	end
	return properity
end
