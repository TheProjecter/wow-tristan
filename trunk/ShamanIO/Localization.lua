local L_Main = AceLibrary("AceLocale-2.2"):new("Enhancer")
L_Main:RegisterTranslations("enUS", function() return {
	["lock_cmd"] = "Lock",
	["lock_desc"] = "Locks or Unlocks the frames for positioning",
	
	["reset_cmd"] = "Reset",
	["reset_desc"] = "Reset all positions to default",
	
	["resize_cmd"] = "Size",
	["resize_desc"] = "Set the size of frames",
	
	["element_group_cmd"] = "ElementFrames",
	["element_group_desc"] = "Toggle element frames on and off",
	["earth_cmd"] = "Earth",
	["fire_cmd"] = "Fire",
	["water_cmd"] = "Water",
	["air_cmd"] = "Air",
	["element_desc"] = "Toggle the frame for all %s totems",
	
	["bonus_group_cmd"] = "BonusFrames",
	["bonus_group_desc"] = "Toggle bonus frames on and off",
	["windfury_cmd"] = "Windfury",
	["windfury_desc"] = "Toggle frame for showing the \"hidden\" windfury cooldown",
	["reincarnation_cmd"] = "Reincarnation",
	["reincarnation_desc"] = "Toggle frame for showing Reincarnation cooldown",
	["invigorated_cmd"] = "Invigorated",
	["invigorated_desc"] = "Toggle frame for showing when Invigorated is up (Untested)",
	
	["ep_cmd"] = "EP",
	["ep_desc"] = "Toggle showing Equivalence Points in Tooltips",
	["ep_group_cmd"] = "EPTypes",
	["ep_group_desc"] = "Set wich Equivalence Points to show",
	["ep_gemq_cmd"] = "GemQuality",
	["ep_gemq_desc"] = "Set Max Quality for Gems (1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic)",
	["ep_gemm_cmd"] = "MetaGem",
	["ep_gemm_desc"] = "Toggle including Meta gems in calculations",
	["epz_cmd"] = "EPZero",
	["epz_desc"] = "Show Equivalence Points even if summary is zero",
	--["aep_group_cmd"] = "AEP",
	--["aep_group_desc"] = "Select wich Attackpower Equivalence Points to show in Tooltips",
	["aep_cmd"] = "AEP",
	["aep_desc"] = "Toggle showing Attackpower Equivalence Points in Tooltips",
	["aeph_cmd"] = "AEPH",
	["aeph_desc"] = "Toggle showing Attackpower Equivalence Points (w/o hit) in Tooltips",
	["hep_cmd"] = "HEP",
	["hep_desc"] = "Toggle showing Healing Equivalence Points in Tooltips",
	["dep_cmd"] = "DEP",
	["dep_desc"] = "Toggle showing spellDamage Equivalence Points in Tooltips",
	["eil_cmd"] = "EIL",
	["eil_desc"] = "Toggle showing Enhancement Item Level in Tooltips",
	["ep_divide_cmd"] = "DivideBy10",
	["ep_divide_desc"] = "For simplicity AEP numbers are multiplied by 10 to avoid fractions, toggling this to ON will divide by 10 again",
	["ep_numbers_cmd"] = "EPNumbers",
	["ep_numbers_desc"] = "Here you can change weights for the EP numbers (0 disables that stat)",
	
	["AGI"] = "Agility",
	["ATTACKPOWER"] = "Attackpower",
	["CR_CRIT"] = "MeleeCrit",
	["CR_HASTE"] = "MeleeHaste",
	["CR_HIT"] = "MeleeHit",
	["CR_SPELLCRIT"] = "SpellCrit",
	["CR_SPELLHASTE"] = "SpellHaste",
	["CR_SPELLHIT"] = "SpellHit",
	["DMG"] = "SpellDamage",
	["HEAL"] = "SpellHeal",
	["IGNOREARMOR"] = "IgnoreArmor",
	["INT"] = "Intelligence",
	["MANAREG"] = "MP5",
	["SPI"] = "Spirit",
	["STR"] = "Strength",
		
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
	
	["specialalpha_cmd"] = "SpecialAlpha",
	["specialalpha_desc"] = "Enable special alpha settings for \"bonus\" frames",
	
	--[[ Strings used for frames ]]--
	["DragToMoveFrame"] = "Click and drag to move frame",
	
	--[[ Warnings ]]--
	["TotemExpiring"] = "%s (%s) expires soon",
	["TotemSlain"] = "%s (%s) was slain!!!",
	["TotemDeath"] = "%s (%s) has expired",
} end )


local L_EP = AceLibrary("AceLocale-2.2"):new("EnhancerEP")
L_EP:RegisterTranslations("enUS", function() return {
	
	--[[ ItemTypes ]]--
	["Armor"] = true,
	["Gem"] = true,
	["Weapon"] = true,
	["Projectile"] = true,
	["Quiver"] = true,
	["Recipe"] = true,
	
	--[[ ItemSubTypes (skip) ]]--
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
	["eep_info"] = "Enhancer's Equivalence Points:",
	
	["aep_tooltip"] = string.rep(" ", 3) .. "AttackpowerEP (inc BoK):",
	["aep_info"] = "AEP model from Tornhoof/Pater",
	["aeph_tooltip"] = string.rep(" ", 3) .. "AttackpowerEP w/o hit (inc BoK):",
	
	["hep_tooltip"] = string.rep(" ", 3) .. "HealingEP (inc BoK):",
	["hep_info"] = "Numbers from Leion (possibly very inaccurate and shouldn't be trusted at all)",
	
	["dep_tooltip"] = string.rep(" ", 3) .. "DamageEP (inc BoK):",
	["dep_info"] = "Numbers from Leion (possibly very inaccurate and shouldn't be trusted at all)",
	
	["eil_tooltip"] = "Enhancement ItemLevel",
	["eil_info"] = "Numbers from Leion (possibly very inaccurate and shouldn't be trusted at all)",
	
	["ep_numbers1"] = "%d (%d)",
	["ep_numbers2"] = "%.1f (%.1f)",
	
} end )