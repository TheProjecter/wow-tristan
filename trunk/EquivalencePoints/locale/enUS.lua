local L = LibStub("AceLocale-3.0"):NewLocale("EquivalencePoints", "enUS", true)

--> _ <--
L["_print"] = "|cff" .. "ffdc5f" .. "EquivalencePoints" .. "|r" .. ":";
L["_debug"] = "|cff" .. "ff7777" .. "EquivalencePoints Debug" .. "|r" .. ":";

--> SlashCommands <--
L["/EqP"] = "EqP";
L["/Equiv"] = "Equiv";
L["/EquivalencePoints"] = "EquivalencePoints";

--> Command <--
L["_cmd _name EquivalencePoints"] = true;
L["_cmd _name config"] = true;
L["_cmd _name Hack Expertise"] = true;
L["_cmd _name Consumables"] = true;
L["_cmd _name Procs and Use"] = true;
L["_cmd _name List Gems"] = true;
L["_cmd _name List Set Gems"] = true;


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