--[[ Can't clear password via console as you can't send empty string via console ]]
local L = AceLibrary("AceLocale-2.2"):new("RaidHelper")

--[[ *** Create Ace2 AddOn *** ]]
RaidHelper = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "AceHook-2.1")
RaidHelper.tConsole = true
RaidHelper.tTitleIcon = "Interface\\Icons\\Ability_Druid_Dreamstate"
RaidHelper.tAddFuToTitle = false
RaidHelper.tAuthorInDD = true
RaidHelper.tVersionInDD = true
RaidHelper.addonFolder = "RaidHelper"
RaidHelper.shortHandTable = {};

--[[ Register a DB for saving ]]
RaidHelper:RegisterDB("RaidHelperDB")
RaidHelper:RegisterDefaults('profile', {
	leadership = true,
	quietready = false,
})
RaidHelper:RegisterDefaults('char', {
	opassword = nil,
	ipassword = nil,
})

--[[ *** Initialize the AddOn *** ]]
function RaidHelper:OnInitialize()
	--[[ Get revision, and fill special strings ]]
	_, _, self.majorVersion, self.minorVersion, self.revisionVersion = string.find(self.version, "(%d+)%.(%d+)%.(%d+)")
	_, _, self.lastUpdateDate = string.find(GetAddOnMetadata(self.addonFolder, "X-LastUpdate"), "(%d+%-%d+%-%d+ %d+%:%d+)")
	
	--[[ Register chat commands ]]
  self.options = self:BuildOptions()
  if (self.tConsole) then self:RegisterChatCommand(L["ConsoleCommands"], self.options) end
  
  --[[ Tell user we have loaded ]]
  self:Print(( string.gsub(string.gsub(string.gsub(L["StartMessage"], "{AddOnName}", self:NameHeading()), "{Version}", self.version), "{Translator}", L["Translator"]) ))
end

function RaidHelper:OnEnable()
	self:RegisterEvent("CHAT_MSG_ADDON")
	-- self:RegisterEvent("READY_CHECK")
	self:SecureHook("DoReadyCheck")
	
	self:RegisterShorthand("raswap", function(cmd) self:Swap(cmd) end )
	self:RegisterShorthand("ramove", function(cmd) self:Move(cmd) end )
	self:RegisterShorthand("raprom", function(cmd) self:Promote(cmd) end )
	self:RegisterShorthand("rademo", function(cmd) self:Demote(cmd) end )
	self:RegisterShorthand("ralead", function(cmd) self:Leader(cmd) end )
	self:RegisterShorthand("raredy", function(cmd) self:RdyCheck(cmd) end )
	self:RegisterShorthand("raoffi", function(cmd) self:Officer(cmd) end )
	-- self:RegisterShorthand("rainvi", function(cmd) self:Invite(cmd) end )
	
	self:RegisterShorthand("rapromote", function(cmd) self:Promote(cmd) end )
	self:RegisterShorthand("rademote", function(cmd) self:Demote(cmd) end )
	self:RegisterShorthand("raleader", function(cmd) self:Leader(cmd) end )
	self:RegisterShorthand("rardy", function(cmd) self:RdyCheck(cmd) end )
	self:RegisterShorthand("rchk", function(cmd) self:RdyCheck(cmd) end )
	self:RegisterShorthand("raofficer", function(cmd) self:Officer(cmd) end )
	-- self:RegisterShorthand("rainv", function(cmd) self:Invite(cmd) end )
end

function RaidHelper:OnDisable()
  self:UnregisterAllEvents()
end

function RaidHelper:READY_CHECK()
	-- self:Print("READY_CHECK", arg1, arg2)
end

function RaidHelper:DoReadyCheck()
	--[[ "Starting ready check..." ;) ]]
	if (GetNumRaidMembers() > 0) then
		if ((self:IsEventScheduled("ResultsUnknown"))) then
			self:CancelScheduledEvent("ResultsUnknown")
		end
		
		self.PrintResultsUnknown = true
		
		self:RegisterEvent("CHAT_MSG_SYSTEM")
		self:ScheduleEvent("ResultsUnknown", self.ResultsUnknown, 45, self)
	end
end

function RaidHelper:CHAT_MSG_SYSTEM(message)
	if (self.db.profile.quietready) then return end
	
	if (string.find(message, L["RDY_NotReady"])) then
		SendChatMessage(L["RDY_Prefix"]..message, "RAID")
		self.PrintResultsUnknown = false
	end
	
	if (message == L["RDY_AllReady"]) then
		SendChatMessage(L["RDY_Prefix"]..message, "RAID")
		self.PrintResultsUnknown = false
	end
	
	if (string.find(message, L["RDY_AFK"])) then
		SendChatMessage(L["RDY_Prefix"]..message, "RAID")
		self.PrintResultsUnknown = false
	end
end
function RaidHelper:ResultsUnknown()
	self:UnregisterEvent("CHAT_MSG_SYSTEM")
	if (self.db.profile.quietready) then return end
	
	if (self.PrintResultsUnknown) then
		SendChatMessage(L["RDY_Prefix"].."Last ready check results unknown! Soz.", "RAID")
	end
end

function RaidHelper:RegisterShorthand(shorthand, func)
	if (shorthand and shorthand ~= "") then
		local type = "RAIDHELPER_SHORTHAND_"..strupper(shorthand)
		SlashCmdList[type] = func
		setglobal("SLASH_"..type.."1", "/"..strlower(shorthand))
		self.shortHandTable[shorthand] = 1
	end
end

function RaidHelper:RaidRank(nameORid)
	-- Possible values: 0, 1, 2, nil
	-- 0 is a standard raid member. 1 is a raid Assistant - labeled (A) in the standard raid window. 2 is the Leader of the raid - labeled (L) in the standard raid window.
	if (tonumber(nameORid)) then
		local _, raidRank = GetRaidRosterInfo(nameORid)
		return raidRank
	else
		local retIndex = nil
		if (self:ValidPlayerName(nameORid)) then
			for RaidIndex = 1, GetNumRaidMembers() do
				if (string.lower(UnitName("raid"..RaidIndex)) == string.lower(nameORid)) then retIndex = RaidIndex end
				if (retIndex) then break end
			end
			
			if (retIndex) then
				local _, raidRank = GetRaidRosterInfo(retIndex)
				return raidRank
			end
		end
	end
	return nil
end

function RaidHelper:Name2RaidIndex(name)
	local retIndex = nil
	for RaidIndex = 1, GetNumRaidMembers() do
		if (string.lower(UnitName("raid"..RaidIndex)) == string.lower(name)) then retIndex = RaidIndex end
		if (retIndex) then break end
	end
	return retIndex
end

function RaidHelper:Trim(expression)
	if (not expression) then expression = "" end
	
	return string.gsub(expression, "^%s*(.-)%s*$", "%1")
end

function RaidHelper:ValidPlayerName(name)
	if (name) then
		if (string.len(name) > 1) then
			if ( (string.find(self:UTF8Replace(name), "^%a+$")) ) then
				return true
			end
		end
	end
	return false
end