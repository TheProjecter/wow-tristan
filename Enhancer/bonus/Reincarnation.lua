EnhancerReincarnation = Enhancer:NewModule("Reincarnation", "AceEvent-2.0");
Enhancer:SetModuleDefaultState("Reincarnation", true);

function EnhancerReincarnation:OnInitialize()
	
end

function EnhancerReincarnation:OnEnable()
	Enhancer:ShowFrame("reincarnation");
	self:BAG_UPDATE();
	
	self:RegisterEvent("PLAYER_ALIVE", "PLAYER_ALIVE");
	self:RegisterEvent("BAG_UPDATE");
	
	self:ScheduleEvent("CheckReincarnation", self.CheckReincarnation, 5, self);
end

function EnhancerReincarnation:OnDisable()
	if (self:IsEventScheduled("ReincarnationUpdate")) then
		self:CancelScheduledEvent("ReincarnationUpdate");
	end
	
	Enhancer:HideFrame("reincarnation");
	self:UnregisterAllEvents();
end

function EnhancerReincarnation:PLAYER_ALIVE()
	self:ScheduleEvent("CheckReincarnation", self.CheckReincarnation, 5, self);
end

function EnhancerReincarnation:BAG_UPDATE()
	Enhancer.reincarnation.textcenter:SetText( GetItemCount(17030) );
end

function EnhancerReincarnation:GetReincarnationIDCached()
	if (not self.reincarnationID) then
		self.reincarnationID = self:GetReincarnationID()
	else
		local spellName, spellRank = GetSpellName(self.reincarnationID, BOOKTYPE_SPELL)
		if (spellName ~= Enhancer.BS["Reincarnation"]) then
			self.reincarnationID = self:GetReincarnationID();
		end
	end
	return self.reincarnationID;
end

function EnhancerReincarnation:GetReincarnationID()
	local spellCheckID = 1;
	local spellID = nil;
	
	while true do
		local spellName, spellRank = GetSpellName(spellCheckID, BOOKTYPE_SPELL)
		
		if (spellName == Enhancer.BS["Reincarnation"]) then spellID = spellCheckID; break; end
   	if (not spellName) then do break; end end
		
		spellCheckID = spellCheckID + 1;
	end
	
	return spellID;
end

function EnhancerReincarnation:GetReincarnationCooldown()
	local ReincarnationID = self:GetReincarnationIDCached();
	return GetSpellCooldown(ReincarnationID, BOOKTYPE_SPELL);
end

function EnhancerReincarnation:CheckReincarnation()
	local ReincarnationID = self:GetReincarnationIDCached();
	
	if (ReincarnationID) then
		local start, duration = self:GetReincarnationCooldown();
		if ( start > 0 and duration > 0) then
			Enhancer.reincarnation.active = true;
			Enhancer:UpdateAlphaBegin("reincarnation");
			self:ScheduleRepeatingEvent("ReincarnationUpdate", self.ReincarnationUpdate, 1, self);
		end
	end
end

function EnhancerReincarnation:ReincarnationUpdate()
	--[[ Check Reincarnation Cooldown ]]
	local ReincarnationID = self:GetReincarnationIDCached();
	
	if (ReincarnationID) then
		local start, duration = self:GetReincarnationCooldown();
		
		if ( start > 0 and duration > 0) then
			local ReincarnationCD = duration - ( GetTime() - start);
			
			Enhancer.reincarnation.textbelow:SetText( Enhancer:FormatTime(ReincarnationCD) );
		else
			Enhancer:FrameDeathBegin("reincarnation");
			if (self:IsEventScheduled("ReincarnationUpdate")) then
				self:CancelScheduledEvent("ReincarnationUpdate");
			end
		end
	end
end