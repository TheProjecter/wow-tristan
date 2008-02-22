local L = LibStub("AceLocale-3.0"):NewLocale("EquivalencePoints", "enUS", true)

--> Misc <--
L["__URL__"] = "http://code [dot] google [dot] com/p/wow-tristan/";
L["__EMAIL__"] = "dennis [dot] hafstrom [at] gmail [dot] com";

L["__CRAZYSHAMAN_URL__"] = "http://theorycraft.narod.ru";

--> _ <--
L["_print"] = "|cff" .. "ffdc5f" .. "EquivalencePoints" .. "|r" .. ":";
L["_debug"] = "|cff" .. "ff7777" .. "EquivalencePoints Debug" .. "|r" .. ":";

--> SlashCommands <--
L["/EqP"] = "EqP";
L["/Equiv"] = "Equiv";
L["/EquivalencePoints"] = "EquivalencePoints";

--> Command <--
L["_cmd _name EquivalencePoints"] = "EquivalencePoints";
L["_cmd _name Config"] = "Config";
L["_cmd _desc Config"] = "Opens Config Dialog";
L["_cmd _name Hack Expertise"] = "Hack Expertise";
L["_cmd _desc Hack Expertise"] = "Only account for usable Expertise Rating on items.";
L["_cmd _name Consumables"] = "Consumables";
L["_cmd _desc Consumables"] = "DataMined bonuses for Consumables.";
L["_cmd _name Procs and Use"] = "Procs and Use";
L["_cmd _desc Procs and Use"] = "Calculated bonuses for procs and/or use effects.";
L["_cmd _name List Gems"] = "List Gems";
L["_cmd _desc List Gems"] = "List gems used in calculations.";
L["_cmd _name List Set Gems"] = "List Set Gems";
L["_cmd _desc List Set Gems"] = "List gems used in calculations even for sets.";
L["_cmd _name Class Specifics"] = "Class Specifics";
L["_cmd _desc Class Specifics"] = "Some classes have a bit more info that EP can display, check this if you want to see it.";
L["_cmd _name Race Specifics"] = "Race Specifics";
L["_cmd _desc Race Specifics"] = "Adds expertise to swords if you're Human, expertise to axes if you're an Orc etc etc.";
L["_cmd _name Layout"] = "Layout";
L["_cmd _name Zero values options"] = "Zero values options";
L["_cmd _name Show Zero"] = "Show Zero";
L["_cmd _desc Show Zero"] = "Show Equivalence Points even if the values is zero.";
L["_cmd _name Show no Bonus items"] = "Show no Bonus items";
L["_cmd _desc Show no Bonus items"] = "Show the zero even if the item has no bonuses at all (only when ShowZero is active).";
L["_cmd _name Empty Line Above"] = "Empty Line Above";
L["_cmd _desc Empty Line Above"] = "Adds an empty line above the data in the tooltip.";
L["_cmd _name Empty Line Below"] = "Empty Line Below";
L["_cmd _desc Empty Line Below"] = "Adds an empty line below the data in the tooltip.";
L["_cmd _name Colors"] = "Colors";
L["_cmd _name Color"] = "Color";
L["_cmd _desc Color"] = "Change the color of the text in tooltips.";
L["_cmd _name Class color"] = "Class color";
L["_cmd _desc Class color"] = "Colors the class specific data with class colors.";
L["_cmd _name Values"] = "Values";
L["_cmd _name Sets"] = "Sets";
L["_cmd _name Set operations"] = "Set operations";
L["_cmd _name Save as Set"] = "Save as Set";
L["_cmd _desc Save as Set"] = "Save current values as an alternative Set";
L["_cmd _name Delete set"] = "Delete set";
L["_cmd _desc Delete set"] = "Delete a saved set.";
L["_cmd _name Load set"] = "Load set";
L["_cmd _desc Load set"] = "Load a saved set.";
L["_cmd _name Set Visibility"] = "Set Visibility";
L["_cmd _name Hide set"] = "Hide set";
L["_cmd _desc Hide set"] = "Prevents a saved set from showing up in tooltips.";
L["_cmd _name UnHide set"] = "UnHide set";
L["_cmd _desc UnHide set"] = "Make a hidden set show up in tooltips again.";
L["_cmd _name Import"] = "Import";
L["_cmd _name Lootrank http://www.lootrank.com/"] = "Lootrank http://www.lootrank.com";
L["_cmd _desc Lootrank http://www.lootrank.com/"] = "Import data from lootrank by entering a lootrank url.";
L["_cmd _name CrazyShaman http://theorycraft.narod.ru/"] = "CrazyShaman http://theorycraft.narod.ru";
L["_cmd _desc CrazyShaman http://theorycraft.narod.ru/"] = "Import data from CrazyShaman simulator.  http://theorycraft.narod.ru";
L["_cmd _name Preset values"] = "Preset values";
L["_cmd _desc Preset values"] = "Import preset values.";
L["_cmd _name Settings"] = "Settings";
L["_cmd _name Receive values"] = "Receive values";
L["_cmd _desc Receive values"] = "Allow other users of this AddOn to send you their values. (Imports into a set rather then overwriting)";
L["_cmd _name Session"] = "Session";
L["_cmd _name Import"] = "Import";
L["_cmd _desc Import"] = "Import data from another session.";
L["_cmd _name Enhancer Import Options"] = "Enhancer Import Options";
L["_cmd _name EAEP"] = "EAEP";
L["_cmd _desc EAEP"] = "Import Enhancer AEP values (only works if Enhancer is loaded ;).";
L["_cmd _name EHEP"] = "EHEP";
L["_cmd _desc EHEP"] = "Import Enhancer HEP values (only works if Enhancer is loaded ;).";
L["_cmd _name EDEP"] = "EDEP";
L["_cmd _desc EDEP"] = "Import Enhancer DEP values (only works if Enhancer is loaded ;).";
L["_cmd _name Export"] = "Export";
L["_cmd _name Send values"] = "Send values";
L["_cmd _desc Send values"] = "Send your main values to a friend.";
L["_cmd _name Session"] = "Session";
L["_cmd _name Export"] = "Export";
L["_cmd _desc Export"] = "Copy paste what's in the textbox and you can import it to another char via import tab.";
L["_cmd _name Gems"] = "Gems";
L["_cmd _name Match Rarity"] = "Match Rarity";
L["_cmd _desc Match Rarity"] = "MatchRarity will use rare gems for rare gear, epic gems for epic gear and so forth.";
L["_cmd _name Max Rarity"] = "Max Rarity";
L["_cmd _desc Max Rarity"] = "Sets the maximum rarity for gems (unless overriden by MatchRarity or MaxAvailRarity)";
L["_cmd _name Rarity Settings"] = "Rarity Settings";
L["_cmd _name Max Avail Rarity"] = "Max Avail Rarity";
L["_cmd _desc Max Avail Rarity"] = "Sets the maximum rarity for gems you have access to (overrides MaxRarity)";
L["_cmd _name Best colored Gem"] = "Best colored Gem";
L["_cmd _name Blue"] = "Blue";
L["_cmd _desc Blue"] = "Display best Blue gem";
L["_cmd _name Red"] = "Red";
L["_cmd _desc Red"] = "Display best Red gem";
L["_cmd _name Yellow"] = "Yellow";
L["_cmd _desc Yellow"] = "Display best Yellow gem";
L["_cmd _name Best meta Gem"] = "Best meta Gem";
L["_cmd _name Meta"] = "Meta";
L["_cmd _desc Meta"] = "Display best Meta gem";
L["_cmd _name Best non-meta Gem"] = "Best non-meta Gem";
L["_cmd _name Any"] = "Any";
L["_cmd _desc Any"] = "Display best non-Meta gem";
L["_cmd _name Dev Tools"] = "Dev Tools";
L["_cmd _name Debug"] = "Debug";
L["_cmd _desc Debug"] = "Toggle Debugging";
L["_cmd _name Contact"] = "Contact";
L["_cmd _name E-mail"] = "E-mail";
L["_cmd _desc E-mail"] = "Copy paste email address into mailing client (Brush it up first ;).";
L["_cmd _name Website"] = "Website";
L["_cmd _desc Website"] = "Copy paste URL into browser.";
L["_cmd _name Reset"] = "Reset";
L["_cmd _desc Reset"] = "Reset all values to zero";
L["_cmd _desc _Values"] = "Set value for %s";

--> Presets <--
L["_preset Shaman (Enhance Low-Level)"] = "Shaman (Enhance Low-Level)";
L["_preset Shaman (Enhance Medium-Level)"] = "Shaman (Enhance Medium-Level)";
L["_preset Shaman (Enhance High-Level)"] = "Shaman (Enhance High-Level)";
L["_preset Shaman (Restoration Medium-Level)"] = "Shaman (Restoration Medium-Level)";
L["_preset Shaman (Restoration High-Level)"] = "Shaman (Restoration High-Level)";
L["_preset Mage (Frost)"] = "Mage (Frost)";
L["_preset Mage (Fire)"] = "Mage (Fire)";
L["_preset Rogue"] = "Rogue";
L["_preset Priest (Holy)"] = "Priest (Holy)";
L["_preset Warlock (Affliction)"] = "Warlock (Affliction)";
L["_preset Paladin (Protection)"] = "Paladin (Protection)";
L["_preset Druid (Restoration)"] = "Druid (Restoration)";
L["_preset Warlock (Destruction)"] = "Warlock (Destruction)";
L["_preset Warrior (Protection)"] = "Warrior (Protection)";
L["_preset Warrior (DPS)"] = "Warrior (DPS)";
L["_preset Hunter (Beast Mastery)"] = "Hunter (Beast Mastery)";

--> Import <-- don't make em too long!
L["_import Crazy Shaman Simulator"] = "CrazyShaman";
L["_import Lootrank"] = "Lootrank%s";
L["_import Lootrank Title"] = " (%s)"; -- get's appended to the %s in the above if it's available otherwise it's "" that takes the %s place

--> ItemSubType <--
L["Guns"] = true;
L["One-Handed Maces"] = true;
L["One-Handed Swords"] = true;
L["Two-Handed Maces"] = true;
L["Two-Handed Swords"] = true;
L["One-Handed Axes"] = true;
L["Two-Handed Axes"] = true;
L["Bows"] = true;
L["Thrown"] = true;

--> Tooltip lines <--
L["Gem List:"] = true;
L["Racial bonus added %.2f ranged crit rating"] = true;
L["Racial bonus added %.2f expertise rating"] = true;
L["Proc/use are guestimated (v%s)"] = true;
L["Expertise is modified (floor([val]/%.2f)*%.2f)"] = true;
L["%s ignore socket colors"] = true; -- "|cffff0000*|r"
L["Values are datamined (v%s)"] = true;
L["Equivalence (BoK)"] = true;
L["%.2f%s (%.2f%s)"] = "%.2f%s (%.2f%s)"; -- Used in tooltips on right side when presenting values
L["%s %s"] = "%s %s"; -- Used in tooltips for Gem Lists input is "Normal Gem Name", "(BoK Gem Name)"
L["_tooltip _rightside Gem List"] = "%s %s";
L["_tooltip Ignore Color"] = "|cff" .. "ff0000" .. "*" .. "|r";

--> Information <--
L["Auto imported your |cffff0000AEP|r values from Enhancer!"] = true;
L["Receiving data from %s"] = true;
L["Set imported as [%s], state set to Hidden"] = true;
L["Lootrank doesn't differ between ranged/melee crit & hit, so if you wanted ranged you should import the set and change it's values! By default the import is to Melee!"] = true;

--> Errors <--
L["Set not specified, import aborted!"] = true;
L["set [%s] not found, import aborted!"] = true;
L["Set [%s] isn't hidden!"] = true;
L["Set [%s] is allready hidden!"] = true;
L["Set [%s] doesn't exist!"] = true;
L["Set [%s] allready exists!"] = true;
L["Values in this AddOn can't go above 10 please check your input"] = true;
L["Error adding class specifics for %s"] = true;
L["Import failed, could not deserialize the data!"] = true;
L["Import failed, the data wasn't a table with values!"] = true;
L["Import ignored due to settings, you can find the toggle under the import tab in /eqp config"] = true;

L["for function [BestGem] itemRarity has to be a number!"] = true;
L["for function [BestGem] GemCacheKeyBase must be included!"] = true;

L["Enhancer not found, import aborted"] = true;

--> Misc <--
L["Best %s gem is %s at %.2f"] = true;
L["Best %s gem BoK is %s at %.2f"] = true;
L["Import complete stats affected:"] = true;
L["Bonus Value to Meta Gems"] = true;
L["|cff77ff77Saved [|r%s (BoK)|cff77ff77]|r"] = true;
L["Set Import Import_001 text"] = "%s_%.3i";