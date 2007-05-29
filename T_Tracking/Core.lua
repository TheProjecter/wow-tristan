-- TODO: Toggle for hiding entire Minimap once not tracking?
-- TOCHECK: If any tracking (except Druid) has a different icon for the same track and needs to be hacked into T_Tracking:GetTrackingTextureName()

T_Tracking = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0", "AceDB-2.0")
local L = AceLibrary("AceLocale-2.2"):new("T_Tracking")
T_Tracking.dewdrop = AceLibrary("Dewdrop-2.0")
T_Tracking.canTrack = false


function T_Tracking:OnInitialize()
    -- Called when the addon is initialized
    self:RegisterDB("T_TrackingDB")
		self:RegisterDefaults('profile', {
			MenuOnEnter = false,
		})
		self:RegisterDefaults('char', {
			LastSpell = nil,
			Justification = "CENTER",
			HideMiniMapWhenNotTracking = false,
			BlinkText = true,
		})

    T_Tracking:CreateFrame()
    
    self:Print(L["translator"])
end

function T_Tracking:OnEnable()
    -- Called when the addon is enabled
    self:RegisterEvent("PLAYER_AURAS_CHANGED")
    self:RegisterEvent("PLAYER_DEAD")
    self:RegisterEvent("LEARNED_SPELL_IN_TAB")
    self:UpdateFrameText(self:IsTracking())
    
    self:LEARNED_SPELL_IN_TAB()
    
    self:RegisterChatCommand(L["AceConsole-Commands"], self.opts)
end

function T_Tracking:OnDisable()
    -- Called when the addon is disabled
    self:UnregisterAllEvents()
end

function T_Tracking:PLAYER_DEAD()
	-- Called when the player is dead :o
	if (self.frameText) then
		self.frameText:Hide()
	end
end

function T_Tracking:PLAYER_AURAS_CHANGED()
	-- Called when the players auras change
	T_Tracking:UpdateFrameText(self:IsTracking())
end

function T_Tracking:LEARNED_SPELL_IN_TAB()
	-- Called when the player learns new spells and when the AddOn is Enabled
	self.canTrack = self:PlayerCanTrack()
	
	if (self.canTrack) then
		self.frame:Show()
	else
		self.frame:Hide()
	end
end

function T_Tracking:PlayerCanTrack()
	local initLoop = true
	local initNum = 1
	local isUsable = false
	
	while (initLoop) do
		local initSkill = GetSpellName(initNum, BOOKTYPE_SPELL);
		if(initSkill) then
			if (strfind(initSkill, L["Find "]) or strfind(initSkill, L["Track "]) or strfind(initSkill, L["Sense "])) then
				if ((strlower(UnitClass("player")) == strlower(L["Druid"])) and (strfind(initSkill, L["Track Humanoids"]))) then
					local numForms = GetNumShapeshiftForms()
					for fIndex = 1, numForms do
						local _,formName,formActive,_ = GetShapeshiftFormInfo(fIndex)
						if (strfind(formName, L["Cat"]) and (formActive)) then
							-- Druid Hack
							isUsable = true
						end
					end
				else
					isUsable = true
				end
			end
			initNum = initNum + 1
		else
			initLoop = nil
		end
	end
	
	return isUsable
end

function T_Tracking:ToggleMenuShow()
	-- Just called when the option to show menu on hover toggles.
	self.db.profile.MenuOnEnter = not self.db.profile.MenuOnEnter
	return self.db.profile.MenuOnEnter;
end

function T_Tracking:GetTrackingTexture()
	-- Override GetTrackingTexture to avoid trying to find nil in the tables
	local TrackingTexture = GetTrackingTexture()
	if (not TrackingTexture) then
		return "Interface\\Icons\\INV_Misc_Map_01"
		-- MiniMapTrackingIcon:SetTexture("Interface\\Icons\\INV_Misc_Map_01")
	else
		return TrackingTexture
	end
end

function T_Tracking:GetTrackingTextureName()
	-- We need to hack the name returned from L in case it's a druid. bleh
	local retVal = L[self.GetTrackingTexture()]
	if ((strlower(UnitClass("player")) == strlower(L["Druid"])) and (retVal == L["Interface\\Icons\\Ability_Tracking"])) then
		-- Druids don't have any track beasts (so far ;)
		retVal = L["Interface\\Icons\\Spell_Holy_PrayerOfHealing"]
	end
	
	return retVal
end

function T_Tracking:IsTracking()
	if (GetTrackingTexture()) then
		return true
	else
		return false
	end
end

function T_Tracking:SaveCast(spell)
	-- Called to save when a spell get's cast via the AddOn for easy Recasting :)
  
  self.db.char.LastSpell = spell;
end

function T_Tracking:UpdateFrameText(isTracking)
	-- Called to update text on the frame
	
	self.frameText:SetText(self:GetTrackingTextureName())
	
	if (isTracking) then
		self:CancelAllScheduledEvents()
		self.frameText:Show()
		MinimapCluster:Show()
		MiniMapTrackingFrame:Hide()
	else
		if (self.db.char.HideMiniMapWhenNotTracking) then MinimapCluster:Hide() else MinimapCluster:Show() end
		self:ScheduleRepeatingEvent(self.FrameBlink, 0.2, self)
	end
end

function T_Tracking:FrameBlink()
	-- Called to make the frame blink when nothing is tracked
	-- TODO: Stop blinking in BG's ffs ;)
	
	if ((UnitIsDead("player")) or (not self.canTrack)) then
		self.frame:Hide()
		return
	else
		self.frame:Show()
	end
	
	if (not self.db.char.BlinkText) then
		self.frameText:Show()
		return
	end
	
	if (self.frameText:IsVisible()) then
		self.frameText:Hide()
	else
		self.frameText:Show()
	end
end

function T_Tracking:OnEnter()
	-- Called when the mouse hovers over the frame
	-- TODO: Show Tooltip
	GameTooltip_SetDefaultAnchor(GameTooltip, T_Tracking.frame)
	GameTooltip:AddLine(L["Tristan's Tracking Menu"])
	GameTooltip:AddLine(" ",.8,.8,.8,1)
	GameTooltip:AddLine(L["Left click to show Menu"],.8,.8,.8,1)
	if (T_Tracking:IsTracking()) then
		GameTooltip:AddLine(L["Rightclick to cancel"],.8,.8,.8,1)
	else
		if (T_Tracking.db.char.LastSpell) then
			GameTooltip:AddLine(L["Rightclick to recast "]..T_Tracking.db.char.LastSpell,0,1,0,1)
		end
	end
	GameTooltip:Show()
	
	if (T_Tracking.db.profile.MenuOnEnter) then
		T_Tracking:ShowMenu()
	end
end

function T_Tracking:OnLeave()
	-- Called when the mouse exits the area above the frame
	GameTooltip:Hide()
end

function T_Tracking:OnClick()
	-- Called when... duh... Yes he clicked the frame what are you gonna do about it
	if arg1=="LeftButton" then
		T_Tracking:LeftClick()
	elseif arg1=="RightButton" then
		T_Tracking:RightClick()
	end
end

function T_Tracking:RebuildOptionsTableAndReturn()
	-- Called to rebuild the optionstable and return it for FuBar ;)
	self:RebuildOptionsTable()
	return self.dewdropOpts
end

function T_Tracking:RebuildOptionsTable()
	-- Called to rebuild options for the Dewdrop menu
	self.dewdropOpts = { }
	
	self.dewdropOpts = {
		type = "group",
		args = {
			header = {
				type = "header",
				name = L["addonname"],
				icon = self:GetTrackingTexture(),
				iconHeight = 16,
				iconWidth = 16,
				order = 1
			},
			mspacer = {
				type = "header",
				order = 2
			},
		}
	}
	
	local initLoop = true
	local initNum = 1
	
	while (initLoop) do
		local initSkill = GetSpellName(initNum, BOOKTYPE_SPELL);
		if(initSkill) then
			if (strfind(initSkill, L["Find "]) or strfind(initSkill, L["Track "]) or strfind(initSkill, L["Sense "])) then
				if ((strlower(UnitClass("player")) == strlower(L["Druid"])) and (strfind(initSkill, L["Track Humanoids"]))) then
					local numForms = GetNumShapeshiftForms()
					for fIndex = 1, numForms do
						local _,formName,formActive,_ = GetShapeshiftFormInfo(fIndex)
						if (strfind(formName, L["Cat"]) and (formActive)) then
							self.dewdropOpts.args["T_Tracking"..initNum] = { }
							self.dewdropOpts.args["T_Tracking"..initNum]["type"] = "toggle"
							self.dewdropOpts.args["T_Tracking"..initNum]["name"] = initSkill
							self.dewdropOpts.args["T_Tracking"..initNum]["desc"] = L["Cast"].." "..initSkill
							self.dewdropOpts.args["T_Tracking"..initNum]["get"] = function() return initSkill == T_Tracking:GetTrackingTextureName() end
							self.dewdropOpts.args["T_Tracking"..initNum]["set"] = function() T_Tracking:CastSpellByName(initSkill) T_Tracking:SaveCast(initSkill) T_Tracking.dewdrop:Close() end
							self.dewdropOpts.args["T_Tracking"..initNum]["order"] = 2 + initNum
						end
					end
				else
					self.dewdropOpts.args["T_Tracking"..initNum] = { }
					self.dewdropOpts.args["T_Tracking"..initNum]["type"] = "toggle"
					self.dewdropOpts.args["T_Tracking"..initNum]["name"] = initSkill
					self.dewdropOpts.args["T_Tracking"..initNum]["desc"] = L["Cast"].." "..initSkill
					self.dewdropOpts.args["T_Tracking"..initNum]["get"] = function() return initSkill == T_Tracking:GetTrackingTextureName() end
					self.dewdropOpts.args["T_Tracking"..initNum]["set"] = function() T_Tracking:CastSpellByName(initSkill) T_Tracking:SaveCast(initSkill) T_Tracking.dewdrop:Close() end
					self.dewdropOpts.args["T_Tracking"..initNum]["order"] = 2 + initNum
				end
			end
			initNum = initNum + 1
		else
			initLoop = nil
		end
	end
	
	self.dewdropOpts.args.CancelTracking = {
		type = "toggle",
		name = L["canceltracking"],
		desc = L["canceltrackingdesc"],
		get = function() return not T_Tracking:IsTracking() end,
		set = function(v) CancelTrackingBuff() self.dewdrop:Close() end,
		order = 3 + initNum
	}
	self.dewdropOpts.args.mspacer2 = {
		type = "header",
		order = 4 + initNum
	}
	self.dewdropOpts.args.ShowOnEnter = {
		type = "toggle",
		name = L["showonenter"],
		desc = L["showonenterdesc"],
		get = function()
				return self.db.profile.MenuOnEnter
			end,
		set = function(v)
				self.db.profile.MenuOnEnter = v
				self.dewdrop:Close()
			end,
		order = 9 + initNum
	}
	self.dewdropOpts.args.Justification = {
		type = "text",
		name = L["justification"],
		desc = L["justificationdesc"],
		get = function()
				return self.db.char.Justification
			end,
		set = function(v)
				self.db.char.Justification = v
				T_Tracking:SetJustifyH(v)
			end,
		validate = { "LEFT", "CENTER", "RIGHT"},
		order = 6 + initNum
	}
	self.dewdropOpts.args.BlinkText = {
		type = "toggle",
		name = L["blinktext"],
		desc = L["blinktextdesc"],
		get = function()
				return self.db.char.BlinkText
			end,
		set = function(v)
				self.db.char.BlinkText = v
				self.dewdrop:Close()
			end,
		order = 7 + initNum
	}
	self.dewdropOpts.args.HideMiniMapWhenNotTracking = {
		type = "toggle",
		name = L["hidemm"],
		desc = L["hidemmdesc"],
		get = function()
				return self.db.char.HideMiniMapWhenNotTracking
			end,
		set = function(v)
				self.db.char.HideMiniMapWhenNotTracking = v
				T_Tracking:UpdateFrameText(self:IsTracking())
				self.dewdrop:Close()
			end,
		order = 8 + initNum
	}
end

function T_Tracking:ShowMenu()
	-- Called to show the Dewdrop menu
	self:RebuildOptionsTable()
	
	if (self.frame:GetTop() > (GetScreenHeight() / 2)) then
		self.dewdrop:Open(self.frame, 'children', function() self.dewdrop:FeedAceOptionsTable(self.dewdropOpts) end, 'point', "TOP", 'relativePoint', "BOTTOM")
	else
		self.dewdrop:Open(self.frame, 'children', function() self.dewdrop:FeedAceOptionsTable(self.dewdropOpts) end, 'point', "BOTTOM", 'relativePoint', "TOP")
	end
end

function T_Tracking:LeftClick()
	-- Called when the user left clicks our frame
	if (not self.db.profile.MenuOnEnter) then
		T_Tracking:ShowMenu()
	end
end

function T_Tracking:RightClick()
	-- Called when the user right clicks our frame
	if (self:IsTracking()) then
		CancelTrackingBuff()
	else
		if (self.db.char.LastSpell) then
			self:CastSpellByName(self.db.char.LastSpell)
		end
	end
end

function T_Tracking:CastSpellByName(spell)
	self:Print("|cffff0000No longer can cast spells through AddOn|r")
	self:Print("   Cast: "..spell.." manually")
	--CastSpellByName(spell)
end

function T_Tracking:SetJustifyH(justification)
	self.frameText:SetJustifyH(justification)
end

function T_Tracking:CreateFrame()
	-- Called at start to create our frames!
	-- self.frame = CreateFrame("Button", "self.frame", UIParent)
	self.frame = CreateFrame("Button", "self.frame", UIParent, "SecureStateDriverTemplate")
	self.frame:EnableMouse(true)
	self.frame:SetMovable(true)
	self.frame:RegisterForDrag("LeftButton")
	self.frame:SetScript("OnDragStart", function() if IsAltKeyDown() then self.frame:StartMoving() end end)
	self.frame:SetScript("OnDragStop", function() self.frame:StopMovingOrSizing() end)
	self.frame:SetScript("OnEnter", self.OnEnter)
	self.frame:SetScript("OnLeave", self.OnLeave)
	self.frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	self.frame:SetScript("OnClick",self.OnClick)
	self.frame:SetWidth(175)
	self.frame:SetHeight(20)
	self.frame:Show()
	self.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

	self.frameText = self.frame:CreateFontString(nil, "ARTWORK")
	self.frameText:SetFontObject(GameFontNormalSmall)
	self.frameText:SetText("")
	self.frameText:SetJustifyH(self.db.char.Justification)
	self.frameText:SetWidth(160)
	self.frameText:SetHeight(12)
	self.frameText:Show()
	self.frameText:ClearAllPoints()
	self.frameText:SetPoint("TOP", self.frame, "TOP", 0, -5)
end