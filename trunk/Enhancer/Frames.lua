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
	object:SetWidth(Enhancer.db.profile.framesize);
	object:SetHeight(Enhancer.db.profile.framesize);
	object:SetPoint("CENTER", UIParent, "CENTER",  0,  0);
	object:SetMovable(true);
	object:RegisterForDrag("LeftButton");
	object:SetFrameStrata("HIGH");
	object:SetClampedToScreen(true);
	object:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false, tileSize = 0, edgeSize = 8,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	});
	object:SetBackdropColor( (1/10), (1/10), (1/10), (1/10));
	object:SetBackdropBorderColor( 1, 1, 1, 0);
	retVal["anchor"] = object;
	
	--[[ Create a fontstring for the Anchor ]]
	object = retVal["anchor"]:CreateFontString(globalname.."AnchorText", "OVERLAY");
	object:SetFontObject(Enhancer.db.profile.belowFont);
	object:ClearAllPoints();
	object:SetTextColor(1, 1, 1, 1);
	object:SetWidth(Enhancer.db.profile.framesize);
	object:SetHeight(Enhancer.db.profile.framesize);
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
	object:SetPoint("CENTER", globalname.."Anchor", "CENTER", 0, 0);
	object:SetMovable(true);
	object:SetBackdrop({
		bgFile = "Interface/Icons/" .. object.bgFileDefault,
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false, tileSize = 0, edgeSize = 8,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	});
	local t = object:CreateTexture(nil,"BACKGROUND")
	object.texture = t

	-- Interface\\AddOns\\cyCircled\\textures\\Square
	object:SetBackdropColor( 1, 1, 1, Enhancer.db.profile.oocinactiveAlpha);
	object:SetBackdropBorderColor( 1, 1, 1, 0);
	retVal["mainframe"] = object;
	
	--[[ Create a Cooldown ]]
	object = CreateFrame("Cooldown", globalname.."FrameCooldown", MainFrame, "CooldownFrameTemplate");
	object:ClearAllPoints();
	object.divider = 10;
	object:SetWidth(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / object.divider));
	object:SetHeight(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / object.divider));
	object:SetPoint("CENTER", globalname.."Frame", "CENTER", 0, 0);
	retVal["cooldown"] = object;
	
	--[[ Create a fontstring above ]]
	object = retVal["mainframe"]:CreateFontString(globalname.."FrameText1", "OVERLAY");
	object:SetFontObject(Enhancer.db.profile.belowFont);
	object:ClearAllPoints();
	object:SetTextColor(1, 1, 1, 1);
	object:SetWidth(Enhancer.db.profile.framesize * (15/10));
	object:SetHeight(Enhancer.db.profile.belowFontSize + 10);
	object:SetPoint("BOTTOM", globalname.."Frame", "TOP");
	object:SetJustifyH("CENTER");
	object:SetJustifyV("MIDDLE");
	object:SetText("");
	object:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
	retVal["textabove"] = object;
	
	--[[ Create a fontstring in center ]]
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
	
	--[[ Create a fontstring below ]]
	object = retVal["mainframe"]:CreateFontString(globalname.."FrameText3", "OVERLAY");
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
	
	retVal["anchor"]:Hide();
	retVal["mainframe"]:Hide();
	
	retVal.xOffsetDefault = xOffset or 0;
	retVal.yOffsetDefault = yOffset or 0;
	
	retVal.data = {}; --[[ Temp storage that clears on FrameDeathEnd ]]--
	
	return retVal, globalname;
end

function Enhancer:MakeMoveable(framename)
	self[framename].anchor:SetScript("OnDragStart",
    function()
			self[framename].anchor:StartMoving();
		end );
	
	self[framename].anchor:SetScript("OnDragStop",
		function()
			self[framename].anchor:StopMovingOrSizing();
			Enhancer:SavePos(framename, self[framename].anchor);
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
		self[framename].anchor:SetPoint("CENTER", UIParent, "CENTER",  self[framename].xOffsetDefault,  self[framename].yOffsetDefault);
		-- self[framename].anchor:SetPoint("CENTER", UIParent, "CENTER",  self[framename].xOffsetDefault,  (self[framename].yOffsetDefault + Enhancer.db.profile.framesize));
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
		self[framename].textabove:SetText("");
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

function Enhancer:UpdateAlphaEnd(framename)
	if (not self[framename]) then return; end
	
	local r, g, b, a = self[framename].mainframe:GetBackdropColor();
	
	if (self[framename].unlocked) then
		-- This frame has been unlocked for moving about so make everything visible for it :)
		self[framename].textcenter:SetAlpha(1);
		self[framename].textbelow:SetAlpha(1);
		self[framename].textabove:SetAlpha(1);
		self[framename].mainframe:SetBackdropColor(r, g, b, 1);
	elseif (self[framename].empty) then
		
		-- At the moment this frame can't hold any data (Main Hand/Off Hand enchants for example)
		self[framename].textcenter:SetAlpha(0);
		self[framename].textbelow:SetAlpha(0);
		self[framename].textabove:SetAlpha(0);
		self[framename].mainframe:SetBackdropColor(r, g, b, 0);
		
	elseif ( (framename == "reincarnation"  or framename == "windfury") and self.db.profile.specialAlpha ) then
		
		-- Special Handling of these frames
		if (self[framename].active) then
			self[framename].textcenter:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[framename].textbelow:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[framename].textabove:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[framename].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.combatAlpha);
		else
			self[framename].textcenter:SetAlpha(Enhancer.db.profile.combatinactiveAlpha);
			self[framename].textbelow:SetAlpha(Enhancer.db.profile.combatinactiveAlpha);
			self[framename].textabove:SetAlpha(Enhancer.db.profile.combatinactiveAlpha);
			self[framename].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.combatinactiveAlpha);
		end
	
	elseif ( Enhancer.oFrames[framename] and self.db.profile.specialAlpha ) then
	
		-- Special Handling of these frames (on or off)
		if (self[framename].active) then
			self[framename].textcenter:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[framename].textbelow:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[framename].textabove:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[framename].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.combatAlpha);
		else
			self[framename].textcenter:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
			self[framename].textbelow:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
			self[framename].textabove:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
			self[framename].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.oocinactiveAlpha);
		end
	
	elseif (self[framename].active) then
		
		if (self.inCombat) then
			self[framename].textcenter:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[framename].textbelow:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[framename].textabove:SetAlpha(Enhancer.db.profile.combatAlpha);
			self[framename].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.combatAlpha);
		else
			self[framename].textcenter:SetAlpha(Enhancer.db.profile.oocombatAlpha);
			self[framename].textbelow:SetAlpha(Enhancer.db.profile.oocombatAlpha);
			self[framename].textabove:SetAlpha(Enhancer.db.profile.oocombatAlpha);
			self[framename].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.oocombatAlpha);
		end
		
	else
		
		if (self.inCombat) then
			self[framename].textcenter:SetAlpha(Enhancer.db.profile.combatinactiveAlpha);
			self[framename].textbelow:SetAlpha(Enhancer.db.profile.combatinactiveAlpha);
			self[framename].textabove:SetAlpha(Enhancer.db.profile.combatinactiveAlpha);
			self[framename].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.combatinactiveAlpha);
		else
			self[framename].textcenter:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
			self[framename].textbelow:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
			self[framename].textabove:SetAlpha(Enhancer.db.profile.oocinactiveAlpha);
			self[framename].mainframe:SetBackdropColor(r, g, b, Enhancer.db.profile.oocinactiveAlpha);
		end
		
	end
end

function Enhancer:FrameDeathPreBegin(framename)
	-- Stupid hack since all frames don't want the middle number erased (Reincarnation)
	self[framename].textcenter:SetText("");
	self:FrameDeathBegin(framename);
end

function Enhancer:FrameDeathBegin(framename)
	if (self[framename] and self[framename].active) then
		self[framename].active = nil;
		self[framename].textbelow:SetText("");
		self[framename].textabove:SetText("");
		
		self:AddPulseDeath(framename);
		self:AddPulse(framename);
		if (self.db.profile.playSound) then
			PlaySoundFile("Interface\\Addons\\Enhancer\\sounds\\" .. framename .. ".mp3");
		end
	else
		self:FrameDeathEnd(framename);
	end
end

function Enhancer:FrameDeathEnd(framename)
	if (not self[framename]) then return; end
	
	self:ChangeIcon(framename, self[framename].mainframe.bgFileDefault);
	
	self[framename].mainframe:SetBackdropBorderColor((self[framename].borderColor and self[framename].borderColor["r"]) or 1, (self[framename].borderColor and self[framename].borderColor["g"]) or 1, (self[framename].borderColor and self[framename].borderColor["b"]) or 1, 0);
	
	for logName, logFrame in pairs(self.combatLog) do
		if (logFrame == framename) then
			self.combatLog[logName] = nil;
		end
	end
	
	self[framename].data = nil; --[[ Temp storage that we clear entirely on FrameDeathEnd ]]--
	self[framename].data = {};
	
	self:UpdateAlphaBegin(framename);
end

function Enhancer:SetFrameData(framename, key, value)
	if (not self[framename]) then return; end
	
	if (not self[framename].data) then self[frame].data = {}; end
	self[framename].data[key] = value;
end

function Enhancer:GetFrameData(framename, key, default)
	return (self[framename] and self[framename].data and self[framename].data[key]) or default;
end

function Enhancer:UpdateFrame(framename)
	if (not self[framename].active) then return; end
	
	if (GetTime() >= self[framename].death) then
		local message = string.format(L["TotemDeath"], self[framename].name, self[framename].element);
		self:ScreenMessage(message, 1, (1/2), 0);
		
		self:FrameDeathPreBegin(framename);
		return;
	end
	
	-- Do range if Cartographer is installed and active
	if (not self.coords) then
		self[framename].textabove:SetText("");
	elseif (Cartographer) then
		local totemX = self:GetFrameData(framename, "ZoneX");
		local totemY = self:GetFrameData(framename, "ZoneY");
		local totemZone = self:GetFrameData(framename, "Zone");
		
		if (totemX and totemY and totemZone) then
			local distance = Cartographer:GetDistanceToPoint(totemX, totemY, totemZone);
			if (distance) then
				self[framename].textabove:SetText( "~" .. string.format("%.1f", distance) .. "~" );
				
				-- Destroy on too much distance? what range is ok?
				if (distance > 400 and false) then
					self:FrameDeathPreBegin(framename);
					return;
				end
			else
				self[framename].textabove:SetText("-");
			end
		end
	end
	
	if (self[framename].warn and GetTime() >= self[framename].warn) then
		self[framename].warn = nil;
		local message = string.format(L["TotemExpiring"], self[framename].name, self[framename].element);
		self:ScreenMessage(message, 1, 1, 0);
	end
	
	self[framename].textbelow:SetText( Enhancer:FormatTime(self[framename].death - GetTime()) );
	self[framename].lived = self[framename].lived + 1;
	if (self[framename].pulse) then
		if ( self[framename].pulse - GetTime() <= 0 ) then
			self:AddPulse(framename);
			self[framename].pulse = self[framename].pulse + self[framename].pulseAdd;
		end
		
		self[framename].textcenter:SetText( ceil(self[framename].pulse - GetTime()) );
	end
	
	if ( not (self:IsEventScheduled(framename)) ) then
		self:ScheduleRepeatingEvent(framename, self.UpdateFrame, 1, self, framename)
	end
end

function Enhancer:ChangeIcon(framename, icon)
	local backdrop = self[framename].mainframe:GetBackdrop();
	if (self[framename].fullicon) then
		backdrop.bgFile = icon;
	else
		backdrop.bgFile = "Interface/Icons/" .. icon;
	end
	
	self[framename].mainframe:SetBackdrop(backdrop);
	self[framename].mainframe:SetBackdropBorderColor( 1, 1, 1, 0);
	self:UpdateAlphaBegin(framename)
end

function Enhancer:AddPulse(framename)
	if (not self.pulsing) then self.pulsing = {}; end
	self.pulsing[framename] = 0;
	
	EnhancerPulseFrame:SetScript("OnUpdate", function()
		Enhancer:Pulse();
	end)
end

function Enhancer:RemPulse(framename)
	if (not self.pulsing) then self.pulsing = {}; end
	self.pulsing[framename] = nil;
end

function Enhancer:AddPulseDeath(framename)
	if (not self.pulsingDeath) then self.pulsingDeath = {}; end
	self.pulsingDeath[framename] = true;
end

Enhancer.onewayPulses = 5;
Enhancer.alterationPulse = (1 / 10);
function Enhancer:Pulse()
	local canStop = true;
	
	for framename, count in pairs(self.pulsing) do
		count = count + 1;
		
		if (count >= (Enhancer.onewayPulses * 2)) then
			self[framename].mainframe:SetHeight( Enhancer.db.profile.framesize );
			self[framename].mainframe:SetWidth( Enhancer.db.profile.framesize );
			self[framename].mainframe:SetBackdropBorderColor(1, 1, 1, 0);
			self[framename].cooldown:SetWidth(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / self[framename].cooldown.divider));
			self[framename].cooldown:SetHeight(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / self[framename].cooldown.divider));
			
			if (self.pulsingDeath and self.pulsingDeath[framename]) then
				self.pulsingDeath[framename] = nil;
				self:FrameDeathEnd(framename);
			end
			self:RemPulse(framename);
		else
			
			if (Enhancer.db.profile.borderPulse) then
				self[framename].mainframe:SetBackdropBorderColor((self[framename].borderColor and self[framename].borderColor["r"]) or 1, (self[framename].borderColor and self[framename].borderColor["g"]) or 1, (self[framename].borderColor and self[framename].borderColor["b"]) or 1, 1);
			end
			
			if (Enhancer.db.profile.growingPulse) then
				local mainSize = self[framename].mainframe:GetHeight();
				local cdSize = self[framename].cooldown:GetHeight();
				if (count <= Enhancer.onewayPulses) then
					-- Going Up
					self[framename].mainframe:SetHeight( mainSize + (mainSize * Enhancer.alterationPulse) );
					self[framename].mainframe:SetWidth( mainSize + (mainSize * Enhancer.alterationPulse) );
					self[framename].cooldown:SetHeight( cdSize + (cdSize * Enhancer.alterationPulse) );
					self[framename].cooldown:SetWidth( cdSize + (cdSize * Enhancer.alterationPulse) );
				else
					-- Going Down
					self[framename].mainframe:SetHeight( mainSize - (mainSize * Enhancer.alterationPulse) );
					self[framename].mainframe:SetWidth( mainSize - (mainSize * Enhancer.alterationPulse) );
					self[framename].cooldown:SetHeight( cdSize - (cdSize * Enhancer.alterationPulse) );
					self[framename].cooldown:SetWidth( cdSize - (cdSize * Enhancer.alterationPulse) );
				end
			end
			
			self.pulsing[framename] = count;
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