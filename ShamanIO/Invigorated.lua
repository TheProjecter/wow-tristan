EnhancerInvigorated = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0");

function EnhancerInvigorated:OnInitialize()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
end

function EnhancerInvigorated:OnEnable()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
	if (not Enhancer.db.profile.Invigorated) then return; end
	self.enabled = true;
	
	Enhancer:ShowFrame("invigorated");
	self:RegisterEvent("SpecialEvents_PlayerBuffGained", "PlayerBuffGained")
	self:RegisterEvent("SpecialEvents_PlayerBuffLost", "PlayerBuffLost")
end

function EnhancerInvigorated:OnDisable()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
	self.enabled = false;
	
	Enhancer:HideFrame("invigorated");
	self:UnregisterAllEvents();
end

function EnhancerInvigorated:Toggle()
	if (self.enabled) then
		Enhancer.db.profile.Invigorated = false;
		self:OnDisable();
	else
		Enhancer.db.profile.Invigorated = true;
		self:OnEnable();
	end
end

function EnhancerInvigorated:Active()
	return self.enabled;
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