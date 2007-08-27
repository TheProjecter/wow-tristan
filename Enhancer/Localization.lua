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
	
	["ep_cmd"] = "EP",
	["ep_desc"] = "Toggle showing Equivalence Points in Tooltips",
	["ep_group_cmd"] = "EPTypes",
	["ep_group_desc"] = "Set wich Equivalence Points to show",
	["ep_gemq_cmd"] = "GemQuality",
	["ep_gemq_desc"] = "Set Max Quality for Gems (1 = None, 2 = Uncommon, 3 = Rare, 4 = Epic)",
	["ep_gemm_cmd"] = "MetaGem",
	["ep_gemm_desc"] = "Toggle including Meta gems in calculations",
	["epz_cmd"] = "EPZero",
	["epz_desc"] = "Show Equivalence Points even if summary is zero",
	["aep_cmd"] = "AEP",
	["aep_desc"] = "Toggle showing Attackpower Equivalence Points in Tooltips",
	["aeph_cmd"] = "AEPwoH",
	["aeph_desc"] = "Toggle showing Attackpower Equivalence Points (w/o hit) in Tooltips",
	["hep_cmd"] = "HEP",
	["hep_desc"] = "Toggle showing Healing Equivalence Points in Tooltips",
	["dep_cmd"] = "DEP",
	["dep_desc"] = "Toggle showing spellDamage Equivalence Points in Tooltips",
	["deph_cmd"] = "DEPwoH",
	["deph_desc"] = "Toggle showing spellDamage Equivalence Points (w/o hit) in Tooltips",
	["eip_cmd"] = "EIP",
	["eip_desc"] = "Toggle showing Enhancement Itemization Points in Tooltips",
	["ep_numbers_cmd"] = "EPNumbers",
	["ep_numbers_desc"] = "Here you can change weights for the EP numbers (0 disables that stat)",
	["ep_guess_cmd"] = "EPEstimates",
	["ep_guess_desc"] = "Include guesstimates of non static bonuses on weapons (procs/use) for EP",
	["bestgem_cmd"] = "BestGem",
	["bestgem_desc"] = "Calculates the best gem based on your settings",
	["blue"] = "Blue",
	["yellow"] = "Yellow",
	["red"] = "Red",
	["any"] = "Any",
	
	["AGI"] = "Agility",
	["ATTACKPOWER"] = "Attackpower",
	["CR_CRIT"] = "MeleeCrit",
	["CR_HASTE"] = "MeleeHaste",
	["CR_HIT"] = "MeleeHit",
	["CR_SPELLCRIT"] = "SpellCrit",
	["CR_SPELLHASTE"] = "SpellHaste",
	["CR_SPELLHIT"] = "SpellHit",
	["CR_RESILIENCE"] = "Resilience",
	["DMG"] = "SpellDamage",
	["HEAL"] = "SpellHeal",
	["IGNOREARMOR"] = "IgnoreArmor",
	["INT"] = "Intelligence",
	["MANAREG"] = "MP5",
	["SPI"] = "Spirit",
	["STR"] = "Strength",
	["STA"] = "Stamina",
		
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
	
	--[[ Announcement ]]--
	["Announcement"] = "Enhancer is currently being developed if you find a bug somewhere or something you think is wrong, feel free to email me at dennis.hafstrom@gmail.com",
	["Announcement_cmd"] = "Announcement",
	["Announcement_desc"] = "Announcement (the spam at load ;) settings",
	["a_show_cmd"] = "Show",
	["a_show_desc"] = "Show Announcement(s)",
	["a_disable_cmd"] = "Disable",
	["a_disable_desc"] = "Disable Announcement(s) at load",
	
	["Rank 0"] = 0, -- Ugly hack for no-rank spells ;)
	["Rank 1"] = 1,
	["Rank 2"] = 2,
	["Rank 3"] = 3,
	["Rank 4"] = 4,
	["Rank 5"] = 5,
	["Rank 6"] = 6,
	["Rank 7"] = 7,
	["Rank 8"] = 8,
	["Rank 9"] = 9,
	["Rank 10"] = 10,
	["Rank 11"] = 11,
	["Rank 12"] = 12,
	["Rank 13"] = 13,
	["Rank 14"] = 14,
	["Rank 15"] = 15,
	["Rank 16"] = 16,
	["Rank 17"] = 17,
	["Rank 18"] = 18,
	["Rank 19"] = 19,
	["Rank 20"] = 20,
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
	["aep_info"] = "AEP model from Tornhoof/Pater", -- Not used atm
	["aeph_tooltip"] = string.rep(" ", 3) .. "AttackpowerEP w/o hit (inc BoK):",
	
	["hep_tooltip"] = string.rep(" ", 3) .. "HealingEP (inc BoK):",
	["hep_info"] = "Numbers from Leion (possibly very inaccurate and shouldn't be trusted at all)", -- Not used atm
	
	["dep_tooltip"] = string.rep(" ", 3) .. "DamageEP (inc BoK):",
	["dep_info"] = "Numbers from Leion (possibly very inaccurate and shouldn't be trusted at all)", -- Not used atm
	["deph_tooltip"] = string.rep(" ", 3) .. "DamageEP w/o hit (inc BoK):",
	
	["eip_tooltip"] = "Enhancement Itemization Points",
	["eip_info"] = "Numbers from Leion (possibly very inaccurate and shouldn't be trusted at all)", -- Not used atm
	
	["ep_numbers1"] = "%d (%d)",
	["ep_numbers2"] = "%.1f (%.1f)",
	
	["bestgem_link"] = "Best gem (color %s) with current values is: %s at %.1f and %s at %.1f with BoK",
	["bestgem_nolink"] = "Best gem (color %s) with current values is: %s at %.1f and %s at %.1f with BoK",
	["Red"] = "red",
	["Yellow"] = "yellow",
	["Blue"] = "blue",
	["Any"] = "any",
	
} end )