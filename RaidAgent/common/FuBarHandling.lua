RaidAgent.hasIcon = RaidAgent.tTitleIcon
RaidAgent.hideMenuTitle = true
RaidAgent.hasNoColor = false
RaidAgent.tooltipHiddenWhenEmpty = true
RaidAgent.clickableTooltip = true
RaidAgent.cannotDetachTooltip = true
RaidAgent.independentProfile = true
RaidAgent.hideWithoutStandby = true

local L = AceLibrary("AceLocale-2.2"):new("RaidAgent")
local Tablet = AceLibrary("Tablet-2.0")
local TabletCat = nil
local PC = AceLibrary("PaintChips-2.0")

function RaidAgent:FuInitialize()
	self.OnMenuRequest = self.options
end

function RaidAgent:OnDataUpdate()
	--
end

function RaidAgent:OnTextUpdate()
	local fuText = self:FuName()
	
	local lootmethod, masterlooterID = GetLootMethod()
	
	if ((lootmethod == "master") and (self:PlayerInRaid() or self:PlayerInParty())) then
		fuText = self:SetHexColor("ItemQuality4", "Master Looter")
		
		if (self.masterLooter) then
			fuText = fuText.." ("..self.masterLooter..")"
		elseif (masterlooterID) then
			if (masterlooterID == 0) then
				self.masterLooter = self.PlayerName
				fuText = fuText.." ("..self.masterLooter..")"
				if (not self:IsEventScheduled("MLAnnounce")) then
					self:ScheduleRepeatingEvent("MLAnnounce", self.MLAnnounce, 300, self)
				end
			else
				self.masterLooter = UnitName("party"..masterlooterID)
				fuText = fuText.." ("..self.masterLooter..")"
			end
		else
			fuText = fuText.." (Unknown)"
		end
		
		if ((self.autoMLName) and (self.masterLooter == self.PlayerName)) then
			fuText = self:SetHexColor("red", "*")..fuText
		end
	elseif (self:PlayerInRaid() or self:PlayerInParty()) then
		if (lootmethod == "freeforall") then fuText = self:SetHexColor("ItemQuality4", "Free For All") end
		if (lootmethod == "roundrobin") then fuText = self:SetHexColor("ItemQuality4", "Round Robin") end
		if (lootmethod == "group") then fuText = self:SetHexColor("ItemQuality4", "Group Loot") end
		if (lootmethod == "needbeforegreed") then fuText = self:SetHexColor("ItemQuality4", "Need Before Greed") end
	end
	
	if (self:CurrentGroupType()) then
		local raidCount = self:SetHexColor("orange", self:GetNumGroupMembers())
		if ((self.db.profile.RaidNumbersFu) and (RaidAgent:CurrentGroupType() ~= "GUILD")) then
			local onlineCount, offlineCount, deadCount, zoneCount = 0, 0, 0, 0
			for groupIndex = 1, self:GetNumGroupMembers() do
				local _, _, _, _, _, _, zone, online, isDead = self:GetGroupRosterInfo(groupIndex)
				if (online) then onlineCount = onlineCount + 1 else offlineCount = offlineCount + 1 end
				if (isDead) then deadCount = deadCount + 1 end
				if (GetRealZoneText() == zone) then zoneCount = zoneCount + 1 end
			end
			onlineCount = self:SetHexColor("yellow", onlineCount)
			offlineCount = self:SetHexColor("ItemQuality0", offlineCount)
			deadCount = self:SetHexColor("red", deadCount)
			zoneCount = self:SetHexColor("green", zoneCount)
			fuText = "("..raidCount..")=("..onlineCount.."/"..offlineCount.."/"..deadCount.."/"..zoneCount..") "..fuText
		else
			fuText = "("..raidCount..") "..fuText
		end
	end
	
	self:SetText(fuText)
end

function RaidAgent:OnTooltipUpdate()
	Tablet:SetTitle(self:FuName())
	Tablet:SetTitleColor(163/255, 53/255, 238/255) -- Epic for the right feeling
	
	self:TabletSetColorJustifyCheck("ItemQuality6", "LEFT", true)
	
	self:NewTabletCategory('columns', 1)
	if ((not self:PlayerInRaid()) and self:PlayerInParty()) then
		self:TabletExtraHint(L["FuHintClickRaid"])
	elseif (self:PlayerInRaid() and IsRaidLeader()) then
		self:TabletExtraHint(L["FuHintClickReady"])
	end
	self:TabletExtraHint(L["FuHintClickUngroup"])
	
	local myGroup = { [self.PlayerName] = true, }
	local raidStrengthTotal = 0
	local raidStrengthValues = { }
	
	if (self:PlayerInRaid()) then
		self:NewTabletCategory('columns', 2)
		self:NewTabletLine(
				L["TabletCatType"]
			, L["TabletCatAmount"]
		)
		
		local classArray = { }
		local typeArray = { }
		local class2typeArray = { ["DRUID"] = L["TypeHealers"], ["HUNTER"] = L["TypeDPSers"], ["MAGE"] = L["TypeDPSers"], ["PALADIN"] = L["TypeHealers"], ["PRIEST"] = L["TypeHealers"], ["ROGUE"] = L["TypeDPSers"], ["SHAMAN"] = L["TypeHealers"], ["WARLOCK"] = L["TypeDPSers"], ["WARRIOR"] = L["TypeTanks"] }
		local myClass, myEnglishClass = UnitClass("player")
		local myType = class2typeArray[myEnglishClass]
		
		for groupIndex=1, GetNumPartyMembers() do
			myGroup[UnitName("party"..groupIndex)] = true
		end
		
		for key, value in pairs(class2typeArray) do
			if (not typeArray[value]) then typeArray[value] = 0 end
		end
		
		for raidIndex=1, GetNumRaidMembers() do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidIndex)
			
			if (not classArray[fileName]) then classArray[fileName] = { } classArray[fileName].count = 0 end
			
			
			classArray[fileName].count = classArray[fileName].count + 1
			classArray[fileName].class = class
			
			typeArray[class2typeArray[fileName]] = typeArray[class2typeArray[fileName]] + 1
		
			if ((self.db.profile.RaidStrength) and (online)) then
				for key, value in pairs(self:RaidStrengthValues(fileName)) do
					if (not raidStrengthValues[key]) then raidStrengthValues[key] = 0 end
					raidStrengthValues[key] = raidStrengthValues[key] + value
					raidStrengthTotal = raidStrengthTotal + value
				end
			end
		end
		
		self:TabletSetColorJustifyCheck("orange", nil, nil)
		for key, value in pairs(typeArray) do
			self:NewTabletLine(
					key
				, value
				, function() self:RaidMsg( self:GoFigure(L["RaidReportTypes"], { ["Num"] = value, ["Type"] = key }) ) end
				, (myType == key)
			)
		end
		
		self:NewTabletLine(
			""
		)
		
		for key, value in pairs(classArray) do
			self:TabletSetColorJustifyCheck(key, nil, nil)
			self:NewTabletLine(
					classArray[key].class
				, classArray[key].count
				, function() self:RaidMsg(self:GoFigure(L["RaidReportTypes"], { ["Num"] = classArray[key].count, ["Type"] = classArray[key].class }) ) end
				, (myClass == classArray[key].class)
			)
		end
		
		self:TabletExtraHint(L["FuHintClickReport"])
	end
	
	if (self:CurrentGroupType()) then
		self:NewTabletCategory('columns', 6)
		self:TabletSetColorJustifyCheck("ItemQuality6", nil, nil)
		self:NewTabletLine(
				L["TabletCatName"]
			, L["TabletCatGroup"]
			, L["TabletCatLevel"]
			, L["TabletCatClass"]
			, L["TabletCatSpecial"]
			, L["TabletCatZone"]
		)
		for groupIndex = 1, self:GetNumGroupMembers() do
			--local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(raidIndex)
			local name, rank, subgroup, level, class, fileName, zone, online, isDead = self:GetGroupRosterInfo(groupIndex)
			local rankSuffix = ""
			local grouped = myGroup[name]
			
			if (self:CurrentGroupType() ~= "GUILD") then
				if (rank == 1) then
					rankSuffix = L["RaidPromoted"].." "
				elseif (rank == 2) then
					rankSuffix = L["RaidLeader"].." "
				end
			end
			
			if (name == self.masterLooter) then
				rankSuffix = rankSuffix..L["RaidML"].." "
			end
			
			local specialString
			if (not self.census[name]) then
				specialString = self:GetCensusStringForUnsynced()
			else
				specialString = self:GetCensusStringForClass(self:ReadCensusString(self.census[name]))
			end
			
			if (not online) then
				self:TabletSetColorJustifyCheck("ItemQuality0", nil, nil)
				specialString = self:StripColors(specialString)
			elseif (isDead) then
				self:TabletSetColorJustifyCheck("red", nil, nil)
				specialString = self:StripColors(specialString)
			else
				self:TabletSetColorJustifyCheck(fileName, nil, nil)
			end
			self:NewTabletLine(
					rankSuffix..name
				, subgroup
				, level
				, class
				, specialString
				, zone
				, function() self:FuNameClick(name, rank, groupIndex) end
				, grouped
			)
		end
		
		if (self:PlayerInRaid()) then self:TabletExtraHint(L["FuHintClickName1"]) end
		self:TabletExtraHint(L["FuHintClickName2"])
	end
	
	if (self:PlayerInRaid()) then
		if (self.db.profile.RaidStrength) then
			self:TabletExtraHeadline(
					self:GoFigure(L["RaidStrengthValues"], raidStrengthTotal)
				, function() self:RaidMsg( self:GoFigure(L["RaidStrengthValues"], raidStrengthTotal) ) end
			)
			
			self:NewTabletCategory('columns', 6, 'hideBlankLine', true)
			
			self:TabletSetColorJustifyCheck("orange", nil, nil)
			self:NewTabletLine(
					L["RaidStrengthDPS"]
				, L["RaidStrengthAoE"]
				, L["RaidStrengthHeal"]
				, L["RaidStrengthTank"]
				, L["RaidStrengthCCPullMA"]
				, L["RaidStrengthBuffDebuff"]
			)
			
			local raidStrengthString
			for key, value in pairs(raidStrengthValues) do
			 if (raidStrengthString) then raidStrengthString = raidStrengthString..", " else raidStrengthString = "" end
				raidStrengthString = raidStrengthString..L[key]..": "..value
			end
			
			self:NewTabletLine(
					raidStrengthValues["DPS"]
				, raidStrengthValues["AoE"]
				, raidStrengthValues["Heal"]
				, raidStrengthValues["Tank"]
				, raidStrengthValues["CC"].." / "..raidStrengthValues["Pull"].." / "..raidStrengthValues["MA"]
				, raidStrengthValues["Buff"].." / "..raidStrengthValues["Debuff"]
				, function() self:RaidMsg( self:GoFigure(L["RaidStrengthsValues"], raidStrengthString) ) end
			)
			self:TabletExtraHint(L["FuHintClickReport"])
		end
	end
	
	if (not self:CurrentGroupType()) then
		self:TabletSetColorJustifyCheck("ItemQuality6", "CENTER", nil)
		self:NewTabletLine(L["Not grouped"])
	end
end

function RaidAgent:OnClick()
	if (IsShiftKeyDown()) then
		LeaveParty()
	elseif ((not self:PlayerInRaid()) and self:PlayerInParty()) then
		if (IsPartyLeader()) then
			ConvertToRaid()
		else
			self:Print(L["Error_OnlyLeaderCanConvert"])
		end
	elseif (self:PlayerInRaid()) then
		if (IsRaidLeader()) then
			DoReadyCheck()
		else
			self:Print(L["Error_OnlyLeaderCanReady"])
		end
	end
end

function RaidAgent:OnDoubleClick() -- "button"
	--
end

function RaidAgent:OnMouseDown() -- "button"
	--
end

function RaidAgent:OnReceiveDrag()
	--
end

function RaidAgent:RaidMsg(msg)
	if (IsShiftKeyDown()) then
		SendChatMessage(msg, "OFFICER")
	else
		SendChatMessage(msg, "RAID")
	end
end

function RaidAgent:FuNameClick(clickName, clickRank, clickIndex)
	if (IsShiftKeyDown() and IsControlKeyDown() and IsAltKeyDown()) then
		--SetItemRef("player:"..clickName, "|Hplayer:"..clickName.."|h["..clickName.."|h", "LeftButton")
		self:PrintFullCensusData(clickName, true)
		return
	elseif (IsShiftKeyDown() and IsControlKeyDown()) then
		self:PrintFullCensusData(clickName, false)
		return
	end
	if (IsRaidLeader() or IsRaidOfficer()) then
		if (IsShiftKeyDown() and IsRaidLeader()) then
			PromoteToLeader(clickName)
		elseif (IsControlKeyDown() and IsRaidLeader()) then
			SetLootMethod("Master", clickName, 2)
		elseif (IsAltKeyDown()) then
			UninviteUnit(clickName)
		elseif ((clickRank == 0) and IsRaidLeader()) then
			PromoteToAssistant(clickName)
		elseif ((clickRank == 1) and IsRaidLeader()) then
			DemoteAssistant(clickName)
		end
	end
end

function RaidAgent:TabletSetColorJustifyCheck(pcColor, justify, hasCheck)
	if (not self.tabletOptions) then self.tabletOptions = { } end
	if (type(pcColor) == "string") then self.tabletOptions.pcColor = pcColor end
	if (type(justify) == "string") then self.tabletOptions.justify = justify end
	if (type(hasCheck) == "boolean") then self.tabletOptions.hasCheck = hasCheck end
end

function RaidAgent:NewTabletCategory(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	local args = {}
	tinsert(args, arg1)
	tinsert(args, arg2)
	tinsert(args, arg3)
	tinsert(args, arg4)
	tinsert(args, arg5)
	tinsert(args, arg6)
	tinsert(args, arg7)
	tinsert(args, arg8)
	tinsert(args, arg9)
	
	local info = { }
	for _, locArg in pairs(args) do
		if (type(locArg) == "number") then
			info["columns"] = locArg
		elseif (type(locArg) == "boolean") then
			info["hideBlankLine"] = locArg
		end
	end
	
	return info
end

function RaidAgent:NewTabletCategory(...)
	TabletCat = Tablet:AddCategory(...)
end

function RaidAgent:NewTabletLine(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if (not self.tabletOptions) then self.tabletOptions = { } end
	
	local args = {}
	tinsert(args, arg1)
	tinsert(args, arg2)
	tinsert(args, arg3)
	tinsert(args, arg4)
	tinsert(args, arg5)
	tinsert(args, arg6)
	tinsert(args, arg7)
	tinsert(args, arg8)
	tinsert(args, arg9)
	
	local info = { }
	local txtCounter = 1
	local _, textR, textG, textB = PC:GetRGBPercent(self.tabletOptions.pcColor)
	
	for _, locArg in pairs(args) do
		if (type(locArg) == "function") then
			info["func"] = locArg
		elseif (type(locArg) == "boolean") then
			info["isRadio"] = locArg
			info["checked"] = locArg
		else
			local textString = "text"..txtCounter
			local justifyString = "justify"..txtCounter
			local textRString = "text"..txtCounter.."R"
			local textGString = "text"..txtCounter.."G"
			local textBString = "text"..txtCounter.."B"
			
			if (txtCounter == 1) then
				textString = "text"
				justifyString = "justify"
				textRString = "textR"
				textGString = "textG"
				textBString = "textB"
			end
			
			info[textString] = locArg
			info[justifyString] = self.tabletOptions.justify
			info[textRString] = textR
			info[textGString] = textG
			info[textBString] = textB
			
			txtCounter = txtCounter + 1
		end
	end
	info["hasCheck"] = self.tabletOptions.hasCheck

	TabletCat:AddLine(info)
end

function RaidAgent:TabletExtraHint(hint, func)
	self:TabletSetColorJustifyCheck("green", "LEFT", nil)
	self:NewTabletCategory('columns', 1, 'hideBlankLine', true)
	self:NewTabletLine("Hint: "..hint, func)
end

function RaidAgent:TabletExtraHeadline(headline, func)
	self:TabletSetColorJustifyCheck("ItemQuality6", "CENTER", nil)
	self:NewTabletCategory('columns', 1)
	self:NewTabletLine(headline, func)
end