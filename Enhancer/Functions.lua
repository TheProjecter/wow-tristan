function Enhancer:CheckRunningModules()
	if ( self:IsModuleActive("Earth") or self:IsModuleActive("Fire") or self:IsModuleActive("Water") or self:IsModuleActive("Air") ) then
		if ( not self:IsEventRegistered("UNIT_SPELLCAST_SUCCEEDED") ) then
			self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "CastingTotem")
		end
	else
		if ( self:IsEventRegistered("UNIT_SPELLCAST_SUCCEEDED") ) then
			self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
		end
	end
end

function Enhancer:CreateTotem(totem, rank)
	if (type(rank) ~= "number") then
		if (tonumber(rank)) then
			rank = tonumber(rank);
		else
			self:Print("Big Error: Rank was not a number nor could it be converted. Please mail dennis.hafstrom@gmail.com with info about what rank you cast");
			return;
		end
	end
	
	local Icon = Enhancer.Totems[totem].Icon;
	local TimeToLive = Enhancer.Totems[totem].Time or (Enhancer.Totems[totem][rank] and Enhancer.Totems[totem][rank].Time);
	local Element = Enhancer.Totems[totem].Element;
	local HitPoints = Enhancer.Totems[totem].Life or (Enhancer.Totems[totem][rank] and Enhancer.Totems[totem][rank].Life);
	local Pulse = Enhancer.Totems[totem].Pulse;
	
	if (not Enhancer:IsModuleActive(Element)) then return; end
	
	local frame = string.lower(Element);
	for k, v in pairs(self.combatLog) do
		if (v == frame) then self.combatLog[k] = nil; end
	end
	
	local combatLogName = totem;
	if (rank > 1) then combatLogName = combatLogName .. " " .. self.Ranks[rank]; end
	self.combatLog[combatLogName] = frame;
	if (Enhancer.Totems[totem].CombatLog) then
		for _, logName in ipairs(Enhancer.Totems[totem].CombatLog) do
			self.combatLog[logName] = frame;
		end
	end
	
	if (Enhancer.Totems[totem][rank] and Enhancer.Totems[totem][rank].Level) then
		if (totem == Enhancer.BS["Stoneclaw Totem"]) then
			-- HitPoints increase by (Level - TotemMinLearnLevel) * 3
			HitPoints = HitPoints + ((self.PlayerLevel - Enhancer.Totems[totem][rank].Level) * 3);
		end
	end
	
	self[frame].name = totem;
	self[frame].element = Element;
	self[frame].active = true;
	self[frame].hitPoints = HitPoints;
	self[frame].death = GetTime() + TimeToLive;
	if (TimeToLive > 7) then
		self[frame].warn = GetTime() + TimeToLive - 7;
	else
		self[frame].warn = nil;
	end
	self[frame].pulseAdd = Pulse;
	if (Pulse) then
		self[frame].pulse = GetTime() + self[frame].pulseAdd;
	else
		self[frame].pulse = nil
	end
	
	self[frame].lived = 0;
	self:ChangeIcon(frame, Icon);
	self[frame].mainframe:SetBackdropBorderColor((self[frame].borderColor and self[frame].borderColor["r"]) or 1, (self[frame].borderColor and self[frame].borderColor["g"]) or 1, (self[frame].borderColor and self[frame].borderColor["b"]) or 1, 0);
	self:UpdateAlphaBegin(frame)
	
	self[frame].textcenter:SetText(Pulse);
	self[frame].textbelow:SetText( Enhancer:FormatTime(self[frame].death - GetTime()) );
	if ( not (self:IsEventScheduled(frame)) ) then
		self:ScheduleRepeatingEvent(frame, self.UpdateFrame, (1 / 2), self, frame)
	end
end

function Enhancer:ScreenMessage(message, r, g, b, a, h)
	UIErrorsFrame:AddMessage(message, r or 1, g or 1, b or 1, a or 1, h or 3);
end

function Enhancer:AddFrameToList(framename, all, totem, death)
	if (all) then
		table.insert(Enhancer.aFrames, framename);
	end
	
	if (totem) then
		table.insert(Enhancer.tFrames, framename);
	end
	
	if (death) then
		table.insert(Enhancer.dFrames, framename);
	end
	
	self:MakeMoveable(framename);
	self:LoadPos(framename);
end

function Enhancer:AddFrameToOnOffList(framename)
	Enhancer.oFrames[framename] = true;
end

function Enhancer:ToggleLock(framelist)
	if (not framelist) then framelist = Enhancer.aFrames; end
	
	if (type(framelist) == "table") then
		for _, framename in ipairs(framelist) do
			self:ToggleLock(framename);
		end
	else
		local framename = framelist;
		
		if (self.db.profile.locked) then
			self[framename].anchor:Hide();
			self[framename].unlocked = nil;
		else
			if (self[framename].mainframe:IsVisible()) then
				self[framename].anchor:Show();
				self[framename].unlocked = true;
			end
		end
		
		self:UpdateAlphaBegin(framename);
	end
end

function Enhancer:Resize()
	for _, frame in ipairs(Enhancer.aFrames) do
		self[frame].mainframe:SetWidth(Enhancer.db.profile.framesize);
		self[frame].mainframe:SetHeight(Enhancer.db.profile.framesize);
		
		self[frame].cooldown:SetWidth(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / 3));
		self[frame].cooldown:SetHeight(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / 3));
		
		self[frame].textbelow:SetWidth(Enhancer.db.profile.framesize);
		
		self[frame].textcenter:SetHeight(Enhancer.db.profile.framesize);
		self[frame].textcenter:SetWidth(Enhancer.db.profile.framesize);
	end
	
	self:UpdateFont();
end

function Enhancer:UpdateFont()
	Enhancer.db.profile.centerFontSize = (Enhancer.db.profile.framesize / 3);
	Enhancer.db.profile.centerFont = CreateFont("EnhancerCenterFont");
	Enhancer.db.profile.centerFont:SetFont(Enhancer.db.profile.centerFontName, Enhancer.db.profile.centerFontSize, Enhancer.db.profile.centerFontFlags);
	
	Enhancer.db.profile.belowFontSize = (Enhancer.db.profile.framesize / 4);
	Enhancer.db.profile.belowFont = CreateFont("EnhancerBelowFont");
	Enhancer.db.profile.belowFont:SetFont(Enhancer.db.profile.belowFontName, Enhancer.db.profile.belowFontSize, Enhancer.db.profile.belowFontFlags);
	
	for _, frame in ipairs(Enhancer.aFrames) do
		self[frame].textbelow:SetHeight(Enhancer.db.profile.belowFontSize + 10);
	end
end

function Enhancer:FormatTime(seconds)
	seconds = seconds;
	seconds = floor(seconds);
	secs = mod(seconds, 60);
	mins = (seconds - secs) / 60;
	return mins..":"..string.sub("00"..secs, -2);
end

function Enhancer:Round(number, decimals)
  local multiplier = 10^(decimals or 0)
  return math.floor(number * multiplier + 0.5) / multiplier
end

function Enhancer:TestCastingTotem()
	local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
	Enhancer:CastingTotem("player", Enhancer.BS["Strength of Earth Totem"], L:GetReverseTranslation(1));
	Enhancer:CastingTotem("player", Enhancer.BS["Totem of Wrath"], L:GetReverseTranslation(1));
	Enhancer:CastingTotem("player", Enhancer.BS["Mana Spring Totem"], L:GetReverseTranslation(0));
	Enhancer:CastingTotem("player", Enhancer.BS["Windfury Totem"], L:GetReverseTranslation(1));
end

function Enhancer:EPValuesChanged()
	if (not Enhancer:HasModule("EP")) then return; end
	if (not Enhancer:IsModule("EP")) then return; end
	local EPModule = Enhancer:GetModule("EP");
	EPModule:ResetGemCache();
end