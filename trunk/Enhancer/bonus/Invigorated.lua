EnhancerInvigorated = Enhancer:NewModule("Invigorated", "AceEvent-2.0");
Enhancer:SetModuleDefaultState("Invigorated", false);
local FrameName = "invigorated";

function EnhancerInvigorated:OnInitialize()
	Enhancer.invigorated = Enhancer:CreateButton("EnhancerFrameInvigorated", "Spell_Nature_NatureResistanceTotem", 0, 170);
	Enhancer.invigorated.borderColor = { ["r"] = (0/255), ["g"] = (245/255), ["b"] = (255/255), ["a"] = 1, }
	Enhancer:AddFrameToList(FrameName, true, false, true) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
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
	if (buffName == "Invigorated") then
		Enhancer.invigorated.active = true;
		Enhancer:UpdateAlphaBegin("invigorated");
	end
end

function EnhancerInvigorated:PlayerBuffLost(buffName, applications, texture, rank)
	if (buffName == "Invigorated") then
		Enhancer.invigorated.active = false;
		Enhancer:UpdateAlphaBegin("invigorated");
	end
end