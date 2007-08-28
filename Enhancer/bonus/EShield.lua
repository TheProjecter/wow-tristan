EnhancerEShield = Enhancer:NewModule("EShield", "AceEvent-2.0");
Enhancer:SetModuleDefaultState("EShield", false);
local FrameName = "eshield";
local SpellName = Enhancer.BS["Earth Shield"];
-- SpellName = Enhancer.BS["Lightning Shield"] -- Testing

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
end

function EnhancerEShield:OnEnable()
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
	
	self:RegisterEvent("UNIT_SPELLCAST_SENT", "SpellCastSent");
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "SpellCastSucceeded");
	-- self:RegisterEvent("UNIT_SPELLCAST_FAILED", "SpellCastFailed");
	-- self:RegisterEvent("UNIT_AURA", "AuraChange");
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
	-- if (name == "") then name = UnitName("player"); end -- ?Testing
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
	
	if (spell == SpellName and self:NameToUnit(target)) then
		self.EShieldUnit = self:NameToUnit(target);
		self.EShieldName = target;
	end
end

function EnhancerEShield:SpellCastSucceeded(unit, spell, rank)
	if (spell == SpellName and self.EShieldUnit) then
		local buffIndex, applications, timeLeft = self:UnitHasBuff(self.EShieldUnit, SpellName);
		Enhancer:Print(buffIndex, applications, timeLeft);
		
		-- Just in case it hasn't appeared yet serverside or if it got insta-cancelled the update will kill it anyway laters
		if (not applications) then applications = 10; end
		if (not timeLeft) then timeLeft =  (10 * 60); end
		
		Enhancer[FrameName].active = true;
		Enhancer[FrameName].unit = self.EShieldUnit;
		Enhancer[FrameName].name = self.EShieldName;
		Enhancer[FrameName].expires = GetTime() + timeLeft;
		Enhancer[FrameName].textbelow:SetText( Enhancer[FrameName].name .. Enhancer:FormatTime( timeLeft ) );
		Enhancer[FrameName].textcenter:SetText( applications );
		Enhancer:UpdateAlphaBegin(FrameName);
		self:ScheduleRepeatingEvent("UpdateEShield", self.UpdateEShield, 1, self);
		self.EShieldUnit = nil;
		self.EShieldName = nil;
	end
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
		Enhancer:Print(unit, buffIndex);
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

function EnhancerEShield:UpdateEShield()
	if (GetTime() > Enhancer[FrameName].expires) then
			Enhancer:ScreenMessage(L["Earth Shield has expired"]);
			Enhancer:FrameDeathPreBegin(FrameName);
			self:CancelAllScheduledEvents();
			return;
		end
	
	if (Enhancer[FrameName].name ~= UnitName(Enhancer[FrameName].unit)) then
		-- Units changed try find it
		Enhancer[FrameName].unit = self:NameToUnit(Enhancer[FrameName].name);
		
		if (not Enhancer[FrameName].unit) then
			Enhancer:ScreenMessage(L["Lost track of Earth Shield"]);
			Enhancer:FrameDeathPreBegin(FrameName);
			self:CancelAllScheduledEvents();
			return;
		end
	end
	
	local buffIndex, applications, timeLeft = self:UnitHasBuff(Enhancer[FrameName].unit, SpellName);
	if (buffIndex and not timeLeft) then
		-- Not our buff possibly someone over-wrote it
		Enhancer:ScreenMessage(L["Lost track of Earth Shield"]);
		Enhancer:FrameDeathPreBegin(FrameName);
		self:CancelAllScheduledEvents();
		return;
	end
	
	if (not buffIndex) then
		-- This one as used up it's charges
		Enhancer:FrameDeathPreBegin(FrameName);
		self:CancelAllScheduledEvents();
		return;
	end
	
	if (GetTime() > (Enhancer[FrameName].expires - 10)) then
		Enhancer:ScreenMessage(L["Earth Shield is about to expire"]);
	end
	
	Enhancer[FrameName].textbelow:SetText( Enhancer[FrameName].name .. Enhancer:FormatTime( timeLeft ) );
	Enhancer[FrameName].textcenter:SetText( applications );
	
	-- self.UpdateCount = nil;
end