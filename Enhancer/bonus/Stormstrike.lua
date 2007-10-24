EnhancerStormstrike = Enhancer:NewModule("Stormstrike", "AceEvent-2.0", "Parser-3.0");
Enhancer:SetModuleDefaultState("Stormstrike", true);
local FrameName = "stormstrike";

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerStormstrike:GetConsoleOptions()
	return L["stormstrike_cmd"], L["stormstrike_desc"];
end

function EnhancerStormstrike:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Holy_SealOfMight", 0, 0);
	Enhancer[FrameName].fullicon = true;
	Enhancer[FrameName].mainframe.bgFileDefault  = [[Interface\AddOns\Enhancer\texture\EnhancerSSWF]];
	Enhancer[FrameName].borderColor = Enhancer.colors.air.dec;
	Enhancer:AddFrameToList(FrameName, true, false, false) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer[FrameName].moveName = "SS CD";
	Enhancer:SetBackdropColor(FrameName, (5 / 10), 1, (5 / 10));
	Enhancer:ChangeIcon(FrameName, [[Interface\AddOns\Enhancer\texture\EnhancerSSWF]]);
	-- 
end

function EnhancerStormstrike:OnEnable()
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
	
	-- Same as Windfury module!
	-- {"Damage", "Miss", "Parry", "Dodge", "Resist", "Absorb", "Block", "Evade", "Immune"}
	for _, event in ipairs({"Damage", "Miss"}) do
		self:RegisterParserEvent({eventType = event, sourceID = "player"}, "ParserInfo");
	end
	
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "Stormstrike");
	self:StormstrikeCheck();
end

function EnhancerStormstrike:OnDisable()
	Enhancer:HideFrame(FrameName);
	
	self:UnregisterAllParserEvents();
	self:CancelAllScheduledEvents();
end

function EnhancerStormstrike:Stormstrike(unit, spell, rank)
	if (spell == Enhancer.BS["Stormstrike"]) then
		
		-- Stormstrike cast
		local start, duration = GetSpellCooldown(Enhancer.BS["Stormstrike"]);
		Enhancer[FrameName].cooldown:SetCooldown(start, duration);
		Enhancer[FrameName].active = true;
		Enhancer:UpdateAlphaBegin(FrameName);
		
		if (not (self:IsEventScheduled("StormstrikeCheck"))) then
			self:ScheduleRepeatingEvent("StormstrikeCheck", self.StormstrikeCheck, (2 / 10), self);
		end
	end
end

function EnhancerStormstrike:StormstrikeCheck()
	local start, duration = GetSpellCooldown(Enhancer.BS["Stormstrike"]);
	if (not tonumber(start)) then return; end
	if (not tonumber(duration)) then return; end
	local cd = ceil(start + duration - GetTime());
	
	if (cd > 0) then
		Enhancer[FrameName].textcenter:SetText(cd);
	else
		Enhancer:FrameDeathPreBegin(FrameName);
		Enhancer:UpdateAlphaBegin(FrameName);
		if (self:IsEventScheduled("StormstrikeCheck")) then
			self:CancelScheduledEvent("StormstrikeCheck");
		end
	end
end

function EnhancerStormstrike:ParserInfo(info)
	if ( info.abilityName == Enhancer.BS["Windfury Attack"] and info.sourceID == "player" ) then
		self:WindfuryHit();
	end
end

function EnhancerStormstrike:WindfuryHit()
	local diff = Enhancer[FrameName].cooldownstart and (GetTime() - Enhancer[FrameName].cooldownstart);
	if (diff and diff < 1) then return; end -- Second WF shouldn't reset the timer
	
	Enhancer:SetBackdropColor(FrameName, 1, (5 / 10), (5 / 10));
	Enhancer[FrameName].cooldownstart = GetTime();
	Enhancer[FrameName].cooldownend = GetTime() + 3;
	Enhancer:UpdateAlphaBegin(FrameName);
	
	if ( not (self:IsEventScheduled("WindfuryCooldownNumber")) ) then
		self:ScheduleRepeatingEvent("WindfuryCooldownNumber", self.WindfuryCooldownNumber, (1 / 2), self)
	end
end

function EnhancerStormstrike:WindfuryCooldownNumber()
	local cdstart = Enhancer[FrameName].cooldownstart;
	local cdend = Enhancer[FrameName].cooldownend;
	local cd = ceil(cdend - GetTime())
	
	if (cd <= 0) then
		Enhancer[FrameName].cooldownstart = nil;
		Enhancer:SetBackdropColor(FrameName, (5 / 10), 1, (5 / 10));
		if (self:IsEventScheduled("WindfuryCooldownNumber")) then
			self:CancelScheduledEvent("WindfuryCooldownNumber")
		end
	end
end