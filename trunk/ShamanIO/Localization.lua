local L_Main = AceLibrary("AceLocale-2.2"):new("ShamanIO")
L_Main:RegisterTranslations("enUS", function() return {
	["lock_cmd"] = "(Un)Lock",
	["lock_desc"] = "Locks or Unlocks the frames for positioning",
	
	--[[ Strings used for frames ]]--
	["DragToMoveFrame"] = "Click and drag to move frame",
	
	--[[ Warnings ]]--
	["TotemExpiring"] = "%s (%s) expires soon",
	["TotemSlain"] = "%s (%s) was slain!!!",
	["TotemDeath"] = "%s (%s) has expired",
} end )


local L_AEP = AceLibrary("AceLocale-2.2"):new("ShamanIOAEP")
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
	["Enhancement AEP (exc BoK): %d"] = true,
	["Enhancement AEP (inc BoK): %d"] = true,
	
} end )