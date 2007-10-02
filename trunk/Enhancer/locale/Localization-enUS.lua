--[[ Want to translate?

	Make a copy of this file in the same folder and rename the end into the locale you want to translate for, also remove this header
	
	The following are allready referenced in the .toc file:
	Localization-deDE.lua, Localization-frFR.lua, Localization-koKR.lua, Localization-zhCN.lua, Localization-zhTW.lua, Localization-esES.lua
	if I missed yours you need to add it manually for testing
	
	Translate the row below that looks like this: local locale = "enUS";
	Change enUS to whatever locale you are using
	
	Translate the right hand side of everything, German example:
		["lock_cmd"] = "Sperren",
		...
		["eep_info"] = "Enhancer's Vergleichspunkte:",
	
	Anything ending with _cmd is used as a console commmand and I usually try to keep those as one word.
	
	Once you are done mail it to me at dennis.hafstrom@gmail.com and I'll add it to the distributed file :)
]]--

local U = Enhancer_URLs; -- Read up URLs, " .. U["EJ"] .. "
local locale = "enUS";

local L_Main = AceLibrary("AceLocale-2.2"):new("Enhancer")
L_Main:RegisterTranslations(locale, function() return {
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
	["ep_info_exec"] = "Some sources for finding \"your\" AEP:\r1) " .. U["CrazyShamanCalc"] .. "\r2) " .. U["EJ"] .. "\r3) " .. U["WoWEquipO"] .. "\r4) " .. U["Pater"] .. "\rDefault AEP are from Tornhoof/Pater",
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
	["WEAPON_MIN"] = "WeaponMin",
	["WEAPON_MAX"] = "WeaponMax",
		
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
	["Lost track of Earth Shield"] = "Lost track of Earth Shield",
	["Earth Shield has expired"] = "Earth Shield has expired",
	["Earth Shield is about to expire"] = "Earth Shield is about to expire",
	
	["tench_cmd"] = "Enchants",
	["tench_desc"] = "Toggle frames for showing temporary enchants",
	
	["invigorated_cmd"] = "Invigorated",
	["invigorated_desc"] = "Toggle frame for showing when Invigorated is up (Untested)",
	["Invigorated"] = "Invigorated",
	
	["hway_cmd"] = "HealingWay",
	["hway_desc"] = "Toggles CandyBars for Healing Way",
	["hway_yougain"] = "You gain", -- as it appears in combat log when you gain a buff!
	["hway_anchortext"] = "Alt-Click to move Anchor",
	
	["aep_import_crazyshaman_cmd"] = "CrazyShamanImport",
	["aep_import_crazyshaman_desc"] = "Import value string from Crazy Shaman's DPS & AEP calculator ( " .. U["CrazyShamanCalc"] .. " )",
	["aep_import_warning"] = "Some AEP values was not included, please check the following AEP values (%s)",
	
	["yard_group_cmd"] = "RangeSettings",
	["yard_group_desc"] = "Totems dissapear when you go to far away from them settings for that is here",
	["yard_range_cmd"] = "Range",
	["yard_range_desc"] = "What range to assume the totem is gone (Default: 150, Quick in-game testing showed closer to 100)",
	["yard_active_cmd"] = "Active",
	["yard_active_desc"] = "Toggle destroying frame on range active or not",
	
	["base_warn"] = " (base value)",
	
	["windfurytotem_cmd"] = "WindfuryTotem",
	["windfurytotem_desc"] = "Timer for twisting windfury totem",
	
	["snap_cmd"] = "Snap",
	["snap_desc"] = "Snap frames when in the vicinity of each other",
	
	["font_cmd"] = "Font",
	["font_desc"] = "Font settings",
	["fontabove_cmd"] = "Above",
	["fontabove_desc"] = "Font settings for text above the frame",
	["fontcenter_cmd"] = "Center",
	["fontcenter_desc"] = "Font settings for text in the center of the frame",
	["fontbelow_cmd"] = "Below",
	["fontbelow_desc"] = "Font settings for text below the frame",
	["fontname_cmd"] = "Font",
	["fontname_desc"] = "Font type",
	["fontsize_cmd"] = "Size",
	["fontsize_desc"] = "Font size",
	["fontflag_cmd"] = "Outline",
	["fontflag_desc"] = "Font outline (OUTLINE\|THICKOUTLINE\|NONE)",
	["Messages_cmd"] = "Messages",
	["Messages_desc"] = "Message settings",
	
	["roman_cmd"] = "Roman",
	["roman_desc"] = "Set Enhancer to use roman numbers on Shields etc",
	
	["time_cmd"] = "Time",
	["time_desc"] = "Settings regarding time",
	["pulse_cmd"] = "Pulse",
	["pulse_desc"] = "Settings regarding death pulse",
	["warning_cmd"] = "Warnings",
	["warning_desc"] = "Settings regarding warnings",
	
	["blizztime_cmd"] = "Blizzard",
	["blizztime_desc"] = "Set Enhancer to use Blizzard's time format",
	["blizzssec_cmd"] = "UseS",
	["blizzssec_desc"] = "Here you can enable/disable appending a 's' to seconds",
	["warnExpire_cmd"] = "Expiring",
	["warnExpire_desc"] = "Warn before expiring",
	["warnDeath_cmd"] = "Expired",
	["warnDeath_desc"] = "Warn when exipired",
	["warnSlain_cmd"] = "Killed",
	["warnSlain_desc"] = "Warn when a totem is killed",
	["warnTime_cmd"] = "Time",
	["warnTime_desc"] = "When expiring warn this amount of seconds before (changing this won't affect existing totems)",
	
}; end );

local L_EP = AceLibrary("AceLocale-2.2"):new("EnhancerEP")
L_EP:RegisterTranslations(locale, function() return {
	
	--[[ ItemTypes ]]--
	["Armor"] = "Armor",
	["Gem"] = "Gem",
	["Weapon"] = "Weapon",
	["Projectile"] = "Projectile",
	["Quiver"] = "Quiver",
	["Recipe"] = "Recipe",
	
	--[[ Sockets as they appear on the tooltip has to include Socket as it's used for matching and lots of matches are possible with only color ]]--
	["Red Socket"] = "Red Socket",
	["Blue Socket"] = "Blue Socket",
	["Yellow Socket"] = "Yellow Socket",
	["Meta Socket"] = "Meta Socket",
	
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