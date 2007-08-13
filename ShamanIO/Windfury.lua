EnhancerWindfury = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0");

function EnhancerWindfury:OnInitialize()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
end

function EnhancerWindfury:OnEnable()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
	if (not Enhancer.db.profile.Windfury) then return; end
	self.enabled = true;
	
	Enhancer:ShowFrame("windfury");
end

function EnhancerWindfury:OnDisable()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
	self.enabled = false;
	
	Enhancer:HideFrame("windfury");
	self:UnregisterAllEvents();
end

function EnhancerWindfury:Toggle()
	if (self.enabled) then
		Enhancer.db.profile.Windfury = false;
		self:OnDisable();
	else
		Enhancer.db.profile.Windfury = true;
		self:OnEnable();
	end
end

function EnhancerWindfury:Active()
	return self.enabled;
end

function Enhancer:WindfuryHit()
	if (not EnhancerWindfury:Active()) then return; end -- Don't do shit unless "module" is enabled;
	if (self.windfury.active) then return; end -- Second WF shouldn't reset the timer ;)
	
	self.windfury.active = true;
	self.windfury.cooldownstart = GetTime();
	self.windfury.cooldownend = GetTime() + 3;
	
	self.windfury.cooldown:SetCooldown(Enhancer.windfury.cooldownstart, 3);
	self:UpdateAlphaBegin("windfury");
	self:WindfuryCooldownNumber();
	
	if ( not (self:IsEventScheduled("WindfuryCooldownNumber")) ) then
		self:ScheduleRepeatingEvent("WindfuryCooldownNumber", self.WindfuryCooldownNumber, 1, self)
	end
end

function Enhancer:WindfuryCooldownNumber()
	local cdstart = self.windfury.cooldownstart;
	local cdend = self.windfury.cooldownend;
	local cd = ceil(cdend - GetTime())
	
	if (cd <= 0) then
		self.windfury.textcenter:SetText("");
		if (self:IsEventScheduled("WindfuryCooldownNumber")) then
			self:CancelScheduledEvent("WindfuryCooldownNumber")
		end
		
		self:FrameDeathBegin("windfury");
	else
		-- Cooldown running
		self.windfury.textcenter:SetText(cd);
	end
end