do return; end

-- Need more testing as I don't have Tier 5 ;)
EnhancerInvigorated = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0");

function EnhancerInvigorated:OnInitialize()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
end

function EnhancerInvigorated:OnEnable()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
	if (not Enhancer.db.profile.Invigorated) then return; end
	self.enabled = true;
	
	Enhancer:ShowFrame("invigorated");
	self:RegisterEvent("UNIT_AURA");
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

function EnhancerInvigorated:UNIT_AURA()
	-- UNIT_AURA | arg 1: party1 | arg 2: Sprint | arg 3: 1 | arg 4: 0 | arg 5: Interface\Icons\Ability_Rogue_Sprint | arg 6: Rank 3
	if (arg1 ~= "player") then
		Enhancer:Print(arg1, arg2, arg3, arg4, arg5, arg6);
	end
end