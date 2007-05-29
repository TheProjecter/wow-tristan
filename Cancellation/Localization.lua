local L = AceLibrary("AceLocale-2.2"):new("Cancellation")

L:RegisterTranslations("enUS", function() return {
	["addonname"] = "Tristan's Cancellation |cff7fff7f -Ace2-|r",
	["author"] = "Tristan - Frostmane.eu",
	["translator"] = "Using translation by: Tristan - Frostmane.eu",
	["consolecommands"] = {"/Cancellation", "/cancel", "/canc"},
	
	["RegExToIgnoreDuration"] = "(.*) remaining",
	
	["Menu"] = "Buff Menu",
	["Show Menu"] = "Show buff menu",
	["Clean up Tables"] = true,
	["Cleans up the tables and deletes unused data"] = true,
	["Set Categories"] = true,
	["ReCategorize"] = true,
	["This clears all categories\nTo only clear from one buff set that to empty"] = true,
	["Clean up the DB"] = true,
	["v1"] = true,
	["Cleans up stuff obsolete from v1 that may still linger in your SavedVariables"] = true,
	
	["Set All"] = true,
	["Sets the option for all buffs in this category"] = "\nSets the option for all buffs in this category! Will only set it for items currently in this category!",
	
	["01. Do Nothing"] = true,
	["02. Fire an alert in the chat"] = true,
	["03. Fire an alert on the screen"] = true,
	["04. Auto-Cancel it"] = true,
	["05. Auto-Cancel it and log"] = true,
	
	["|cffff7f7f{n}|r is not an allowed Category, please try again"] = true,
	["Set the category to {c} to hide it from the interface"] = "\nSet the category to {c} to hide it from the interface! Hidden buffs will never be alerted or Autocanceled",
	["Category: {c}"] = true,
	
	["AlertMessage"] = "|cff7fff7f{c}|r|cffff7f7f{b}|r|cff7fff7f{a}|r",
	[" detected"] = true,
} end)