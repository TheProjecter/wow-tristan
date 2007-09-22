EnhancerHWay = Enhancer:NewModule("HWay", "AceEvent-2.0", "CandyBar-2.0", "AceHook-2.1");
EnhancerHWay.DefaultState = false;
Enhancer:SetModuleDefaultState("HWay", EnhancerHWay.DefaultState);
EnhancerHWay.SpellName = Enhancer.BS["Healing Way"];
EnhancerHWay.SpellIcon = Enhancer.BS:GetSpellIcon(Enhancer.BS["Healing Way"]);
--EnhancerHWay.SpellName = Enhancer.BS["Strength of Earth"];

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerHWay:GetConsoleOptions()
	return L["hway_cmd"], L["hway_desc"];
end

function EnhancerHWay:OnInitialize()
	if (not Enhancer.db.profile.bonus.hway) then Enhancer.db.profile.bonus.hway = {}; end
	self:Hook(Enhancer, "ToggleLockForHooks", "LockHook");
end

function EnhancerHWay:OnEnable()
	self:RegisterCandyBarGroup("EnhancerHWay");
	self:CreateBars();
	self:CandyBarPosition();
	
	self:RegisterEvent("SpecialEvents_UnitBuffGained", "BuffGained");
	self:RegisterEvent("SpecialEvents_UnitBuffLost", "BuffLost");
	self:RegisterEvent("SpecialEvents_UnitBuffCountChanged", "BuffRefreshed");
	self:RegisterEvent("SpecialEvents_UnitBuffRefreshed", "BuffRefreshed");
	
	Enhancer:Print("HealingWay Module is in early beta or something ;)!");
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

function EnhancerHWay:LockHook()
	self:ToggleAnchorFrame();
	self.hooks[Enhancer]["ToggleLockForHooks"]();
end

function EnhancerHWay:ToggleAnchorFrame()
	if (not self.anchorframe) then return; end
	
	if ((not Enhancer.db.profile.locked) and Enhancer:IsModuleActive("EShield")) then
		self.anchorframe:Show()
	else
		self.anchorframe:Hide()
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

function EnhancerHWay:BuffGained(unit, name, index, count, icon, rank, duration, timeLeft)
	if (not UnitExists(unit)) then return; end
	if (name ~= self.SpellName) then return; end
	
	self:UpdateCandyBar(unit, count, duration or 15);
end

function EnhancerHWay:BuffLost(unit, name, count, icon, rank, duration)
	if (not UnitExists(unit)) then return; end
	if (name ~= self.SpellName) then return; end
	
	local name, server = UnitName(unit);
	local barName = name;
	
	self:UnregisterCandyBar(barName);
end

function EnhancerHWay:BuffRefreshed(unit, name, index, count, icon, rank, duration, timeLeft)
	if (not UnitExists(unit)) then return; end
	if (name ~= self.SpellName) then return; end
	
	self:UpdateCandyBar(unit, count, (duration > 0 and duration) or 1);
end

function EnhancerHWay:UpdateCandyBar(unit, count, duration)
	local name, server = UnitName(unit);
	local buffDuration = duration or 15;
	local barName = name;
	local barText = string.format("%s - %s (%d)", name, self.SpellName, count);
	if (buffDuration == 0) then buffDuration = 15; end
	
	if (not self:IsCandyBarRegistered(barName)) then
		self:RegisterCandyBar(barName, buffDuration, barText, self.SpellIcon, "green", "yellow", "red");
		self:SetCandyBarTexture(barName, "Interface\\Addons\\Enhancer\\texture\\Smoothv2");
		self:RegisterCandyBarWithGroup(barName, "EnhancerHWay");
		self:SetCandyBarFade(barName, -1);
		
		self:StartCandyBar(barName);
		self:SetCandyBarTimeLeft(barName, buffDuration);
	else
		self:SetCandyBarTimeLeft(barName, buffDuration);
		self:SetCandyBarText(barName, barText);
		self:StartCandyBar(barName);
	end
end

function EnhancerHWay:Debug(...)
	if (Enhancer.debug) then
		Enhancer:Print(...);
	end
end