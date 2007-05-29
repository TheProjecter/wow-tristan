local L = AceLibrary("AceLocale-2.2"):new("RaidInfo")
local deformatter = AceLibrary("Deformat-2.0")

--[[ *** Create Ace2 AddOn *** ]]
RaidInfo = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "CandyBar-2.0", "FuBarPlugin-2.0")

--[[ Register a DB for saving ]]
RaidInfo:RegisterDB("RaidInfoDB")
RaidInfo:RegisterDefaults('profile', {
	SendInCombat = false,
	anchorframehidden = true,
	updatetooltip = false,
})

RaidInfo.tConsole = true
RaidInfo.tFubar = true
RaidInfo.tTitleIcon = "Interface\\Icons\\INV_Misc_EngGizmos_20"
RaidInfo.tAddFuToTitle = false
RaidInfo.tAuthorInDD = true
RaidInfo.tVersionInDD = true

--[[ *** Initialize the AddOn *** ]]
function RaidInfo:OnInitialize()
	--[[ Get revision, and fill special strings ]]
	_, _, self.majorVersion, self.minorVersion, self.revisionVersion = string.find(self.version, "(%d+)%.(%d+)%.(%d+)")
	_, _, self.lastUpdateDate = string.find(GetAddOnMetadata("RaidInfo", "X-LastUpdate"), "(%d+%-%d+%-%d+ %d+%:%d+)")
	self.PlayerName = UnitName("player")
	
	--[[ Register chat commands ]]
  self.options = self:BuildOptions()
  if (self.tConsole) then self:RegisterChatCommand(L["consolecommands"], self.options) end
  
  --[[ More init ]]
  self:FuInitialize()
  
  --[[ Tell user we have loaded ]]
  self:Print( self:GoFigure(L["load_message"], { ["FancyName"] = self:FancyName(), ["Version"] = self.version, ["Translator"] = L["translator"] }) )
end

function RaidInfo:OnEnable()
	self.knowledgeBase = nil -- Clear knowledge base
	self.knowledgeBase = { } -- Clear knowledge base
	
	self:RegisterEvent("RAID_ROSTER_UPDATE", function() self:Update() end)
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", function() self:Update() end)
	self:RegisterEvent("GUILD_ROSTER_UPDATE", function() self:Update() end)
	self:RegisterEvent("PLAYER_GUILD_UPDATE", function() self:Update() end)
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	self:RegisterCandyBarGroup(self.name)
	self:SetupFrames()
	self:CandyBarPosition()
	self:ToggleUpdateTooltip()
	self:ScheduleRepeatingEvent("Ping", self.Ping, 60, self)
end

function RaidInfo:OnDisable()
  self:UnregisterAllEvents()
end

--[[ EVENT Functions ]]
--[[function RaidInfo:RAID_ROSTER_UPDATE()
	self:Update()
end]]

function RaidInfo:PLAYER_REGEN_DISABLED()
	self.regenDisabled = true
	self.inCombat = true
end

function RaidInfo:PLAYER_REGEN_ENABLED()
	self.regenDisabled = false
	self.inCombat = false
end