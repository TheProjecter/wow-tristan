local L = AceLibrary("AceLocale-2.2"):new("Enhancer");
local _G = getfenv();
local strataToUse = "BACKGROUND"; --TOOLTIP

function Enhancer:CreateButton(globalname, bgFile, xOffset, yOffset)
	local retVal = {};
	local object;
	
	if (_G[globalname]) then
		-- This'll give an error but it should never happen with good globalnames so giving an error is good :)
		return nil, globalname; -- _G[globalname] = nil;
	end
	
	--[[ Create an anchor ]]
	object = CreateFrame("Button", globalname.."Anchor", UIParent);
	object:Hide();
	object:SetWidth(150);
	object:SetHeight(30);
	object:SetPoint("CENTER", UIParent, "CENTER",  0,  0);
	object:SetMovable(true);
	object:RegisterForDrag("LeftButton");
	object:SetFrameStrata("HIGH");
	object:SetClampedToScreen(true);
	object:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	});
	retVal["anchor"] = object;
	
	--[[ Create a fontstring for the Anchor ]]
	object = retVal["anchor"]:CreateFontString(globalname.."AnchorText", "OVERLAY");
	object:SetFontObject(Enhancer.db.profile.belowFont);
	object:ClearAllPoints();
	object:SetTextColor(1, 1, 1, 1);
	object:SetWidth(120);
	object:SetHeight(25);
	object:SetPoint("CENTER", globalname.."Anchor", "CENTER");
	object:SetJustifyH("CENTER");
	object:SetJustifyV("MIDDLE");
	object:SetText(L["DragToMoveFrame"]);
	retVal["anchortext"] = object;
	
	--[[ Create a frame ]]
	object = CreateFrame("Frame", globalname.."Frame", UIParent);
	object.bgFileDefault = bgFile;
	object:SetWidth(Enhancer.db.profile.framesize);
	object:SetHeight(Enhancer.db.profile.framesize);
	object:SetFrameStrata(strataToUse);
	object:SetPoint("TOP", globalname.."Anchor", "BOTTOM", 0, 0);
	object:SetMovable(true);
	object:SetBackdrop({
		bgFile = "Interface/Icons/" .. object.bgFileDefault,
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	});
	object:SetBackdropColor( 1, 1, 1, Enhancer.db.profile.oocinactiveAlpha);
	object:SetBackdropBorderColor( 1, 1, 1, 0);
	retVal["mainframe"] = object;
	
	--[[ Create a Cooldown ]]
	object = CreateFrame("Cooldown", globalname.."FrameCooldown", MainFrame, "CooldownFrameTemplate");
	object:ClearAllPoints();
	object:SetWidth(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / 3));
	object:SetHeight(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / 3));
	object:SetPoint("CENTER", globalname.."Frame", "CENTER", 0, 0);
	retVal["cooldown"] = object;
	
	--[[ Create a fontstring below ]]
	object = retVal["mainframe"]:CreateFontString(globalname.."FrameText1", "OVERLAY");
	object:SetFontObject(Enhancer.db.profile.belowFont);
	object:ClearAllPoints();
	object:SetTextColor(1, 1, 1, 1);
	object:SetWidth(Enhancer.db.profile.framesize);
	object:SetHeight(Enhancer.db.profile.belowFontSize + 10);
	object:SetPoint("TOP", globalname.."Frame", "BOTTOM");
	object:SetJustifyH("CENTER");
	object:SetJustifyV("MIDDLE");
	object:SetText("");
	object:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
	retVal["textbelow"] = object;
	
	--[[ Create the 2nd fontstring ]]
	object = retVal["mainframe"]:CreateFontString(globalname.."FrameText2", "OVERLAY");
	object:SetFontObject(Enhancer.db.profile.centerFont);
	object:ClearAllPoints();
	object:SetTextColor(1, 1, 1, 1);
	object:SetWidth(Enhancer.db.profile.framesize);
	object:SetHeight(Enhancer.db.profile.framesize);
	object:SetPoint("CENTER", globalname.."Frame", "CENTER");
	object:SetJustifyH("CENTER");
	object:SetJustifyV("MIDDLE");
	object:SetText("");
	object:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
	object:SetShadowColor(0, 0, 0, 1)
	object:SetShadowOffset(0.8, -0.8)
	retVal["textcenter"] = object;
	
	retVal["anchor"]:Hide();
	retVal["mainframe"]:Hide();
	
	retVal.xOffsetDefault = xOffset or 0;
	retVal.yOffsetDefault = yOffset or 0;
	
	return retVal, globalname;
end

function Enhancer:MakeMoveable(frame)
	self[frame].anchor:SetScript("OnDragStart",
    function()
			self[frame].anchor:StartMoving();
		end );
	
	self[frame].anchor:SetScript("OnDragStop",
		function()
			self[frame].anchor:StopMovingOrSizing();
			Enhancer:SavePos(frame, self[frame].anchor);
		end );
end

function Enhancer:SavePos(framename, frame)
	if (not Enhancer.db.profile.framePositions) then Enhancer.db.profile.framePositions = {}; end
	if (not Enhancer.db.profile.framePositions[framename]) then Enhancer.db.profile.framePositions[framename] = {}; end
	frame:GetCenter()
	local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint();
	-- self:Print( frame:GetPoint() );
	
	Enhancer.db.profile.framePositions[framename]["point"] = point;
	Enhancer.db.profile.framePositions[framename]["relativeTo"] = relativeTo;
	Enhancer.db.profile.framePositions[framename]["relativePoint"] = relativePoint;
	Enhancer.db.profile.framePositions[framename]["xOfs"] = xOfs;
	Enhancer.db.profile.framePositions[framename]["yOfs"] = yOfs;
end

function Enhancer:LoadPos(framelist)
	if (not framelist) then return; end
	
	if (type(framelist) == "table") then
		for _, framename in pairs(framelist) do
			self:LoadPos(framename);
		end
	else
		local framename = framelist;
		
		if (Enhancer.db.profile.framePositions and Enhancer.db.profile.framePositions[framename] and self[framename]) then
			self[framename].anchor:ClearAllPoints();
			self[framename].anchor:SetPoint(
				Enhancer.db.profile.framePositions[framename]["point"],
				Enhancer.db.profile.framePositions[framename]["relativeTo"],
				Enhancer.db.profile.framePositions[framename]["relativePoint"],
				Enhancer.db.profile.framePositions[framename]["xOfs"],
				Enhancer.db.profile.framePositions[framename]["yOfs"]
			);
		else
			Enhancer:DefaultPos(framelist);
		end
	end
end

function Enhancer:ResetPos()
	for _, framename in ipairs(Enhancer.aFrames) do
		self:DefaultPos(framename);
	end
end

function Enhancer:DefaultPos(framelist)
	if (not framelist) then return; end
	
	if (type(framelist) == "table") then
		for _, framename in pairs(framelist) do
			self:DefaultPos(framename);
		end
	else
		local framename = framelist;
		self[framename].anchor:ClearAllPoints();
		self[framename].anchor:SetPoint("CENTER", UIParent, "CENTER",  self[framename].xOffsetDefault,  (self[framename].yOffsetDefault + Enhancer.db.profile.framesize))
		-- positiveX = East, positiveY = North
	end
end

function Enhancer:ShowFrame(framelist)
	if (not framelist) then return; end
	
	if (type(framelist) == "table") then
		for _, framename in pairs(framelist) do
			self:ShowFrame(framename);
		end
	else
		local framename = framelist;
		self[framename].mainframe:Show();
		if (not self.db.profile.locked) then self[framename].anchor:Show(); end
		self:UpdateAlphaBegin(framename);
	end
end

function Enhancer:HideFrame(framelist)
	if (not framelist) then return; end
	
	if (type(framelist) == "table") then
		for _, framename in pairs(framelist) do
			self:HideFrame(framename);
		end
	else
		local framename = framelist;
		
		self[framename].active = false;
		self[framename].textbelow:SetText("");
		self[framename].textcenter:SetText("");
		self[framename].mainframe:Hide();
		self[framename].anchor:Hide();
	end
end

function Enhancer:UpdateAlphaBegin(framelist)
	if (not framelist) then
		self:UpdateAlphaBegin(Enhancer.aFrames);
	elseif (type(framelist) == "table") then
		for _, framename in pairs(framelist) do
			self:UpdateAlphaEnd(framename);
		end
	else
		self:UpdateAlphaEnd(framelist);
	end
end

function Enhancer:UpdateAlphaEnd(frame)
	if (not self[frame]) then return; end
	
	local r, g, b, a = self[frame].mainframe:GetBackdropColor();
	
	if (self[frame].unlocked) then
		-- This frame has been unlocked for moving about so make everything visible for it :)
		self[frame].textcenter:SetAlpha(1);
		self[frame].textbelow:SetAlpha(1);
		self[frame].mainframe:SetBackdropColor(r, g, b, 1);
	elseif ( (frame == "reincarnation"  or frame == "windfury") and self.db.profile.specialAlpha ) then
		
		-- Special Handling of these frames
		if (self[frame].active) then
			self[frame].textcenter:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[frame].textbelow:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[frame].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.combatAlpha);
		else
			self[frame].textcenter:SetAlpha(Enhancer.db.profile.combatinactiveAlpha);
			self[frame].textbelow:SetAlpha(Enhancer.db.profile.combatinactiveAlpha);
			self[frame].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.combatinactiveAlpha);
		end
	
	elseif ( (frame == "invigorated") and self.db.profile.specialAlpha ) then
	
		-- Special Handling of these frames
		if (self[frame].active) then
			self[frame].textcenter:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[frame].textbelow:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[frame].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.combatAlpha);
		else
			self[frame].textcenter:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
			self[frame].textbelow:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
			self[frame].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.oocinactiveAlpha);
		end
	
	elseif (self[frame].active) then
		
		if (self.inCombat) then
			self[frame].textcenter:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[frame].textbelow:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[frame].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.combatAlpha);
		else
			self[frame].textcenter:SetAlpha(Enhancer.db.profile.oocombatAlpha);
			self[frame].textbelow:SetAlpha(Enhancer.db.profile.oocombatAlpha);
			self[frame].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.oocombatAlpha);
		end
		
	else
		
		if (self.inCombat) then
			self[frame].textcenter:SetAlpha(Enhancer.db.profile.combatinactiveAlpha);
			self[frame].textbelow:SetAlpha(Enhancer.db.profile.combatinactiveAlpha);
			self[frame].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.combatinactiveAlpha);
		else
			self[frame].textcenter:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
			self[frame].textbelow:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
			self[frame].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.oocinactiveAlpha);
		end
		
	end
end

function Enhancer:FrameDeathPreBegin(frame)
	-- Stupid hack since all frames don't want the middle number erased (Reincarnation)
	self[frame].textcenter:SetText("");
	self:FrameDeathBegin(frame);
end

function Enhancer:FrameDeathBegin(frame)
	if (self[frame] and self[frame].active) then
		self[frame].active = nil;
		self[frame].textbelow:SetText("");
		
		self:AddPulseDeath(frame);
		self:AddPulse(frame);
		if (self.db.profile.playSound) then
			PlaySoundFile("Interface\\Addons\\Enhancer\\sounds\\" .. frame .. ".mp3");
		end
	else
		self:FrameDeathEnd(frame);
	end
end

function Enhancer:FrameDeathEnd(frame)
	if (not self[frame]) then return; end
	
	self:ChangeIcon(frame, self[frame].mainframe.bgFileDefault);
	self[frame].mainframe:SetBackdropBorderColor((self[frame].borderColor and self[frame].borderColor["r"]) or 1, (self[frame].borderColor and self[frame].borderColor["g"]) or 1, (self[frame].borderColor and self[frame].borderColor["b"]) or 1, 0);
	
	for logName, logFrame in pairs(self.combatLog) do
		if (logFrame == frame) then
			self.combatLog[logName] = nil;
		end
	end
	
	self:UpdateAlphaBegin(frame);
end

function Enhancer:UpdateFrame(frame)
	if (not self[frame].active) then return; end
	
	if (GetTime() >= self[frame].death) then
		local message = string.format(L["TotemDeath"], self[frame].name, self[frame].element);
		self:ScreenMessage(message, 1, (1/2), 0);
		
		self:FrameDeathPreBegin(frame);
		return;
	end
	
	if (self[frame].warn and GetTime() >= self[frame].warn) then
		self[frame].warn = nil;
		local message = string.format(L["TotemExpiring"], self[frame].name, self[frame].element);
		self:ScreenMessage(message, 1, 1, 0);
	end
	
	self[frame].textbelow:SetText( Enhancer:FormatTime(self[frame].death - GetTime()) );
	self[frame].lived = self[frame].lived + 1;
	if (self[frame].pulse) then
		if ( self[frame].pulse - GetTime() <= 0 ) then
			self:AddPulse(frame);
			self[frame].pulse = self[frame].pulse + self[frame].pulseAdd;
		end
		
		self[frame].textcenter:SetText( ceil(self[frame].pulse - GetTime()) );
	end
	
	if ( not (self:IsEventScheduled(frame)) ) then
		self:ScheduleRepeatingEvent(frame, self.UpdateFrame, 1, self, frame)
	end
end

function Enhancer:ChangeIcon(framename, icon)
	local backdrop = self[framename].mainframe:GetBackdrop();
	backdrop.bgFile = "Interface/Icons/" .. icon;
	self[framename].mainframe:SetBackdrop(backdrop);
	self[framename].mainframe:SetBackdropBorderColor( 1, 1, 1, 0);
	self:UpdateAlphaBegin(framename)
end

function Enhancer:ChangeIconFull(framename, icon)
	local backdrop = self[framename].mainframe:GetBackdrop();
	backdrop.bgFile = icon;
	self[framename].mainframe:SetBackdrop(backdrop);
	self[framename].mainframe:SetBackdropBorderColor( 1, 1, 1, 0);
	self:UpdateAlphaBegin(framename)
end

function Enhancer:AddPulse(frame)
	if (not self.pulsing) then self.pulsing = {}; end
	self.pulsing[frame] = 0;
	
	EnhancerPulseFrame:SetScript("OnUpdate", function()
		Enhancer:Pulse();
	end)
end

function Enhancer:RemPulse(frame)
	if (not self.pulsing) then self.pulsing = {}; end
	self.pulsing[frame] = nil;
end

function Enhancer:AddPulseDeath(frame)
	if (not self.pulsingDeath) then self.pulsingDeath = {}; end
	self.pulsingDeath[frame] = true;
end

Enhancer.onewayPulses = 5;
Enhancer.alterationPulse = (1 / 10);
function Enhancer:Pulse()
	local canStop = true;
	
	for frame, count in pairs(self.pulsing) do
		count = count + 1;
		
		if (count >= (Enhancer.onewayPulses * 2)) then
			self[frame].mainframe:SetHeight( Enhancer.db.profile.framesize );
			self[frame].mainframe:SetWidth( Enhancer.db.profile.framesize );
			self[frame].mainframe:SetBackdropBorderColor(1, 1, 1, 0);
			self[frame].cooldown:SetWidth(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / 3));
			self[frame].cooldown:SetHeight(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / 3));
			
			if (self.pulsingDeath and self.pulsingDeath[frame]) then
				self.pulsingDeath[frame] = nil;
				self:FrameDeathEnd(frame);
			end
			self:RemPulse(frame);
		else
			
			if (Enhancer.db.profile.borderPulse) then
				self[frame].mainframe:SetBackdropBorderColor(self[frame].borderColor["r"] or 1, self[frame].borderColor["g"] or 1, self[frame].borderColor["b"] or 1, self[frame].borderColor["a"] or 1);
			end
			
			if (Enhancer.db.profile.growingPulse) then
				local mainSize = self[frame].mainframe:GetHeight();
				local cdSize = self[frame].cooldown:GetHeight();
				if (count <= Enhancer.onewayPulses) then
					-- Going Up
					self[frame].mainframe:SetHeight( mainSize + (mainSize * Enhancer.alterationPulse) );
					self[frame].mainframe:SetWidth( mainSize + (mainSize * Enhancer.alterationPulse) );
					self[frame].cooldown:SetHeight( cdSize + (cdSize * Enhancer.alterationPulse) );
					self[frame].cooldown:SetWidth( cdSize + (cdSize * Enhancer.alterationPulse) );
				else
					-- Going Down
					self[frame].mainframe:SetHeight( mainSize - (mainSize * Enhancer.alterationPulse) );
					self[frame].mainframe:SetWidth( mainSize - (mainSize * Enhancer.alterationPulse) );
					self[frame].cooldown:SetHeight( cdSize - (cdSize * Enhancer.alterationPulse) );
					self[frame].cooldown:SetWidth( cdSize - (cdSize * Enhancer.alterationPulse) );
				end
			end
			
			self.pulsing[frame] = count;
			canStop = false;
		end
	end
	
	if (canStop) then
		EnhancerPulseFrame:SetScript("OnUpdate", function()
		end)
	end
end

Enhancer.doPulse = {};
EnhancerPulseFrame = CreateFrame("Frame")