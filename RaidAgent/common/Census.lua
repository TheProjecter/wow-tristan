--[[ WORK IN PROGRESS, PLEASE DO NOT ALTER FILES YET ]]
local L = AceLibrary("AceLocale-2.2"):new("RaidAgent")

function RaidAgent:CensusInitialize()
	if (not self.census) then self.census = { } end
end

function RaidAgent:Ping(SendInCombat)
	if ((self.inCombat) and (not SendInCombat)) then return end
	
	if (not self.censusData) then
		self:UpdateOwnCensusData()
		return
	end
	
	self:SendAddonMessage("data "..self.censusData)
end

function RaidAgent:UpdateOwnCensusData(SendInCombat)
	if ((self.inCombat) and (not SendInCombat)) then return end
	
	local localizedClass, englishClass = UnitClass("player")
	if (self:CreateCensusString(englishClass)) then
		self.censusData = englishClass..";"..self:CreateCensusString(englishClass)
	end
	
	if (self.censusData) then self:Ping() end
end

function RaidAgent:CreateCensusString(englishClass)
	local rVal = ""
	
	if (englishClass == "DRUID") then
		rVal = rVal..self:CensusGetTalentInfo(1, 8, "DD_InS")..":" -- Insect Swarm
		rVal = rVal..self:CensusGetTalentInfo(1, 18, "DD_MoF")..":" -- Moonkin Form
		rVal = rVal..self:CensusGetTalentInfo(1, 19, "DD_IFF")..":" -- Improved Faire Fire
		rVal = rVal..self:CensusGetTalentInfo(2, 14, "DD_FFi")..":" -- Fearie Fire (Feral)
		rVal = rVal..self:CensusGetTalentInfo(2, 19, "DD_LoP")..":" -- Leader of the Pack
		rVal = rVal..self:CensusGetTalentInfo(2, 20, "DD_ILP")..":" -- Improved Leader of the Pack
		rVal = rVal..self:CensusGetTalentInfo(2, 22, "DD_Man")..":" -- Mangle
		rVal = rVal..self:CensusGetTalentInfo(3, 1, "DD_IMW")..":" -- Improved Mark of the Wild
		rVal = rVal..self:CensusGetTalentInfo(3, 11, "DD_NaS")..":" -- Nature's Swiftness
		rVal = rVal..self:CensusGetTalentInfo(3, 20, "DD_ToL")..":" -- Tree of Life
		return self:TrimAny(rVal, ":")
	end
	
	if (englishClass == "HUNTER") then
		rVal = rVal..self:CensusGetTalentInfo(1, 7, "HR_Pat")..":" -- Pathfinding
		rVal = rVal..self:CensusGetTalentInfo(1, 17, "HR_FeI")..":" -- Ferocious Inspiration
		rVal = rVal..self:CensusGetTalentInfo(2, 3, "HR_IHM")..":" -- Improved Hunter's Mark
		rVal = rVal..self:CensusGetTalentInfo(2, 17, "HR_TsA")..":" -- Trueshot Aura
		rVal = rVal..self:CensusGetTalentInfo(3, 20, "HR_WyS")..":" -- Wyvern Sting
		return self:TrimAny(rVal, ":")
	end
	
	if (englishClass == "MAGE") then
		rVal = rVal..self:CensusGetTalentInfo(1, 7, "ME_MaA")..":" -- Magic Attunement
		rVal = rVal..self:CensusGetTalentInfo(1, 23, "ME_Slo")..":" -- Slow
		rVal = rVal..self:CensusGetTalentInfo(2, 10, "ME_ImS")..":" -- Improved Scorch
		rVal = rVal..self:CensusGetTalentInfo(3, 18, "ME_WiC")..":" -- Winter's Chill
		return self:TrimAny(rVal, ":")
	end
	
	if (englishClass == "PALADIN") then
		rVal = rVal..self:CensusGetTalentInfo(1, 6, "PN_AMa")..":" -- Aura Mastery
		rVal = rVal..self:CensusGetTalentInfo(1, 7, "PN_ILH")..":" -- Improved Lay on Hand
		rVal = rVal..self:CensusGetTalentInfo(1, 10, "PN_IBW")..":" -- Improving Blessing of Wisdom
		rVal = rVal..self:CensusGetTalentInfo(2, 1, "PN_IDA")..":" -- Improved Devotion Aura
		rVal = rVal..self:CensusGetTalentInfo(2, 6, "PN_BoK")..":" -- Blessing of Kings
		rVal = rVal..self:CensusGetTalentInfo(2, 12, "PN_ICA")..":" -- Improved Concentration Aura
		rVal = rVal..self:CensusGetTalentInfo(2, 13, "PN_IRA")..":" -- Improved Resistances Aura
		rVal = rVal..self:CensusGetTalentInfo(2, 14, "PN_BoS")..":" -- Blessing of Sanctuary
		rVal = rVal..self:CensusGetTalentInfo(3, 1, "PN_IBM")..":" -- Improved Blessing of Might
		rVal = rVal..self:CensusGetTalentInfo(3, 14, "PN_SaA")..":" -- Sanctity Aura
		rVal = rVal..self:CensusGetTalentInfo(3, 15, "PN_ISA")..":" -- Improved Sanctity Aura
		return self:TrimAny(rVal, ":")
	end
	
	if (englishClass == "PRIEST") then
		rVal = rVal..self:CensusGetTalentInfo(1, 4, "PT_PWF")..":" -- Improved Power Word: Fortitude
		rVal = rVal..self:CensusGetTalentInfo(1, 5, "PT_PWS")..":" -- Improved Power Word: Shield
		rVal = rVal..self:CensusGetTalentInfo(1, 14, "PT_DiS")..":" -- Divine Spirit
		rVal = rVal..self:CensusGetTalentInfo(1, 15, "PT_IDS")..":" -- Improved Divine Spirit
		rVal = rVal..self:CensusGetTalentInfo(1, 18, "PT_PoI")..":" -- Power Infusion
		rVal = rVal..self:CensusGetTalentInfo(1, 19, "PT_ReS")..":" -- Reflective Shield
		rVal = rVal..self:CensusGetTalentInfo(2, 8, "PT_Ins")..":" -- Inspiration
		rVal = rVal..self:CensusGetTalentInfo(2, 9, "PT_HoR")..":" -- Holy Reach
		rVal = rVal..self:CensusGetTalentInfo(2, 18, "PT_LiW")..":" -- Lightwell
		rVal = rVal..self:CensusGetTalentInfo(3, 11, "PT_ShW")..":" -- Shadow Weaving
		rVal = rVal..self:CensusGetTalentInfo(3, 12, "PT_Sil")..":" -- Silence
		rVal = rVal..self:CensusGetTalentInfo(3, 13, "PT_VaE")..":" -- Vampiric Embrace
		rVal = rVal..self:CensusGetTalentInfo(3, 18, "PT_ShF")..":" -- Shadow Form
		rVal = rVal..self:CensusGetTalentInfo(3, 20, "PT_Mis")..":" -- Misery
		rVal = rVal..self:CensusGetTalentInfo(3, 21, "PT_VaT")..":" -- Vampiric Touch
		return self:TrimAny(rVal, ":")
	end
	
	if (englishClass == "ROGUE") then
		rVal = rVal..self:CensusGetTalentInfo(3, 10, "RE_ISa")..":" -- Improved Sap
		rVal = rVal..self:CensusGetTalentInfo(3, 15, "RE_Hem")..":" -- Hemorrhage
		return self:TrimAny(rVal, ":")
	end
	
	if (englishClass == "SHAMAN") then
		rVal = rVal..self:CensusGetTalentInfo(1, 3, "SN_EaG")..":" -- Earth's Grasp
		rVal = rVal..self:CensusGetTalentInfo(1, 13, "SN_ElF")..":" -- Elemental Fury
		rVal = rVal..self:CensusGetTalentInfo(1, 20, "SN_ToW")..":" -- Totem of Wrath
		rVal = rVal..self:CensusGetTalentInfo(2, 3, "SN_GuT")..":" -- Guardian Totems
		rVal = rVal..self:CensusGetTalentInfo(3, 1, "SN_IHW")..":" -- Improved Healing Wave
		rVal = rVal..self:CensusGetTalentInfo(3, 3, "SN_IRe")..":" -- Improved Reincarnation
		rVal = rVal..self:CensusGetTalentInfo(3, 4, "SN_AnH")..":" -- Ancestral Healing
		rVal = rVal..self:CensusGetTalentInfo(3, 7, "SN_HeF")..":" -- Healing Focus
		rVal = rVal..self:CensusGetTalentInfo(3, 9, "SN_HeG")..":" -- Healing Grace
		rVal = rVal..self:CensusGetTalentInfo(3, 10, "SN_ReT")..":" -- Restorative Totems
		rVal = rVal..self:CensusGetTalentInfo(3, 12, "SN_HeW")..":" -- Healing Way
		rVal = rVal..self:CensusGetTalentInfo(3, 13, "SN_NaS")..":" -- Nature's Swiftness
		rVal = rVal..self:CensusGetTalentInfo(3, 14, "SN_FoM")..":" -- Focused Mind
		rVal = rVal..self:CensusGetTalentInfo(3, 16, "SN_MTT")..":" -- Mana Tide Totem
		rVal = rVal..self:CensusGetTalentInfo(3, 17, "SN_NaG")..":" -- Nature's Guardian
		rVal = rVal..self:CensusGetTalentInfo(3, 18, "SN_NaB")..":" -- Nature's Blessing
		return self:TrimAny(rVal, ":")
	end
	
	if (englishClass == "WARLOCK") then
		rVal = rVal..self:CensusGetTalentInfo(1, 3, "WK_ICW")..":" -- Improved Curse of Weakness
		rVal = rVal..self:CensusGetTalentInfo(1, 13, "WK_ShW")..":" -- Shadow Embrace
		rVal = rVal..self:CensusGetTalentInfo(2, 1, "WK_IHs")..":" -- Improved Healthstone
		rVal = rVal..self:CensusGetTalentInfo(2, 2, "WK_IIm")..":" -- Improved Imp
		rVal = rVal..self:CensusGetTalentInfo(3, 1, "WK_ISB")..":" -- Improved Shadow Bolt
		return self:TrimAny(rVal, ":")
	end
	
	if (englishClass == "WARRIOR") then
		rVal = rVal..self:CensusGetTalentInfo(1, 20, "WR_MoS")..":" -- Mortal Strike
		rVal = rVal..self:CensusGetTalentInfo(2, 3, "WR_IDe")..":" -- Improved Demoralizing Shout
		rVal = rVal..self:CensusGetTalentInfo(2, 6, "WR_PiH")..":" -- Piercing Howl
		rVal = rVal..self:CensusGetTalentInfo(2, 8, "WR_IBa")..":" -- Improved Battle Shout
		rVal = rVal..self:CensusGetTalentInfo(2, 13, "WR_DeW")..":" -- Death Wish
		rVal = rVal..self:CensusGetTalentInfo(3, 6, "WR_LaS")..":" -- Last Stand
		rVal = rVal..self:CensusGetTalentInfo(3, 9, "WR_Def")..":" -- Defiance
		rVal = rVal..self:CensusGetTalentInfo(3, 11, "WR_IDi")..":" -- Improved Disarm
		rVal = rVal..self:CensusGetTalentInfo(3, 13, "WR_ISW")..":" -- Improved Shield Wall
		rVal = rVal..self:CensusGetTalentInfo(3, 18, "WR_IDS")..":" -- Improved Defensive Stance
		rVal = rVal..self:CensusGetTalentInfo(3, 21, "WR_Vit")..":" -- Vitality
		return self:TrimAny(rVal, ":")
	end
	
	return nil
end

function RaidAgent:CensusGetTalentInfo(tabIndex, talentIndex, talentKey)
	local nameTalent, _, _, _, currentRank, maxRank, _, _ = GetTalentInfo(tabIndex, talentIndex)
	return talentKey.."."..currentRank.."."..maxRank
	-- return talentKey.."."..currentRank.."."..maxRank.."."..tabIndex..self:PadTalentIndex(talentIndex)
end

function RaidAgent:PadTalentIndex(talentIndex)
	return string.sub("0000"..talentIndex, -2)
end

function RaidAgent:UpdateCensusInfo(censusInfo)
	local censusData, englishClass = self:ReadCensusString(censusInfo)
	local infoText = ""
	local DB = self.db.profile
	
	-- Empty Census Options
	if (not DB.censusOptions) then DB.censusOptions = { } end
	if (not DB.censusLastOption) then DB.censusLastOption = { } end
	
	if (not DB.censusOptions[englishClass]) then
	-- New Class for Census Options \o/
		DB.censusOptions[englishClass] = { }
		local locClass = englishClass
		if (L:HasTranslation(englishClass)) then locClass = L[englishClass] end
	end
	
	for talentKey, talentTable in pairs(censusData) do
		if (not DB.censusOptions[englishClass][talentKey]) then
		-- New talent \o/
			if (L:HasTranslation(talentKey)) then
				DB.censusOptions[englishClass][talentKey] = L[talentKey]
				DB.censusLastOption[englishClass] = talentKey
				infoText = infoText..L[talentKey]..", "
			else
				self:Print( self:GoFigure(L["NoTranslationTalent"], talentKey) )
			end
		end
	end
	
	if (infoText ~= "") then
		infoText = self:TrimAny(self:Trim(infoText), ",")
		self:Print( self:GoFigure(L["LearnedTalent(s)"], infoText) )
	end
end

function RaidAgent:ReadCensusString(censusInfo)
	local rVal = { }
	local classValues = self:Split(censusInfo, "%;")
	local englishClass = classValues[1]
	for _, RawTalents in ipairs(self:Split(classValues[2], "%:")) do
		local talentValues = self:Split(RawTalents, "%.")
		
		if (L:HasTranslation(talentValues[1])) then
			rVal[talentValues[1]] = { }
			rVal[talentValues[1]]["raw"] = RawTalents
			rVal[talentValues[1]]["rank"] = tonumber(talentValues[2])
			rVal[talentValues[1]]["maxRank"] = tonumber(talentValues[3])
			rVal[talentValues[1]]["isMaxed"] = (talentValues[2] == talentValues[3])
		end
	end
	return rVal, englishClass
end

function RaidAgent:CensusTalentStatus(text)
  
end

function RaidAgent:GetCensusStringForUnsynced()
	return self:SetHexColor("red", L["Not Synced"])
end

function RaidAgent:GetCensusStringForClass(censusData, englishClass)
	if (not self:HaveClass(englishClass)) then return self:SetHexColor("censusred", "Class not in census") end
	if (not self:ShowForClass(englishClass)) then return self:SetHexColor("censusgreen", "Synced") end
	if (not L:HasTranslation(self:ShowForClass(englishClass))) then return self:SetHexColor("censusorange", "Talent unknown") end
	
	local talentKey = self:ShowForClass(englishClass)
	if (censusData[talentKey].maxRank == 1) then
		if (censusData[talentKey].rank == censusData[talentKey].maxRank) then
			return self:SetHexColor("censusgreen", L[talentKey])
		else
			return self:SetHexColor("censusred", "-"..L[talentKey].."-")
		end
	else
		if (censusData[talentKey].rank == 0) then
			return self:SetHexColor("censusred", L[talentKey].." "..censusData[talentKey].rank.."/"..censusData[talentKey].maxRank)
		elseif (censusData[talentKey].rank == censusData[talentKey].maxRank) then
			return self:SetHexColor("censusgreen", L[talentKey].." "..censusData[talentKey].rank.."/"..censusData[talentKey].maxRank)
		else
			return self:SetHexColor("censusorange", L[talentKey].." "..censusData[talentKey].rank.."/"..censusData[talentKey].maxRank)
		end
	end
end

function RaidAgent:PrintOrRaid(msg, inRaid)
	if (inRaid) then
		SendChatMessage(self:StripColors(msg), self:CurrentGroupType())
	else
		self:Print(msg)
	end
end

function RaidAgent:PrintFullCensusData(name, inRaid)
	if (strlen(name) < 2) then return end
	
	self:PrintOrRaid( self:GoFigure(L["CensusReport"], name), inRaid)
	if (not self.census[name]) then
		self:PrintOrRaid(self:SetHexColor("censusred", L["CensusReportNotSynced"]), inRaid)
	else
		censusData, englishClass = self:ReadCensusString(self.census[name])
		local localClass = englishClass
		if (L:HasTranslation(englishClass)) then localClass = L[englishClass] end
		
		self:PrintOrRaid( self:GoFigure(L["CensusReportClass"], localClass), inRaid)
		for talentKey, talentTable in pairs(censusData) do
			local talentName = talentKey
			local rank = censusData[talentKey].rank
			local maxRank = censusData[talentKey].maxRank
			if (L:HasTranslation(talentKey)) then talentName = L[talentKey] end
			local talentInfoString
			
			if (maxRank == 1) then
				if (rank == 1) then
					talentInfoString = self:SetHexColor("censusgreen", L["CensusReportYes"])
				else
					talentInfoString = self:SetHexColor("censusred", L["CensusReportNo"])
				end
			else
				if (rank == 0) then
					talentInfoString = self:SetHexColor("censusred", rank.."/"..maxRank)
				elseif (rank == maxRank) then
					talentInfoString = self:SetHexColor("censusgreen", rank.."/"..maxRank)
				else
					talentInfoString = self:SetHexColor("censusorange", rank.."/"..maxRank)
				end
			end
			
			self:PrintOrRaid("  * "..talentName..": "..talentInfoString, inRaid)
		end
	end
end

function RaidAgent:HaveClass(englishClass)
	local DB = self.db.profile
	if (not DB.censusOptions) then DB.censusOptions = { } end
	return DB.censusOptions[englishClass]
end

function RaidAgent:ShowForClass(englishClass)
	local DB = self.db.profile
	if (not DB.censusShow) then DB.censusShow = { } end
	return DB.censusShow[englishClass] or DB.censusLastOption[englishClass]
end

function RaidAgent:SetShowForClass(englishClass, value)
	local DB = self.db.profile
	if (not DB.censusShow) then DB.censusShow = { } end
	DB.censusShow[englishClass] = value
end