EnhancerHWay = Enhancer:NewModule("HWay", "AceEvent-2.0");
EnhancerHWay.DefaultState = false;
Enhancer:SetModuleDefaultState("HWay", EnhancerHWay.DefaultState);
EnhancerHWay.SpellName = Enhancer.BS["Healing Way"];

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerHWay:GetConsoleOptions()
	return L["hway_cmd"], L["hway_desc"];
end

function EnhancerHWay:OnInitialize()
	
end

function EnhancerHWay:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS", "PeriodicBuff");
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS", "PeriodicBuff");
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS", "PeriodicBuff");
	
	-- self:ScheduleEvent("DelayManualScan", self.ManualScan, 5, self)
	
	Enhancer:Print("Healing Way Enabled");
end

function EnhancerHWay:OnDisable()
	self:UnregisterAllEvents();
	self:CancelAllScheduledEvents();
end

function EnhancerHWay:NameToUnit(name)
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

function EnhancerHWay:PeriodicBuff(info)
	local unit, what, count;
	if (string.find(info, L["hway_yougain"]) and string.find(info, self.SpellName)) then
		unit = "player";
		
	  what, count = Enhancer.deformat(info, AURAAPPLICATIONADDEDSELFHELPFUL);
	  if (not what) then
			what = Enhancer.deformat(info, AURAADDEDSELFHELPFUL);
			count = 1;
		end
	elseif (string.find(info, self.SpellName)) then
		local who;
		who, what, count = Enhancer.deformat(info, AURAAPPLICATIONADDEDOTHERHELPFUL);
		if (not who) then
			who, what = Enhancer.deformat(info, AURAADDEDOTHERHELPFUL);
			count = 1;
		end
		
		unit = self:NameToUnit(who);
	end
	
	if (unit and what and count) then
	  self:Debug(UnitName(unit), "gained", what, ", count:", count, " - ", (what == self.SpellName));
	end
end

function EnhancerHWay:Debug(...)
	if (Enhancer.debug) then
		Enhancer:Print(...);
	end
end