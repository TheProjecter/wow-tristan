EnhancerEShield = Enhancer:NewModule("EShield", "AceEvent-2.0");
EnhancerEShield.DefaultState = false;
Enhancer:SetModuleDefaultState("EShield", EnhancerEShield.DefaultState);
local FrameName = "eshield";
EnhancerEShield.SpellName = Enhancer.BS["Earth Shield"];
-- EnhancerEShield.SpellName = Enhancer.BS["Water Breathing"] -- Testing

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerEShield:GetConsoleOptions()
	return L["eshield_cmd"], L["eshield_desc"];
end

function EnhancerEShield:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Nature_SkinofEarth", 0, 210);
	Enhancer[FrameName].borderColor = { ["r"] = (139/255), ["g"] = (69/255), ["b"] = (19/255), ["a"] = 1, };
	Enhancer:AddFrameToList(FrameName, true, false, false) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer[FrameName].moveName = "EShield";
	
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
	self:ScheduleEvent("DelayManualScan", self.ManualScan, 5, self)
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

function EnhancerEShield:ManualScan(announceLost, origin)
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
		Enhancer:ScreenMessage(L["Lost track of Earth Shield"]);
		if (Enhancer.debug and origin) then
			self:Print("DEBUG: Origin = %s", origin);
		end
	end
	Enhancer:FrameDeathPreBegin(FrameName);
end

function EnhancerEShield:Create(unit, name)
	local buffIndex, applications, timeLeft = self:UnitHasBuff(unit, EnhancerEShield.SpellName);
	
	-- Just in case it hasn't appeared yet serverside or if it got insta-cancelled or something bugs out (the update will kill it anyway in 1 sec)
	if (not applications) then applications = 10; end
	if (not timeLeft) then timeLeft =  (10 * 60); end
	
	Enhancer[FrameName].active = true;
	Enhancer:SetFrameData(FrameName, "unit", unit)
	Enhancer:SetFrameData(FrameName, "name", name)
	Enhancer:SetFrameData(FrameName, "expires", (GetTime() + timeLeft))
	
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
	if (not UnitExists(unit)) then return nil; end
	
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
	if (not UnitExists(unit)) then return nil; end
	
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
	local name = Enhancer:GetFrameData(FrameName, "name");
	local unit = Enhancer:GetFrameData(FrameName, "unit");
	local expires = Enhancer:GetFrameData(FrameName, "expires");
	local warned = Enhancer:GetFrameData(FrameName, "warned");
	
	if (not name and not unit) then
		-- How did this happen? :o
		self:CancelAllScheduledEvents();
		self:ManualScan(true, "1");
		return;
	end
	
	if (not UnitExists(unit)) then
		-- Here we have trouble the unit does not exist (Disconnect / Left Party / unit changed by many swaps in raid or w/e etc)
		if (self:NameToUnit(Enhancer:GetFrameData(FrameName, "name"))) then
			-- Ok, unit changed so all is now fine (hopefully)
			unit = self:NameToUnit(Enhancer:GetFrameData(FrameName, "name"));
			Enhancer:SetFrameData(FrameName, "unit", unit);
		else
			-- Can't find name nor unit so we lost track of our buff
			self:CancelAllScheduledEvents();
			self:ManualScan(true, "2");
			return;
		end
	end
	
	if (expires and GetTime() > expires) then
		-- Time ran out
		Enhancer:ScreenMessage(L["Earth Shield has expired"]);
		Enhancer:FrameDeathPreBegin(FrameName);
		self:CancelAllScheduledEvents();
		return;
	end
	
	local buffIndex, applications, timeLeft = self:UnitHasBuff(unit, EnhancerEShield.SpellName);
	if (buffIndex and timeLeft) then
		Enhancer:SetFrameData(FrameName, "expires", (GetTime() + timeLeft))
	elseif (buffIndex and not timeLeft) then
		-- Problem is if he is out of range (HS:ed to shattrath to get his resistance gear or w/e)
		if (CheckInteractDistance(unit, 4)) then
			-- This guy is in definately in range so it's definately not our buff, possibly someone over-wrote it
			self:CancelAllScheduledEvents();
			self:ManualScan(true, "3");
			return;
		else
			-- Dunno if it is ours or not as there could be to much distance from the unit atm, assume it's ours and keep checking
			timeLeft = Enhancer:GetFrameData(FrameName, "expires", 0) - GetTime();
		end
	end
	
	if (not buffIndex) then
		-- This one has probably used up it's charges
		Enhancer:ScreenMessage(L["Earth Shield has expired"]);
		Enhancer:FrameDeathPreBegin(FrameName);
		self:CancelAllScheduledEvents();
		return;
	end
	
	if (timeLeft <= 10 and not warned) then
		Enhancer:ScreenMessage(L["Earth Shield is about to expire"]);
		Enhancer:SetFrameData(FrameName, "warned", true)
	elseif (timeLeft > 10 and warned) then
		Enhancer:SetFrameData(FrameName, "warned", nil)
	end
	
	Enhancer[FrameName].textbelow:SetText( Enhancer:GetFrameData(FrameName, "name") .. "\r"  .. Enhancer:FormatTime( timeLeft ) );
	Enhancer[FrameName].textcenter:SetText( applications );
end