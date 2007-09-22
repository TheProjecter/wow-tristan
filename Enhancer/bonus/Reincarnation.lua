EnhancerReincarnation = Enhancer:NewModule("Reincarnation", "AceEvent-2.0");
EnhancerReincarnation.DefaultState = true;
Enhancer:SetModuleDefaultState("Reincarnation", EnhancerReincarnation.DefaultState);
local FrameName = "reincarnation";

function EnhancerReincarnation:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Nature_Reincarnation", 0, -150);
	Enhancer[FrameName].borderColor = { ["r"] = (139/255), ["g"] = (69/255), ["b"] = (19/255), ["a"] = 1, }
	Enhancer:AddFrameToList(FrameName, true, false, false) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer[FrameName].moveName = "Ankh";
end

function EnhancerReincarnation:OnEnable()
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
	
	self:BAG_UPDATE();
	
	self:RegisterEvent("PLAYER_ALIVE", "PLAYER_ALIVE");
	self:RegisterEvent("BAG_UPDATE");
	
	self:ScheduleEvent("CheckReincarnation", self.CheckReincarnation, 5, self);
end

function EnhancerReincarnation:OnDisable()
	Enhancer:HideFrame(FrameName);
	
	self:UnregisterAllEvents();
	self:CancelAllScheduledEvents();
end

function EnhancerReincarnation:PLAYER_ALIVE()
	self:ScheduleEvent("CheckReincarnation", self.CheckReincarnation, 5, self);
end

function EnhancerReincarnation:BAG_UPDATE()
	Enhancer[FrameName].textcenter:SetText( GetItemCount(17030) );
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
			Enhancer[FrameName].active = true;
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
			
			Enhancer[FrameName].textbelow:SetText( Enhancer:FormatTime(ReincarnationCD) );
		else
			Enhancer:FrameDeathBegin("reincarnation");
			if (self:IsEventScheduled("ReincarnationUpdate")) then
				self:CancelScheduledEvent("ReincarnationUpdate");
			end
		end
	end
end