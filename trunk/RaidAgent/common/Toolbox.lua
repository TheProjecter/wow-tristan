--[[ WORK IN PROGRESS, PLEASE DO NOT ALTER FILES YET ]]
local L = AceLibrary("AceLocale-2.2"):new("RaidAgent")
local PC = AceLibrary("PaintChips-2.0")

PC:RegisterColor("censusred", "ff3333")
PC:RegisterColor("censusorange", "ff9933")
PC:RegisterColor("censusgreen", "33ff33")
PC:RegisterColor("Tristan", "e6cc80")

RaidAgent.RaidRankStrings = { [0] = "Raid Member", [1] = "Raid Officer", [2] = "Raid Leader" }

function RaidAgent:SetHexColor(color, expression)
	if (PC:GetHex(color)) then
		color = PC:GetHex(color)
	else
		if (not string.find(color, "%x%x%x%x%x%x")) then
			return expression
		end
	end
	
	return "|cff"..color..expression.."|r"
end

function RaidAgent:FancyName()
	-- ["fancyname"] = "{author} {addon} {ace}",
	local Title = GetAddOnMetadata("RaidAgent", "Title")
	local Author = self:SetHexColor("Tristan", self:AuthorOwner())
	local Ace = "|cff7fff7f -Ace2-|r"
	Title = self:SetHexColor("Tristan", self:Trim(string.gsub(Title, "%|cff7fff7f %-Ace2%-%|r$", "")))
	
	if (self.tAuthorInDD) then Author = "" end
	
	return self:Trim(self:GoFigure(L["fancyname"], { ["Author"] = Author, ["Title"] = Title, ["Ace"] = Ace}))
end

function RaidAgent:FuName()
	local AddOnName = self:Trim(string.gsub(GetAddOnMetadata("RaidAgent", "Title"), "%|cff7fff7f %-Ace2%-%|r$", ""))
	if (self.tAddFuToTitle) then
		return self:SetHexColor("ItemQuality4", AddOnName).."|cff00ff00Fu|r"
	else
		return self:SetHexColor("ItemQuality4", AddOnName)
	end
end

function RaidAgent:PlayerNameCase(expression)
	if (expression) then
		if (strlen(expression) < 2) then
			expression = nil
		else
			expression = strupper(strsub(expression, 1, 1))..strlower(strsub(expression, 2))
		end
	end
	
	return expression
end

function RaidAgent:StripColors(expression)
	expression = string.gsub(expression, "%|c%x%x%x%x%x%x%x%x", "")
	expression = string.gsub(expression, "%|r", "")
	return expression
end

function RaidAgent:Trim(expression)
	return string.gsub(expression, "^%s*(.-)%s*$", "%1")
end

function RaidAgent:TrimAny(expression, argument)
	argument = string.sub(argument, 1, 1)
	local startAt = 1
  while strsub(expression, startAt, 1) == argument do
    startAt = startAt + 1
  end
  local endAt = strlen(expression)
  while strsub(expression, endAt, endAt) == argument do
    endAt = endAt - 1
  end
  return strsub(expression, startAt, endAt)
end

function RaidAgent:GoFigure(expression, insert)
	if (type(insert) == "table") then
		for key, value in pairs(insert) do
			expression = ( gsub(expression, "{"..key.."}", value) )
		end
		return expression
	else
		return ( gsub(expression, "{$}", insert) )
	end
end

function RaidAgent:Split(text, delimiter)
  local list = {}
  local pos = 1
  
  if strfind("", delimiter, 1) then -- this would result in endless loops
    error("delimiter matches empty string!")
  end
  while 1 do
    local first, last = strfind(text, delimiter, pos)
    if first then -- found?
      tinsert(list, strsub(text, pos, first-1))
      pos = last+1
    else
      tinsert(list, strsub(text, pos))
      break
    end
  end
  return list
end

function RaidAgent:AuthorOwner()
	return self:DoOwnage(GetAddOnMetadata("RaidAgent", "Author"))
end

function RaidAgent:DoPlural(expression)
	local rVal = expression
	if (not string.find(string.lower(rVal), "s", -1)) then rVal = rVal.."s" end
	return rVal
end

function RaidAgent:DoOwnage(expression)
	local rVal = expression
	if (string.find(string.lower(self.author), "s", -1)) then rVal = rVal.."'" else rVal = rVal.."'s" end
	return rVal
end

function RaidAgent:PlayerInRaid()
	return UnitInRaid("player")
end

function RaidAgent:PlayerInParty()
	return (GetNumPartyMembers() > 0)
end

function RaidAgent:IsInBattleground()
	local inInstance, instanceType = IsInInstance() 
	
	if (instanceType == "pvp") then return true else return false end
	-- Prolly don't work with arena but w/e
end

function RaidAgent:SendAddonMessage(text, prefix)
--SendAddonMessage("prefix", "text", "PARTY|RAID|GUILD|BATTLEGROUND")
	if (not prefix) then prefix = self.name end
	local type = self:CurrentGroupType()
	if (type) then
		SendAddonMessage(prefix, text, type)
	end
end

function RaidAgent:CurrentGroupType()
	if (self:IsInBattleground()) then
		return "BATTLEGROUND"
	elseif (self:PlayerInRaid()) then
		return "RAID"
	elseif (self:PlayerInParty()) then
		return "PARTY"
	elseif (IsInGuild()) then
		return "GUILD"
	end
	
	return nil
end

function RaidAgent:GetNumGroupMembers()
	if (self:IsInBattleground()) then
		return GetNumRaidMembers()
	elseif (self:PlayerInRaid()) then
		return GetNumRaidMembers()
	elseif (self:PlayerInParty()) then
		return (GetNumPartyMembers() + 1) -- +1 as to include the player
	elseif (IsInGuild()) then
		return GetNumGuildMembers(false)
	end
	
	return nil
end

function RaidAgent:GetGroupRosterInfo(groupIndex)
	local name, rank, subgroup, level, class, fileName, zone, online, isDead = nil, nil, nil, nil, nil, nil, nil, nil, nil
	local realm
	
	if (self:IsInBattleground()) then
		name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(groupIndex)
		name, realm = UnitName("raid"..groupIndex)
		if (realm) then name = name.."-"..realm end
	elseif (self:PlayerInRaid()) then
		name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(groupIndex)
	elseif (self:PlayerInParty()) then
		local unitID = "party"..groupIndex
		if (groupIndex > GetNumPartyMembers()) then unitID = "player" end
		rank = 0
		subgroup = 1
		
		name = UnitName(unitID)
		if (UnitIsPartyLeader(unitID)) then rank = 2 end
		level = UnitLevel(unitID)
		class, fileName = UnitClass(unitID)
		-- zone
		online = UnitIsConnected(unitID)
		isDead = UnitIsDead(unitID)
	elseif (IsInGuild()) then
		name, _, _, level, class, zone, _, _, online = GetGuildRosterInfo(groupIndex)
		rank = 0
		subgroup = 0
		-- isDead
		if L:HasReverseTranslation(class) then fileName = L:GetReverseTranslation(class) end
	end
	
	return name, rank, subgroup, level, class, fileName, zone, online, isDead
end