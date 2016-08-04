local LibStub = LibStub
local Geodew = LibStub("AceAddon-3.0"):GetAddon("Geodew")
local Geodew_UI = Geodew.UI
local CreateFrame = CreateFrame
local LSM = LibStub("LibSharedMedia-3.0")

local properity

function Geodew_UI.GetBarProperity()
	properity = properity or
	{
		Bar_Lock = false,
		Bar_Left = 700,
		Bar_Top = 800,
		Bar_PercentageFont = LSM:GetDefault("font"),
		Bar_PercentageFontSize = 15,
		Bar_AmountFont = LSM:GetDefault("font"),
		Bar_AmountFontSize = 15,
		
		Bar_Width = 150,
		Bar_Height = 30,
		
		Bar_Low = 0.4,
		Bar_High = 0.8,
		
		Bar_LowColorR = 0,
		Bar_LowColorG = 0,
		Bar_LowColorB = 1,
		Bar_LowColorA = 1,
		
		Bar_MidColorR = 0,
		Bar_MidColorG = 1,
		Bar_MidColorB = 0,
		Bar_MidColorA = 1,
		
		Bar_HighColorR = 1,
		Bar_HighColorG = 0,
		Bar_HighColorB = 0,
		Bar_HighColorA = 1,
		
		Bar_StatusBar = LSM:GetDefault("statusbar"),
		Bar_Background = "Blizzard Dialog Background Dark"
	}
	return properity
end

local class_bar = {}
class_bar.__index = class_bar

function class_bar:Lock()
	local enable = not self.db.profile.lock
	self.frame:SetMovable(enable)
	self.frame:EnableMouse(enable)
end

function class_bar:Size()
	local width= self.db.profile.Bar_Width
	local height = self.db.profile.Bar_Height
	self.frame:SetSize(width,height)
	self.bar:SetSize(width,height)
end

function class_bar:Position()
	self.frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT",self.db.profile.Bar_Left,self.db.profile.Bar_Top)
end

function class_bar:PercentFont()
	self.percent:SetFont(LSM:HashTable("font")[self.db.profile.Bar_PercentageFont],self.db.profile.Bar_PercentageFontSize, "OUTLINE")
end

function class_bar:AmountFont()
	self.amount:SetFont(LSM:HashTable("font")[self.db.profile.Bar_AmountFont], self.db.profile.Bar_AmountFontSize, "OUTLINE")
end

function class_bar:StatusBar()
	self.bar:SetStatusBarTexture(LSM:HashTable("statusbar")[self.db.profile.Bar_StatusBar])
end

function class_bar:Background()
	self.background:SetTexture(LSM:HashTable("background")[self.db.profile.Bar_Background])
end

function class_bar:Update()
	self:Lock()
	self:StatusBar()
	self:Background()
	self:Size()
	self:Position()
	self:PercentFont()
	self:AmountFont()
end

local function on_mouse_down(frame)
	frame:StartMoving()
end

local function on_mouse_up(frame)
	frame:StopMovingOrSizing()
	local profile = frame.bar.db.profile
	profile.Bar_Left = frame:GetLeft()
	profile.Bar_Top = frame:GetTop()
end

local function on_drag_stop(frame)
	frame:StopMovingOrSizing()
end

function Geodew_UI:CreateBar(db)
	local frme = CreateFrame("Frame",nil,UIParent)
	frme:SetFrameStrata("MEDIUM")
	frme:SetClampedToScreen(true)
	frme:SetPoint("CENTER", UIParent, "CENTER",0,0)
	frme:Hide()
	local b =  frme : CreateTexture(nil, "BACKGROUND")
	b:SetAllPoints(frme)
	local br =  CreateFrame("StatusBar",nil,frme)
	br:SetPoint("CENTER", frme, "CENTER",0,0)
	br:SetFrameLevel(br:GetFrameLevel()-1)
	br:SetMinMaxValues(0,1)
	local per = frme:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	per:SetPoint("RIGHT", frme, "RIGHT",0, 0)
	local amt = frme:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	amt:SetPoint("RIGHT", frme, "CENTER",0, 0)
	local o = {["frame"]=frme,["background"]=b,["bar"]=br,["percent"]=per,["amount"]=amt,["db"]=db}
	setmetatable(o, class_bar)
	frme.bar = o
	frme:SetScript("OnMouseDown", on_mouse_down)
	frme:SetScript("OnMouseUp", on_mouse_up)
	frme:SetScript("OnDragStop", on_drag_stop)
	return o
end


local string_format = string.format
local amount_format = "%.0f"
local percent_format = "%.0f%%"

function class_bar:Hide()
	self.frame : Hide()
end

function class_bar:Show()
	self.frame : Show()
end

function class_bar:Set(amount,mx)
	local percent = amount/mx
	local profile = self.db.profile
	local bar = self.bar
	if percent< profile.Bar_Low then
		bar:SetStatusBarColor(profile.Bar_LowColorR,profile.Bar_LowColorG,profile.Bar_LowColorB,profile.Bar_LowColorA)
	elseif percent < profile.Bar_High then
		bar:SetStatusBarColor(profile.Bar_MidColorR,profile.Bar_MidColorG,profile.Bar_MidColorB,profile.Bar_MidColorA)
	else
		bar:SetStatusBarColor(profile.Bar_HighColorR,profile.Bar_HighColorG,profile.Bar_HighColorB,profile.Bar_HighColorA)
	end
	self.bar:SetValue(percent)
	
	self.percent:SetText(string_format(percent_format,100*percent))
	self.amount:SetText(string_format(amount_format,amount))
end

Geodew_UI.bar = class_bar