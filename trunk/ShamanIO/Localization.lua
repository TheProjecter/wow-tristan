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
	
	["invigorated_cmd"] = "Invigorated",
	["invigorated_desc"] = "Toggle frame for showing when Invigorated is up (Untested)",
	
	["ep_cmd"] = "EP",
	["ep_desc"] = "Toggle showing Equivalence Points in Tooltips",
	["aep_cmd"] = "AEP",
	["aep_desc"] = "Toggle showing Attackpower Equivalence Points in Tooltips",
	["hep_cmd"] = "HEP",
	["hep_desc"] = "Toggle showing Healing Equivalence Points in Tooltips",
	
	["sound_cmd"] = "Sound",
	["sound_desc"] = "Toggle playing sound when a totem expires",
	
	["growpulse_cmd"] = "GrowPulse",
	["growpulse_desc"] = "Toggle growing frame on \"pulses\"",
	
	["borderpulse_cmd"] = "BorderPulse",
	["borderpulse_desc"] = "Toggle coloring border on \"pulses\"",
	
	["alpha_cmd"] = "Alpha",
	["alpha_desc"] = "Alpha for frames",
	
	["alpha_ooc_active_cmd"] = "ActiveOutOfCombat",
	["alpha_ooc_active_desc"] = "Alpha for frames when active and out of combat",
	
	["alpha_ooc_inactive_cmd"] = "InactiveOutOfCombat",
	["alpha_ooc_inactive_desc"] = "Alpha for frames when inactive and out of combat",
	
	["alpha_ic_active_cmd"] = "ActiveInCombat",
	["alpha_ic_active_desc"] = "Alpha for frames when active and in combat",
	
	["alpha_ic_inactive_cmd"] = "InactiveInCombat",
	["alpha_ic_inactive_desc"] = "Alpha for frames when inactive and in combat",
	
	--[[ Strings used for frames ]]--
	["DragToMoveFrame"] = "Click and drag to move frame",
	
	--[[ Warnings ]]--
	["TotemExpiring"] = "%s (%s) expires soon",
	["TotemSlain"] = "%s (%s) was slain!!!",
	["TotemDeath"] = "%s (%s) has expired",
} end )


local L_AEP = AceLibrary("AceLocale-2.2"):new("EnhancerEP")
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
	
	--[[ Sockets as they appear on the tooltip]]--
	["Red Socket"] = true,
	["Blue Socket"] = true,
	["Yellow Socket"] = true,
	["Meta Socket"] = true,
	
	--[[ Tooltip strings ]]--
	["aep_tooltip0"] = "Enhancer AEP (inc BoK): %d (%d)",
	["aep_tooltip1"] = "(Blue) Enhancer AEP (inc BoK): %d (%d)",
	["aep_tooltip2"] = "(Green) Enhancer AEP (inc BoK): %d (%d)",
	["aep_info"] = "AEP model from Tornhoof/Pater",
	
	["hep_tooltip0"] = "Enhancer HEP (inc BoK): %d (%d)",
	["hep_tooltip1"] = "(Blue) Enhancer HEP (inc BoK): %d (%d)",
	["hep_tooltip2"] = "(Green) Enhancer HEP (inc BoK): %d (%d)",
	["hep_info"] = "HEP model from Leion\r(experimental and no gems/sockets yet)",
	
} end )