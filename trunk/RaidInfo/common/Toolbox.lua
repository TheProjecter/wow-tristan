local L = AceLibrary("AceLocale-2.2"):new("RaidInfo")
local PC = AceLibrary("PaintChips-2.0")

PC:RegisterColor("Tristan", "e6cc80")

function RaidInfo:SetHexColor(color, expression)
	if (PC:GetHex(color)) then
		color = PC:GetHex(color)
	else
		if (not string.find(color, "%x%x%x%x%x%x")) then
			return expression
		end
	end
	
	return "|cff"..color..expression.."|r"
end

function RaidInfo:FancyName()
	local Title = GetAddOnMetadata("RaidInfo", "Title")
	local Author = self:SetHexColor("Tristan", self:AuthorOwner())
	local Ace = "|cff7fff7f -Ace2-|r"
	Title = self:SetHexColor("Tristan", self:Trim(string.gsub(Title, "%|cff7fff7f %-Ace2%-%|r$", "")))
	
	if (self.tAuthorInDD) then Author = "" end
	
	return self:Trim(self:GoFigure(L["fancyname"], { ["Author"] = Author, ["Title"] = Title, ["Ace"] = Ace}))
end

function RaidInfo:FuName()
	local AddOnName = self:Trim(string.gsub(GetAddOnMetadata("RaidInfo", "Title"), "%|cff7fff7f %-Ace2%-%|r$", ""))
	if (self.tAddFuToTitle) then
		return self:SetHexColor("ItemQuality4", AddOnName).."|cff00ff00Fu|r"
	else
		return self:SetHexColor("ItemQuality4", AddOnName)
	end
end

function RaidInfo:StripColors(expression)
	expression = string.gsub(expression, "%|c%x%x%x%x%x%x%x%x", "")
	expression = string.gsub(expression, "%|r", "")
	return expression
end

function RaidInfo:Trim(expression)
	return string.gsub(expression, "^%s*(.-)%s*$", "%1")
end

function RaidInfo:TrimAny(expression, argument)
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

function RaidInfo:GoFigure(expression, insert)
	if (type(insert) == "table") then
		for key, value in pairs(insert) do
			expression = ( gsub(expression, "{"..key.."}", value) )
		end
		return expression
	else
		return ( gsub(expression, "{$}", insert) )
	end
end

function RaidInfo:AuthorOwner()
	return self:DoOwnage(GetAddOnMetadata("RaidInfo", "Author"))
end

function RaidInfo:DoPlural(expression)
	local rVal = expression
	if (not string.find(string.lower(rVal), "s", -1)) then rVal = rVal.."s" end
	return rVal
end

function RaidInfo:DoOwnage(expression)
	local rVal = expression
	if (string.find(string.lower(self.author), "s", -1)) then rVal = rVal.."'" else rVal = rVal.."'s" end
	return rVal
end

function RaidInfo:PlayerInRaid()
	return UnitInRaid("player")
end

function RaidInfo:PlayerInParty()
	return (GetNumPartyMembers() > 0)
end

function RaidInfo:IsInBattleground()
	local inInstance, instanceType = IsInInstance() 
	
	if (instanceType == "pvp") then return true else return false end
	-- Prolly don't work with arena but w/e
end

function RaidInfo:CurrentGroupType()
	if (self:IsInBattleground()) then
		return "BATTLEGROUND"
	elseif (self:PlayerInRaid()) then
		return "RAID"
	elseif (self:PlayerInParty()) then
		return "PARTY"
	--[[elseif (IsInGuild()) then
		return "GUILD"]]
	end
	
	return nil
end

function RaidInfo:GetNumGroupMembers()
	if (self:IsInBattleground()) then
		return GetNumRaidMembers()
	elseif (self:PlayerInRaid()) then
		return GetNumRaidMembers()
	elseif (self:PlayerInParty()) then
		return (GetNumPartyMembers() + 1) -- +1 as to include the player
	--[[elseif (IsInGuild()) then
		return GetNumGuildMembers(false)]]
	end
	
	return nil
end

function RaidInfo:GetGroupRosterInfo(groupIndex)
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
	--[[elseif (IsInGuild()) then
		name, _, _, level, class, zone, _, _, online = GetGuildRosterInfo(groupIndex)
		rank = 0
		subgroup = 0
		-- isDead
		if L:HasReverseTranslation(class) then fileName = L:GetReverseTranslation(class) end]]
	end
	
	return name, rank, subgroup, level, class, fileName, zone, online, isDead
end

function RaidInfo:GetFormattedTime(secs)
	if secs >= 86400 then
		return floor(secs / 86400 + 0.5) .. "d", mod(secs, 86400)
	elseif secs >= 3600 then
		return floor(secs / 3600 + 0.5) .. "h", mod(secs, 3600)
	elseif secs >= 180 then
		return floor(secs / 60 + 0.5) .. "m", mod(secs, 60)
	elseif secs >= 60 then
		return format("%d:%02d", floor(secs / 60), mod(secs, 60)), secs - floor(secs)
	end
	return floor(secs + 0.5), secs - floor(secs)
end