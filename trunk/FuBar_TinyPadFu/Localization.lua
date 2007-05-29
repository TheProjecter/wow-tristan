local L = AceLibrary("AceLocale-2.2"):new("FuBar_TinyPadFu")

L:RegisterTranslations("enUS", function() return {
	["AuthorPrefixed"] = "Author: {$}",
	["VersionPrefixed"] = "Version: {$}",
	["LastUpdatePrefixed"] = "Last Update: {$}",
	["fancyname"] = "{Author} {Title} {Ace}",
	
	["addonname"] = "|cffffffffTinyPad|r|cff00ff00Fu|r |cff7fff7f -Ace2-|r",
	["addonnameFu"] = "TinyPad",
	["author"] = "Tristan - Frostmane.eu",
	["translator"] = "Using translation by: Tristan - Frostmane.eu",
	["consolecommands"] = { },
	
	["TinyPad Pages"] = true,
	["<Empty>"] = true,
	["Script"] = "Script [|cffffffff{t}|r]",
	["Icon"] = true,
	["Select Icon For FuBar"] = true,
	["TabletPageNum"] = "Page {i}:",
	["TinyPadError"] = "|cffff0000Page {i} doesn't exist|r",
	["SplitError"] = "delimiter matches empty string!",
	["FuBarHint"] = "Click to toggle TinyPad\nClick a page: Edit that page\nShift-Click a page: Run that page as script\nAlt-Click a page: Delete that page\n\n'--[[ <Title> ]]' as the first row works as a title for script pages!",
	
} end)