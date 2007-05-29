--[[ WORK IN PROGRESS, PLEASE DO NOT ALTER FILES YET ]]
local L = AceLibrary("AceLocale-2.2"):new("RaidAgent")
CreateFrame("GameTooltip", "RaidAgentGameTooltip", UIParent, "GameTooltipTemplate")
RaidAgentGameTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")

RaidAgent.autoLootItems = {
	MC = {
		[17010] = true, --Fiery Core
		[17011] = true, --Lava Core
	},
	BWL = {
		[18562] = true, --Elementium Ore
	},
	ZG = {
		[19698] = true, --Zulian Coin
		[19699] = true, --Razzashi Coin
		[19700] = true, --Hakkari Coin
		[19701] = true, --Gurubashi Coin
		[19702] = true, --Vilebranch Coin
		[19703] = true, --Witherbark Coin
		[19704] = true, --Sandfury Coin
		[19705] = true, --Skullsplitter Coin
		[19706] = true, --Bloodscalp Coin
		[19707] = true, --Red Hakkari Bijou
		[19708] = true, --Blue Hakkari Bijou
		[19709] = true, --Yellow Hakkari Bijou
		[19710] = true, --Orange Hakkari Bijou
		[19711] = true, --Green Hakkari Bijou
		[19712] = true, --Purple Hakkari Bijou
		[19713] = true, --Bronze Hakkari Bijou
		[19714] = true, --Silver Hakkari Bijou
		[19715] = true, --Gold Hakkari Bijou
	},
	AQ = {
		[20858] = true, --Stone Scarab
		[20859] = true, --Gold Scarab
		[20860] = true, --Silver Scarab
		[20861] = true, --Bronze Scarab
		[20862] = true, --Crystal Scarab
		[20863] = true, --Clay Scarab
		[20864] = true, --Bone Scarab
		[20865] = true, --Ivory Scarab
		[20866] = true, --Azure Idol
		[20867] = true, --Onyx Idol
		[20868] = true, --Lambent Idol
		[20869] = true, --Amber Idol
		[20870] = true, --Jasper Idol
		[20871] = true, --Obsidian Idol
		[20872] = true, --Vermillion Idol
		[20873] = true, --Alabaster Idol
		[20874] = true, --Idol of the Sun
		[20875] = true, --Idol of Night
		[20876] = true, --Idol of Death
		[20877] = true, --Idol of the Sage
		[20878] = true, --Idol of Rebirth
		[20879] = true, --Idol of Life
		[20881] = true, --Idol of Strife
		[20882] = true, --Idol of War
	},
	Naxx = {
		[22373] = true, --Wartorn Leather Scrap
		[22374] = true, --Wartorn Chain Scrap
		[22375] = true, --Wartorn Plate Scrap
		[22376] = true, --Wartorn Cloth Scrap
	},
}

-- local lootIcon, lootName, lootQuantity, lootRarity = GetLootSlotInfo(lootIndex)
-- local found, _, itemColor, itemID, enchantID, suffixID, _, _, _, _, uniqueID, itemName = string.find(lootLink, "^%|c%x%x(%x+)%|Hitem:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)%|h%[(.+)%]%|h%|r$")

function RaidAgent:AutoLootInitialize()
	self.autoMLName = nil
end

function RaidAgent:AutoML()
	local candidateIndex = 1
	while (GetMasterLootCandidate(candidateIndex)) do
		if (strlower(GetMasterLootCandidate(candidateIndex)) == strlower(self.autoMLName)) then
			for lootIndex = GetNumLootItems(), 1, -1 do
				if (LootSlotIsItem(lootIndex)) then
					local _, lootName, _, lootRarity = GetLootSlotInfo(lootIndex)
					if (lootRarity >= GetLootThreshold()) then
						local lootLink = GetLootSlotLink(lootIndex)
						local _, _, _, itemID = string.find(lootLink, L["LootLinkBreakDown"])
						
						local frmLoot = LootFrame
						if (IsAddOnLoaded("XLoot")) then frmLoot = XLootFrame end
						
						if (itemID) then
							local giveAway
							=  ((self.autoLootItems.ZG[tonumber(itemID)])   and (self.db.profile.autoML.ZG))
							or ((self.autoLootItems.AQ[tonumber(itemID)])   and (self.db.profile.autoML.AQ))
							or ((self.autoLootItems.Naxx[tonumber(itemID)]) and (self.db.profile.autoML.Naxx))
							or ((self.autoLootItems.BWL[tonumber(itemID)]) and (self.db.profile.autoML.BWL))
							
							if (self.db.profile.autoML.BoE) then
								RaidAgentGameTooltip:SetLootItem(lootIndex)
								for i = 1, 3 do
								  local mytext = getglobal("RaidAgentGameTooltipTextLeft" .. i)
								  local text = mytext:GetText()
								  if (text == L["Binds when equipped"]) then
								  	giveAway = true
								  	break
								  end
								end
							end
							
							if (giveAway) then
								self:AnnounceLoot( self:GoFigure(L["AutoLoot"], { ["Link"] = lootLink, ["PlayerName"] = GetMasterLootCandidate(candidateIndex) }) )
								GiveMasterLoot(lootIndex, candidateIndex)
							end
						end
					end
				end
			end
		  break
		end
		candidateIndex = candidateIndex + 1
	end
end

function RaidAgent:RandomML()
	math.randomseed(math.random(0,2147483647)+(GetTime()*1000));
	
	for lootIndex = GetNumLootItems(), 1, -1 do
		if (LootSlotIsItem(lootIndex)) then
			local _, lootName, _, lootRarity = GetLootSlotInfo(lootIndex)
			if (lootRarity >= GetLootThreshold()) then
				local lootLink = GetLootSlotLink(lootIndex)
				local _, _, _, itemID = string.find(lootLink, L["LootLinkBreakDown"])
				if (itemID) then
					local giveAway
					=  ((self.autoLootItems.MC[tonumber(itemID)])   and (self.db.profile.autoML.MC))
					or ((self.autoLootItems.BWL[tonumber(itemID)])   and (self.db.profile.autoML.BWL))
					or ((self.autoLootItems.ZG[tonumber(itemID)])   and (self.db.profile.autoML.ZG))
					or ((self.autoLootItems.AQ[tonumber(itemID)])   and (self.db.profile.autoML.AQ))
					or ((self.autoLootItems.Naxx[tonumber(itemID)]) and (self.db.profile.autoML.Naxx))
					
					if (self.db.profile.autoML.BoE) then
						RaidAgentGameTooltip:SetLootItem(lootIndex)
						for i = 1, 3 do
						  local mytext = getglobal("RaidAgentGameTooltipTextLeft" .. i)
						  local text = mytext:GetText()
						  if (text == L["Binds when equipped"]) then
						  	giveAway = true
						  	break
						  end
						end
					end
					
					if (giveAway) then
						local candidateIndex = self:GetCandidateIndex()
						
						self:AnnounceLoot( self:GoFigure(L["RandomLoot"], { ["Link"] = lootLink, ["PlayerName"] = GetMasterLootCandidate(candidateIndex), ["Num"] = candidateIndex }) )
						GiveMasterLoot(lootIndex, candidateIndex)
					end
				end
			end
		end
	end
end

function RaidAgent:GetCandidateIndex()
	local rVal
	while (true) do
		local randomMax = 1
		if (self:PlayerInRaid()) then
			randomMax = GetNumRaidMembers()
		elseif (self:PlayerInParty()) then
			randomMax = GetNumPartyMembers()
		end
		
		local randomNumber = math.random(randomMax)
		local candidateIndex = 1
		while (GetMasterLootCandidate(candidateIndex)) do
			if (candidateIndex == randomNumber) then
				rVal = candidateIndex
				break
			end
			candidateIndex = candidateIndex + 1
		end
		if (rVal) then break end
	end
	return rVal
end

function RaidAgent:AnnounceLoot(msg)
	if (self:PlayerInRaid()) then
		SendChatMessage(msg, "RAID")
	else
		SendChatMessage(msg, "PARTY")
	end
end