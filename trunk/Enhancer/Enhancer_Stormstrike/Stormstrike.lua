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
	Enhancer:UpdateAlphaBegin(FrameName);
	Enhancer:ChangeIcon(FrameName, [[Interface\AddOns\Enhancer\texture\EnhancerSSWF]]);
	Enhancer:AddFrameToOnOffList(FrameName)
end

function EnhancerStormstrike:OnEnable()
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
	
	for _, event in ipairs(Enhancer.wfParserTypes) do
		self:RegisterParserEvent({eventType = event, sourceID = "player"}, "ParserInfo");
	end
	
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "Stormstrike");
	self:StormstrikeCooldown();
end

function EnhancerStormstrike:OnDisable()
	Enhancer:HideFrame(FrameName);
	
	self:UnregisterAllParserEvents();
	self:CancelAllScheduledEvents();
end

function EnhancerStormstrike:FrameActive(key, state)
	if (key) then
		Enhancer:SetFrameData(FrameName, key, state);
	end
	
	if (Enhancer:GetFrameData(FrameName, "SS Active") or Enhancer:GetFrameData(FrameName, "WF Active")) then
		Enhancer[FrameName].active = true;
	elseif (Enhancer[FrameName].active) then
		Enhancer:FrameDeathPreBegin(FrameName);
		return;
	end
	
	Enhancer:UpdateAlphaBegin(FrameName);
end

function EnhancerStormstrike:Stormstrike(unit, spell, rank)
	if (spell == Enhancer.BS["Stormstrike"]) then
		
		Enhancer:ClearFrameData(FrameName);
		Enhancer:SetFrameData(FrameName, "Do Cooldown", true);
		self:FrameActive("SS Active", true);
		
		if (not (self:IsEventScheduled("StormstrikeCooldown"))) then
			self:ScheduleRepeatingEvent("StormstrikeCooldown", self.StormstrikeCooldown, (2 / 10), self);
		end
	end
end

function EnhancerStormstrike:StormstrikeCooldown()
	local start, duration = GetSpellCooldown(Enhancer.BS["Stormstrike"]);
	if (not tonumber(start)) then return; end
	if (not tonumber(duration)) then return; end
	local cd = ceil(start + duration - GetTime());
	
	if (cd > 0) then
		Enhancer[FrameName].textcenter:SetText(cd);
		
		if (Enhancer:GetFrameData(FrameName, "Do Cooldown")) then
			Enhancer[FrameName].cooldown:SetCooldown(GetTime(), cd);
			Enhancer:SetFrameData(FrameName, "Do Cooldown", nil);
		end
	else
		self:FrameActive("SS Active", nil);
		if (self:IsEventScheduled("StormstrikeCooldown")) then
			self:CancelScheduledEvent("StormstrikeCooldown");
		end
	end
end

function EnhancerStormstrike:ParserInfo(info)
	if ( info.abilityName == Enhancer.BS["Windfury Attack"] and info.sourceID == "player" ) then
		self:WindfuryStart();
	end
end

function EnhancerStormstrike:WindfuryStart()
	local diff = Enhancer[FrameName].cooldownstart and (GetTime() - Enhancer[FrameName].cooldownstart);
	if (diff and diff < 1) then return; end -- Second WF shouldn't reset the timer
	
	Enhancer[FrameName].cooldownstart = GetTime();
	Enhancer[FrameName].cooldownend = GetTime() + 3;
	self:FrameActive("WF Active", true);
	
	if ( not (self:IsEventScheduled("WindfuryCooldown")) ) then
		self:ScheduleRepeatingEvent("WindfuryCooldown", self.WindfuryCooldown, (1 / 2), self)
	end
	
	EnhancerStormstrike:WindfuryCooldown()
end

function EnhancerStormstrike:WindfuryCooldown()
	local cdstart = Enhancer[FrameName].cooldownstart;
	local cdend = Enhancer[FrameName].cooldownend;
	local cd = ceil(cdend - GetTime())
	
	if (cd <= 0) then
		Enhancer[FrameName].cooldownstart = nil;
		self:FrameActive("WF Active", nil);
		if (self:IsEventScheduled("WindfuryCooldown")) then
			self:CancelScheduledEvent("WindfuryCooldown")
		end
	end
	
	if ((cd <= 0) or (cd > 2)) then
		Enhancer:SetBackdropColor(FrameName, (5 / 10), 1, (5 / 10));
	elseif (cd) then
		Enhancer:SetBackdropColor(FrameName, 1, (5 / 10), (5 / 10));
	end
	Enhancer:UpdateAlphaBegin(FrameName);
end