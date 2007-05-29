local L = AceLibrary("AceLocale-2.2"):new("T_RPP")

L:RegisterTranslations("enUS", function() return {
	["addonname"] = "Tristan's RPP/DKP Values |cff7fff7f -Ace2-|r",
	["author"] = "Tristan - Frostmane.eu",
	["translator"] = "Using translation by: Tristan - Frostmane.eu",
	
	["Enabled"] = true,
	["Disabled"] = true,
	
	["Title RPP"] = true,
  ["Toggles the display of RPP Values in title(/end of tooltip)"] = true,
  
  ["Update"] = true,
  ["Update value for an item (Usage: /trpp update [Item Link] #)"] = true,
  ["[Item Link] <value>"] = true,
  ["Added Item: %s - Value:%d"] = true,
  ["Purge"] = true,
  ["Clear collected data (joining a new guild?)"] = true,
  ["Database has been purged!"] = true,
  
  ["* RPP/DKP: "] = true,
  
  ["Load Ghost DKP Data"] = true,
  ["Load saved values for <Ghost> on Frostmane.eu"] = true,
  ["Load Omen DKP Data"] = true,
  ["Load saved values for <Omen> on Frostmane.eu"] = true,
  ["Load Ashes DKP Data"] = true,
  ["Load saved values for <Ashes> on Frostmane.eu"] = true,
  ["Load Grief DKP Data"] = true,
  ["Load saved values for <Grief> on Frostmane.eu"] = true,
	
} end)