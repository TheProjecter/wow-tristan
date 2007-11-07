EnhancerWindfury = Enhancer:NewModule("Windfury", "AceEvent-2.0", "Parser-3.0");
Enhancer:SetModuleDefaultState("Windfury", true);
local FrameName = "windfury";

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerWindfury:GetConsoleOptions()
	return L["windfury_cmd"], L["windfury_desc"];
end

function EnhancerWindfury:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Nature_Cyclone", 0, -25);
	Enhancer[FrameName].borderColor = Enhancer.colors.air.dec;
	Enhancer:AddFrameToList(FrameName, true, false, false) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer[FrameName].moveName = "WF CD";
	Enhancer:SetBackdropColor(FrameName, (5 / 10), 1, (5 / 10));
end

function EnhancerWindfury:OnEnable()
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
	
	for _, event in ipairs(Enhancer.wfParserTypes) do
		self:RegisterParserEvent({eventType = event, sourceID = "player"}, "ParserInfo");
	end
	
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "Stormstrike");
	self:StormstrikeCheck();
end

function EnhancerWindfury:OnDisable()
	Enhancer:HideFrame(FrameName);
	
	self:UnregisterAllParserEvents();
	self:CancelAllScheduledEvents();
end

function EnhancerWindfury:Stormstrike(unit, spell, rank)
	if (spell == Enhancer.BS["Stormstrike"]) then
		if (not (self:IsEventScheduled("StormstrikeCheck"))) then
			self:ScheduleRepeatingEvent("StormstrikeCheck", self.StormstrikeCheck, (2 / 10), self);
		end
	end
end

function EnhancerWindfury:StormstrikeCheck()
	local start, duration = GetSpellCooldown(Enhancer.BS["Stormstrike"]);
	
	if (start and ((start > 0 and duration > 2) or self:IsEventScheduled("WindfuryCooldownNumber"))) then
		Enhancer:SetBackdropColor(FrameName, 1, (5 / 10), (5 / 10));
		Enhancer:UpdateAlphaBegin(FrameName);
	else
		Enhancer:SetBackdropColor(FrameName, (5 / 10), 1, (5 / 10));
		Enhancer:UpdateAlphaBegin(FrameName);
		if (self:IsEventScheduled("StormstrikeCheck")) then
			self:CancelScheduledEvent("StormstrikeCheck");
		end
	end
end

function EnhancerWindfury:ParserInfo(info)
	if ( info.abilityName == Enhancer.BS["Windfury Attack"] and info.sourceID == "player" ) then
		self:WindfuryHit();
	end
end

function EnhancerWindfury:WindfuryHit()
	local diff = Enhancer[FrameName].cooldownstart and (GetTime() - Enhancer[FrameName].cooldownstart);
	if (diff and diff < 1) then return; end -- Second WF shouldn't reset the timer ;) But it's not always 2 since the mob can die by the first for example
	
	if (diff and diff < 3) then
		if (Enhancer.debug) then Enhancer:Print("WF re-proc with only " .. diff .. " seconds in between!"); end
	end
	
	Enhancer[FrameName].active = true;
	Enhancer[FrameName].cooldownstart = GetTime();
	Enhancer[FrameName].cooldownend = GetTime() + 3;
	
	Enhancer[FrameName].cooldown:SetCooldown(Enhancer[FrameName].cooldownstart, 3);
	Enhancer:UpdateAlphaBegin(FrameName);
	self:WindfuryCooldownNumber();
	
	if ( not (self:IsEventScheduled("WindfuryCooldownNumber")) ) then
		self:ScheduleRepeatingEvent("WindfuryCooldownNumber", self.WindfuryCooldownNumber, (1 / 2), self)
	end
end

function EnhancerWindfury:WindfuryCooldownNumber()
	local cdstart = Enhancer[FrameName].cooldownstart;
	local cdend = Enhancer[FrameName].cooldownend;
	local cd = ceil(cdend - GetTime())
	
	if (cd <= 0) then
		Enhancer[FrameName].textcenter:SetText("");
		if (self:IsEventScheduled("WindfuryCooldownNumber")) then
			self:CancelScheduledEvent("WindfuryCooldownNumber")
		end
		
		Enhancer:FrameDeathPreBegin(FrameName);
	else
		Enhancer[FrameName].textcenter:SetText(cd);
	end
end