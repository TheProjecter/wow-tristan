local AddOn = LibStub("AceAddon-3.0"):GetAddon("EquivalencePoints", true);
if (not AddOn) then return; end

--[[
			Explanation to the calculations below:
			Bloodlust Brooch (Use: Increases attack power by 278 for 20 sec.) forumla:
				GAIN * DURATION / COOLDOWN
				 278 *    20    / 120
			Dragonspine Trophy (Equip: Your melee and ranged attacks have a chance to increase your haste rating by 325 for 10 sec.) formula:
				GAIN * DURATION * PPM / MINUTE
				 325 *    10    * 1.5 / 60
			Ashtongue Talisman of Vision (Equip: Stormstrike has a 50% chance to grant up to 275 attack power for 10 sec.) formula:
				GAIN * DURATION * Chance / CD  -- Chance is 50 from each Stormstrike (that can be cast every 10 sec)
				 275 *    10    *   0.5  / 10
			
			ONLY ADD THE PROC/USE the other bonus will be found by ItemBonusLib
]]--
AddOn.BonusEP.ProcsAndUseVersion = "2.3.3";
AddOn.BonusEP.ProcsAndUse = {};

AddOn.BonusEP.ProcsAndUse[28437] = { ["CR_HASTE"] = (212 * 10 * 2 / 60) }; -- Drakefist Hammer, Chance on hit: Increases your haste rating by 212 for 10 sec. 2PPM
AddOn.BonusEP.ProcsAndUse[28438] = { ["CR_HASTE"] = (212 * 10 * 2 / 60) }; -- Dragonmaw, Chance on hit: Increases your haste rating by 212 for 10 sec. 2PPM
AddOn.BonusEP.ProcsAndUse[28439] = { ["CR_HASTE"] = (212 * 10 * 2 / 60) }; -- Dragonstrike, Chance on hit: Increases your haste rating by 212 for 10 sec. 2PPM

AddOn.BonusEP.ProcsAndUse[33507] = { ["ATTACKPOWER"] = (110 * 10 * 0.5 / 6) }; -- Stonebreaker's Totem (Had it at 55 dunno why)
AddOn.BonusEP.ProcsAndUse[28830] = { ["CR_HASTE"] = (325 * 10 * 1.5 / 60) }; -- Dragonspine Trophy
AddOn.BonusEP.ProcsAndUse[32505] = { ["IGNOREARMOR"] = (300 * 10 * 2.4 / 60) }; -- Madness of the Betrayer
AddOn.BonusEP.ProcsAndUse[30627] = { ["ATTACKPOWER"] = (340 * 10 * 0.9 / 60) }; -- Tsunami Talisman
AddOn.BonusEP.ProcsAndUse[32491] = { ["ATTACKPOWER"] = (275 * 10 * 0.5 / 10) }; -- Ashtongue Talisman of Vision (only AP part)
AddOn.BonusEP.ProcsAndUse[31856] = { ["ATTACKPOWER"] = 120 }; -- Darkmoon Card: Crusade
AddOn.BonusEP.ProcsAndUse[29383] = { ["ATTACKPOWER"] = (278 * 20 / 120) }; -- Bloodlust Brooch
AddOn.BonusEP.ProcsAndUse[28034] = { ["ATTACKPOWER"] = (300 * 10 * 0.9 / 60) }; -- Hourglass of the Unraveller
AddOn.BonusEP.ProcsAndUse[28034] = { ["CR_HASTE"] = (260 * 10 / 120) }; -- Abacus of Violent Odds
AddOn.BonusEP.ProcsAndUse[22954] = { ["CR_HASTE"] = (200 * 15 / 120) }; -- Kiss of the Spider

AddOn.BonusEP.ProcsAndUse[33831] = { ["ATTACKPOWER"] = (360 * 20 / 120) }; -- Berserker's Call
AddOn.BonusEP.ProcsAndUse[28041] = { ["ATTACKPOWER"] = (200 * 15 / 90) }; -- Bladefist's Breadth
-- AddOn.BonusEP.ProcsAndUse[32770] = { ["ATTACKPOWER"] = (140 * 30 * 2 / 60) }; -- Skyguard Silver Cross
AddOn.BonusEP.ProcsAndUse[21180] = { ["ATTACKPOWER"] = (280 * 20 / 120) }; -- Earthstrike
AddOn.BonusEP.ProcsAndUse[23041] = { ["ATTACKPOWER"] = (260 * 20 / 120) }; -- Slayer's Crest
AddOn.BonusEP.ProcsAndUse[23570] = { ["ATTACKPOWER"] = (357.5 * 10 / 120) }; -- Jom Gabbar
AddOn.BonusEP.ProcsAndUse[28528] = { ["CR_DODGE"] = (300 * 10 / 120) }; -- Moroes' Lucky Pocket Watch

AddOn.BonusEP.ProcsAndUse[29301] = { ["ATTACKPOWER"] = (160 * 10 / 60) }; -- Band of the Eternal Champion

AddOn.BonusEP.ProcsAndUse[32658] = { ["AGI"] = (150 * 20 / 120) }; -- Badge of Tenacity