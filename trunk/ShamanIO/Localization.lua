local L_Main = AceLibrary("AceLocale-2.2"):new("Enhancer")
L_Main:RegisterTranslations("enUS", function() return {
	["lock_cmd"] = "Lock",
	["lock_desc"] = "Locks or Unlocks the frames for positioning",
	
	["reset_cmd"] = "Reset",
	["reset_desc"] = "Reset all positions to default",
	
	["resize_cmd"] = "Size",
	["resize_desc"] = "Set the size of frames",
	
	["windfury_cmd"] = "Windfury",
	["windfury_desc"] = "Toggle frame for showing the \"hidden\" windfury cooldown",
	
	["reincarnation_cmd"] = "Reincarnation",
	["reincarnation_desc"] = "Toggle frame for showing Reincarnation cooldown",
	
	["aep_cmd"] = "AEP",
	["aep_desc"] = "Toggle showing Attackpower Equivalence Points in Tooltips",
	
	--[[ Strings used for frames ]]--
	["DragToMoveFrame"] = "Click and drag to move frame",
	
	--[[ Warnings ]]--
	["TotemExpiring"] = "%s (%s) expires soon",
	["TotemSlain"] = "%s (%s) was slain!!!",
	["TotemDeath"] = "%s (%s) has expired",
} end )


local L_AEP = AceLibrary("AceLocale-2.2"):new("EnhancerAEP")
L_AEP:RegisterTranslations("enUS", function() return {
	
	--[[ ItemTypes ]]--
	["Armor"] = true,
	["Gem"] = true,
	["Weapon"] = true,
	["Projectile"] = true,
	["Quiver"] = true,
	
	--[[ ItemSubTypes ]]--
	["Plate"] = true,
	["Idols"] = true,
	["Librams"] = true,
	["Fishing Pole"] = true,
	["One-Handed Swords"] = true,
	["Polearms"] = true,
	["Two-Handed Swords"] = true,
	["Bows"] = true,
	["Crossbows"] = true,
	["Guns"] = true,
	["Thrown"] = true,
	["Wands"] = true,
	
	--[[ Tooltip string ]]--
	["Enhancement AEP (inc BoK): %d (%d)"] = true,
	
} end )