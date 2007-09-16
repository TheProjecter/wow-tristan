EnhancerWindfuryTotem = Enhancer:NewModule("WindfuryTotem", "AceEvent-2.0", "Parser-3.0");
EnhancerWindfuryTotem.DefaultState = false;
Enhancer:SetModuleDefaultState("WindfuryTotem", EnhancerWindfuryTotem.DefaultState);
local FrameName = "windfurytotem";

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerWindfuryTotem:GetConsoleOptions()
	return L["windfurytotem_cmd"], L["windfurytotem_desc"];
end

function EnhancerWindfuryTotem:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Nature_Windfury", -205, -205);
	Enhancer[FrameName].borderColor = { ["r"] = (127/255), ["g"] = (255/255), ["b"] = (212/255), ["a"] = 1, }
	Enhancer:AddFrameToList(FrameName, true, false, false) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer:AddFrameToOnOffList(FrameName);
	Enhancer[FrameName].moveName = "Weave";
end

function EnhancerWindfuryTotem:OnEnable()
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
	
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "CastingTotem");
end

function EnhancerWindfuryTotem:OnDisable()
	Enhancer:HideFrame(FrameName);
	
	self:UnregisterAllParserEvents();
	self:CancelAllScheduledEvents();
end

function EnhancerWindfuryTotem:CastingTotem(unit, totem, rank)
	if (unit ~= "player") then return; end
	
	if (totem == Enhancer.BS["Windfury Totem"]) then
		Enhancer[FrameName].active = true;
		Enhancer[FrameName].cooldownstart = GetTime();
		Enhancer[FrameName].cooldownend = GetTime() + 9;
		
		Enhancer[FrameName].cooldown:SetCooldown(Enhancer[FrameName].cooldownstart, 9);
		Enhancer:UpdateAlphaBegin(FrameName);
		
		if ( not (self:IsEventScheduled("WindfuryTotemCooldownNumber")) ) then
			self:ScheduleRepeatingEvent("WindfuryTotemCooldownNumber", self.WindfuryTotemCooldownNumber, (1 / 2), self)
		end
	end
end

function EnhancerWindfuryTotem:WindfuryTotemCooldownNumber()
	local cdstart = Enhancer[FrameName].cooldownstart;
	local cdend = Enhancer[FrameName].cooldownend;
	local cd = ceil(cdend - GetTime())
	
	if (cd <= 0) then
		Enhancer[FrameName].textcenter:SetText("");
		if (self:IsEventScheduled("WindfuryTotemCooldownNumber")) then
			self:CancelScheduledEvent("WindfuryTotemCooldownNumber")
		end
		
		Enhancer:FrameDeathPreBegin(FrameName);
	else
		Enhancer[FrameName].textcenter:SetText(cd);
	end
end