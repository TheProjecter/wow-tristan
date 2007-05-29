--[[
		All of this code is ripped straight from oRA2 only name of the frame was changed
		ALL CREDIT oRA2 dev team
		ALL CREDIT oRA2 dev team
		ALL CREDIT oRA2 dev team
		ALL CREDIT oRA2 dev team
		ALL CREDIT oRA2 dev team
		ALL CREDIT oRA2 dev team
		ALL CREDIT oRA2 dev team
]]
local L = AceLibrary("AceLocale-2.2"):new("RaidInfo")

function RaidInfo:SetupFrames()
	if not self.anchorframe then
		local anchorframe = CreateFrame("Frame", self.name.."AnchorFrame", UIParent)
		anchorframe:EnableMouse(true)
		anchorframe:SetMovable(true)
		anchorframe:RegisterForDrag("LeftButton")
		anchorframe:SetScript("OnDragStart", function() if IsAltKeyDown() then self["anchorframe"]:StartMoving() end end)
		anchorframe:SetScript("OnDragStop", function() self["anchorframe"]:StopMovingOrSizing() self:SavePosition() end)
		anchorframe:SetWidth(175)
		anchorframe:SetHeight(50)
		anchorframe:Hide()
		anchorframe:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

		local title = anchorframe:CreateFontString(nil, "ARTWORK")
		title:SetFontObject(GameFontNormalSmall)
		title:SetText(L["AnchorFrameTitle"])
		title:SetJustifyH("CENTER")
		title:SetWidth(160)
		title:SetHeight(12)
		title:Show()
		title:ClearAllPoints()
		title:SetPoint("TOP", anchorframe, "TOP", 0, -5)

		local text = anchorframe:CreateFontString(nil, "ARTWORK")
		text:SetFontObject(GameFontHighlightSmall)
		text:SetJustifyH("CENTER")
		text:SetJustifyV("TOP")
		text:SetWidth(160)
		--text:SetHeight(25)
		text:Show()
		text:ClearAllPoints()
		text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -5)

		self.anchorframe = anchorframe
		self.anchorframetitle = title
		self.anchorframetext = text
		
		self:ToggleAnchorFrame()
		self:RestorePosition()
	end
end

function RaidInfo:SavePosition()
	local f = self.anchorframe
	local x,y = f:GetLeft(), f:GetTop()
	local s = f:GetEffectiveScale()
		
	x,y = x*s,y*s

	self.db.profile.posx = x
	self.db.profile.posy = y
	
	self:CandyBarPosition()
end

function RaidInfo:CandyBarPosition()
	local candyBarGrowUp = (not (self.anchorframe:GetTop() > (GetScreenHeight() / 2)))
	self:SetCandyBarGroupGrowth(self.name, candyBarGrowUp)
	if (candyBarGrowUp) then
		self:SetCandyBarGroupPoint(self.name, "BOTTOM", self.anchorframetext, "TOP", 0, 25)
	else
		self:SetCandyBarGroupPoint(self.name, "TOP", self.anchorframetext, "BOTTOM", 0, 0)
	end
end

function RaidInfo:RestorePosition()
	local x = self.db.profile.posx
	local y = self.db.profile.posy
		
	if not x or not y then return end
				
	local f = self.anchorframe
	local s = f:GetEffectiveScale()

	x,y = x/s,y/s

	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
end

function RaidInfo:ToggleAnchorFrame()
	if self.db.profile.anchorframehidden then
		self.anchorframe:Hide()
	else
		self.anchorframe:Show()
	end
end



function RaidInfo:ToggleView()
	self.db.profile.anchorframehidden = not self.db.profile.anchorframehidden
	if self.anchorframe and self.anchorframe:IsVisible() then
		self.anchorframe:Hide()
	end
	if not self.db.profile.anchorframehidden then
		if not self.anchorframe then self:SetupFrames() end
		self.anchorframe:Show()
	end
end
