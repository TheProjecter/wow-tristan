--[[ Want to translate?

	Make a copy of this file in the same folder and rename the end into the locale you want to translate for, also remove this header
	
	The following are allready referenced in the .toc file:
	Localization_deDE.lua, Localization_frFR.lua, Localization_koKR.lua, Localization_zhCN.lua, Localization_zhTW.lua, Localization_esES.lua
	if I missed yours you need to add it manually for testing
	
	Translate the right hand side of everything, German example:
		["lock_cmd"] = "Sperren",
		...
		["eep_info"] = "Enhancer's Vergleichspunkte:",
	
	Anything ending with _cmd is used as a console commmand and I usually try to keep those as one word.
	Things like: ["Gem"] = true should be translated as ["Gem"] = "Edelstein" since true can only be used in the enUS locale
	
	Once you are done mail it to me at dennis.hafstrom@gmail.com and I'll add it to the distributed file :)
]]--

local L_Main = AceLibrary("AceLocale-2.2"):new("Enhancer")
L_Main:RegisterTranslations("enUS", function() return {
	["translator"] = "Leion - Frostmane.eu",
	
	["waterfall_cmd"] = "Waterfall",
	["waterfall_desc"] = "Open Waterfall configuration",
	
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
	["ep_info_cmd"] = "Info",
	["ep_info_desc"] = "More information about Equivalence Points",
	["ep_info_exec"] = "Some sources for finding \"your\" AEP:\rhttp://elitistjerks.com/f31/t13297-enhance_shaman_collected_works_theorycraft_vol_i/\rhttp://code.google.com/p/wowequipoptimizer\rhttp://www.discofiend.com/pater/\rhttp://elitbrus.tripod.com/",
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
	["DragToMoveFrame"] = "Drag", --"Click and drag to move frame",
	
	--[[ Warnings ]]--
	["TotemExpiring"] = "%s (%s) expires soon",
	["TotemSlain"] = "%s (%s) was slain!!!",
	["TotemDeath"] = "%s (%s) has expired",
	
	--[[ Announcements ]]--
	["Announcement"] = "Enhancer is currently being developed if you find a bug somewhere or something you think is wrong, feel free to email me at dennis.hafstrom@gmail.com",
	["Announcement_cmd"] = "Announcement",
	["Announcement_desc"] = "Announcement (the spam at load ;) settings",
	["a_show_cmd"] = "Show",
	["a_show_desc"] = "Show Announcement(s)",
	["a_disable_cmd"] = "Disable",
	["a_disable_desc"] = "Disable Announcement(s) at load",
	
	[0] = "Rank 0",
	[1] = "Rank 1",
	[2] = "Rank 2",
	[3] = "Rank 3",
	[4] = "Rank 4",
	[5] = "Rank 5",
	[6] = "Rank 6",
	[7] = "Rank 7",
	[8] = "Rank 8",
	[9] = "Rank 9",
	[10] = "Rank 10",
	[11] = "Rank 11",
	[12] = "Rank 12",
	[13] = "Rank 13",
	[14] = "Rank 14",
	[15] = "Rank 15",
	[16] = "Rank 16",
	[17] = "Rank 17",
	[18] = "Rank 18",
	[19] = "Rank 19",
	[20] = "Rank 20",
	
	--[[ Modules ]]--
	["shield_cmd"] = "Shield",
	["shield_desc"] = "Toggle frame for showing when shields are up",
	
	["eshield_cmd"] = "EarthShield",
	["eshield_desc"] = "Toggle frame for showing earth shield",
	["Lost track of Earth Shield"] = true,
	["Earth Shield has expired"] = true,
	["Earth Shield is about to expire"] = true,
	
	["tench_cmd"] = "Enchants",
	["tench_desc"] = "Toggle frames for showing temporary enchants",
	
	["invigorated_cmd"] = "Invigorated",
	["invigorated_desc"] = "Toggle frame for showing when Invigorated is up (Untested)",
	["Invigorated"] = true,
	
	["hway_cmd"] = "HealingWay",
	["hway_desc"] = "Toggles CandyBars for Healing Way",
	["hway_yougain"] = "You gain", -- as it appears in combat log when you gain a buff!
	["hway_anchortext"] = "Alt-Click to move Anchor",
	
	["aep_import_crazyshaman_cmd"] = "CrazyShamanImport",
	["aep_import_crazyshaman_desc"] = "Import value string from Crazy Shaman's DPS & AEP calculator ( http://theorycraft.narod.ru/ )",
	["aep_import_warning"] = "Some AEP values was not included, please check the following AEP values (%s)",
	
}; end );

local L_EP = AceLibrary("AceLocale-2.2"):new("EnhancerEP")
L_EP:RegisterTranslations("enUS", function() return {
	
	--[[ ItemTypes ]]--
	["Armor"] = true,
	["Gem"] = true,
	["Weapon"] = true,
	["Projectile"] = true,
	["Quiver"] = true,
	["Recipe"] = true,
	
	--[[ Sockets as they appear on the tooltip has to include Socket as it's used for matching and lots of matches are possible with only color ]]--
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
	["hep_info"] = "Numbers from Leion (possibly very inaccurate and shouldn't be taken as gospel)", -- Not used atm
	
	["dep_tooltip"] = string.rep(" ", 3) .. "DamageEP (inc BoK):",
	["dep_info"] = "Numbers from Leion (possibly very inaccurate and shouldn't be taken as gospel)", -- Not used atm
	["deph_tooltip"] = string.rep(" ", 3) .. "DamageEP w/o hit (inc BoK):",
	
	["eip_tooltip"] = "Enhancement Itemization Points",
	["eip_info"] = "Numbers from Leion (possibly very inaccurate and shouldn't be taken as gospel)", -- Not used atm
	
	["ep_numbers1"] = "%d (%d)",  -- Lua string.format
	["ep_numbers2"] = "%.1f (%.1f)",  -- Lua string.format
	
	["bestgem_link"] = "Best gem (color %s) with current values is: %s at %.1f and %s at %.1f with BoK",
	["bestgem_nolink"] = "Best gem (color %s) with current values is: %s at %.1f and %s at %.1f with BoK",
	["Red"] = "red",
	["Yellow"] = "yellow",
	["Blue"] = "blue",
	["Any"] = "any",
	
}; end );