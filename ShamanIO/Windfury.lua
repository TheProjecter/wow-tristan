ShamanIOWF = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0");

local _, englishClass = UnitClass("player");

function ShamanIOWF:OnInitialize()
	if (englishClass ~= "SHAMAN") then return; end
end

function ShamanIOWF:OnEnable()
	if (englishClass ~= "SHAMAN") then return; end
	self.enabled = true;
	
	ShamanIO.windfury.mainframe:Show();
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
end

function ShamanIOWF:OnDisable()
	if (englishClass ~= "SHAMAN") then return; end
	self.enabled = false;
	
	ShamanIO.windfury.mainframe:Hide();
	self:UnregisterAllEvents();
end

function ShamanIOWF:Toggle()
	if (self.enabled) then
		self:OnDisable();
	else
		self:OnEnable();
	end
end

function ShamanIOWF:Active()
	return self.enabled;
end

function ShamanIOWF:CHAT_MSG_SPELL_SELF_DAMAGE()
	local found, _, windfuryhit = string.find(arg1, "Your Windfury Attack (.+)\.");
	
	if (found) then
		ShamanIO:WindfuryHit();
	end
end

function ShamanIO:WindfuryHit()
	self.windfury.active = true;
	self.windfury.cooldownstart = GetTime();
	self.windfury.cooldownend = GetTime() + 3;
	
	self.windfury.cooldown:SetCooldown(ShamanIO.windfury.cooldownstart, 3);
	self:UpdateAlphaBegin("windfury");
	self:WindfuryCooldownNumber();
	
	if ( not (self:IsEventScheduled("WindfuryCooldownNumber")) ) then
		self:ScheduleRepeatingEvent("WindfuryCooldownNumber", self.WindfuryCooldownNumber, 1, self)
	end
end

function ShamanIO:WindfuryCooldownNumber()
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

do return; end

function ShammySpy:FormatTime(seconds)
	seconds = floor(seconds);
	secs = mod(seconds, 60);
	mins = (seconds - secs) / 60;
	return mins..":"..string.sub("00"..secs, -2);
end