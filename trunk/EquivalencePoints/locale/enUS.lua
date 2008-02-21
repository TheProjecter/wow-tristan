local L = LibStub("AceLocale-3.0"):NewLocale("EquivalencePoints", "enUS", true)

--> _ <--
L["_print"] = "|cff" .. "ffdc5f" .. "EquivalencePoints" .. "|r" .. ":";
L["_debug"] = "|cff" .. "ff7777" .. "EquivalencePoints Debug" .. "|r" .. ":";

--> SlashCommands <--
L["/EqP"] = "EqP";
L["/Equiv"] = "Equiv";
L["/EquivalencePoints"] = "EquivalencePoints";

--> Command <--
L["_cmd _name EquivalencePoints"] = "EquivalencePoints";
L["_cmd _name config"] = "config";
L["_cmd _name Hack Expertise"] = "Hack Expertise";
L["_cmd _name Consumables"] = "Consumables";
L["_cmd _name Procs and Use"] = "Procs and Use";
L["_cmd _name List Gems"] = "List Gems";
L["_cmd _name List Set Gems"] = "List Set Gems";
L["_cmd _name Class Specifics"] = "Class Specifics";
L["_cmd _name Race Specifics"] = "Race Specifics";
L["_cmd _name Layout"] = "Layout";
L["_cmd _name Show Zero"] = "Show Zero";
L["_cmd _name Show no Bonus items"] = "Show no Bonus items";
L["_cmd _name Empty Line Above"] = "Empty Line Above";
L["_cmd _name Empty Line Below"] = "Empty Line Below";
L["_cmd _name Colors"] = "Colors";
L["_cmd _name Color"] = "Color";
L["_cmd _name Class color"] = "Class color";
L["_cmd _name Values"] = "Values";
L["_cmd _name Sets"] = "Sets";
L["_cmd _name Set operations"] = "Set operations";
L["_cmd _name Save as Set"] = "Save as Set";
L["_cmd _name Delete set"] = "Delete set";
L["_cmd _name Load set"] = "Load set";
L["_cmd _name Set Visibility"] = "Set Visibility";
L["_cmd _name Hide set"] = "Hide set";
L["_cmd _name UnHide set"] = "UnHide set";
L["_cmd _name Import"] = "Import";
L["_cmd _name Lootrank http://www.lootrank.com/"] = "Lootrank http://www.lootrank.com";
L["_cmd _name CrazyShaman http://theorycraft.narod.ru/"] = "CrazyShaman http://theorycraft.narod.ru";
L["_cmd _name Preset values"] = "Preset values";
L["_cmd _name Settings"] = "Settings";
L["_cmd _name Receive values"] = "Receive values";
L["_cmd _name Session"] = "Session";
L["_cmd _name Import"] = "Import";
L["_cmd _name Enhancer Import Options"] = "Enhancer Import Options";
L["_cmd _name EAEP"] = "EAEP";
L["_cmd _name EHEP"] = "EHEP";
L["_cmd _name EDEP"] = "EDEP";
L["_cmd _name Export"] = "Export";
L["_cmd _name Send values"] = "Send values";
L["_cmd _name Session"] = "Session";
L["_cmd _name Export"] = "Export";
L["_cmd _name Gems"] = "Gems";
L["_cmd _name Match Rarity"] = "Match Rarity";
L["_cmd _name Max Rarity"] = "Max Rarity";
L["_cmd _name Max Avail Rarity"] = "Max Avail Rarity";
L["_cmd _name Best colored Gem"] = "Best colored Gem";
L["_cmd _name Blue"] = "Blue";
L["_cmd _name Red"] = "Red";
L["_cmd _name Yellow"] = "Yellow";
L["_cmd _name Best meta Gem"] = "Best meta Gem";
L["_cmd _name Meta"] = "Meta";
L["_cmd _name Best non-meta Gem"] = "Best non-meta Gem";
L["_cmd _name Any"] = "Any";
L["_cmd _name Dev Tools"] = "Dev Tools";
L["_cmd _name Debug"] = "Debug";
L["_cmd _name Reset"] = "Reset";
L["_cmd _name Contact"] = "Contact";
L["_cmd _name E-mail"] = "E-mail";
L["_cmd _name Website"] = "Website";


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
L["%s ignore socket colors"] = true;
L["Values are datamined (v%s)"] = true;
L["Equivalence (BoK)"] = true;

--> Information <--
L["Auto imported your |cffff0000AEP|r values from Enhancer!"] = true;
L["Receiving data from %s"] = true;

--> Errors <--
L["Set not specified, import aborted!"] = true;
L["set [%s] not found, import aborted!"] = true;
L["Error adding class specifics for %s"] = true;
L["Import failed, could not deserialize the data!"] = true;
L["Import failed, the data wasn't a table with values!"] = true;
L["Import ignored due to settings, you can find the toggle under the import tab in /eqp config"] = true;

L["for function [BestGem] itemRarity has to be a number!"] = true;
L["for function [BestGem] GemCacheKeyBase must be included!"] = true;

--> Misc <--
L["Best %s gem is %s at %.2f"] = true;
L["Best %s gem BoK is %s at %.2f"] = true;
L["Set imported as [%s]"] = true;
L["Import complete stats affected:"] = true;
L["Bonus Value to Meta Gems"] = true;
L["|cff77ff77Saved [|r%s (BoK)|cff77ff77]|r"] = true;