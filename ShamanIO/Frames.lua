local L = AceLibrary("AceLocale-2.2"):new("ShamanIO");
local strataToUse = "BACKGROUND"; --TOOLTIP
local defaultAlpha = (3 / 10);
local defaultTextFrameHeight = 20;
local defaultSize = 46;

function ShamanIO:CreateButton(globalname, bgFile)
	local retVal = {};
	local object;
	
	if (not getglobal(globalname)) then
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
		object:SetFontObject(GameFontNormalSmall);
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
		object:SetWidth(defaultSize);
		object:SetHeight(defaultSize);
		object:SetFrameStrata(strataToUse);
		object:SetPoint("TOP", globalname.."Anchor", "BOTTOM", 0, 0);
		object:SetMovable(true);
		object:SetBackdrop({
			bgFile = "Interface/Icons/" .. object.bgFileDefault,
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right = 5, top = 5, bottom = 5 }
		});
		object:SetBackdropColor( 1, 1, 1, defaultAlpha);
		object:SetBackdropBorderColor( 1, 1, 1, 0);
		retVal["mainframe"] = object;
		
		--[[ Create a Cooldown ]]
		object = CreateFrame("Cooldown", globalname.."FrameCooldown", MainFrame, "CooldownFrameTemplate");
		object:ClearAllPoints();
		object:SetWidth(defaultSize - (defaultSize / 3));
		object:SetHeight(defaultSize - (defaultSize / 3));
		object:SetPoint("CENTER", globalname.."Frame", "CENTER", 0, 0);
		retVal["cooldown"] = object;
		
		--[[ Create a fontstring below ]]
		object = retVal["mainframe"]:CreateFontString(globalname.."FrameText1", "OVERLAY");
		object:SetFontObject(GameFontNormalSmall);
		object:ClearAllPoints();
		object:SetTextColor(1, 1, 1, 1);
		object:SetWidth(defaultSize);
		object:SetHeight(defaultTextFrameHeight);
		object:SetPoint("TOP", globalname.."Frame", "BOTTOM");
		object:SetJustifyH("CENTER");
		object:SetJustifyV("MIDDLE");
		object:SetText("");
		object:SetAlpha(defaultAlpha);
		retVal["textbelow"] = object;
		
		--[[ Create the 2nd fontstring ]]
		object = retVal["mainframe"]:CreateFontString(globalname.."FrameText2", "OVERLAY");
		object:SetFontObject(GameFontNormal);
		object:ClearAllPoints();
		object:SetTextColor(1, 1, 1, 1);
		object:SetWidth(defaultSize);
		object:SetHeight(defaultSize);
		object:SetPoint("CENTER", globalname.."Frame", "CENTER");
		object:SetJustifyH("CENTER");
		object:SetJustifyV("MIDDLE");
		object:SetText("");
		object:SetAlpha(defaultAlpha);
		object:SetShadowColor(0, 0, 0, 1)
		object:SetShadowOffset(0.8, -0.8)
		retVal["textcenter"] = object;
		
		retVal["anchor"]:Hide();
		retVal["mainframe"]:Hide();
	end
	
	return retVal, globalname;
end

function ShamanIO:MakeMoveable(frame)
	frame:SetScript("OnDragStart",
    function()
			frame:StartMoving();
		end );
        
	frame:SetScript("OnDragStop",
		function()
			frame:StopMovingOrSizing(frame);
			ShamanIO:SavePos(frame:GetName(), frame);
		end );
end

function ShamanIO:SavePos(framename, frame)
	local db = ShamanIO.db.profile;
	if (not db.framePositions) then db.framePositions = {}; end
	if (not db.framePositions[framename]) then db.framePositions[framename] = {}; end
	frame:GetCenter()
	local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint();
	self:Print( frame:GetPoint() );
	
	db.framePositions[framename]["point"] = point;
	db.framePositions[framename]["relativeTo"] = relativeTo;
	db.framePositions[framename]["relativePoint"] = relativePoint;
	db.framePositions[framename]["xOfs"] = xOfs;
	db.framePositions[framename]["yOfs"] = yOfs;
end

function ShamanIO:LoadPos()
	local db = ShamanIO.db.profile;
	
	if (not db.framePositions) then return; end
	
	for framename, _ in pairs(db.framePositions) do
		if (getglobal(framename)) then
			getglobal(framename):ClearAllPoints();
			getglobal(framename):SetPoint(
				db.framePositions[framename]["point"],
				db.framePositions[framename]["relativeTo"],
				db.framePositions[framename]["relativePoint"],
				db.framePositions[framename]["xOfs"],
				db.framePositions[framename]["yOfs"]
			)
		end
	end
end

function ShamanIO:DefaultPos()
	local db = ShamanIO.db.profile;
	local negativeOut = -170;
	local positiveOut = 170;
	
	self.earth.anchor:ClearAllPoints();
	self.earth.anchor:SetPoint("CENTER", UIParent, "CENTER",  positiveOut,  (positiveOut + defaultSize)) -- positiveOut = East, positiveOut = North
	self.fire.anchor:ClearAllPoints();
	self.fire.anchor:SetPoint("CENTER", UIParent, "CENTER",  negativeOut,  (positiveOut + defaultSize)) -- negativeOut = West, positiveOut = North
	self.water.anchor:ClearAllPoints();
	self.water.anchor:SetPoint("CENTER", UIParent, "CENTER",  positiveOut,  (negativeOut + defaultSize)) -- positiveOut = East, negativeOut = South
	self.air.anchor:ClearAllPoints();
	self.air.anchor:SetPoint("CENTER", UIParent, "CENTER",  negativeOut,  (negativeOut + defaultSize)) -- negativeOut = West, negativeOut = South
	
	self.reincarnation.anchor:ClearAllPoints();
	self.reincarnation.anchor:SetPoint("CENTER", UIParent, "CENTER",  0,  (negativeOut + defaultSize)) -- 0 = Center, negativeOut = South
	
	self.windfury.anchor:ClearAllPoints();
	self.windfury.anchor:SetPoint("CENTER", UIParent, "CENTER",  0,  (positiveOut + defaultSize)) -- 0 = Center, positiveOut = North
	
	if (db.framePositions) then db.framePositions = nil; end
end

function ShamanIO:UpdateAlphaBegin(frames)
	if (type(frames) == "table") then
		for _, frame in pairs(frames) do
			self:UpdateAlphaEnd(frame);
		end
	else
		self:UpdateAlphaEnd(frames);
	end
end

function ShamanIO:UpdateAlphaEnd(frame)
	local shortcut = self[frame];
	
	if (not shortcut) then return; end
	
	local r, g, b, a = shortcut.mainframe:GetBackdropColor();
	
	if (shortcut.active) then
		-- This frame is displaying something :)
		if (self.inCombat or frame == "reincarnation" or frame == "windfury") then
			shortcut.textcenter:SetAlpha(1);
			shortcut.textbelow:SetAlpha(1);
			shortcut.mainframe:SetBackdropColor( r, g, b, 1);
		else
			shortcut.textcenter:SetAlpha(defaultAlpha);
			shortcut.textbelow:SetAlpha(defaultAlpha);
			shortcut.mainframe:SetBackdropColor( r, g, b, defaultAlpha);
		end
		
	else
		-- Not used atm
		shortcut.textcenter:SetAlpha(defaultAlpha);
		shortcut.textbelow:SetAlpha(defaultAlpha);
		shortcut.mainframe:SetBackdropColor( r, g, b, defaultAlpha);
	end
end

function ShamanIO:FrameDeathBegin(frame)
	if (self[frame].active) then
		self[frame].active = nil;
		
		self:AddPulseDeath(frame);
		self:AddPulse(frame);
	else
		self:FrameDeathEnd(frame);
	end
end

function ShamanIO:FrameDeathEnd(frame)
	self:ChangeIcon(frame, self[frame].mainframe.bgFileDefault);
	self[frame].mainframe:SetBackdropBorderColor(self[frame].borderColor["r"] or 1, self[frame].borderColor["g"] or 1, self[frame].borderColor["b"] or 1, 0);
	
	self:UpdateAlphaBegin(frame);
	
	PlaySound("Deathbind Sound");
end

function ShamanIO:UpdateFrame(frame)
	if (not self[frame].active) then return; end
	
	if (GetTime() >= self[frame].death) then
		local message = string.format(L["TotemDeath"], self[frame].name, self[frame].element);
		self:ScreenMessage(message, 1, (1/2), 0);
		
		self[frame].textbelow:SetText("");
		self:FrameDeathBegin(frame);
		return;
	end
	
	if (self[frame].warn and GetTime() >= self[frame].warn) then
		self[frame].warn = nil;
		local message = string.format(L["TotemExpiring"], self[frame].name, self[frame].element);
		self:ScreenMessage(message, 1, 1, 0);
	end
	
	self[frame].textbelow:SetText( ShamanIO:FormatTime(self[frame].death - GetTime()) );
	self[frame].lived = self[frame].lived + 1;
	if (self[frame].pulse) then
		if ( self[frame].pulse - GetTime() <= 0 ) then
			self:AddPulse(frame);
			self[frame].pulse = self[frame].pulse + self[frame].pulseAdd;
		end
		
		self[frame].textcenter:SetText( ceil(self[frame].pulse - GetTime()) );
	end
	
	--self[frame].warn = GetTime() + TimeToLive - 7;
	
	
	if ( not (self:IsEventScheduled(frame)) ) then
		self:ScheduleRepeatingEvent(frame, self.UpdateFrame, 1, self, frame)
	end
end

function ShamanIO:ChangeIcon(frame, icon)
	local backdrop = self[frame].mainframe:GetBackdrop();
	backdrop.bgFile = "Interface/Icons/" .. icon;
	self[frame].mainframe:SetBackdrop(backdrop);
end

function ShamanIO:AddPulse(frame)
	if (not self.pulsing) then self.pulsing = {}; end
	self.pulsing[frame] = 0;
	
	ShamanIOPulseFrame:SetScript("OnUpdate", function()
		ShamanIO:Pulse();
	end)
end

function ShamanIO:RemPulse(frame)
	if (not self.pulsing) then self.pulsing = {}; end
	self.pulsing[frame] = nil;
end

function ShamanIO:AddPulseDeath(frame)
	if (not self.pulsingDeath) then self.pulsingDeath = {}; end
	self.pulsingDeath[frame] = true;
end

ShamanIO.onewayPulses = 5;
ShamanIO.alterationPulse = (1 / 10);
function ShamanIO:Pulse()
	local canStop = true;
	
	for frame, count in pairs(self.pulsing) do
		count = count + 1;
		
		if (count >= (ShamanIO.onewayPulses * 2)) then
			self[frame].mainframe:SetHeight( defaultSize );
			self[frame].mainframe:SetWidth( defaultSize );
			self[frame].mainframe:SetBackdropBorderColor(1, 1, 1, 0);
			self[frame].cooldown:SetWidth(defaultSize - (defaultSize / 3));
			
			if (self.pulsingDeath and self.pulsingDeath[frame]) then
				self.pulsingDeath[frame] = nil;
				self:FrameDeathEnd(frame);
			end
			self:RemPulse(frame);
		else
			
			self[frame].mainframe:SetBackdropBorderColor(self[frame].borderColor["r"] or 1, self[frame].borderColor["g"] or 1, self[frame].borderColor["b"] or 1, self[frame].borderColor["a"] or 1);
			
			local mainSize = self[frame].mainframe:GetHeight();
			local cdSize = self[frame].cooldown:GetHeight();
			if (count <= ShamanIO.onewayPulses) then
				-- Going Up
				self[frame].mainframe:SetHeight( mainSize + (mainSize * ShamanIO.alterationPulse) );
				self[frame].mainframe:SetWidth( mainSize + (mainSize * ShamanIO.alterationPulse) );
				self[frame].cooldown:SetHeight( cdSize + (cdSize * ShamanIO.alterationPulse) );
				self[frame].cooldown:SetWidth( cdSize + (cdSize * ShamanIO.alterationPulse) );
			else
				-- Going Down
				self[frame].mainframe:SetHeight( mainSize - (mainSize * ShamanIO.alterationPulse) );
				self[frame].mainframe:SetWidth( mainSize - (mainSize * ShamanIO.alterationPulse) );
				self[frame].cooldown:SetHeight( cdSize - (cdSize * ShamanIO.alterationPulse) );
				self[frame].cooldown:SetWidth( cdSize - (cdSize * ShamanIO.alterationPulse) );
			end
			
			self.pulsing[frame] = count;
			canStop = false;
		end
	end
	
	if (canStop) then
		ShamanIOPulseFrame:SetScript("OnUpdate", function()
		end)
	end
end

ShamanIO.doPulse = {};
ShamanIOPulseFrame = CreateFrame("Frame")