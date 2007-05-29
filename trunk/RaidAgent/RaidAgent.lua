local L = AceLibrary("AceLocale-2.2"):new("RaidAgent")
local deformatter = AceLibrary("Deformat-2.0")

--[[ *** Create Ace2 AddOn *** ]]
RaidAgent = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "FuBarPlugin-2.0")
RaidAgent.tConsole = true
RaidAgent.tFubar = true
RaidAgent.tTitleIcon = "Interface\\Icons\\Spell_Shadow_UnstableAffliction_3"
RaidAgent.tAddFuToTitle = false
RaidAgent.tAuthorInDD = true
RaidAgent.tVersionInDD = true

--[[ Register a DB for saving ]]
RaidAgent:RegisterDB("RaidAgentDB")
RaidAgent:RegisterDefaults('profile', {
	RaidStrength = true,
	RaidNumbersFu = false,
	autoML = {
		BoE = false,
		MC = false,
		BWL = false,
		ZG = false,
		AQ = false,
		Naxx = false,
	},
	autoLootQuiet = false,
})

--[[ *** Initialize the AddOn *** ]]
function RaidAgent:OnInitialize()
	--[[ Get revision, and fill special strings ]]
	_, _, self.majorVersion, self.minorVersion, self.revisionVersion = string.find(self.version, "(%d+)%.(%d+)%.(%d+)")
	_, _, self.lastUpdateDate = string.find(GetAddOnMetadata("RaidAgent", "X-LastUpdate"), "(%d+%-%d+%-%d+ %d+%:%d+)")
	self.PlayerName = UnitName("player")
	
	--[[ Register chat commands ]]
  self.options = self:BuildOptions()
  if (self.tConsole) then self:RegisterChatCommand(L["consolecommands"], self.options) end
  
  --[[ Call More Initialize ]]
  self:FuInitialize()
  self:CensusInitialize()
  self:AutoLootInitialize()
  self:RaidInitialize()
  
  --[[ Tell user we have loaded ]]
  self:Print( self:GoFigure(L["load_message"], { ["FancyName"] = self:FancyName(), ["Version"] = self.version, ["Translator"] = L["translator"] }) )
end

function RaidAgent:RaidInitialize()
	self.raidRank = 0
	if (self:PlayerInRaid()) then
		for raidIndex=1, GetNumRaidMembers() do
			local name, rank = GetRaidRosterInfo(raidIndex)
			if (name == self.PlayerName) then
				self.raidRank = rank
				self:Print( self:GoFigure(L["LoggedIntoRaid"], self.RaidRankStrings[rank]) )
				break
			end
		end
	end
end

function RaidAgent:OnEnable()
	-- self:SetDebugging(true)
	self.knowledgeBase = nil -- Clear knowledge base
	self.knowledgeBase = { } -- Clear knowledge base
	
	self:RegisterEvent("PARTY_LEADER_CHANGED")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
	self:RegisterEvent("RAID_ROSTER_UPDATE")
	self:RegisterEvent("GUILD_ROSTER_UPDATE")
	self:RegisterEvent("PLAYER_GUILD_UPDATE")
	self:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
	self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("LEARNED_SPELL_IN_TAB")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("LOOT_OPENED")
	
	self:UpdateOwnCensusData()
	self:ScheduleEvent("OneTimePing", self.Ping, 5, self)
	self:ScheduleRepeatingEvent("Ping", self.Ping, 300, self)
end

function RaidAgent:OnDisable()
  self:UnregisterAllEvents()
end

--[[ EVENT Functions ]]
function RaidAgent:PARTY_LEADER_CHANGED()
	self:Update()
end

function RaidAgent:PARTY_MEMBERS_CHANGED()
	if ((not self:PlayerInRaid()) and (not self:PlayerInParty())) then
		self.masterLooter = nil
	end
	self:Update()
end

function RaidAgent:RAID_ROSTER_UPDATE()
	self:Update()
	
	--[[ Find out my rank ]]
	local newRank = -1
	for raidIndex=1, GetNumRaidMembers() do
		local name, rank = GetRaidRosterInfo(raidIndex)
		if (name == self.PlayerName) then
			if (rank ~= self.raidRank) then
				self:Print( self:GoFigure(L["NewRaidRank"], self.RaidRankStrings[rank]) )
				self.raidRank = rank
			end
			break
		end
	end
end

function RaidAgent:PLAYER_GUILD_UPDATE()
	self:Update()
end

function RaidAgent:GUILD_ROSTER_UPDATE()
	self:Update()
end

function RaidAgent:PARTY_LOOT_METHOD_CHANGED()
	if ((GetLootMethod()) ~= "master") then self.masterLooter = nil end
	self:Update()
	self:ScheduleEvent("OneTimeMLAnnounce", self.MLAnnounce, 15, self)
	self:ScheduleRepeatingEvent("MLAnnounce", self.MLAnnounce, 300, self)
end

function RaidAgent:MLAnnounce()
	if (not self:PlayerInRaid()) then -- Not in raid
		self:CancelScheduledEvent("MLAnnounce")
		return
	end
	
	local lootmethod, masterlooterID = GetLootMethod()
	if (lootmethod ~= "master") then -- Loot Type is not Master Looter
		self:CancelScheduledEvent("MLAnnounce")
		return
	elseif (masterlooterID ~= 0) then -- I am not Master Looter
		self:CancelScheduledEvent("MLAnnounce")
		return
	end
	
	--SendAddonMessage("RaidAgent", "ml", "RAID")
	self:SendAddonMessage("ml")
end

function RaidAgent:CHAT_MSG_SYSTEM()
	MasterLooter = deformatter(arg1, ERR_NEW_LOOT_MASTER_S)
	if MasterLooter then
		self.masterLooter = MasterLooter
		self:Update()
	end
	
	if ((arg1 == ERR_RAID_YOU_LEFT) or (arg1 == ERR_LEFT_GROUP_YOU) or (arg1 == ERR_GROUP_DISBANDED)) then
		self.masterLooter = nil
		self.knowledgeBase = { } -- Clear knowledge base
		self:Update()
	end
	
	if (arg1 == ERR_RAID_YOU_JOINED) then
		self:UpdateOwnCensusData()
	end
end

function RaidAgent:CHAT_MSG_ADDON(prefix, message, distributionType, sender)
	if ((prefix == self.name) and (distributionType == self:CurrentGroupType())) then
		local First, Last = strsplit(" ", message ,2)
		First = strlower(First)
		if (First == "data") then
			if (not self.census) then self.census = { } end
			self.census[sender] = Last
			self:UpdateCensusInfo(Last)
			self:Update()
		elseif (First == "sync") then
			self:UpdateOwnCensusData()
			self:Update()
		elseif (First == "ml") then
			if (not self.masterLooter) then self.masterLooter = sender end
			self:Update()
		end
	end
end

function RaidAgent:LEARNED_SPELL_IN_TAB()
	self:UpdateOwnCensusData()
end

function RaidAgent:PLAYER_REGEN_DISABLED()
	self.regenDisabled = true
	self.inCombat = true
end

function RaidAgent:PLAYER_REGEN_ENABLED()
	self.regenDisabled = false
	self.inCombat = false
end

function RaidAgent:LOOT_OPENED(...)
	local lootmethod, masterlooterID = GetLootMethod()
	if (lootmethod ~= "master") then return end
	if (masterlooterID ~= 0) then return end
	
	if (self.autoMLName) then
		self:AutoML(...)
	elseif (self.randomML) then
		self:RandomML(...)
	end
end