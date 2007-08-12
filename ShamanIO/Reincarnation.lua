ShamanIOR = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0");

local BS = AceLibrary("Babble-Spell-2.2")
local _, englishClass = UnitClass("player");

function ShamanIOR:OnInitialize()
	if (englishClass ~= "SHAMAN") then return; end
end

ShamanIOR.DefaultBelowText = "";
ShamanIOR.DefaultBelowText = ShamanIO:FormatTime(0);
function ShamanIOR:OnEnable()
	if (englishClass ~= "SHAMAN") then return; end
	self.enabled = true;
	
	ShamanIO.reincarnation.mainframe:Show();
	ShamanIO.reincarnation.textbelow:SetText(ShamanIOR.DefaultBelowText);
	ShamanIO.reincarnation.textcenter:SetText( GetItemCount(17030) );
	
	self:RegisterEvent("PLAYER_ALIVE", "PLAYER_ALIVE");
	-- Can't use Reincarnation after releasing anyway but keeping it in case I want it for something else -- self:RegisterEvent("PLAYER_UNGHOST", "PLAYER_ALIVE");
	self:RegisterEvent("BAG_UPDATE");
	
	self:ScheduleEvent("CheckReincarnation", self.CheckReincarnation, 5, self);
end

function ShamanIOR:OnDisable()
	if (englishClass ~= "SHAMAN") then return; end
	self.enabled = false;
	
	ShamanIO.reincarnation.active = false;
	ShamanIO.reincarnation.textbelow:SetText("");
	ShamanIO:UpdateAlphaBegin("reincarnation");
	if (self:IsEventScheduled("ReincarnationUpdate")) then
		self:CancelScheduledEvent("ReincarnationUpdate");
	end
	
	ShamanIO.reincarnation.mainframe:Hide();
	self:UnregisterAllEvents();
end

function ShamanIOR:Toggle()
	if (self.enabled) then
		self:OnDisable();
	else
		self:OnEnable();
	end
end

function ShamanIOR:Active()
	return self.enabled;
end

function ShamanIOR:PLAYER_ALIVE()
	self:ScheduleEvent("CheckReincarnation", self.CheckReincarnation, 5, self);
end

function ShamanIOR:BAG_UPDATE()
	ShamanIO.reincarnation.textcenter:SetText( GetItemCount(17030) );
end

function ShamanIOR:GetReincarnationIDCached()
	if (not self.reincarnationID) then
		self.reincarnationID = self:GetReincarnationID()
	else
		local spellName, spellRank = GetSpellName(self.reincarnationID, BOOKTYPE_SPELL)
		if (spellName ~= BS["Reincarnation"]) then
			self.reincarnationID = self:GetReincarnationID();
		end
	end
	return self.reincarnationID;
end

function ShamanIOR:GetReincarnationID()
	local spellCheckID = 1;
	local spellID = nil;
	
	while true do
		local spellName, spellRank = GetSpellName(spellCheckID, BOOKTYPE_SPELL)
		
		if (spellName == BS["Reincarnation"]) then spellID = spellCheckID; break; end
   	if (not spellName) then do break; end end
		
		spellCheckID = spellCheckID + 1;
	end
	
	return spellID;
end

function ShamanIOR:GetReincarnationCooldown()
	local ReincarnationID = self:GetReincarnationIDCached();
	return GetSpellCooldown(ReincarnationID, BOOKTYPE_SPELL);
end

function ShamanIOR:CheckReincarnation()
	local ReincarnationID = self:GetReincarnationIDCached();
	
	if (ReincarnationID) then
		local start, duration = self:GetReincarnationCooldown();
		if ( start > 0 and duration > 0) then
			ShamanIO.reincarnation.active = true;
			ShamanIO:UpdateAlphaBegin("reincarnation");
			self:ScheduleRepeatingEvent("ReincarnationUpdate", self.ReincarnationUpdate, 1, self);
		end
	end
end

function ShamanIOR:ReincarnationUpdate()
	--[[ Check Reincarnation Cooldown ]]
	local ReincarnationID = self:GetReincarnationIDCached();
	
	if (ReincarnationID) then
		local start, duration = self:GetReincarnationCooldown();
		
		if ( start > 0 and duration > 0) then
			local ReincarnationCD = duration - ( GetTime() - start);
			
			ShamanIO.reincarnation.textbelow:SetText( ShamanIO:FormatTime(ReincarnationCD) );
		else
			self:FrameDeathBegin("reincarnation");
			ShamanIO.reincarnation.textbelow:SetText(ShamanIOR.DefaultBelowText);
			if (self:IsEventScheduled("ReincarnationUpdate")) then
				self:CancelScheduledEvent("ReincarnationUpdate");
			end
		end
	end
end