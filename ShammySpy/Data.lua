local L = AceLibrary("AceLocale-2.2"):new("ShammySpy")
ShammySpy.Totems = {}

--> Earth Totems <--
ShammySpy.Totems[L["Earthbind Totem"]] = {}
ShammySpy.Totems[L["Earthbind Totem"]].Icon = "Spell_Nature_StrengthOfEarthTotem02";
ShammySpy.Totems[L["Earthbind Totem"]].Time = 45;
ShammySpy.Totems[L["Earthbind Totem"]].Element = "Earth";
ShammySpy.Totems[L["Earthbind Totem"]].Life = 5;

ShammySpy.Totems[L["Stoneskin Totem"]] = {};
ShammySpy.Totems[L["Stoneskin Totem"]].Icon = "Spell_Nature_StoneSkinTotem";
ShammySpy.Totems[L["Stoneskin Totem"]].Time = 120;
ShammySpy.Totems[L["Stoneskin Totem"]].Element = "Earth";
ShammySpy.Totems[L["Stoneskin Totem"]].Life = 5;

ShammySpy.Totems[L["Stoneclaw Totem"]] = {};
ShammySpy.Totems[L["Stoneclaw Totem"]].Icon = "Spell_Nature_StoneClawTotem";
ShammySpy.Totems[L["Stoneclaw Totem"]].Time = 15;
ShammySpy.Totems[L["Stoneclaw Totem"]].Element = "Earth";
ShammySpy.Totems[L["Stoneclaw Totem"]].Life = nil; -- Depends on rank *sigh*
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 1"]] = { };
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 1"]].Life = 50;
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 2"]] = { };
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 2"]].Life = 150;
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 3"]] = { };
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 3"]].Life = 220;
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 4"]] = { };
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 4"]].Life = 280;
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 5"]] = { };
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 5"]].Life = 390;
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 6"]] = { };
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 6"]].Life = 480;
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 7"]] = { };
ShammySpy.Totems[L["Stoneclaw Totem"]][L["Rank 7"]].Life = 1315;

ShammySpy.Totems[L["Strength of Earth Totem"]] = {};
ShammySpy.Totems[L["Strength of Earth Totem"]].Icon = "Spell_Nature_EarthBindTotem";
ShammySpy.Totems[L["Strength of Earth Totem"]].Time = 120;
ShammySpy.Totems[L["Strength of Earth Totem"]].Element = "Earth";
ShammySpy.Totems[L["Strength of Earth Totem"]].Life = 5;

ShammySpy.Totems[L["Tremor Totem"]] = {};
ShammySpy.Totems[L["Tremor Totem"]].Icon = "Spell_Nature_TremorTotem";
ShammySpy.Totems[L["Tremor Totem"]].Time = 120;
ShammySpy.Totems[L["Tremor Totem"]].Element = "Earth";
ShammySpy.Totems[L["Tremor Totem"]].Life = 5;
ShammySpy.Totems[L["Tremor Totem"]].Pulse = 5;

ShammySpy.Totems[L["Earth Elemental Totem"]] = {};
ShammySpy.Totems[L["Earth Elemental Totem"]].Icon = "Spell_Nature_EarthElemental_Totem";
ShammySpy.Totems[L["Earth Elemental Totem"]].Time = 120;
ShammySpy.Totems[L["Earth Elemental Totem"]].Element = "Earth";
ShammySpy.Totems[L["Earth Elemental Totem"]].Life = 3000; --Unknown atm

--> Fire Totems <--
ShammySpy.Totems[L["Flametongue Totem"]] = {};
ShammySpy.Totems[L["Flametongue Totem"]].Icon = "Spell_Nature_GuardianWard";
ShammySpy.Totems[L["Flametongue Totem"]].Time = 120;
ShammySpy.Totems[L["Flametongue Totem"]].Element = "Fire";
ShammySpy.Totems[L["Flametongue Totem"]].Life = 5;

ShammySpy.Totems[L["Fire Nova Totem"]] = {};
ShammySpy.Totems[L["Fire Nova Totem"]].Icon = "Spell_Fire_SealOfFire";
ShammySpy.Totems[L["Fire Nova Totem"]].Time = 5;
ShammySpy.Totems[L["Fire Nova Totem"]].Element = "Fire";
ShammySpy.Totems[L["Fire Nova Totem"]].Life = 5;

ShammySpy.Totems[L["Frost Resistance Totem"]] = {};
ShammySpy.Totems[L["Frost Resistance Totem"]].Icon = "Spell_FrostResistanceTotem_01"; 
ShammySpy.Totems[L["Frost Resistance Totem"]].Time = 120;
ShammySpy.Totems[L["Frost Resistance Totem"]].Element = "Fire";
ShammySpy.Totems[L["Frost Resistance Totem"]].Life = 5;

ShammySpy.Totems[L["Magma Totem"]] = {};
ShammySpy.Totems[L["Magma Totem"]].Icon = "Spell_Fire_SelfDestruct";
ShammySpy.Totems[L["Magma Totem"]].Time = 20;
ShammySpy.Totems[L["Magma Totem"]].Element = "Fire";
ShammySpy.Totems[L["Magma Totem"]].Life = 5;
ShammySpy.Totems[L["Magma Totem"]].Pulse = 2;

ShammySpy.Totems[L["Searing Totem"]] = {};
ShammySpy.Totems[L["Searing Totem"]].Icon = "Spell_Fire_SearingTotem";
ShammySpy.Totems[L["Searing Totem"]].Time = nil; -- Depends on rank *sigh*
ShammySpy.Totems[L["Searing Totem"]][L["Rank 1"]] = { };
ShammySpy.Totems[L["Searing Totem"]][L["Rank 1"]].Time = 30;
ShammySpy.Totems[L["Searing Totem"]][L["Rank 2"]] = { };
ShammySpy.Totems[L["Searing Totem"]][L["Rank 2"]].Time = 35;
ShammySpy.Totems[L["Searing Totem"]][L["Rank 3"]] = { };
ShammySpy.Totems[L["Searing Totem"]][L["Rank 3"]].Time = 40;
ShammySpy.Totems[L["Searing Totem"]][L["Rank 4"]] = { };
ShammySpy.Totems[L["Searing Totem"]][L["Rank 4"]].Time = 45;
ShammySpy.Totems[L["Searing Totem"]][L["Rank 5"]] = { };
ShammySpy.Totems[L["Searing Totem"]][L["Rank 5"]].Time = 50;
ShammySpy.Totems[L["Searing Totem"]][L["Rank 6"]] = { };
ShammySpy.Totems[L["Searing Totem"]][L["Rank 6"]].Time = 55;
ShammySpy.Totems[L["Searing Totem"]][L["Rank 7"]] = { };
ShammySpy.Totems[L["Searing Totem"]][L["Rank 7"]].Time = 60;
ShammySpy.Totems[L["Searing Totem"]].Element = "Fire";
ShammySpy.Totems[L["Searing Totem"]].Life = 5;

ShammySpy.Totems[L["Totem of Wrath"]] = {};
ShammySpy.Totems[L["Totem of Wrath"]].Icon = "Spell_Fire_TotemOfWrath";
ShammySpy.Totems[L["Totem of Wrath"]].Time = 120;
ShammySpy.Totems[L["Totem of Wrath"]].Element = "Fire";
ShammySpy.Totems[L["Totem of Wrath"]].Life = 5;

ShammySpy.Totems[L["Fire Elemental Totem"]] = {};
ShammySpy.Totems[L["Fire Elemental Totem"]].Icon = "Spell_Fire_Elemental_Totem";
ShammySpy.Totems[L["Fire Elemental Totem"]].Time = 120;
ShammySpy.Totems[L["Fire Elemental Totem"]].Element = "Fire";
ShammySpy.Totems[L["Fire Elemental Totem"]].Life = 3000; --Unknown atm

--> Water Totems <--
ShammySpy.Totems[L["Disease Cleansing Totem"]] = {};
ShammySpy.Totems[L["Disease Cleansing Totem"]].Icon = "Spell_Nature_DiseaseCleansingTotem";
ShammySpy.Totems[L["Disease Cleansing Totem"]].Time = 120;
ShammySpy.Totems[L["Disease Cleansing Totem"]].Element = "Water";
ShammySpy.Totems[L["Disease Cleansing Totem"]].Life = 5;
ShammySpy.Totems[L["Disease Cleansing Totem"]].Pulse = 5;

ShammySpy.Totems[L["Fire Resistance Totem"]] = {};
ShammySpy.Totems[L["Fire Resistance Totem"]].Icon = "Spell_FireResistanceTotem_01"; 
ShammySpy.Totems[L["Fire Resistance Totem"]].Time = 120;
ShammySpy.Totems[L["Fire Resistance Totem"]].Element = "Water";
ShammySpy.Totems[L["Fire Resistance Totem"]].Life = 5;

ShammySpy.Totems[L["Healing Stream Totem"]] = {} ;
ShammySpy.Totems[L["Healing Stream Totem"]].Icon = "INV_Spear_04";
ShammySpy.Totems[L["Healing Stream Totem"]].Time = 120;
ShammySpy.Totems[L["Healing Stream Totem"]].Element = "Water";
ShammySpy.Totems[L["Healing Stream Totem"]].Life = 5;
ShammySpy.Totems[L["Healing Stream Totem"]].Pulse = 2;

ShammySpy.Totems[L["Mana Spring Totem"]] = {};
ShammySpy.Totems[L["Mana Spring Totem"]].Icon = "Spell_Nature_ManaRegenTotem";
ShammySpy.Totems[L["Mana Spring Totem"]].Time = 120;
ShammySpy.Totems[L["Mana Spring Totem"]].Element = "Water";
ShammySpy.Totems[L["Mana Spring Totem"]].Life = 5;
ShammySpy.Totems[L["Mana Spring Totem"]].Pulse = 2;

ShammySpy.Totems[L["Mana Tide Totem"]] = {};
ShammySpy.Totems[L["Mana Tide Totem"]].Icon = "Spell_Frost_SummonWaterElemental";
ShammySpy.Totems[L["Mana Tide Totem"]].Time = 12;
ShammySpy.Totems[L["Mana Tide Totem"]].Element = "Water";
ShammySpy.Totems[L["Mana Tide Totem"]].Life = 5;
ShammySpy.Totems[L["Mana Tide Totem"]].Pulse = 3;

ShammySpy.Totems[L["Poison Cleansing Totem"]] = {};
ShammySpy.Totems[L["Poison Cleansing Totem"]].Icon = "Spell_Nature_PoisonCleansingTotem";
ShammySpy.Totems[L["Poison Cleansing Totem"]].Time = 120;
ShammySpy.Totems[L["Poison Cleansing Totem"]].Element = "Water";
ShammySpy.Totems[L["Poison Cleansing Totem"]].Life = 5;
ShammySpy.Totems[L["Poison Cleansing Totem"]].Pulse = 5;

ShammySpy.Totems[L["Ancient Mana Spring"]] = {};
ShammySpy.Totems[L["Ancient Mana Spring"]].Icon = "INV_Wand_01";
ShammySpy.Totems[L["Ancient Mana Spring"]].Time = 24;
ShammySpy.Totems[L["Ancient Mana Spring"]].Element = "Water";
ShammySpy.Totems[L["Ancient Mana Spring"]].Life = 5;
ShammySpy.Totems[L["Ancient Mana Spring"]].Pulse = 2;

--> Air Totems <--
ShammySpy.Totems[L["Grace of Air Totem"]] = {};
ShammySpy.Totems[L["Grace of Air Totem"]].Icon = "Spell_Nature_InvisibilityTotem";
ShammySpy.Totems[L["Grace of Air Totem"]].Time = 120;
ShammySpy.Totems[L["Grace of Air Totem"]].Element = "Air";
ShammySpy.Totems[L["Grace of Air Totem"]].Life = 5;

ShammySpy.Totems[L["Grounding Totem"]] = {};
ShammySpy.Totems[L["Grounding Totem"]].Icon = "Spell_Nature_GroundingTotem";
ShammySpy.Totems[L["Grounding Totem"]].Time = 45;
ShammySpy.Totems[L["Grounding Totem"]].Element = "Air";
ShammySpy.Totems[L["Grounding Totem"]].Life = 5;

ShammySpy.Totems[L["Nature Resistance Totem"]] = {};
ShammySpy.Totems[L["Nature Resistance Totem"]].Icon = "Spell_Nature_NatureResistanceTotem";
ShammySpy.Totems[L["Nature Resistance Totem"]].Time = 120;
ShammySpy.Totems[L["Nature Resistance Totem"]].Element = "Air";
ShammySpy.Totems[L["Nature Resistance Totem"]].Life = 5;

ShammySpy.Totems[L["Sentry Totem"]] = {};
ShammySpy.Totems[L["Sentry Totem"]].Icon = "Spell_Nature_RemoveCurse";
ShammySpy.Totems[L["Sentry Totem"]].Time = 300;
ShammySpy.Totems[L["Sentry Totem"]].Element = "Air";
ShammySpy.Totems[L["Sentry Totem"]].Life = 5;

ShammySpy.Totems[L["Tranquil Air Totem"]] = {};
ShammySpy.Totems[L["Tranquil Air Totem"]].Icon = "Spell_Nature_Brilliance";
ShammySpy.Totems[L["Tranquil Air Totem"]].Time = 120;
ShammySpy.Totems[L["Tranquil Air Totem"]].Element = "Air";
ShammySpy.Totems[L["Tranquil Air Totem"]].Life = 5;

ShammySpy.Totems[L["Windfury Totem"]] = {};
ShammySpy.Totems[L["Windfury Totem"]].Icon = "Spell_Nature_Windfury";
ShammySpy.Totems[L["Windfury Totem"]].Time = 120;
ShammySpy.Totems[L["Windfury Totem"]].Element = "Air";
ShammySpy.Totems[L["Windfury Totem"]].Life = 5;

ShammySpy.Totems[L["Windwall Totem"]] = {};
ShammySpy.Totems[L["Windwall Totem"]].Icon = "Spell_Nature_EarthBind";
ShammySpy.Totems[L["Windwall Totem"]].Time = 120;
ShammySpy.Totems[L["Windwall Totem"]].Element = "Air";
ShammySpy.Totems[L["Windwall Totem"]].Life = 5;

ShammySpy.Totems[L["Wrath of Air Totem"]] = {};
ShammySpy.Totems[L["Wrath of Air Totem"]].Icon = "Spell_Nature_SlowingTotem";
ShammySpy.Totems[L["Wrath of Air Totem"]].Time = 120;
ShammySpy.Totems[L["Wrath of Air Totem"]].Element = "Air";
ShammySpy.Totems[L["Wrath of Air Totem"]].Life = 5;

--> Special <--
ShammySpy.Totems[L["Enamored Water Spirit"]] = {};
ShammySpy.Totems[L["Enamored Water Spirit"]].Icon = "INV_Wand_01"; -- Trinket totem from Sunken Temple
ShammySpy.Totems[L["Enamored Water Spirit"]].Time = 24;
ShammySpy.Totems[L["Enamored Water Spirit"]].Element = "Water";
ShammySpy.Totems[L["Enamored Water Spirit"]].Life = 5;
ShammySpy.Totems[L["Enamored Water Spirit"]].Pulse = 2;

--> Rank Roman Crap <--
ShammySpy.Ranks = {};
ShammySpy.Ranks["Rank 1"] = "I";
ShammySpy.Ranks["Rank 2"] = "II";
ShammySpy.Ranks["Rank 3"] = "III";
ShammySpy.Ranks["Rank 4"] = "IV";
ShammySpy.Ranks["Rank 5"] = "V";
ShammySpy.Ranks["Rank 6"] = "VI";
ShammySpy.Ranks["Rank 7"] = "VII";
ShammySpy.Ranks["Rank 8"] = "VIII";
ShammySpy.Ranks["Rank 9"] = "IX";
ShammySpy.Ranks["Rank 10"] = "X";
ShammySpy.Ranks["Rank 11"] = "XI";
ShammySpy.Ranks["Rank 12"] = "XII";
ShammySpy.Ranks["Rank 13"] = "XIII";
ShammySpy.Ranks["Rank 14"] = "XIV";
ShammySpy.Ranks["Rank 15"] = "XV";
ShammySpy.Ranks["Rank 16"] = "XVI";
ShammySpy.Ranks["Rank 17"] = "XVII";
ShammySpy.Ranks["Rank 18"] = "XVIII";
ShammySpy.Ranks["Rank 19"] = "XIX";
ShammySpy.Ranks["Rank 20"] = "XX";
ShammySpy.Ranks["1"] = "I";
ShammySpy.Ranks["2"] = "II";
ShammySpy.Ranks["3"] = "III";
ShammySpy.Ranks["4"] = "IV";
ShammySpy.Ranks["5"] = "V";
ShammySpy.Ranks["6"] = "VI";
ShammySpy.Ranks["7"] = "VII";
ShammySpy.Ranks["8"] = "VIII";
ShammySpy.Ranks["9"] = "IX";
ShammySpy.Ranks["10"] = "X";
ShammySpy.Ranks["11"] = "XI";
ShammySpy.Ranks["12"] = "XII";
ShammySpy.Ranks["13"] = "XIII";
ShammySpy.Ranks["14"] = "XIV";
ShammySpy.Ranks["15"] = "XV";
ShammySpy.Ranks["16"] = "XVI";
ShammySpy.Ranks["17"] = "XVII";
ShammySpy.Ranks["18"] = "XVIII";
ShammySpy.Ranks["19"] = "XIX";
ShammySpy.Ranks["20"] = "XX";