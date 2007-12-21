EnhancerAttackPower = Enhancer:NewModule("AttackPower", "AceEvent-2.0", "AceHook-2.1");
Enhancer:SetModuleDefaultState("AttackPower", false);
local FrameName = "EnhancerFrameAPGauge";

local alpha = (7 / 10);
local txtWidth = 100;
local txtHeight = 25;
local txtOffset = 17;

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerAttackPower:GetConsoleOptions()
	return L["attackpower_cmd"], L["attackpower_desc"];
end

function EnhancerAttackPower:OnInitialize()
	-- Create the "real" frame:
	local object;
	
	object = CreateFrame("Button", FrameName.."Anchor", UIParent);
	object:SetWidth(Enhancer.db.profile.Gauges.AttackPower.Width);
	object:SetHeight(Enhancer.db.profile.Gauges.AttackPower.Height);
	object:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
	object:SetMovable(true);
	object:RegisterForDrag("LeftButton");
	object:SetFrameStrata("HIGH");
	object:SetClampedToScreen(true);
	object:SetBackdrop({
		bgFile = "Interface\\AddOns\\Enhancer\\texture\\mover", --white16x16",
		edgeFile = nil,
		tile = false, tileSize = 0, edgeSize = 0,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	});
	object:SetBackdropColor(1, 1, 1, (5 / 10));
	object:Hide();
	self.anchorframe = object;
	
	object = CreateFrame("Frame", FrameName, UIParent);
	object:SetWidth(Enhancer.db.profile.Gauges.AttackPower.Width);
	object:SetHeight(Enhancer.db.profile.Gauges.AttackPower.Height);
	object:SetFrameStrata("BACKGROUND");
	object:SetPoint("CENTER", FrameName.."Anchor", "CENTER", 0, 0);
	object:SetMovable(true);
	object:SetBackdrop({
		bgFile = "Interface\\AddOns\\Enhancer\\texture\\white16x16",
		edgeFile = nil,
		tile = true, tileSize = 16, edgeSize = 0,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	});
	object:SetBackdropColor( (4 / 10), (4 / 10), (4 / 10), alpha);
	object:Hide();
	self.mainframe = object;
	
	object = self.mainframe:CreateTexture(FrameName.."Cur", "OVERLAY")
	object:SetWidth(Enhancer.db.profile.Gauges.AttackPower.Width);
	object:SetHeight((Enhancer.db.profile.Gauges.AttackPower.Height / 2));
	object:SetPoint("BOTTOM", FrameName, "BOTTOM", 0, 0);
	object:SetTexture(1, 1, 0, alpha);
	object:SetBlendMode("MOD");
	self.curTexture = object;
	
	object = self.mainframe:CreateFontString(FrameName.."TextMax", "OVERLAY");
	object:SetFontObject(GameFontHighlightSmall)
	object:SetFont(Enhancer.db.profile.gaugeFontName, Enhancer.db.profile.gaugeFontSize, Enhancer.db.profile.gaugeFontFlags);
	object:ClearAllPoints();
	object:SetTextColor(1, 1, 1, alpha);
	object:SetWidth(txtWidth);
	object:SetHeight(Enhancer.db.profile.gaugeFontSize + 4);
	object:SetPoint("BOTTOM", FrameName, "TOP");
	object:SetJustifyH("CENTER");
	object:SetJustifyV("MIDDLE");
	object:SetText("Max");
	self.maxText = object;
	
	object = self.mainframe:CreateFontString(FrameName.."TextCur", "OVERLAY");
	object:SetFontObject(GameFontHighlightSmall)
	object:SetFont(Enhancer.db.profile.gaugeFontName, Enhancer.db.profile.gaugeFontSize, Enhancer.db.profile.gaugeFontFlags);
	object:ClearAllPoints();
	object:SetTextColor(1, 1, 1, alpha);
	object:SetWidth(txtWidth);
	object:SetHeight(Enhancer.db.profile.gaugeFontSize + 4);
	object:SetPoint("CENTER", FrameName.."Cur", "TOP", 0, ((Enhancer.db.profile.gaugeFontSize + 4) / 4));
	object:SetJustifyH("CENTER");
	object:SetJustifyV("MIDDLE");
	object:SetText("Cur");
	self.curText = object;
	
	object = self.mainframe:CreateFontString(FrameName.."TextMin", "OVERLAY");
	object:SetFontObject(GameFontHighlightSmall)
	object:SetFont(Enhancer.db.profile.gaugeFontName, Enhancer.db.profile.gaugeFontSize, Enhancer.db.profile.gaugeFontFlags);
	object:ClearAllPoints();
	object:SetTextColor(1, 1, 1, alpha);
	object:SetWidth(txtWidth);
	object:SetHeight(Enhancer.db.profile.gaugeFontSize + 4);
	object:SetPoint("TOP", FrameName, "BOTTOM");
	object:SetJustifyH("CENTER");
	object:SetJustifyV("MIDDLE");
	object:SetText("Min");
	self.minText = object;
	
	self.anchorframe:SetScript("OnDragStart",
    function()
			self.anchorframe:StartMoving();
		end );
	
	self.anchorframe:SetScript("OnDragStop",
		function()
			self.anchorframe:StopMovingOrSizing();
			self:SavePos();
		end );
	
	self:LoadPos()
	self:LockHook()
end

function EnhancerAttackPower:OnEnable()
	self:RegisterEvent("UNIT_ATTACK_POWER", "APowerChanged");
	self:RegisterEvent("COMBAT_RATING_UPDATE", "SPowerChanged");
	
	self:Hook(Enhancer, "ToggleLockForHooks", "LockHook");
	
	self.mainframe:Show();
	self:LockHook();
end

function EnhancerAttackPower:OnDisable()
	self:UnregisterAllEvents();
	self:CancelAllScheduledEvents();
	self:UnhookAll();
	
	self.mainframe:Hide();
end

function EnhancerAttackPower:Resize()
	self.anchorframe:SetWidth(Enhancer.db.profile.Gauges.AttackPower.Width);
	self.anchorframe:SetHeight(Enhancer.db.profile.Gauges.AttackPower.Height);
	self.mainframe:SetWidth(Enhancer.db.profile.Gauges.AttackPower.Width);
	self.mainframe:SetHeight(Enhancer.db.profile.Gauges.AttackPower.Height);
	self.curTexture:SetWidth(Enhancer.db.profile.Gauges.AttackPower.Width);
	
	EnhancerAttackPower.maxText:SetFont(Enhancer.db.profile.gaugeFontName, Enhancer.db.profile.gaugeFontSize, Enhancer.db.profile.gaugeFontFlags);
	EnhancerAttackPower.curText:SetFont(Enhancer.db.profile.gaugeFontName, Enhancer.db.profile.gaugeFontSize, Enhancer.db.profile.gaugeFontFlags);
	EnhancerAttackPower.minText:SetFont(Enhancer.db.profile.gaugeFontName, Enhancer.db.profile.gaugeFontSize, Enhancer.db.profile.gaugeFontFlags);
	
	self:APowerChanged("player")
end

function EnhancerAttackPower:APowerChanged(arg1)
	if (arg1 == "player") then
		local base, posBuff, negBuff = UnitAttackPower("player");
		local cur = base + posBuff + negBuff;
		
		if (not self.MIN or self.MIN > cur) then
			self.MIN = cur;
			self.minText:SetText(cur);
		end
		
		if (cur > (self.MAX or 0)) then
			self.MAX = cur;
		end
		
		local cCur = cur - self.MIN;
		local cMax = self.MAX - self.MIN;
		local cHeight = (cCur / cMax) * Enhancer.db.profile.Gauges.AttackPower.Height;
		
		-- Redo this to make it go from full red to full green/red to full green
		local cHalf = cMax / 2;
		local cGreen = 1; --(cCur / cMax);
		local cRed = 1; --(1 - cGreen);
		local cBlue = 0;
		
		if (cCur > cHalf) then
			-- Remove some red from the bar
			cRed = 1 - ((cCur - cHalf) / (cMax - cHalf));
		elseif (cCur < cHalf) then
			-- Remove some green from the bar
			cGreen = cCur / (cMax - cHalf);
		end
		
		
		self.curText:SetText("+"..cCur);
		if (Enhancer.db.profile.Gauges.AttackPower.TrueMax) then
			self.maxText:SetText(self.MAX);
		else
			self.maxText:SetText("+"..self.MAX - self.MIN);
		end
		
		if (self.MIN == self.MAX) then
			cHeight = Enhancer.db.profile.Gauges.AttackPower.Height / 2;
			cRed = 1;
			cGreen = 1;
		end
		
		-- calc heights
		self.curTexture:SetHeight(cHeight);
		self.curTexture:SetTexture(cRed, cGreen, cBlue);
		
		if (cHeight < (Enhancer.db.profile.Gauges.AttackPower.Height / 2)) then
			-- Text above
			self.curText:SetPoint("CENTER", FrameName.."Cur", "TOP", 0, ((Enhancer.db.profile.gaugeFontSize + 4) / 4));
		else
			-- Text below
			self.curText:SetPoint("CENTER", FrameName.."Cur", "TOP", 0, (0 - ((Enhancer.db.profile.gaugeFontSize + 4) / 4)));
		end
	end
end

function EnhancerAttackPower:SPowerChanged(arg1)
	if (arg1 == "player") then
	end
end

function EnhancerAttackPower:LockHook()
	if (Enhancer.db.profile.locked) then
		self.anchorframe:Hide();
	elseif (Enhancer:IsModuleActive("AttackPower")) then
		self.anchorframe:Show();
	end
	
	if (self.hooks and self.hooks[Enhancer] and self.hooks[Enhancer]["ToggleLockForHooks"]) then
		self.hooks[Enhancer]["ToggleLockForHooks"]();
	end
end

function EnhancerAttackPower:SavePos()
	Enhancer:SavePos(FrameName, self.anchorframe)
end

function EnhancerAttackPower:LoadPos()
	if (Enhancer.db.profile.framePositions and Enhancer.db.profile.framePositions[FrameName]) then
		self.anchorframe:ClearAllPoints();
		self.anchorframe:SetPoint(
			Enhancer.db.profile.framePositions[FrameName]["point"],
			Enhancer.db.profile.framePositions[FrameName]["relativeTo"],
			Enhancer.db.profile.framePositions[FrameName]["relativePoint"],
			Enhancer.db.profile.framePositions[FrameName]["xOfs"],
			Enhancer.db.profile.framePositions[FrameName]["yOfs"]
		);
	else
		self.anchorframe:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
	end
end

function EnhancerAttackPower:EnterCombat()
	-- self.mainframe:Show();
end

function EnhancerAttackPower:OutOfCombat()
	-- self.mainframe:Hide();
end