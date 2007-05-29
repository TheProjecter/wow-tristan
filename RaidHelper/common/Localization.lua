local L = AceLibrary("AceLocale-2.2"):new("RaidHelper")

L:RegisterTranslations("enUS", function() return {
	["AuthorPrefixed"] = "Author: {$}",
	["VersionPrefixed"] = "Version: {$}",
	["LastUpdatePrefixed"] = "Last Update: {$}",
	["NameHeading"] = "{Author} {Title} {Ace}",
	["Translator"] = "Tristan-Frostmane[EU]",
	["StartMessage"] = "{AddOnName} v{Version} loaded (using translation by: {Translator})",
	["ConsoleCommands"] = {"/RaidHelper", "/rah"},
	
	["leadership_name"] = "Leadership Requests",
	["leadership_desc"] = "Toggle this to off if you don't\nwant to ever obey Leadership\nrequests from your Raid Officers",
	["quietready_name"] = "Don't announce ready checks",
	["quietready_desc"] = "Toggle this to off if you don't\nwant to announce results of\nready checks to the raid",
	["help_name"] = "Help",
	["help_desc"] = "Shows help for Shorthands",
	["opassword_name"] = "Promote Pass",
	["opassword_desc"] = "Set a password for auto-promotion\n(can't start or end with whitespace)",
	["ipassword_name"] = "Invite Pass",
	["ipassword_desc"] = "Set a password for group invites\n(can't start or end with whitespace\nand only works for guildmembers)",
	
	["RDY_AFK"] = "The following players are AFK", -- The following players are AFK: Tristan
	["RDY_NotReady"] = "is not ready", -- Tristan is not ready
	["RDY_AllReady"] = "Everyone is Ready", -- Everyone is Ready
	["RDY_Prefix"] = "(Ready Check Result) ",
	
} end)