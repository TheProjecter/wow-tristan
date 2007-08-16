EnhancerDebug = AceLibrary("AceAddon-2.0"):new();

local L = AceLibrary("AceLocale-2.2"):new("EnhancerDebug")
L:RegisterTranslations("enUS", function() return {
	
	["DRAG HERE"] = true,
	
} end )

function EnhancerDebug:SetupFrames()
	if (self.dragbutton) then return; end
	self.dragbutton = CreateFrame("Button",nil,UIParent)
	self.dragbutton.owner = self
	self.dragbutton:Hide()
	self.dragbutton:ClearAllPoints()
	self.dragbutton:SetWidth(200)
	self.dragbutton:SetHeight(25)

	if Enhancer.db.profile.debugframe.x and Enhancer.db.profile.debugframe.y then
		self.dragbutton:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Enhancer.db.profile.debugframe.x, Enhancer.db.profile.debugframe.y)
	else
		self.dragbutton:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 0, 0)
	end
	self.dragbutton:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right =5, top = 5, bottom = 5 }
	})
	self.dragbutton:SetBackdropColor(1,0,0,.4)

	self.dragbutton:SetMovable(true)
	self.dragbutton:RegisterForDrag("LeftButton")
	self.dragbutton:SetScript("OnDragStart", function() this.owner.dragbutton:StartMoving() end )
	self.dragbutton:SetScript("OnDragStop",
		function()
			this.owner.dragbutton:StopMovingOrSizing()
			local _,_,_,x,y = this:GetPoint("CENTER")
			Enhancer.db.profile.debugframe.x = x
			Enhancer.db.profile.debugframe.y = y
		end
	)
	-- self.dragbutton:RegisterForClicks("RightButtonUp")
	-- self.dragbutton:SetScript("OnClick", function() self:UpdateLock() end);

	self.dragtext = self.dragbutton:CreateFontString(nil, "OVERLAY")
	self.dragtext.owner = self
	self.dragtext:SetFontObject(GameFontNormalSmall)
	self.dragtext:ClearAllPoints()
	self.dragtext:SetTextColor(1, 1, 1, 1)
	self.dragtext:SetWidth(200)
	self.dragtext:SetHeight(25)
	self.dragtext:SetPoint("TOPLEFT", self.dragbutton, "TOPLEFT")
	self.dragtext:SetJustifyH("CENTER")
	self.dragtext:SetJustifyV("MIDDLE")
	self.dragtext:SetText(L["DRAG HERE"])

	self.msgframe = CreateFrame("MessageFrame")
	self.msgframe.owner = self
	self.msgframe:ClearAllPoints()
	self.msgframe:SetWidth(400)
	self.msgframe:SetHeight(200)
	self.msgframe:SetPoint("TOP", self.dragbutton, "TOP", 0, 0)
	self.msgframe:SetInsertMode("BOTTOM")
	self.msgframe:SetJustifyH("LEFT")
	self.msgframe:SetFrameStrata("HIGH")
	self.msgframe:SetToplevel(true)
	
	self.msgframe:SetFontObject(GameFontNormal)

	self:UpdateLock()

	self.msgframe:Show()
end

function EnhancerDebug:UpdateLock()
	if (not self.msgframe) then return; end
	if Enhancer.db.profile.debugframe.lock then
		self.dragbutton:SetMovable(false)
		self.dragbutton:RegisterForDrag()
		self.msgframe:SetBackdrop(nil)
		self.msgframe:SetBackdropColor(0,0,0,0)
		self.dragbutton:Hide()
	else
		self.dragbutton:Show()
		self.dragbutton:SetMovable(true)
		self.dragbutton:RegisterForDrag("LeftButton")
		self.msgframe:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right =5, top = 5, bottom = 5 }
		})
		self.msgframe:SetBackdropColor(1,0,0,.4)
	end
end

function Enhancer:DebugLock()
	EnhancerDebug:UpdateLock();
end

function Enhancer:DebugFrames()
	EnhancerDebug:SetupFrames();
end

function Enhancer:Debug(message)
	if not EnhancerDebug.msgframe then return; end
	EnhancerDebug.msgframe:AddMessage(message, 1, 1, 1, 1, UIERRORS_HOLD_TIME);
end