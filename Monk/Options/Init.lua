local Geodew_Options = LibStub("AceAddon-3.0"):NewAddon("Geodew_Options")

Geodew_Options.option_table =
{
	type = "group",
	name = "Geodew",
	args = {}
}

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

function Geodew_Options : push(key,val)
	val.order = get_order()
	self.option_table.args[key] = val
end

function Geodew_Options : get_table()
	return self.option_table
end