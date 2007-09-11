EnhancerHWay = Enhancer:NewModule("HWay", "AceEvent-2.0", "CandyBar-2.0", "AceHook-2.1");
EnhancerHWay.DefaultState = false;
Enhancer:SetModuleDefaultState("HWay", EnhancerHWay.DefaultState);
EnhancerHWay.SpellName = Enhancer.BS["Healing Way"];
-- EnhancerHWay.SpellName = Enhancer.BS["Lightning Shield"];

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerHWay:GetConsoleOptions()
	return L["hway_cmd"], L["hway_desc"];
end

function EnhancerHWay:OnInitialize()
	if (not Enhancer.db.profile.bonus.hway) then Enhancer.db.profile.bonus.hway = {}; end
end

function EnhancerHWay:OnEnable()
	self:RegisterCandyBarGroup("EnhancerHWay");
	self:CreateBars();
	self:CandyBarPosition();
	
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS", "PeriodicBuff");
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS", "PeriodicBuff");
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS", "PeriodicBuff");
	
	self:RegisterEvent("UNIT_AURA", "Aura1");
	self:RegisterEvent("UNIT_AURASTATE", "Aura2");
	
	-- self:ScheduleEvent("DelayManualScan", self.ManualScan, 5, self);
	self:Hook(Enhancer, "ToggleLock", "LockHook");
end

function EnhancerHWay:Aura1(...)
	self:Debug("UNIT_AURA", ...);
	-- arg 1: party1 | arg 2: Mark of the Wild | arg 3: 1 | arg 4: 0 | arg 5: Interface\Icons\Spell_Nature_Regeneration | arg 6: Rank 8 
end
function EnhancerHWay:Aura2(...)
	self:Debug("UNIT_AURASTATE", ...);
	-- arg 1: party1 | arg 2: Mark of the Wild | arg 3: 1 | arg 4: 0 | arg 5: Interface\Icons\Spell_Nature_Regeneration | arg 6: Rank 8 
end

function EnhancerHWay:OnDisable()
	self:UnregisterAllEvents();
	self:CancelAllScheduledEvents();
end

function EnhancerHWay:CreateBars()
	if not self.anchorframe then
		local anchorframe = CreateFrame("Frame", "EnhancerHWayAnchorFrame", UIParent)
		anchorframe:EnableMouse(true)
		anchorframe:SetMovable(true)
		anchorframe:RegisterForDrag("LeftButton")
		anchorframe:SetScript("OnDragStart", function() if IsAltKeyDown() then self.anchorframe:StartMoving() end end)
		anchorframe:SetScript("OnDragStop", function() self.anchorframe:StopMovingOrSizing() self:SavePosition() end)
		anchorframe:SetWidth(175)
		anchorframe:SetHeight(50)
		anchorframe:Hide()
		anchorframe:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

		local title = anchorframe:CreateFontString(nil, "ARTWORK")
		title:SetFontObject(GameFontNormalSmall)
		title:SetText(L["hway_anchortext"])
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
	end
	
	self:ToggleAnchorFrame()
	self:RestorePosition()
end

function EnhancerHWay:SavePosition()
	local f = self.anchorframe
	local x,y = f:GetLeft(), f:GetTop()
	local s = f:GetEffectiveScale()
		
	x,y = x*s,y*s

	Enhancer.db.profile.bonus.hway.posx = x
	Enhancer.db.profile.bonus.hway.posy = y
	
	self:CandyBarPosition()
end

function EnhancerHWay:CandyBarPosition()
	local candyBarGrowUp = (not (self.anchorframe:GetTop() > (GetScreenHeight() / 2)))
	self:SetCandyBarGroupGrowth("EnhancerHWay", candyBarGrowUp)
	if (candyBarGrowUp) then
		self:SetCandyBarGroupPoint("EnhancerHWay", "BOTTOM", self.anchorframetext, "TOP", 0, 25)
	else
		self:SetCandyBarGroupPoint("EnhancerHWay", "TOP", self.anchorframetext, "BOTTOM", 0, 0)
	end
end

function EnhancerHWay:RestorePosition()
	local x = Enhancer.db.profile.bonus.hway.posx
	local y = Enhancer.db.profile.bonus.hway.posy
		
	if not x or not y then return end
				
	local f = self.anchorframe
	local s = f:GetEffectiveScale()

	x,y = x/s,y/s

	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
end

function EnhancerHWay:LockHook(...)
	self.hooks[Enhancer]["ToggleLock"](...);
	self:ToggleAnchorFrame();
end

function EnhancerHWay:ToggleAnchorFrame()
	if Enhancer.db.profile.locked then
		self.anchorframe:Hide()
	else
		self.anchorframe:Show()
	end
end

function EnhancerHWay:ToggleView()
	Enhancer.db.profile.bonus.hway.anchorframehidden = not Enhancer.db.profile.bonus.hway.anchorframehidden
	if self.anchorframe and self.anchorframe:IsVisible() then
		self.anchorframe:Hide()
	end
	if (not Enhancer.db.profile.bonus.hway.anchorframehidden) then
		if not self.anchorframe then self:SetupFrames() end
		self.anchorframe:Show()
	end
end

function EnhancerHWay:PeriodicBuff(info)
	local unit, what, count;
	if (string.find(info, L["hway_yougain"]) and string.find(info, self.SpellName)) then
		unit = "player";
		
	  what, count = Enhancer.deformat(info, AURAAPPLICATIONADDEDSELFHELPFUL);
	  if (not what) then
			what = Enhancer.deformat(info, AURAADDEDSELFHELPFUL);
			count = 1;
		end
	elseif (string.find(info, self.SpellName)) then
		local who;
		who, what, count = Enhancer.deformat(info, AURAAPPLICATIONADDEDOTHERHELPFUL);
		if (not who) then
			who, what = Enhancer.deformat(info, AURAADDEDOTHERHELPFUL);
			count = 1;
		end
		
		unit = Enhancer:NameToUnit(who);
	end
	
	if (unit and what and count) then
	  self:UpdateCandyBar(unit, self.SpellName, count)
	end
end

function EnhancerHWay:UpdateCandyBar(unit, spell, count)
	if (not UnitExists(unit)) then return; end
	
	local icon = Enhancer.BS:GetSpellIcon(spell);
	local name, server = UnitName(unit);
	local duration = 15; -- Healing Way duration is 15 sec
	local barName = name;
	local barText = string.format("%s - %s (%d)", name, spell, count);
	
	if (not self:IsCandyBarRegistered(barName)) then
		self:RegisterCandyBar(barName, duration, barText, icon, "green", "yellow", "red");
		self:SetCandyBarTexture(barName, "Interface\\Addons\\Enhancer\\texture\\Smoothv2");
		self:RegisterCandyBarWithGroup(barName, "EnhancerHWay");
		
		self:StartCandyBar(barName, true);
		self:SetCandyBarTimeLeft(barName, duration);
		self:SetCandyBarCompletion(barName, function() EnhancerHWay:EndOfBar(unit, spell, count); end)
	else
		local _, _, _, running = self:CandyBarStatus(barName);
		if (running) then
			self:SetCandyBarTimeLeft(duration);
			self:SetCandyBarText(barName, barText);
		end
	end
end

function EnhancerHWay:EndOfBar(unit, spell, count)
end

function EnhancerHWay:Debug(...)
	if (Enhancer.debug) then
		Enhancer:Print(...);
	end
end