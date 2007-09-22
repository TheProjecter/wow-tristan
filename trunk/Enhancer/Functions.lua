local L = AceLibrary("AceLocale-2.2"):new("Enhancer");

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

function Enhancer:CreateTotem(totem, rank, totemX, totemY, totemZone)
	if (type(rank) ~= "number") then
		if (tonumber(rank)) then
			rank = tonumber(rank);
		else
			self:Print("Big Error: Rank was not a number nor could it be converted. Please mail dennis.hafstrom@gmail.com with info about what did when the error occured and wheter you can recreate it or not");
			return;
		end
	end
	
	local Icon = Enhancer.Totems[totem].Icon;
	local TimeToLive = Enhancer.Totems[totem].Time or (Enhancer.Totems[totem][rank] and Enhancer.Totems[totem][rank].Time);
	local Element = Enhancer.Totems[totem].Element;
	local HitPoints = Enhancer.Totems[totem].Life or (Enhancer.Totems[totem][rank] and Enhancer.Totems[totem][rank].Life);
	local Pulse = Enhancer.Totems[totem].Pulse;
	local Range = Enhancer.Totems[totem].Range;
	if (Range and Enhancer.Totems[totem].TotemicMastery) then
		Range = Range + 10;
	end
	
	if (not Enhancer:IsModuleActive(Element)) then return; end
	
	local frame = string.lower(Element);
	for k, v in pairs(self.combatLog) do
		if (v == frame) then self.combatLog[k] = nil; end
	end
	
	local combatLogName = totem;
	--[[ Rank 1 Totems doesn't seem to get Roman Numbers applied to them in the combat log ]]--
	if (rank > 1) then combatLogName = combatLogName .. " " .. self.LR:R(rank); end
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
		--if (totem == Enhancer.BS["Tremor Totem"]) then
		--	self[frame].pulse = GetTime();
		--end
	else
		self[frame].pulse = nil
	end
	self[frame].lived = 0;
	self[frame].range = Range;
	
	self:ChangeIcon(frame, Icon);
	self[frame].mainframe:SetBackdropBorderColor((self[frame].borderColor and self[frame].borderColor["r"]) or 1, (self[frame].borderColor and self[frame].borderColor["g"]) or 1, (self[frame].borderColor and self[frame].borderColor["b"]) or 1, 0);
	self:UpdateAlphaBegin(frame)
	
	self:SetFrameData(frame, "ZoneX", totemX)
	self:SetFrameData(frame, "ZoneY", totemY)
	self:SetFrameData(frame, "Zone", totemZone)
	
	self[frame].textcenter:SetText(Pulse);
	self[frame].textbelow:SetText( Enhancer:FormatTime(self[frame].death - GetTime()) );
	if ( not (self:IsEventScheduled(frame)) ) then
		self:ScheduleRepeatingEvent(frame, self.UpdateFrame, (1 / 2), self, frame)
	end
end

function Enhancer:Message(message, r, g, b, a, h)
	Enhancer:Pour(message, r or 1, g or 1, b or 1, a or 1, h or 3);
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
	self:DefaultPos(framename);
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
			if (not self[framename].active) then
				self[framename].textbelow:SetText("");
				self[framename].textabove:SetText("");
			end
		else
			if (self[framename].mainframe:IsVisible()) then
				self[framename].anchor:Show();
				self[framename].unlocked = true;
				
				if (not self[framename].active) then
					self[framename].textbelow:SetText(self[framename].moveName or "");
				end
			end
		end
		
		self:UpdateAlphaBegin(framename);
	end
	
	self:ToggleLockForHooks();
end
function Enhancer:ToggleLockForHooks()
end

function Enhancer:Resize()
	for _, frame in ipairs(Enhancer.aFrames) do
		self[frame].mainframe:SetWidth(Enhancer.db.profile.framesize);
		self[frame].mainframe:SetHeight(Enhancer.db.profile.framesize);
		
		self[frame].anchor:SetWidth(Enhancer.db.profile.framesize);
		self[frame].anchor:SetHeight(Enhancer.db.profile.framesize);
		
		self[frame].anchortext:SetWidth(Enhancer.db.profile.framesize);
		self[frame].anchortext:SetHeight(Enhancer.db.profile.framesize);
		
		self[frame].cooldown:SetWidth(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / self[frame].cooldown.divider));
		self[frame].cooldown:SetHeight(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / self[frame].cooldown.divider));
		
		self[frame].textabove:SetWidth(Enhancer.db.profile.framesize * (15/10));
		self[frame].textcenter:SetHeight(Enhancer.db.profile.framesize);
		self[frame].textcenter:SetWidth(Enhancer.db.profile.framesize);
		self[frame].textbelow:SetWidth(Enhancer.db.profile.framesize * (15/10));
	end
end

function Enhancer:UpdateFont()
	for _, frame in ipairs(Enhancer.aFrames) do
		-- Adjust frames that needs adjusting
		self[frame].textabove:SetHeight(Enhancer.db.profile.aboveFontSize + 10);
		self[frame].textbelow:SetHeight(Enhancer.db.profile.belowFontSize + 10);
		
		-- Update fonts
		self[frame].textabove:SetFont(Enhancer.db.profile.aboveFontName, Enhancer.db.profile.aboveFontSize, Enhancer.db.profile.aboveFontFlags);
		self[frame].textcenter:SetFont(Enhancer.db.profile.centerFontName, Enhancer.db.profile.centerFontSize, Enhancer.db.profile.centerFontFlags);
		self[frame].textbelow:SetFont(Enhancer.db.profile.belowFontName, Enhancer.db.profile.belowFontSize, Enhancer.db.profile.belowFontFlags);
	end
end

function Enhancer:FormatTime(seconds)
	if (seconds < 0) then seconds = 0; end
	
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
	Enhancer:CastingTotem("player", Enhancer.BS["Strength of Earth Totem"], L[1]);
	Enhancer:CastingTotem("player", Enhancer.BS["Totem of Wrath"], L[1]);
	Enhancer:CastingTotem("player", Enhancer.BS["Mana Spring Totem"], L[0]);
	Enhancer:CastingTotem("player", Enhancer.BS["Windfury Totem"], L[1]);
end

function Enhancer:EPValuesChanged()
	if (not Enhancer:HasModule("EP")) then return; end
	if (not Enhancer:IsModule("EP")) then return; end
	local EPModule = Enhancer:GetModule("EP");
	EPModule:ResetGemCache();
end

function Enhancer:NameToUnit(name)
	if (not name) then return nil; end
	
	if (name == UnitName("player")) then
		return "player";
	elseif (UnitInRaid("player")) then
		for i = 1, 40 do
			if (UnitName("raid"..i) == name) then return "raid"..i; end
		end
	else
		for i = 1, 5 do
			if (UnitName("party"..i) == name) then return "party"..i; end
		end
	end
	return nil;
end

function Enhancer:CrazyShamanImport(data)
	-- Assume the data will look like this (to avoid locale errors with fraction separators):
	-- AP:10;STR:20;AGI:18;STA:0;CR:20;HR:14;HsR:15;RS:0;IA:10;
	
	local CrazyShamanLookup = {
		["AP"] = "ATTACKPOWER",
		["STR"] = "STR",
		["AGI"] = "AGI",
		["STA"] = "STA",
		["CR"] = "CR_CRIT",
		["HR"] = "CR_HIT",
		["HsR"] = "CR_HASTE",
		["RS"] = "CR_RESILIENCE",
		["IA"] = "IGNOREARMOR",
	};
	
	local standardizedData = {}
	local updateValid = false;
	for _, dataPart in ipairs( { strsplit(";", data) } ) do
		if (dataPart and dataPart ~= "") then
			local identifier, number = strsplit(":", dataPart);
			
			local value = number / 10;
			local key = CrazyShamanLookup[identifier];
			
			if (key) then
				standardizedData[key] = value;
				updateValid = true;
			end
		end
	end
	
	if (updateValid) then
		self:StandardAEPImport(standardizedData)
	end
end

function Enhancer:HasTalent(name)
	for tabIndex = 1, GetNumTalentTabs() do
		for talentIndex = 1, GetNumTalents(tabIndex) do
			nameTalent, _, _, _, currentRank, maxRank, _, _ = GetTalentInfo(tabIndex, talentIndex);
			
			if (nameTalent == name) then
				return (currentRank == maxRank), currentRank, maxRank;
			end
		end
	end
end

function Enhancer:TotemicMastery()
	local tabIndex = 3;
	local talentIndex = 8;
	local name;
	
	local findStr = "Restoration"; -- Make localized
	name = GetTalentTabInfo(tabIndex); -- name, iconTexture, pointsSpent, background = GetTalentTabInfo( tabIndex );
	if (name ~= findStr) then
	    for ix = 1, GetNumTalentTabs() do
	        name = GetTalentTabInfo(tabIndex);
	        if (name == findStr) then tabIndex = ix; break; end
					name = nil;
	    end
	    if (not name) then return; end
	end
	
	findStr = "Totemic Mastery"; -- Make localized
	name = GetTalentInfo(tabIndex, talentIndex);
	if (name ~= findStr) then
	    for ix = 1, GetNumTalents(tabIndex) do
	        name = GetTalentInfo(tabIndex, talentIndex);
	        if (name == findStr) then talentIndex = ix; break; end
					name = nil;
	    end
	    if (not name) then return; end
	end
	
	local tName, _, _, _, tRank, tMRank = GetTalentInfo(tabIndex, talentIndex); -- nameTalent, iconPath, tier, column, currentRank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(tabIndex, talentIndex);
	return (tRank == tMRank), tName;
end

function Enhancer:StandardAEPImport(standardizedData)
	local unused, changed = {}, {};
	
	for key, value in pairs(standardizedData) do
		if (self.db.profile.AEPNumbers[key]) then
			changed[key] = true;
			self.db.profile.AEPNumbers[key] = value;
		else
			tinsert(unused, key);
			--[[
			Not used for anything atm but this function should be very seldomly called so figure saving them
			for future eventuall use is of little to none harm.
			]]
		end
	end
	
	local userShouldCheck = nil;
	for key, _ in pairs(self.db.profile.AEPNumbers) do
		if (not changed[key]) then
			-- self.db.profile.AEPNumbers[key] = 0;
			
			if (userShouldCheck) then
				userShouldCheck = strjoin(", ", userShouldCheck, L[key]);
			else
				userShouldCheck = L[key];
			end
			
		end
	end
	
	if (userShouldCheck) then
		self:Print(string.format(L["aep_import_warning"], userShouldCheck));
	end
end