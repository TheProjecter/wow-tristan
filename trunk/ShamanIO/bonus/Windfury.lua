EnhancerWindfury = Enhancer:NewModule("Windfury", "AceEvent-2.0");
Enhancer:SetModuleDefaultState("Windfury", true);

function EnhancerWindfury:OnInitialize()
	
end

function EnhancerWindfury:OnEnable()
	Enhancer:ShowFrame("windfury");
end

function EnhancerWindfury:OnDisable()
	Enhancer:HideFrame("windfury");
end

function Enhancer:WindfuryHit()
	if (not Enhancer:IsModuleActive("Windfury")) then return; end -- Don't do shit unless module is enabled;
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