--[[ *** Localization *** ]]
local L = AceLibrary("AceLocale-2.2"):new("DeclineDuel")

L:RegisterTranslations("enUS", function() return {
	["AuthorPrefix"] = "Author: ",
	["VersionPrefix"] = "Author: ",
	
	["active_name"] = "Active",
	["active_desc"] = "Turn declines on and off",
	["quietMode_name"] = "Quiet Mode",
	["quietMode_desc"] = "Disables telling contestants you don't want to duel",
	["pmsMode_name"] = "PMS Mode",
	["pmsMode_desc"] = "Enables nastier afk/dnd messages!",
	["Messages"] = true,
	["messagesSubgroup_name"] = "Message settings",
	["messagesSubgroup_desc"] = "Here you can set the different messages",
	["msgNormal_name"] = "Normal",
	["msgNormal_desc"] = "Message sent under normal circumstances",
	["msgAFK_name"] = "AFK",
	["msgAFK_desc"] = "Message sent when AFK",
	["msgDND_name"] = "DND",
	["msgDND_desc"] = "Message sent when DND",
	["test_name"] = "Test",
	["test_desc"] = "Test partially by invoking the duel procedure with yourself as contestant ;)",
	
	["chatcommands"] = { "/dd", "/DeclineDuel", "/decd" },
} end)

--[[ *** Create Ace2 AddOn *** ]]
DeclineDuel = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0")

DeclineDuel.imbaColor = "e6cc80"
DeclineDuel.msgSuffix = " (This message is automated by an AddOn called DeclineDuel)"
DeclineDuel:RegisterDB("DeclineDuelDB")
DeclineDuel:RegisterDefaults('char', {
	active = true,
	beQuiet = false,
})
DeclineDuel:RegisterDefaults('profile', {
	PMS = true,
	normal = "I do not wish to participate in duelling!",
	afk = "Check my status??? AWAY FROM KEYBOARD!!!",
	dnd = "Check my status??? DO NOT DISTURB!!!",
})

--[[ *** Initialize the AddOn *** ]]
function DeclineDuel:OnInitialize()
	self.options = {
		type = "group",
		args = {
	  	headerName = {
				type = "header",
				name = "|cff"..self.imbaColor.."DeclineDuel|r |cff7fff7f -Ace2-|r",
				icon = "Interface\\Icons\\INV_Fabric_MoonRag_Primal",
				iconHeight = 16,
				iconWidth = 16,
				order = 1,
			},
			headerAuthor = {
				type = "header",
				name = "|cff"..self.imbaColor..L["AuthorPrefix"].."Tristan|r",
				order = 2,
			},
			headerVersion = {
				type = "header",
				name = "|cff"..self.imbaColor..L["VersionPrefix"].."1.0|r",
				order = 3,
			},
			headerspacer = {
				type = "header",
				order = 4,
			},
			active = {
				type = "toggle",
				name = L["active_name"],
				desc = L["active_desc"],
			  get = function() return self.db.char.active end,
			  set = function() self.db.char.active = not self.db.char.active end,
			  order = 5,
			},
			quietMode = {
				type = "toggle",
				name = L["quietMode_name"],
				desc = L["quietMode_desc"],
			  get = function() return self.db.char.beQuiet end,
			  set = function() self.db.char.beQuiet = not self.db.char.beQuiet end,
			  order = 6,
			},
			pmsMode = {
				type = "toggle",
				name = L["pmsMode_name"],
				desc = L["pmsMode_desc"],
			  get = function() return self.db.profile.PMS end,
			  set = function() self.db.profile.PMS = not self.db.profile.PMS end,
			  order = 6,
			},
			messagesSubgroup = {
				type = "group",
				name = L["messagesSubgroup_name"],
				desc = L["messagesSubgroup_desc"],
				order = 7,
				args = {
					headerMessages = {
						type = "header",
						name = "|cff"..self.imbaColor..L["Messages"].."|r",
						order = 1,
					},
					normal = {
						type = "text",
						name = L["msgNormal_name"],
						desc = L["msgNormal_desc"],
					  get = function() return self.db.profile.normal end,
					  set = function(newMsg) self.db.profile.normal = newMsg end,
					  usage = "<Any string>",
					  order = 2,
					},
					afk = {
						type = "text",
						name = L["msgAFK_name"],
						desc = L["msgAFK_desc"],
					  get = function() return self.db.profile.afk end,
					  set = function(newMsg) self.db.profile.afk = newMsg end,
					  usage = "<Any string>",
					  order = 3,
					},
					dnd = {
						type = "text",
						name = L["msgDND_name"],
						desc = L["msgDND_desc"],
					  get = function() return self.db.profile.dnd end,
					  set = function(newMsg) self.db.profile.dnd = newMsg end,
					  usage = "<Any string>",
					  order = 4,
					},
				},
			},
			headertest = {
				type = "header",
				order = 8,
			},
			test = {
				type = "execute",
				name = L["test_name"],
				desc = L["test_desc"],
			  func = function() self:DUEL_REQUESTED(UnitName("player")) end,
				order = 9,
			},
		},
	}
	
	self:RegisterChatCommand(L["chatcommands"], self.options)
end

function DeclineDuel:OnEnable()
	self:RegisterEvent("DUEL_REQUESTED")
end

function DeclineDuel:OnDisable()
  self:UnregisterAllEvents()
end

--[[ EVENT Functions ]]
function DeclineDuel:DUEL_REQUESTED(opponentName)
	if (not self.db.char.active) then return end
	
	CancelDuel()
	
	if (self.db.profile.beQuiet) then return end
	
	if (UnitIsDND("player") and self.db.profile.PMS) then
		SendChatMessage(self.db.profile.dnd..self.msgSuffix, "WHISPER", GetDefaultLanguage("player"), opponentName)
	elseif (UnitIsAFK("player") and self.db.profile.PMS) then
		SendChatMessage(self.db.profile.afk..self.msgSuffix, "WHISPER", GetDefaultLanguage("player"), opponentName)
	else
		SendChatMessage(self.db.profile.normal..self.msgSuffix, "WHISPER", GetDefaultLanguage("player"), opponentName)
	end
end
