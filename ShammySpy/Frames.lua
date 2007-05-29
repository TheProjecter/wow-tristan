--[[ THIS SHIT (Frames) MAKES MY HEAD HURT! ]]
local L = AceLibrary("AceLocale-2.2"):new("ShammySpy")
local negativeOut = -120;
local positiveOut = 120;
local strataToUse = "BACKGROUND"; --TOOLTIP

--[[ Functions -----------------------------------------------------------------------]]
function ShammySpy:SetupFrames()
	if (not getglobal("ShammySpyEarthFrame")) then
		--[[ Create the anchor ]]
		local ShammySpyEarthFrameAnchor = CreateFrame("Button", "ShammySpyEarthFrameAnchor", UIParent)
		ShammySpyEarthFrameAnchor:Hide()
		ShammySpyEarthFrameAnchor:SetWidth(150)
		ShammySpyEarthFrameAnchor:SetHeight(30)
		ShammySpyEarthFrameAnchor:SetPoint("CENTER", "WorldFrame", "CENTER",  0,  0)
		ShammySpyEarthFrameAnchor:SetMovable(true)
		ShammySpyEarthFrameAnchor:RegisterForDrag("LeftButton")
		ShammySpyEarthFrameAnchor:SetScript("OnDragStart",
			function()
				ShammySpyEarthFrameAnchor:StartMoving()
				ShammySpyEarthFrame:StartMoving()
			end )
		ShammySpyEarthFrameAnchor:SetScript("OnDragStop",
			function()
				ShammySpyEarthFrameAnchor:StopMovingOrSizing()
				ShammySpyEarthFrame:StopMovingOrSizing()
				local _,_,_,x,y = ShammySpyEarthFrameAnchor:GetPoint()
				ShammySpy.db.profile.ShammySpyEarthFrame.x = x
				ShammySpy.db.profile.ShammySpyEarthFrame.y = y
			end )
		ShammySpyEarthFrameAnchor:SetFrameStrata("HIGH")
		ShammySpyEarthFrameAnchor:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right =5, top = 5, bottom = 5 }
		})
		--[[ Create the anchor fontstring ]]
		local ShammySpyEarthFrameAnchorText = ShammySpyEarthFrameAnchor:CreateFontString("ShammySpyEarthFrameText", "OVERLAY")
		ShammySpyEarthFrameAnchorText:SetFontObject(GameFontNormalSmall)
		ShammySpyEarthFrameAnchorText:ClearAllPoints()
		ShammySpyEarthFrameAnchorText:SetTextColor(1, 1, 1, 1)
		ShammySpyEarthFrameAnchorText:SetWidth(120)
		ShammySpyEarthFrameAnchorText:SetHeight(25)
		ShammySpyEarthFrameAnchorText:SetPoint("CENTER", "ShammySpyEarthFrameAnchor", "CENTER")
		ShammySpyEarthFrameAnchorText:SetJustifyH("CENTER")
		ShammySpyEarthFrameAnchorText:SetJustifyV("MIDDLE")
		ShammySpyEarthFrameAnchorText:SetText(L["Click and drag!"])
		
		--[[ Create the frame ]]
		local ShammySpyEarthFrame = CreateFrame("Frame", "ShammySpyEarthFrame", UIParent)
		ShammySpyEarthFrame:SetWidth(35)
		ShammySpyEarthFrame:SetHeight(35)
		ShammySpyEarthFrame:SetFrameStrata(strataToUse)
		ShammySpyEarthFrame:SetPoint("TOP", "ShammySpyEarthFrameAnchor", "BOTTOM", 0, 0)
		ShammySpyEarthFrame:SetMovable(true)
		ShammySpyEarthFrame:SetBackdrop({
			bgFile = "Interface/Icons/Spell_Totem_WardOfDraining",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right =5, top = 5, bottom = 5 }
		})
		ShammySpyEarthFrame:SetBackdropColor( 1, 1, 1, (1/3))
		ShammySpyEarthFrame:SetBackdropBorderColor( 1, 1, 1, 0)
		--[[ Create the fontstring ]]
		local ShammySpyEarthFrameText1 = ShammySpyEarthFrame:CreateFontString("ShammySpyEarthFrameText1", "OVERLAY")
		ShammySpyEarthFrameText1:SetFontObject(GameFontNormalSmall)
		ShammySpyEarthFrameText1:ClearAllPoints()
		ShammySpyEarthFrameText1:SetTextColor(1, 1, 1, 1)
		ShammySpyEarthFrameText1:SetWidth(35)
		ShammySpyEarthFrameText1:SetHeight(20)
		ShammySpyEarthFrameText1:SetPoint("TOP", "ShammySpyEarthFrame", "BOTTOM")
		ShammySpyEarthFrameText1:SetJustifyH("CENTER")
		ShammySpyEarthFrameText1:SetJustifyV("MIDDLE")
		ShammySpyEarthFrameText1:SetText(L["Earth"])
		--[[ Create the 2nd fontstring ]]
		local ShammySpyEarthFrameText2 = ShammySpyEarthFrame:CreateFontString("ShammySpyEarthFrameText2", "OVERLAY")
		ShammySpyEarthFrameText2:SetFontObject(SubZoneTextFont)--GameFontNormalSmall)
		ShammySpyEarthFrameText2:ClearAllPoints()
		ShammySpyEarthFrameText2:SetTextColor(1, 1, 1, 1)
		ShammySpyEarthFrameText2:SetWidth(35)
		ShammySpyEarthFrameText2:SetHeight(35)
		ShammySpyEarthFrameText2:SetPoint("CENTER", "ShammySpyEarthFrame", "CENTER")
		ShammySpyEarthFrameText2:SetJustifyH("CENTER")
		ShammySpyEarthFrameText2:SetJustifyV("MIDDLE")
		ShammySpyEarthFrameText2:SetText("")
	end
	ShammySpyEarthFrame:Show()
	
	if (not getglobal("ShammySpyFireFrame")) then
		--[[ Create the anchor ]]
		local ShammySpyFireFrameAnchor = CreateFrame("Button", "ShammySpyFireFrameAnchor", UIParent)
		ShammySpyFireFrameAnchor:Hide()
		ShammySpyFireFrameAnchor:SetWidth(150)
		ShammySpyFireFrameAnchor:SetHeight(30)
		ShammySpyFireFrameAnchor:SetPoint("CENTER", "WorldFrame", "CENTER",  0,  0)
		ShammySpyFireFrameAnchor:SetMovable(true)
		ShammySpyFireFrameAnchor:RegisterForDrag("LeftButton")
		ShammySpyFireFrameAnchor:SetScript("OnDragStart",
			function()
				ShammySpyFireFrameAnchor:StartMoving()
				ShammySpyFireFrame:StartMoving()
			end )
		ShammySpyFireFrameAnchor:SetScript("OnDragStop",
			function()
				ShammySpyFireFrameAnchor:StopMovingOrSizing()
				ShammySpyFireFrame:StopMovingOrSizing()
				local _,_,_,x,y = ShammySpyFireFrameAnchor:GetPoint()
				ShammySpy.db.profile.ShammySpyFireFrame.x = x
				ShammySpy.db.profile.ShammySpyFireFrame.y = y
			end )
		ShammySpyFireFrameAnchor:SetFrameStrata("HIGH")
		ShammySpyFireFrameAnchor:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right =5, top = 5, bottom = 5 }
		})
		--[[ Create the anchor fontstring ]]
		local ShammySpyFireFrameAnchorText = ShammySpyFireFrameAnchor:CreateFontString("ShammySpyFireFrameText", "OVERLAY")
		ShammySpyFireFrameAnchorText:SetFontObject(GameFontNormalSmall)
		ShammySpyFireFrameAnchorText:ClearAllPoints()
		ShammySpyFireFrameAnchorText:SetTextColor(1, 1, 1, 1)
		ShammySpyFireFrameAnchorText:SetWidth(120)
		ShammySpyFireFrameAnchorText:SetHeight(25)
		ShammySpyFireFrameAnchorText:SetPoint("CENTER", "ShammySpyFireFrameAnchor", "CENTER")
		ShammySpyFireFrameAnchorText:SetJustifyH("CENTER")
		ShammySpyFireFrameAnchorText:SetJustifyV("MIDDLE")
		ShammySpyFireFrameAnchorText:SetText(L["Click and drag!"])
		
		--[[ Create the frame ]]
		local ShammySpyFireFrame = CreateFrame("Frame", "ShammySpyFireFrame", UIParent)
		ShammySpyFireFrame:SetWidth(35)
		ShammySpyFireFrame:SetHeight(35)
		ShammySpyFireFrame:SetFrameStrata(strataToUse)
		ShammySpyFireFrame:SetPoint("TOP", "ShammySpyFireFrameAnchor", "BOTTOM", 0, 0)
		ShammySpyFireFrame:SetMovable(true)
		ShammySpyFireFrame:SetBackdrop({
			bgFile = "Interface/Icons/Spell_Totem_WardOfDraining",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right =5, top = 5, bottom = 5 }
		})
		ShammySpyFireFrame:SetBackdropColor( 1, 1, 1, (1/3))
		ShammySpyFireFrame:SetBackdropBorderColor( 1, 1, 1, 0)
		--[[ Create the fontstring ]]
		local ShammySpyFireFrameText1 = ShammySpyFireFrame:CreateFontString("ShammySpyFireFrameText1", "OVERLAY")
		ShammySpyFireFrameText1:SetFontObject(GameFontNormalSmall)
		ShammySpyFireFrameText1:ClearAllPoints()
		ShammySpyFireFrameText1:SetTextColor(1, 1, 1, 1)
		ShammySpyFireFrameText1:SetWidth(35)
		ShammySpyFireFrameText1:SetHeight(20)
		ShammySpyFireFrameText1:SetPoint("TOP", "ShammySpyFireFrame", "BOTTOM")
		ShammySpyFireFrameText1:SetJustifyH("CENTER")
		ShammySpyFireFrameText1:SetJustifyV("MIDDLE")
		ShammySpyFireFrameText1:SetText(L["Fire"])
		--[[ Create the 2nd fontstring ]]
		local ShammySpyFireFrameText2 = ShammySpyFireFrame:CreateFontString("ShammySpyFireFrameText2", "OVERLAY")
		ShammySpyFireFrameText2:SetFontObject(SubZoneTextFont)--GameFontNormalSmall)
		ShammySpyFireFrameText2:ClearAllPoints()
		ShammySpyFireFrameText2:SetTextColor(1, 1, 1, 1)
		ShammySpyFireFrameText2:SetWidth(35)
		ShammySpyFireFrameText2:SetHeight(35)
		ShammySpyFireFrameText2:SetPoint("CENTER", "ShammySpyFireFrame", "CENTER")
		ShammySpyFireFrameText2:SetJustifyH("CENTER")
		ShammySpyFireFrameText2:SetJustifyV("MIDDLE")
		ShammySpyFireFrameText2:SetText("")
	end
	ShammySpyFireFrame:Show()
	
	if (not getglobal("ShammySpyWaterFrame")) then
		--[[ Create the anchor ]]
		local ShammySpyWaterFrameAnchor = CreateFrame("Button", "ShammySpyWaterFrameAnchor", UIParent)
		ShammySpyWaterFrameAnchor:Hide()
		ShammySpyWaterFrameAnchor:SetWidth(150)
		ShammySpyWaterFrameAnchor:SetHeight(30)
		ShammySpyWaterFrameAnchor:SetPoint("CENTER", "WorldFrame", "CENTER",  0,  0)
		ShammySpyWaterFrameAnchor:SetMovable(true)
		ShammySpyWaterFrameAnchor:RegisterForDrag("LeftButton")
		ShammySpyWaterFrameAnchor:SetScript("OnDragStart",
			function()
				ShammySpyWaterFrameAnchor:StartMoving()
				ShammySpyWaterFrame:StartMoving()
			end )
		ShammySpyWaterFrameAnchor:SetScript("OnDragStop",
			function()
				ShammySpyWaterFrameAnchor:StopMovingOrSizing()
				ShammySpyWaterFrame:StopMovingOrSizing()
				local _,_,_,x,y = ShammySpyWaterFrameAnchor:GetPoint()
				ShammySpy.db.profile.ShammySpyWaterFrame.x = x
				ShammySpy.db.profile.ShammySpyWaterFrame.y = y
			end )
		ShammySpyWaterFrameAnchor:SetFrameStrata("HIGH")
		ShammySpyWaterFrameAnchor:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right =5, top = 5, bottom = 5 }
		})
		--[[ Create the anchor fontstring ]]
		local ShammySpyWaterFrameAnchorText = ShammySpyWaterFrameAnchor:CreateFontString("ShammySpyWaterFrameText", "OVERLAY")
		ShammySpyWaterFrameAnchorText:SetFontObject(GameFontNormalSmall)
		ShammySpyWaterFrameAnchorText:ClearAllPoints()
		ShammySpyWaterFrameAnchorText:SetTextColor(1, 1, 1, 1)
		ShammySpyWaterFrameAnchorText:SetWidth(120)
		ShammySpyWaterFrameAnchorText:SetHeight(25)
		ShammySpyWaterFrameAnchorText:SetPoint("CENTER", "ShammySpyWaterFrameAnchor", "CENTER")
		ShammySpyWaterFrameAnchorText:SetJustifyH("CENTER")
		ShammySpyWaterFrameAnchorText:SetJustifyV("MIDDLE")
		ShammySpyWaterFrameAnchorText:SetText(L["Click and drag!"])
		
		--[[ Create the frame ]]
		local ShammySpyWaterFrame = CreateFrame("Frame", "ShammySpyWaterFrame", UIParent)
		ShammySpyWaterFrame:SetWidth(35)
		ShammySpyWaterFrame:SetHeight(35)
		ShammySpyWaterFrame:SetFrameStrata(strataToUse)
		ShammySpyWaterFrame:SetPoint("TOP", "ShammySpyWaterFrameAnchor", "BOTTOM", 0, 0)
		ShammySpyWaterFrame:SetMovable(true)
		ShammySpyWaterFrame:SetBackdrop({
			bgFile = "Interface/Icons/Spell_Totem_WardOfDraining",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right =5, top = 5, bottom = 5 }
		})
		ShammySpyWaterFrame:SetBackdropColor( 1, 1, 1, (1/3))
		ShammySpyWaterFrame:SetBackdropBorderColor( 1, 1, 1, 0)
		--[[ Create the fontstring ]]
		local ShammySpyWaterFrameText1 = ShammySpyWaterFrame:CreateFontString("ShammySpyWaterFrameText1", "OVERLAY")
		ShammySpyWaterFrameText1:SetFontObject(GameFontNormalSmall)
		ShammySpyWaterFrameText1:ClearAllPoints()
		ShammySpyWaterFrameText1:SetTextColor(1, 1, 1, 1)
		ShammySpyWaterFrameText1:SetWidth(35)
		ShammySpyWaterFrameText1:SetHeight(20)
		ShammySpyWaterFrameText1:SetPoint("TOP", "ShammySpyWaterFrame", "BOTTOM")
		ShammySpyWaterFrameText1:SetJustifyH("CENTER")
		ShammySpyWaterFrameText1:SetJustifyV("MIDDLE")
		ShammySpyWaterFrameText1:SetText(L["Water"])
		--[[ Create the 2nd fontstring ]]
		local ShammySpyWaterFrameText2 = ShammySpyWaterFrame:CreateFontString("ShammySpyWaterFrameText2", "OVERLAY")
		ShammySpyWaterFrameText2:SetFontObject(SubZoneTextFont)--GameFontNormalSmall)
		ShammySpyWaterFrameText2:ClearAllPoints()
		ShammySpyWaterFrameText2:SetTextColor(1, 1, 1, 1)
		ShammySpyWaterFrameText2:SetWidth(35)
		ShammySpyWaterFrameText2:SetHeight(35)
		ShammySpyWaterFrameText2:SetPoint("CENTER", "ShammySpyWaterFrame", "CENTER")
		ShammySpyWaterFrameText2:SetJustifyH("CENTER")
		ShammySpyWaterFrameText2:SetJustifyV("MIDDLE")
		ShammySpyWaterFrameText2:SetText("")
	end
	ShammySpyWaterFrame:Show()
	
	if (not getglobal("ShammySpyAirFrame")) then
		--[[ Create the anchor ]]
		local ShammySpyAirFrameAnchor = CreateFrame("Button", "ShammySpyAirFrameAnchor", UIParent)
		ShammySpyAirFrameAnchor:Hide()
		ShammySpyAirFrameAnchor:SetWidth(150)
		ShammySpyAirFrameAnchor:SetHeight(30)
		ShammySpyAirFrameAnchor:SetPoint("CENTER", "WorldFrame", "CENTER",  0,  0)
		ShammySpyAirFrameAnchor:SetMovable(true)
		ShammySpyAirFrameAnchor:RegisterForDrag("LeftButton")
		ShammySpyAirFrameAnchor:SetScript("OnDragStart",
			function()
				ShammySpyAirFrameAnchor:StartMoving()
				ShammySpyAirFrame:StartMoving()
			end )
		ShammySpyAirFrameAnchor:SetScript("OnDragStop",
			function()
				ShammySpyAirFrameAnchor:StopMovingOrSizing()
				ShammySpyAirFrame:StopMovingOrSizing()
				local _,_,_,x,y = ShammySpyAirFrameAnchor:GetPoint()
				ShammySpy.db.profile.ShammySpyAirFrame.x = x
				ShammySpy.db.profile.ShammySpyAirFrame.y = y
			end )
		ShammySpyAirFrameAnchor:SetFrameStrata("HIGH")
		ShammySpyAirFrameAnchor:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right =5, top = 5, bottom = 5 }
		})
		--[[ Create the anchor fontstring ]]
		local ShammySpyAirFrameAnchorText = ShammySpyAirFrameAnchor:CreateFontString("ShammySpyAirFrameText", "OVERLAY")
		ShammySpyAirFrameAnchorText:SetFontObject(GameFontNormalSmall)
		ShammySpyAirFrameAnchorText:ClearAllPoints()
		ShammySpyAirFrameAnchorText:SetTextColor(1, 1, 1, 1)
		ShammySpyAirFrameAnchorText:SetWidth(120)
		ShammySpyAirFrameAnchorText:SetHeight(25)
		ShammySpyAirFrameAnchorText:SetPoint("CENTER", "ShammySpyAirFrameAnchor", "CENTER")
		ShammySpyAirFrameAnchorText:SetJustifyH("CENTER")
		ShammySpyAirFrameAnchorText:SetJustifyV("MIDDLE")
		ShammySpyAirFrameAnchorText:SetText(L["Click and drag!"])
		
		--[[ Create the frame ]]
		local ShammySpyAirFrame = CreateFrame("Frame", "ShammySpyAirFrame", UIParent)
		ShammySpyAirFrame:SetWidth(35)
		ShammySpyAirFrame:SetHeight(35)
		ShammySpyAirFrame:SetFrameStrata(strataToUse)
		ShammySpyAirFrame:SetPoint("TOP", "ShammySpyAirFrameAnchor", "BOTTOM", 0, 0)
		ShammySpyAirFrame:SetMovable(true)
		ShammySpyAirFrame:SetBackdrop({
			bgFile = "Interface/Icons/Spell_Totem_WardOfDraining",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right =5, top = 5, bottom = 5 }
		})
		ShammySpyAirFrame:SetBackdropColor( 1, 1, 1, (1/3))
		ShammySpyAirFrame:SetBackdropBorderColor( 1, 1, 1, 0)
		--[[ Create the fontstring ]]
		local ShammySpyAirFrameText1 = ShammySpyAirFrame:CreateFontString("ShammySpyAirFrameText1", "OVERLAY")
		ShammySpyAirFrameText1:SetFontObject(GameFontNormalSmall)
		ShammySpyAirFrameText1:ClearAllPoints()
		ShammySpyAirFrameText1:SetTextColor(1, 1, 1, 1)
		ShammySpyAirFrameText1:SetWidth(35)
		ShammySpyAirFrameText1:SetHeight(20)
		ShammySpyAirFrameText1:SetPoint("TOP", "ShammySpyAirFrame", "BOTTOM")
		ShammySpyAirFrameText1:SetJustifyH("CENTER")
		ShammySpyAirFrameText1:SetJustifyV("MIDDLE")
		ShammySpyAirFrameText1:SetText(L["Air"])
		--[[ Create the 2nd fontstring ]]
		local ShammySpyAirFrameText2 = ShammySpyAirFrame:CreateFontString("ShammySpyAirFrameText2", "OVERLAY")
		ShammySpyAirFrameText2:SetFontObject(SubZoneTextFont)--GameFontNormalSmall)
		ShammySpyAirFrameText2:ClearAllPoints()
		ShammySpyAirFrameText2:SetTextColor(1, 1, 1, 1)
		ShammySpyAirFrameText2:SetWidth(35)
		ShammySpyAirFrameText2:SetHeight(35)
		ShammySpyAirFrameText2:SetPoint("CENTER", "ShammySpyAirFrame", "CENTER")
		ShammySpyAirFrameText2:SetJustifyH("CENTER")
		ShammySpyAirFrameText2:SetJustifyV("MIDDLE")
		ShammySpyAirFrameText2:SetText("")
	end
	ShammySpyAirFrame:Show()
	
	if (not getglobal("ShammySpyReincarnationFrame")) then
		--[[ Create the anchor ]]
		local ShammySpyReincarnationFrameAnchor = CreateFrame("Button", "ShammySpyReincarnationFrameAnchor", UIParent)
		ShammySpyReincarnationFrameAnchor:Hide()
		ShammySpyReincarnationFrameAnchor:SetWidth(150)
		ShammySpyReincarnationFrameAnchor:SetHeight(30)
		ShammySpyReincarnationFrameAnchor:SetPoint("CENTER", "WorldFrame", "CENTER",  0,  0)
		ShammySpyReincarnationFrameAnchor:SetMovable(true)
		ShammySpyReincarnationFrameAnchor:RegisterForDrag("LeftButton")
		ShammySpyReincarnationFrameAnchor:SetScript("OnDragStart",
			function()
				ShammySpyReincarnationFrameAnchor:StartMoving()
				ShammySpyReincarnationFrame:StartMoving()
			end )
		ShammySpyReincarnationFrameAnchor:SetScript("OnDragStop",
			function()
				ShammySpyReincarnationFrameAnchor:StopMovingOrSizing()
				ShammySpyReincarnationFrame:StopMovingOrSizing()
				local _,_,_,x,y = ShammySpyReincarnationFrameAnchor:GetPoint()
				ShammySpy.db.profile.ShammySpyReincarnationFrame.x = x
				ShammySpy.db.profile.ShammySpyReincarnationFrame.y = y
			end )
		ShammySpyReincarnationFrameAnchor:SetFrameStrata("HIGH")
		ShammySpyReincarnationFrameAnchor:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right =5, top = 5, bottom = 5 }
		})
		--[[ Create the anchor fontstring ]]
		local ShammySpyReincarnationFrameAnchorText = ShammySpyReincarnationFrameAnchor:CreateFontString("ShammySpyReincarnationFrameText", "OVERLAY")
		ShammySpyReincarnationFrameAnchorText:SetFontObject(GameFontNormalSmall)
		ShammySpyReincarnationFrameAnchorText:ClearAllPoints()
		ShammySpyReincarnationFrameAnchorText:SetTextColor(1, 1, 1, 1)
		ShammySpyReincarnationFrameAnchorText:SetWidth(120)
		ShammySpyReincarnationFrameAnchorText:SetHeight(25)
		ShammySpyReincarnationFrameAnchorText:SetPoint("CENTER", "ShammySpyReincarnationFrameAnchor", "CENTER")
		ShammySpyReincarnationFrameAnchorText:SetJustifyH("CENTER")
		ShammySpyReincarnationFrameAnchorText:SetJustifyV("MIDDLE")
		ShammySpyReincarnationFrameAnchorText:SetText(L["Click and drag!"])
		
		--[[ Create the frame ]]
		local ShammySpyReincarnationFrame = CreateFrame("Frame", "ShammySpyReincarnationFrame", UIParent)
		ShammySpyReincarnationFrame:SetWidth(35)
		ShammySpyReincarnationFrame:SetHeight(35)
		ShammySpyReincarnationFrame:SetFrameStrata(strataToUse)
		ShammySpyReincarnationFrame:SetPoint("TOP", "ShammySpyReincarnationFrameAnchor", "BOTTOM", 0, 0)
		ShammySpyReincarnationFrame:SetMovable(true)
		ShammySpyReincarnationFrame:SetBackdrop({
			bgFile = "Interface/Icons/Spell_Nature_Reincarnation",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right =5, top = 5, bottom = 5 }
		})
		ShammySpyReincarnationFrame:SetBackdropColor( 1, 1, 1, (1/3))
		ShammySpyReincarnationFrame:SetBackdropBorderColor( 1, 1, 1, 0)
		--[[ Create the fontstring ]]
		local ShammySpyReincarnationFrameText1 = ShammySpyReincarnationFrame:CreateFontString("ShammySpyReincarnationFrameText1", "OVERLAY")
		ShammySpyReincarnationFrameText1:SetFontObject(GameFontNormalSmall)
		ShammySpyReincarnationFrameText1:ClearAllPoints()
		ShammySpyReincarnationFrameText1:SetTextColor(1, 1, 1, 1)
		ShammySpyReincarnationFrameText1:SetWidth(35)
		ShammySpyReincarnationFrameText1:SetHeight(20)
		ShammySpyReincarnationFrameText1:SetPoint("TOP", "ShammySpyReincarnationFrame", "BOTTOM")
		ShammySpyReincarnationFrameText1:SetJustifyH("CENTER")
		ShammySpyReincarnationFrameText1:SetJustifyV("MIDDLE")
		ShammySpyReincarnationFrameText1:SetText("00:00")
		--[[ Create the 2nd fontstring ]]
		local ShammySpyReincarnationFrameText2 = ShammySpyReincarnationFrame:CreateFontString("ShammySpyReincarnationFrameText2", "OVERLAY")
		ShammySpyReincarnationFrameText2:SetFontObject(GameFontNormalSmall)
		ShammySpyReincarnationFrameText2:ClearAllPoints()
		ShammySpyReincarnationFrameText2:SetTextColor(1, 1, 1, 1)
		ShammySpyReincarnationFrameText2:SetWidth(35)
		ShammySpyReincarnationFrameText2:SetHeight(35)
		ShammySpyReincarnationFrameText2:SetPoint("CENTER", "ShammySpyReincarnationFrame", "CENTER")
		ShammySpyReincarnationFrameText2:SetJustifyH("CENTER")
		ShammySpyReincarnationFrameText2:SetJustifyV("MIDDLE")
		ShammySpyReincarnationFrameText2:SetText("0")
	end
	ShammySpyReincarnationFrame:Show()
	
	ShammySpy:MoveFrames()
end

function ShammySpy:MoveFrames()
	if (ShammySpy.db.profile.ShammySpyEarthFrame.x and ShammySpy.db.profile.ShammySpyEarthFrame.y) then
		ShammySpyEarthFrameAnchor:ClearAllPoints()
		ShammySpyEarthFrameAnchor:SetPoint("TOPLEFT", "WorldFrame", "TOPLEFT",  ShammySpy.db.profile.ShammySpyEarthFrame.x,  ShammySpy.db.profile.ShammySpyEarthFrame.y)
	else
		ShammySpyEarthFrameAnchor:ClearAllPoints()
		ShammySpyEarthFrameAnchor:SetPoint("CENTER", "WorldFrame", "CENTER",  positiveOut,  (positiveOut + 40)) -- positiveOut = East, positiveOut = North
	end
	
	if (ShammySpy.db.profile.ShammySpyFireFrame.x and ShammySpy.db.profile.ShammySpyFireFrame.y) then
		ShammySpyFireFrameAnchor:ClearAllPoints()
		ShammySpyFireFrameAnchor:SetPoint("TOPLEFT", "WorldFrame", "TOPLEFT",  ShammySpy.db.profile.ShammySpyFireFrame.x,  ShammySpy.db.profile.ShammySpyFireFrame.y)
	else
		ShammySpyFireFrameAnchor:ClearAllPoints()
		ShammySpyFireFrameAnchor:SetPoint("CENTER", "WorldFrame", "CENTER",  negativeOut,  (positiveOut + 40)) -- negativeOut = West, positiveOut = North
	end
	
	if (ShammySpy.db.profile.ShammySpyWaterFrame.x and ShammySpy.db.profile.ShammySpyWaterFrame.y) then
		ShammySpyWaterFrameAnchor:ClearAllPoints()
		ShammySpyWaterFrameAnchor:SetPoint("TOPLEFT", "WorldFrame", "TOPLEFT",  ShammySpy.db.profile.ShammySpyWaterFrame.x,  ShammySpy.db.profile.ShammySpyWaterFrame.y)
	else
		ShammySpyWaterFrameAnchor:ClearAllPoints()
		ShammySpyWaterFrameAnchor:SetPoint("CENTER", "WorldFrame", "CENTER",  positiveOut,  (negativeOut + 40)) -- positiveOut = East, negativeOut = South
	end
	
	if (ShammySpy.db.profile.ShammySpyAirFrame.x and ShammySpy.db.profile.ShammySpyAirFrame.y) then
		ShammySpyAirFrameAnchor:ClearAllPoints()
		ShammySpyAirFrameAnchor:SetPoint("TOPLEFT", "WorldFrame", "TOPLEFT",  ShammySpy.db.profile.ShammySpyAirFrame.x,  ShammySpy.db.profile.ShammySpyAirFrame.y)
	else
		ShammySpyAirFrameAnchor:ClearAllPoints()
		ShammySpyAirFrameAnchor:SetPoint("CENTER", "WorldFrame", "CENTER",  negativeOut,  (negativeOut + 40)) -- negativeOut = West, negativeOut = South
	end
	
	if (ShammySpy.db.profile.ShammySpyReincarnationFrame.x and ShammySpy.db.profile.ShammySpyReincarnationFrame.y) then
		ShammySpyReincarnationFrameAnchor:ClearAllPoints()
		ShammySpyReincarnationFrameAnchor:SetPoint("TOPLEFT", "WorldFrame", "TOPLEFT",  ShammySpy.db.profile.ShammySpyReincarnationFrame.x,  ShammySpy.db.profile.ShammySpyReincarnationFrame.y)
	else
		ShammySpyReincarnationFrameAnchor:ClearAllPoints()
		ShammySpyReincarnationFrameAnchor:SetPoint("CENTER", "WorldFrame", "CENTER",  0,  (negativeOut + 40)) -- 0 = Center, negativeOut = South
	end
end

function ShammySpy:UpdateLock()
	if (ShammySpy.db.profile.lock) then
		ShammySpyEarthFrameAnchor:Hide()
		ShammySpyFireFrameAnchor:Hide()
		ShammySpyWaterFrameAnchor:Hide()
		ShammySpyAirFrameAnchor:Hide()
		ShammySpyReincarnationFrameAnchor:Hide()
	else
		ShammySpyEarthFrameAnchor:Show()
		ShammySpyFireFrameAnchor:Show()
		ShammySpyWaterFrameAnchor:Show()
		ShammySpyAirFrameAnchor:Show()
		ShammySpyReincarnationFrameAnchor:Show()
	end
end