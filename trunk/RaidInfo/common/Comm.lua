local L = AceLibrary("AceLocale-2.2"):new("RaidInfo")
local L2 = AceLibrary("AceLocale-2.2"):new("RaidInfoSpecial")

function RaidInfo:CHAT_MSG_ADDON(prefix, message, distributionType, sender)
	if ((prefix == self.name) and (distributionType == self:CurrentGroupType())) then
		local First, Last = strsplit(" ", message ,2)
		if (First == "CoolDown") then
			self:CleanUp()
			
			local spellName, spellLeft, spellIcon, spellDura = strsplit("!", Last)
			spellLeft = tonumber(spellLeft)
			spellDone = ceil(GetTime() + spellLeft)
			spellDura = tonumber(spellDura)
			local AddedNewSpell = false
			
			if (not self.knowledgeBase[sender]) then self.knowledgeBase[sender] = { } end
			if (not self.knowledgeBase[sender][spellName]) then
				AddedNewSpell = true
				self.knowledgeBase[sender][spellName] = { }
			end
			self.knowledgeBase[sender][spellName]["Done"] = spellDone
			self.knowledgeBase[sender][spellName]["Icon"] = spellIcon
			self.knowledgeBase[sender][spellName]["Dura"] = spellDura
			
			self:DoCandyBar(sender, spellName, spellDura, spellDone, spellIcon, (AddedNewSpell and self.db.char[spellName]))
			self:Update()
		end
	end
end

function RaidInfo:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, rank)
	if (L2:HasReverseTranslation(spellName)) then
		self:ScheduleEvent("QuickPing", self.Ping, 1, self)
	end
end

function RaidInfo:SendAddonMessage(text, prefix)
--SendAddonMessage("prefix", "text", "PARTY|RAID|GUILD|BATTLEGROUND")
	if (not prefix) then prefix = self.name end
	local type = self:CurrentGroupType()
	if (type) then
		SendAddonMessage(prefix, text, type)
	end
end

function RaidInfo:Ping()
	if (not self:CurrentGroupType()) then return end
	if ((self.inCombat) and (not self.db.profile.SendInCombat)) then return end
	self:CleanUp()
	
	local i = 1
	while true do
		local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
		local start, duration = GetSpellCooldown(i, BOOKTYPE_SPELL)
		start = floor(start)
		duration = ceil(duration)
		local spellIcon = GetSpellTexture(i, BOOKTYPE_SPELL)
		if (not spellName) then do break end end
	
		if ( start > 0 and duration > 0 and L2:HasReverseTranslation(spellName)) then
			if (duration - ( GetTime() - start) > 15) then -- Don't capture 1s global CD
				local timeLeft = ceil(duration - ( GetTime() - start))
				local cdString = strjoin("!", L2:GetReverseTranslation(spellName), timeLeft, spellIcon, duration)
				self:SendAddonMessage(strjoin(" ", "CoolDown", cdString))
			end
		end
	   
		i = i + 1
	end
end

function RaidInfo:BarName(UnitName, SpellName)
	return UnitName..SpellName
end

function RaidInfo:DoCandyBar(UnitName, SpellName, Duration, Completed, Icon, Run)
	local barName = self:BarName(UnitName, SpellName)
	local barText = SpellName.." ("..UnitName..")"
	local TimeLeft = Completed - GetTime()
	
	if (not self:IsCandyBarRegistered(barName)) then
		self:RegisterCandyBar(barName, Duration, barText, Icon, "red", "yellow")
		self:SetCandyBarTexture(barName, "Interface\\Addons\\RaidInfo\\textures\\otravi")
		self:RegisterCandyBarWithGroup(barName, self.name)
		
		if (Run) then
			self:StartCandyBar(barName, true)
			self:SetCandyBarTimeLeft(barName, TimeLeft)
		end
		self:SetCandyBarOnClick(barName, function() RaidInfo:ToggleVisibility(UnitName, SpellName) end)
		self:SetCandyBarCompletion(barName, function() RaidInfo:CleanUp() end)
	else
		local _, _, _, running = self:CandyBarStatus(barName)
		if (running) then self:SetCandyBarTimeLeft(barName, TimeLeft) end
	end
end

function RaidInfo:ToggleVisibility(UnitName, SpellName)
	local barName = self:BarName(UnitName, SpellName)
	if (not self.knowledgeBase[UnitName][SpellName]) then
		if (self:IsCandyBarRegistered(barName)) then
			self:UnregisterCandyBar(barName)
		end
		return
	end
	
	spellDone = self.knowledgeBase[UnitName][SpellName]["Done"]
	local timeLeft = spellDone - GetTime()
	
	local _, _, _, running = self:CandyBarStatus(barName)
	if (running) then
		self:StopCandyBar(barName)
	else
		if (self:IsCandyBarRegistered(barName)) then
			self:StartCandyBar(barName, true)
			self:SetCandyBarTimeLeft(barName, timeLeft)
		else
			self:DoCandyBar(UnitName, SpellName, self.knowledgeBase[UnitName][SpellName]["Dura"], self.knowledgeBase[UnitName][SpellName]["Done"], self.knowledgeBase[UnitName][SpellName]["Icon"], true)
		end
	end
end

function RaidInfo:CleanUp()
	for name, cdTable in pairs(self.knowledgeBase) do
		for spellName, spellInfo in pairs(cdTable) do
			if (tonumber(spellInfo["Done"]) < GetTime()) then
				self.knowledgeBase[name][spellName] = nil
			end
		end
	end
end