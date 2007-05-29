local L = AceLibrary("AceLocale-2.2"):new("TGuildFrame")

L:RegisterTranslations("enUS", function() return {
	
	--[[ Crappy GetGuildRosterInfo doesn't return englishClass WTF? ]]
	["Druid"] = "DRUID",
	["Hunter"] = "HUNTER",
	["Mage"] = "MAGE",
	["Paladin"] = "PALADIN",
	["Priest"] = "PRIEST",
	["Rogue"] = "ROGUE",
	["Shaman"] = "SHAMAN",
	["Warlock"] = "WARLOCK",
	["Warrior"] = "WARRIOR",
	
} end)