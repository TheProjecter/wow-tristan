EnhancerInvigorated = Enhancer:NewModule("Invigorated", "AceEvent-2.0");
EnhancerInvigorated.DefaultState = false;
Enhancer:SetModuleDefaultState("Invigorated", EnhancerInvigorated.DefaultState);
local FrameName = "invigorated";

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerInvigorated:GetConsoleOptions()
	return L["invigorated_cmd"], L["invigorated_desc"];
end

function EnhancerInvigorated:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Nature_NatureResistanceTotem", 0, 210);
	Enhancer:AddFrameToList(FrameName, true, false, true) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer:AddFrameToOnOffList(FrameName)
	Enhancer[FrameName].moveName = "Invig";
end

function EnhancerInvigorated:OnEnable()
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
	
	self:RegisterEvent("SpecialEvents_PlayerBuffGained", "PlayerBuffGained")
	self:RegisterEvent("SpecialEvents_PlayerBuffLost", "PlayerBuffLost")
end

function EnhancerInvigorated:OnDisable()
	Enhancer:HideFrame(FrameName);
	
	self:UnregisterAllEvents();
end

function EnhancerInvigorated:PlayerBuffGained(buffName, buffIndex, applications, texture, rank, index)
	if (buffName == L["Invigorated"]) then
		Enhancer[FrameName].active = true;
		Enhancer[FrameName].cooldown:SetCooldown(GetTime(), 15);
		Enhancer:UpdateAlphaBegin(FrameName);
	end
end

function EnhancerInvigorated:PlayerBuffLost(buffName, applications, texture, rank)
	if (buffName == L["Invigorated"]) then
		Enhancer:FrameDeathPreBegin(FrameName);
	end
end