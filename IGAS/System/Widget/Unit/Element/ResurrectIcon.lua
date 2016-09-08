-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.ResurrectIcon", version) then
	return
end

__Doc__[[The resurrect indicator]]
class "ResurrectIcon"
	inherit "Texture"
	extend "IFResurrect"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function ResurrectIcon(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.TexturePath = [[Interface\RaidFrame\Raid-Icon-Rez]]
		self.Height = 16
		self.Width = 16
	end
endclass "ResurrectIcon"