local L = AceLibrary("AceLocale-2.2"):new("RaidInfo")

L:RegisterTranslations("enUS", function() return {
	["AuthorPrefixed"] = "Author: {$}",
	["VersionPrefixed"] = "Version: {$}",
	["LastUpdatePrefixed"] = "Last Update: {$}",
	["fancyname"] = "{Author} {Title} {Ace}",
	["translator"] = "Tristan-Frostmane[EU]",
	["load_message"] = "{FancyName} v{Version} loaded (using translation by: {Translator})",
	["consolecommands"] = {"/RaInfo", "/RaidInf", "/rai"},
	["fubarTabletHint"] = "When in a party then click to convert to raid\nHint: When in raid click to do a ready check\nHint: You can shift-click to leave a group (also works when bugged)\nHint: Right-click for more options",
	
	["SendInCombat_name"] = "Send In Combat",
	["SendInCombat_desc"] = "Toggle sending of information in combat, if you lag or w/e then turning this off might improve performance",
	["ToggleAnchor_name"] = "Hide CoolDown Anchor",
	["ToggleAnchor_desc"] = "Hides the anchor for the cooldown bars",
	["AutoShow_name"] = "Auto Show",
	["AutoShow_desc"] = "Set what CoolDowns to auto start the Candybar for",
	["UpdateTooltip_name"] = "Auto Update Tooltip",
	["UpdateTooltip_desc"] = "Controls if the AddOn keeps the tooltip up to date constantly or just showing the Cooldown from when you open the tooltip",
	
	["AnchorFrameTitle"] = "Alt-Click to move Anchor",
	
	["TabletCatName"] = "Name",
	["TabletCatSpell"] = "Spell",
	["TabletCatCD"] = "Cooldown",
	
	["FuHintClick"] = "Click to toggle showing a CandyBar for this CoolDown",
	["Nothing to display"] = "Nothing to show",
	["Not grouped"] = "You are not in a group",
	
	--[[ *** CLASSES *** ]]
	["DRUID"] = "Druid",
	["HUNTER"] = "Hunter",
	["MAGE"] = "Mage",
	["PALADIN"] = "Paladin",
	["PRIEST"] = "Priest",
	["ROGUE"] = "Rogue",
	["SHAMAN"] = "Shaman",
	["WARLOCK"] = "Warlock",
	["WARRIOR"] = "Warrior",
	
} end)