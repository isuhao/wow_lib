local LibStub = LibStub
local Geodew = LibStub("AceAddon-3.0"):GetAddon("Geodew")
local Geodew_UI = Geodew.UI
local CreateFrame = CreateFrame
local bg_texture = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark"
local statusbar_texture ="Interface\\TargetingFrame\\UI-StatusBar"
local LSM = LibStub("LibSharedMedia-3.0")

local properity

function Geodew_UI.GetGridProperity()
	properity = properity or
	{
		Grid_Lock = false,
		Grid_Left = 700,
		Grid_Top = 800,
		Grid_Size = 60,
		Grid_CenterTextFont = LSM:GetDefault("font"),
		Grid_CenterTextSize = 30,
		Grid_BottomTextFont = LSM:GetDefault("font"),
		Grid_BottomTextSize = 15,
	}
	return properity
end


local class_grid = {}
class_grid.__index = class_grid

function class_grid:Lock()
	local enable = not self.db.profile.lock
	self.frame:SetMovable(enable)
	self.frame:EnableMouse(enable)
end

function class_grid:Size()
	local size= self.db.profile.Grid_Size
	self.frame:SetSize(size,size)
end
function class_grid:CenterText()
	local profile = self.db.profile
	self.center_text:SetFont(LSM:HashTable("font")[profile.Grid_CenterTextFont], profile.Grid_CenterTextSize, "OUTLINE")
end
function class_grid:BottomText()
	local profile = self.db.profile
	self.bottom_text:SetFont(LSM:HashTable("font")[profile.Grid_BottomTextFont], profile.Grid_BottomTextSize, "OUTLINE")
end
function class_grid:Position()
	self.frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT",self.db.profile.Grid_Left,self.db.profile.Grid_Top)
end

function class_grid:Update()
	self:Lock()
	self:CenterText()
	self:BottomText()
	self:Size()
	self:Position()
end

local function on_mouse_down(frame)
	frame:StartMoving()
end

local function on_mouse_up(frame)
	frame:StopMovingOrSizing()
	local profile = frame.grid.db.profile
	profile.Grid_Left = frame:GetLeft()
	profile.Grid_Top = frame:GetTop()
end

local function on_drag_stop(frame)
	frame:StopMovingOrSizing()
end

function Geodew_UI:CreateGrid(db)
	local frme = CreateFrame("Frame",nil,UIParent)
	frme:SetFrameStrata("MEDIUM")
	frme:SetClampedToScreen(true)
	frme:SetPoint("CENTER", UIParent, "CENTER",0,0)
	local b =  frme : CreateTexture(nil, "BACKGROUND")
	b:SetAllPoints(frme)
	b:SetTexCoord(0.1,0.9,0.1,0.9)	
	local ct = frme:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	ct:SetPoint("Center", frme, "CENTER",0, 0)
	local btmt = frme:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	btmt:SetPoint("Bottom", frme, "Bottom",0, 0)
	local cd = CreateFrame("Cooldown", nil, frme, "CooldownFrameTemplate")
	cd:SetHideCountdownNumbers(true) 
	local o = {["frame"]=frme,["background"]=b,["center_text"]=ct,["bottom_text"]=btmt,["cooldown"]=cd,["db"]=db}
	setmetatable(o, class_grid)
	frme.grid = o
	frme:SetScript("OnMouseDown", on_mouse_down)
	frme:SetScript("OnMouseUp", on_mouse_up)
	frme:SetScript("OnDragStop", on_drag_stop)
	return o
end


local string_format = string.format
local amount_format = "%.0f"
local percent_format = "%.0f%%"

function class_grid:Hide()
	self.frame : Hide()
end

function class_grid:Show()
	self.frame : Show()
end

function class_grid:SetTexture(texture)
	self.background:SetTexture(texture)
end

local GetSpellCooldown = GetSpellCooldown
local UnitChannelInfo = UnitChannelInfo
local GetSpellInfo = GetSpellInfo

function class_grid:SetCD(spellid)
	self.cooldown:SetCooldown(GetSpellCooldown(spellid))
end

function class_grid:SetPlayerChanneling(spellid)
	local name, subText, text, texture, startTime, endTime = UnitChannelInfo("player")
	if name == GetSpellInfo(spellid) then
		startTime = startTime / 1000
		endTime = endTime / 1000
		self.cooldown:SetCooldown(startTime,endTime-startTime)
	else
		self:SetCD(spellid)
	end
end

Geodew_UI.grid = class_grid