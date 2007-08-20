EnhancerInvigorated = Enhancer:NewModule("Invigorated", "AceEvent-2.0");
Enhancer:SetModuleDefaultState("Invigorated", false);

function EnhancerInvigorated:OnInitialize()
	
end

function EnhancerInvigorated:OnEnable()
	Enhancer:ShowFrame("invigorated");
	self:RegisterEvent("SpecialEvents_PlayerBuffGained", "PlayerBuffGained")
	self:RegisterEvent("SpecialEvents_PlayerBuffLost", "PlayerBuffLost")
end

function EnhancerInvigorated:OnDisable()
	Enhancer:HideFrame("invigorated");
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