local L = AceLibrary("AceLocale-2.2"):new("TGuildFrame")

function TGuildFrame:GUILDFRAME_OPENED()
	if (FriendsFrame:IsVisible() and GuildMOTDEditButton:IsVisible()) then
		TGuildFrameGuildButton:Show()
		TGuildFrameGuildButton:SetPoint("TOPRIGHT", "FriendsFrameCloseButton", "TOPLEFT", 3, -6)
	else
		TGuildFrameGuildButton:Hide()
	end
end
function TGuildFrame:GUILDFRAME_CLOSED()
	TGuildFrameGuildButton:Hide()
end

-- Make Button (great job done by phyber)
-- MakeButtons and Tooltip taken from AHWipe
function TGuildFrame:MakeButtons()
	local TGuildFrameGuildButton = CreateFrame("Button", "TGuildFrameGuildButton", UIParent, "UIPanelButtonTemplate")
	TGuildFrameGuildButton:SetWidth(75)
	TGuildFrameGuildButton:SetHeight(19)
	TGuildFrameGuildButton:RegisterForClicks("LeftButtonDown")
	TGuildFrameGuildButton:SetScript("OnClick", function() self:Toggle() end)
	--TGuildFrameGuildButton:SetScript("OnEnter", function() self:Tooltip("Save Information about your Guild") end)
	--TGuildFrameGuildButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
	TGuildFrameGuildButton:SetFrameStrata("HIGH")
	TGuildFrameGuildButton:SetText("TGuildFrame")
	TGuildFrameGuildButton:Hide()
end