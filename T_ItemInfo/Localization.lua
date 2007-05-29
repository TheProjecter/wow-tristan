--[[ More text to be translated in Tables.lua (ItemID's to Info) keept in separate file for simplicity  ]]
local L = AceLibrary("AceLocale-2.2"):new("T_ItemInfo")

L:RegisterTranslations("enUS", function() return {
	["addonname"] = "Tristan's ItemInfo |cff7fff7f -Ace2-|r",
	["author"] = "Tristan - Frostmane.eu",
	["translator"] = "Using translation by: Tristan - Frostmane.eu",
	["consolecommands"] = {"/ItemInfo", "/tii"},
	
	["stackInfo"] = "Stack Information",
	["stackInfo_desc"] = "Shows information about stacking in tooltips",
	["itemID"] = "Item ID",
	["itemID_desc"] = "Show the ItemID in tooltip",
	["itemLevel"] = "Item Level",
	["itemLevel_desc"] = "Show the ItemLevel in tooltip",
	["preLoaded"] = "PreLoaded Data",
	["preLoaded_desc"] = "Shows some handy information in tooltips",
} end)