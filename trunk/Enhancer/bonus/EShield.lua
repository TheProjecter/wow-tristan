EnhancerEShield = Enhancer:NewModule("EShield", "AceEvent-2.0");
Enhancer:SetModuleDefaultState("EShield", false);
local FrameName = "eshield";
EnhancerEShield.SpellName = Enhancer.BS["Earth Shield"];
-- EnhancerEShield.SpellName = Enhancer.BS["Water Breathing"] -- Testing

local SEA = AceLibrary("SpecialEvents-Aura-2.0");

local L = AceLibrary("AceLocale-2.2"):new("EnhancerEShield")
L:RegisterTranslations("enUS", function() return {
	["cmd"] = "EarthShield",
	["desc"] = "Toggle frame for showing earth shield",
	
	["Lost track of Earth Shield"] = true,
	["Earth Shield has expired"] = true,
	["Earth Shield is about to expire"] = true,
}; end );
function EnhancerEShield:GetConsoleOptions()
	return L["cmd"], L["desc"];
end

function EnhancerEShield:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Nature_SkinofEarth", 0, 210);
	Enhancer[FrameName].borderColor = { ["r"] = (139/255), ["g"] = (69/255), ["b"] = (19/255), ["a"] = 1, };
	Enhancer:AddFrameToList(FrameName, true, false, false) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	
	--[[ Change the height so we can fit two rows ]]--
	Enhancer[FrameName].textbelow:SetHeight((Enhancer.db.profile.belowFontSize * 2) + 20);
end

function EnhancerEShield:OnEnable()
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
	
	self:RegisterEvent("UNIT_SPELLCAST_SENT", "SpellCastSent");
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "SpellCastSucceeded");
	
	-- self:RegisterEvent("UNIT_AURA", "AuraChange");
	
	self:RegisterEvent("PARTY_LEADER_CHANGED", "ManualScan");
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", "ManualScan");
	self:RegisterEvent("RAID_ROSTER_UPDATE", "ManualScan");
	self:ManualScan();
end

function EnhancerEShield:OnDisable()
	Enhancer:HideFrame(FrameName);
	
	self:UnregisterAllEvents();
	self:CancelAllScheduledEvents();
end

function EnhancerEShield:AuraChange(unit)
	-- self.UpdateCount = true;
end

function EnhancerEShield:NameToUnit(name)
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

function EnhancerEShield:SpellCastSent(unit, spell, rank, target)
	if (unit ~= "player") then return; end
	
	if (spell == EnhancerEShield.SpellName and self:NameToUnit(target)) then
		self.EShieldUnit = self:NameToUnit(target);
		self.EShieldName = target;
	end
end

function EnhancerEShield:SpellCastSucceeded(unit, spell, rank)
	if (spell == EnhancerEShield.SpellName and self.EShieldUnit) then
		local unit = self.EShieldUnit;
		local name = self.EShieldName;
		self.EShieldUnit = nil;
		self.EShieldName = nil;
		self:Create(unit, name);
	elseif (spell == EnhancerEShield.SpellName) then
		self:ManualScan();
	end
end

function EnhancerEShield:ManualScan(announceLost)
	if (Enhancer[FrameName].active) then return; end
	
	-- First we try to find a person with the buff! (Disconnects and/or leaving and rejoining group can cause this)
	local unit, name = "player", UnitName("player");
	local buffIndex, applications, timeLeft = self:UnitHasBuffNoCache(unit, EnhancerEShield.SpellName);
	
	if ( buffIndex and timeLeft ) then
		-- The buff exists (buffIndex) and it's ours (timeLeft)
		self:Create(unit, name);
		return;
	elseif (UnitInRaid("player")) then
		for i = 1, 40 do
			if (UnitExists("raid"..i)) then
				unit, name = "raid"..i, UnitName("raid"..i);
				buffIndex, applications, timeLeft = self:UnitHasBuffNoCache(unit, EnhancerEShield.SpellName)
				if ( buffIndex and timeLeft ) then
					self:Create(unit, name);
					return;
				end
			end
		end
	else
		for i = 1, 5 do
			if (UnitExists("party"..i)) then
				unit, name = "party"..i, UnitName("party"..i);
				buffIndex, applications, timeLeft = self:UnitHasBuffNoCache(unit, EnhancerEShield.SpellName)
				if ( buffIndex and timeLeft ) then
					self:Create(unit, name);
					return;
				end
			end
		end
	end
	
	if (announceLost) then
		Enhancer:FrameDeathPreBegin(FrameName);
		Enhancer:ScreenMessage(L["Lost track of Earth Shield"]);
	end
end

function EnhancerEShield:Create(unit, name)
	local buffIndex, applications, timeLeft = self:UnitHasBuff(unit, EnhancerEShield.SpellName);
	
	-- Just in case it hasn't appeared yet serverside or if it got insta-cancelled or something bugs out (the update will kill it anyway in 1 sec)
	if (not applications) then applications = 10; end
	if (not timeLeft) then timeLeft =  (10 * 60); end
	
	Enhancer[FrameName].active = true;
	Enhancer[FrameName].unit = unit;
	Enhancer[FrameName].name = name;
	Enhancer[FrameName].expires = GetTime() + timeLeft;
	Enhancer[FrameName].textbelow:SetText( name .. "\r" .. Enhancer:FormatTime( timeLeft ) );
	Enhancer[FrameName].textcenter:SetText( applications );
	Enhancer:UpdateAlphaBegin(FrameName);
	self:ScheduleRepeatingEvent("UpdateEShield", self.UpdateEShield, 1, self);
end

function EnhancerEShield:SpellCastFailed()
	self.EShieldUnit = nil;
	self.EShieldName = nil;
end

function EnhancerEShield:UnitHasBuff(unit, name)
	local applications, timeLeft;
	
	if (self.BuffIndexCache) then
		if (name == UnitBuff(unit,self.BuffIndexCache)) then
			_, _, _, applications, _, timeLeft = UnitBuff(unit,self.BuffIndexCache);
		else
			self.BuffIndexCache = nil;
		end
	end
	
	if (not self.BuffIndexCache) then
		local buffIndex = 1;
		while (UnitBuff(unit, buffIndex) ~= nil) do
			if ( name == UnitBuff(unit, buffIndex)) then
				self.BuffIndexCache = buffIndex;
				_, _, _, applications, _, timeLeft = UnitBuff(unit, buffIndex);
				break;
			end
			buffIndex = buffIndex + 1;
		end
	end
	
	return self.BuffIndexCache, applications, timeLeft;
end

function EnhancerEShield:UnitHasBuffNoCache(unit, name)
	local applications, timeLeft, buffIndex;
	
	local buffIndex = 1;
	while (UnitBuff(unit, buffIndex) ~= nil) do
		if ( name == UnitBuff(unit, buffIndex)) then
			_, _, _, applications, _, timeLeft = UnitBuff(unit, buffIndex);
			break;
		end
		buffIndex = buffIndex + 1;
	end
	
	return buffIndex, applications, timeLeft;
end

function EnhancerEShield:UpdateEShield()
	if (GetTime() > Enhancer[FrameName].expires) then
		-- Time ran out
		Enhancer:ScreenMessage(L["Earth Shield has expired"]);
		Enhancer:FrameDeathPreBegin(FrameName);
		self:CancelAllScheduledEvents();
		return;
	end
	
	if (Enhancer[FrameName].name ~= UnitName(Enhancer[FrameName].unit)) then
		-- Unit changed try to find it or rescan
		Enhancer[FrameName].unit = self:NameToUnit(Enhancer[FrameName].name);
		
		if (not Enhancer[FrameName].unit) then
			self:CancelAllScheduledEvents();
			self:ManualScan(true);
			return;
		end
	end
	
	local buffIndex, applications, timeLeft = self:UnitHasBuff(Enhancer[FrameName].unit, EnhancerEShield.SpellName);
	if (buffIndex and not timeLeft) then
		-- Not our buff possibly someone over-wrote it
		self:CancelAllScheduledEvents();
		self:ManualScan(true);
		return;
	end
	
	if (not buffIndex) then
		-- This one has used up it's charges probably
		Enhancer:ScreenMessage(L["Earth Shield has expired"]);
		Enhancer:FrameDeathPreBegin(FrameName);
		self:CancelAllScheduledEvents();
		return;
	end
	
	if (GetTime() > (Enhancer[FrameName].expires - 10) and not Enhancer[FrameName].temp) then
		Enhancer:ScreenMessage(L["Earth Shield is about to expire"]);
		Enhancer[FrameName].temp = true;
	end
	
	Enhancer[FrameName].expires = GetTime() + timeLeft;
	Enhancer[FrameName].textbelow:SetText( Enhancer[FrameName].name .. "\r"  .. Enhancer:FormatTime( timeLeft ) );
	Enhancer[FrameName].textcenter:SetText( applications );
end