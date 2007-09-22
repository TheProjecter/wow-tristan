EnhancerWindfury = Enhancer:NewModule("Windfury", "AceEvent-2.0", "Parser-3.0");
EnhancerWindfury.DefaultState = true;
Enhancer:SetModuleDefaultState("Windfury", EnhancerWindfury.DefaultState);
local FrameName = "windfury";

function EnhancerWindfury:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Nature_Cyclone", 0, -25);
	Enhancer[FrameName].borderColor = { ["r"] = (127/255), ["g"] = (255/255), ["b"] = (212/255), ["a"] = 1, }
	Enhancer:AddFrameToList(FrameName, true, false, false) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer[FrameName].moveName = "WF CD";
end

function EnhancerWindfury:OnEnable()
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
	
	self:RegisterParserEvent({
		eventType = 'Damage',
	}, "ParserDamage");
	
	-- SPELL_UPDATE_COOLDOWN
end

function EnhancerWindfury:OnDisable()
	Enhancer:HideFrame(FrameName);
	
	self:UnregisterAllParserEvents();
	self:CancelAllScheduledEvents();
end

function EnhancerWindfury:ParserDamage(info)
	-- Doubt we want both tbh
	if ( (info.abilityName == Enhancer.BS["Windfury"] or info.abilityName == Enhancer.BS["Windfury Attack"]) and info.sourceID == "player" ) then
		self:WindfuryHit();
	end
end

 -- GetSpellCooldown(spellID, BOOKTYPE_SPELL);

function EnhancerWindfury:WindfuryHit()
	if (Enhancer[FrameName].active) then return; end -- Second WF shouldn't reset the timer ;)
	
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