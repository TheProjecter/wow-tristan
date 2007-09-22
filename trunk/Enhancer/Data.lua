Enhancer.Totems = {}

--> Earth Totems <--
Enhancer.Totems[Enhancer.BS["Earthbind Totem"]] = {}
Enhancer.Totems[Enhancer.BS["Earthbind Totem"]].Icon = "Spell_Nature_StrengthOfEarthTotem02";
Enhancer.Totems[Enhancer.BS["Earthbind Totem"]].Time = 45;
Enhancer.Totems[Enhancer.BS["Earthbind Totem"]].Element = "Earth";
Enhancer.Totems[Enhancer.BS["Earthbind Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Earthbind Totem"]].Range = 10;
Enhancer.Totems[Enhancer.BS["Earthbind Totem"]].TotemicMastery = nil;
-- Enhancer.Totems[Enhancer.BS["Earthbind Totem"]].Pulse = 3; --[[ Not sure about this ]]--

Enhancer.Totems[Enhancer.BS["Stoneskin Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Stoneskin Totem"]].Icon = "Spell_Nature_StoneSkinTotem";
Enhancer.Totems[Enhancer.BS["Stoneskin Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Stoneskin Totem"]].Element = "Earth";
Enhancer.Totems[Enhancer.BS["Stoneskin Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Stoneskin Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Stoneskin Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]].Icon = "Spell_Nature_StoneClawTotem";
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]].Time = 15;
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]].Element = "Earth";
-- Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]].Pulse = 2; --[[ Not sure about this ]]--
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]].Life = nil; -- Depends on rank *sigh*
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][1] = { };
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][1].Life = 50; -- 50->236
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][1].Level = 8; -- Bonus 3 per Level above
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][2] = { };
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][2].Life = 150; -- 150->306
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][2].Level = 18;
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][3] = { };
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][3].Life = 220; -- 220->346
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][3].Level = 28;
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][4] = { };
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][4].Life = 280; -- 280->376
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][4].Level = 38;
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][5] = { };
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][5].Life = 390; -- 390->456
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][5].Level = 48;
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][6] = { };
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][6].Life = 480; -- 480->516
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][6].Level = 58;
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][7] = { };
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][7].Life = 1315; -- 1315->1324
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][7].Level = 67;
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][7].Range = 8;
Enhancer.Totems[Enhancer.BS["Stoneclaw Totem"]][7].TotemicMastery = nil;

Enhancer.Totems[Enhancer.BS["Strength of Earth Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Strength of Earth Totem"]].Icon = "Spell_Nature_EarthBindTotem";
Enhancer.Totems[Enhancer.BS["Strength of Earth Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Strength of Earth Totem"]].Element = "Earth";
Enhancer.Totems[Enhancer.BS["Strength of Earth Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Strength of Earth Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Strength of Earth Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Tremor Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Tremor Totem"]].Icon = "Spell_Nature_TremorTotem";
Enhancer.Totems[Enhancer.BS["Tremor Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Tremor Totem"]].Element = "Earth";
Enhancer.Totems[Enhancer.BS["Tremor Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Tremor Totem"]].Pulse = 4; -- Dunno why I had it on 5 but according to wowwiki etc it's supposed to be 4!
Enhancer.Totems[Enhancer.BS["Tremor Totem"]].Range = 30;
Enhancer.Totems[Enhancer.BS["Tremor Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Earth Elemental Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Earth Elemental Totem"]].Icon = "Spell_Nature_EarthElemental_Totem";
Enhancer.Totems[Enhancer.BS["Earth Elemental Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Earth Elemental Totem"]].Element = "Earth";
Enhancer.Totems[Enhancer.BS["Earth Elemental Totem"]].Life = 7200; -- Was hitting a totem today and mobHealth gave this number
--Enhancer.Totems[Enhancer.BS["Earth Elemental Totem"]].CombatLog = { "Earth Elemental" }
Enhancer.Totems[Enhancer.BS["Earth Elemental Totem"]].Range = 20; -- Guesstimate
Enhancer.Totems[Enhancer.BS["Earth Elemental Totem"]].TotemicMastery = nil;

--> Fire Totems <--
Enhancer.Totems[Enhancer.BS["Searing Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Searing Totem"]].Icon = "Spell_Fire_SearingTotem";
Enhancer.Totems[Enhancer.BS["Searing Totem"]].Time = nil; -- Depends on rank *sigh*
Enhancer.Totems[Enhancer.BS["Searing Totem"]][1] = { };
Enhancer.Totems[Enhancer.BS["Searing Totem"]][1].Time = 30;
Enhancer.Totems[Enhancer.BS["Searing Totem"]][2] = { };
Enhancer.Totems[Enhancer.BS["Searing Totem"]][2].Time = 35;
Enhancer.Totems[Enhancer.BS["Searing Totem"]][3] = { };
Enhancer.Totems[Enhancer.BS["Searing Totem"]][3].Time = 40;
Enhancer.Totems[Enhancer.BS["Searing Totem"]][4] = { };
Enhancer.Totems[Enhancer.BS["Searing Totem"]][4].Time = 45;
Enhancer.Totems[Enhancer.BS["Searing Totem"]][5] = { };
Enhancer.Totems[Enhancer.BS["Searing Totem"]][5].Time = 50;
Enhancer.Totems[Enhancer.BS["Searing Totem"]][6] = { };
Enhancer.Totems[Enhancer.BS["Searing Totem"]][6].Time = 55;
Enhancer.Totems[Enhancer.BS["Searing Totem"]][7] = { };
Enhancer.Totems[Enhancer.BS["Searing Totem"]][7].Time = 60;
Enhancer.Totems[Enhancer.BS["Searing Totem"]].Element = "Fire";
Enhancer.Totems[Enhancer.BS["Searing Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Searing Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Searing Totem"]].TotemicMastery = nil;

Enhancer.Totems[Enhancer.BS["Fire Nova Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Fire Nova Totem"]].Icon = "Spell_Fire_SealOfFire";
Enhancer.Totems[Enhancer.BS["Fire Nova Totem"]].Time = 5;
Enhancer.Totems[Enhancer.BS["Fire Nova Totem"]].Element = "Fire";
Enhancer.Totems[Enhancer.BS["Fire Nova Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Fire Nova Totem"]].Range = 10;
Enhancer.Totems[Enhancer.BS["Fire Nova Totem"]].TotemicMastery = nil;

Enhancer.Totems[Enhancer.BS["Magma Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Magma Totem"]].Icon = "Spell_Fire_SelfDestruct";
Enhancer.Totems[Enhancer.BS["Magma Totem"]].Time = 20;
Enhancer.Totems[Enhancer.BS["Magma Totem"]].Element = "Fire";
Enhancer.Totems[Enhancer.BS["Magma Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Magma Totem"]].Pulse = 2;
Enhancer.Totems[Enhancer.BS["Magma Totem"]].Range = 8;
Enhancer.Totems[Enhancer.BS["Magma Totem"]].TotemicMastery = false;

Enhancer.Totems[Enhancer.BS["Frost Resistance Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Frost Resistance Totem"]].Icon = "Spell_FrostResistanceTotem_01"; 
Enhancer.Totems[Enhancer.BS["Frost Resistance Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Frost Resistance Totem"]].Element = "Fire";
Enhancer.Totems[Enhancer.BS["Frost Resistance Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Frost Resistance Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Frost Resistance Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Flametongue Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Flametongue Totem"]].Icon = "Spell_Nature_GuardianWard";
Enhancer.Totems[Enhancer.BS["Flametongue Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Flametongue Totem"]].Element = "Fire";
Enhancer.Totems[Enhancer.BS["Flametongue Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Flametongue Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Flametongue Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Totem of Wrath"]] = {};
Enhancer.Totems[Enhancer.BS["Totem of Wrath"]].Icon = "Spell_Fire_TotemOfWrath";
Enhancer.Totems[Enhancer.BS["Totem of Wrath"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Totem of Wrath"]].Element = "Fire";
Enhancer.Totems[Enhancer.BS["Totem of Wrath"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Totem of Wrath"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Totem of Wrath"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Fire Elemental Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Fire Elemental Totem"]].Icon = "Spell_Fire_Elemental_Totem";
Enhancer.Totems[Enhancer.BS["Fire Elemental Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Fire Elemental Totem"]].Element = "Fire";
Enhancer.Totems[Enhancer.BS["Fire Elemental Totem"]].Life = 3600; -- Was hitting a totem today and mobHealth gave this number
--Enhancer.Totems[Enhancer.BS["Fire Elemental Totem"]].CombatLog = { "Fire Elemental" }
Enhancer.Totems[Enhancer.BS["Fire Elemental Totem"]].Range = 20; -- Guesstimate
Enhancer.Totems[Enhancer.BS["Fire Elemental Totem"]].TotemicMastery = nil;

--> Water Totems <--
Enhancer.Totems[Enhancer.BS["Healing Stream Totem"]] = {} ;
Enhancer.Totems[Enhancer.BS["Healing Stream Totem"]].Icon = "INV_Spear_04";
Enhancer.Totems[Enhancer.BS["Healing Stream Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Healing Stream Totem"]].Element = "Water";
Enhancer.Totems[Enhancer.BS["Healing Stream Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Healing Stream Totem"]].Pulse = 2;
Enhancer.Totems[Enhancer.BS["Healing Stream Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Healing Stream Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Mana Spring Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Mana Spring Totem"]].Icon = "Spell_Nature_ManaRegenTotem";
Enhancer.Totems[Enhancer.BS["Mana Spring Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Mana Spring Totem"]].Element = "Water";
Enhancer.Totems[Enhancer.BS["Mana Spring Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Mana Spring Totem"]].Pulse = 2;
Enhancer.Totems[Enhancer.BS["Mana Spring Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Mana Spring Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Poison Cleansing Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Poison Cleansing Totem"]].Icon = "Spell_Nature_PoisonCleansingTotem";
Enhancer.Totems[Enhancer.BS["Poison Cleansing Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Poison Cleansing Totem"]].Element = "Water";
Enhancer.Totems[Enhancer.BS["Poison Cleansing Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Poison Cleansing Totem"]].Pulse = 5;
Enhancer.Totems[Enhancer.BS["Poison Cleansing Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Poison Cleansing Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Disease Cleansing Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Disease Cleansing Totem"]].Icon = "Spell_Nature_DiseaseCleansingTotem";
Enhancer.Totems[Enhancer.BS["Disease Cleansing Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Disease Cleansing Totem"]].Element = "Water";
Enhancer.Totems[Enhancer.BS["Disease Cleansing Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Disease Cleansing Totem"]].Pulse = 5;
Enhancer.Totems[Enhancer.BS["Disease Cleansing Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Disease Cleansing Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Mana Tide Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Mana Tide Totem"]].Icon = "Spell_Frost_SummonWaterElemental";
Enhancer.Totems[Enhancer.BS["Mana Tide Totem"]].Time = 12;
Enhancer.Totems[Enhancer.BS["Mana Tide Totem"]].Element = "Water";
Enhancer.Totems[Enhancer.BS["Mana Tide Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Mana Tide Totem"]].Pulse = 3;
Enhancer.Totems[Enhancer.BS["Mana Tide Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Mana Tide Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Fire Resistance Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Fire Resistance Totem"]].Icon = "Spell_FireResistanceTotem_01"; 
Enhancer.Totems[Enhancer.BS["Fire Resistance Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Fire Resistance Totem"]].Element = "Water";
Enhancer.Totems[Enhancer.BS["Fire Resistance Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Fire Resistance Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Fire Resistance Totem"]].TotemicMastery = true;

--> Air Totems <--
Enhancer.Totems[Enhancer.BS["Grace of Air Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Grace of Air Totem"]].Icon = "Spell_Nature_InvisibilityTotem";
Enhancer.Totems[Enhancer.BS["Grace of Air Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Grace of Air Totem"]].Element = "Air";
Enhancer.Totems[Enhancer.BS["Grace of Air Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Grace of Air Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Grace of Air Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Windfury Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Windfury Totem"]].Icon = "Spell_Nature_Windfury";
Enhancer.Totems[Enhancer.BS["Windfury Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Windfury Totem"]].Element = "Air";
Enhancer.Totems[Enhancer.BS["Windfury Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Windfury Totem"]].Pulse = 5;
Enhancer.Totems[Enhancer.BS["Windfury Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Windfury Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Grounding Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Grounding Totem"]].Icon = "Spell_Nature_GroundingTotem";
Enhancer.Totems[Enhancer.BS["Grounding Totem"]].Time = 45;
Enhancer.Totems[Enhancer.BS["Grounding Totem"]].Element = "Air";
Enhancer.Totems[Enhancer.BS["Grounding Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Grounding Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Grounding Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Windwall Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Windwall Totem"]].Icon = "Spell_Nature_EarthBind";
Enhancer.Totems[Enhancer.BS["Windwall Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Windwall Totem"]].Element = "Air";
Enhancer.Totems[Enhancer.BS["Windwall Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Windwall Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Windwall Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Sentry Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Sentry Totem"]].Icon = "Spell_Nature_RemoveCurse";
Enhancer.Totems[Enhancer.BS["Sentry Totem"]].Time = 300;
Enhancer.Totems[Enhancer.BS["Sentry Totem"]].Element = "Air";
Enhancer.Totems[Enhancer.BS["Sentry Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Sentry Totem"]].Range = nil;
Enhancer.Totems[Enhancer.BS["Sentry Totem"]].TotemicMastery = nil;

Enhancer.Totems[Enhancer.BS["Nature Resistance Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Nature Resistance Totem"]].Icon = "Spell_Nature_NatureResistanceTotem";
Enhancer.Totems[Enhancer.BS["Nature Resistance Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Nature Resistance Totem"]].Element = "Air";
Enhancer.Totems[Enhancer.BS["Nature Resistance Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Nature Resistance Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Nature Resistance Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Tranquil Air Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Tranquil Air Totem"]].Icon = "Spell_Nature_Brilliance";
Enhancer.Totems[Enhancer.BS["Tranquil Air Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Tranquil Air Totem"]].Element = "Air";
Enhancer.Totems[Enhancer.BS["Tranquil Air Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Tranquil Air Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Tranquil Air Totem"]].TotemicMastery = true;

Enhancer.Totems[Enhancer.BS["Wrath of Air Totem"]] = {};
Enhancer.Totems[Enhancer.BS["Wrath of Air Totem"]].Icon = "Spell_Nature_SlowingTotem";
Enhancer.Totems[Enhancer.BS["Wrath of Air Totem"]].Time = 120;
Enhancer.Totems[Enhancer.BS["Wrath of Air Totem"]].Element = "Air";
Enhancer.Totems[Enhancer.BS["Wrath of Air Totem"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Wrath of Air Totem"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Wrath of Air Totem"]].TotemicMastery = true;

--> Special <--
-- Enamored Water Spirit
Enhancer.Totems[Enhancer.BS["Enamored Water Spirit"]] = {};
Enhancer.Totems[Enhancer.BS["Enamored Water Spirit"]].Icon = "INV_Wand_01"; -- Trinket totem from Sunken Temple
Enhancer.Totems[Enhancer.BS["Enamored Water Spirit"]].Time = 24;
Enhancer.Totems[Enhancer.BS["Enamored Water Spirit"]].Element = "Water";
Enhancer.Totems[Enhancer.BS["Enamored Water Spirit"]].Life = 5;
Enhancer.Totems[Enhancer.BS["Enamored Water Spirit"]].Pulse = 2;
Enhancer.Totems[Enhancer.BS["Enamored Water Spirit"]].Range = 20;
Enhancer.Totems[Enhancer.BS["Enamored Water Spirit"]].TotemicMastery = nil;