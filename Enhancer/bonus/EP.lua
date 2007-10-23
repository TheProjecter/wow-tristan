local L = AceLibrary("AceLocale-2.2"):new("EnhancerEP")
EnhancerEP = Enhancer:NewModule("EP", "AceEvent-2.0");
Enhancer:SetModuleDefaultState("EP", true);

local ibl = AceLibrary("ItemBonusLib-1.0");
local TipHooker = AceLibrary("TipHooker-1.0");
local Gratuity = AceLibrary("Gratuity-2.0")

function EnhancerEP:OnInitialize()
	-- Give guesstimate bonus to special gems/items
	self.gems["Relentless Earthstorm Diamond"]["AEP"] = 75; -- 3% Increased Critical Damage
	self.gems["Relentless Earthstorm Diamond"]["AEPH"] = 75; -- 3% Increased Critical Damage
	--[[
                3% Increased Critical Damage -- is given 75 for Enhancement EP above
                +4 Resist All
                2% Reduced Threat
                +3 Melee Damage
                Chance to Stun Target
                +14 Spell Crit Rating and 
                1% Spell Reflect
                5% Snare and Root Resist
                5% Stun Resistance
                Chance to restore mana on spellcast
                5% on spellcast - next spell cast in half time
                5% Stun Resistance
                5% Stun Resist
                +3 Resist All
                3% Increased Critical Damage
                Minor Run Speed Increase
                Chance to Restore Health on hit
                Chance to Increase Melee/Ranged Attack Speed
	]]--
	
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
	]]--
	self.ProcsAndUse = {};
	self.ProcsAndUse[28437] = { ["CR_HASTE"] = (212 * 10 * 2 / 60) }; -- Drakefist Hammer, Chance on hit: Increases your haste rating by 212 for 10 sec. 2PPM
	self.ProcsAndUse[28438] = { ["CR_HASTE"] = (212 * 10 * 2 / 60) }; -- Dragonmaw, Chance on hit: Increases your haste rating by 212 for 10 sec. 2PPM
	self.ProcsAndUse[28439] = { ["CR_HASTE"] = (212 * 10 * 2 / 60) }; -- Dragonstrike, Chance on hit: Increases your haste rating by 212 for 10 sec. 2PPM
	
	self.ProcsAndUse[33507] = { ["ATTACKPOWER"] = (110 * 10 * 0.5 / 6) }; -- Stonebreaker's Totem (Had it at 55 dunno why)
	self.ProcsAndUse[28830] = { ["CR_HASTE"] = (325 * 10 * 1.5 / 60) }; -- Dragonspine Trophy
	self.ProcsAndUse[32505] = { ["IGNOREARMOR"] = (300 * 10 * 2.4 / 60) }; -- Madness of the Betrayer
	self.ProcsAndUse[30627] = { ["ATTACKPOWER"] = (340 * 10 * 0.9 / 60) }; -- Tsunami Talisman
	self.ProcsAndUse[32491] = { ["ATTACKPOWER"] = (275 * 10 * 0.5 / 10) }; -- Ashtongue Talisman of Vision (only AP part)
	self.ProcsAndUse[31856] = { ["ATTACKPOWER"] = 120 }; -- Darkmoon Card: Crusade
	self.ProcsAndUse[29383] = { ["ATTACKPOWER"] = (278 * 20 / 120) }; -- Bloodlust Brooch
	self.ProcsAndUse[28034] = { ["ATTACKPOWER"] = (300 * 10 * 0.9 / 60) }; -- Hourglass of the Unraveller
	self.ProcsAndUse[28034] = { ["CR_HASTE"] = (260 * 10 / 120) }; -- Abacus of Violent Odds
	self.ProcsAndUse[22954] = { ["CR_HASTE"] = (200 * 15 / 120) }; -- Kiss of the Spider
	
	self.ProcsAndUse[33831] = { ["ATTACKPOWER"] = (360 * 20 / 120) }; -- Berserker's Call
	self.ProcsAndUse[28041] = { ["ATTACKPOWER"] = (200 * 15 / 90) }; -- Bladefist's Breadth
	-- self.ProcsAndUse[32770] = { ["ATTACKPOWER"] = (140 * 30 * 2 / 60) }; -- Skyguard Silver Cross
	self.ProcsAndUse[21180] = { ["ATTACKPOWER"] = (280 * 20 / 120) }; -- Earthstrike
	self.ProcsAndUse[23041] = { ["ATTACKPOWER"] = (260 * 20 / 120) }; -- Slayer's Crest
	self.ProcsAndUse[23570] = { ["ATTACKPOWER"] = (357.5 * 10 / 120) }; -- Jom Gabbar
	self.ProcsAndUse[28528] = { ["CR_DODGE"] = (300 * 10 / 120) }; -- Moroes' Lucky Pocket Watch
	
	self.ProcsAndUse[29301] = { ["ATTACKPOWER"] = (160 * 10 / 60) }; -- Band of the Eternal Champion
	
	--[[ For some reason I can't get TipHooker to work without enabling
			 RatingBuster wich sux so I hacked a bit here ]]--
	self:ScheduleEvent("Tooltip", self.Tooltip, 1, self);
end

function EnhancerEP:OnEnable()
	TipHooker:Hook(self.ProcessTooltip, "item");
end

function EnhancerEP:OnDisable()
	TipHooker:Unhook(self.ProcessTooltip, "item");
end

function EnhancerEP:Tooltip()
	--[[ For some reason I can't get TipHooker to work without enabling
			 RatingBuster wich sux so I hacked a bit here ]]--
	local FunctionThatNeverExecutes = TipHooker.OnEventFrame:GetScript("OnEvent");
	pcall( FunctionThatNeverExecutes );
end

local TypeSufixString = "|cffff0000*|r";
local TopSufixString = "|cffff0000^|r";
function EnhancerEP:TypeSufix(values, itemid, careProcsOrUse)
	itemid = tonumber(itemid);
	if (not itemid) then return "", careProcsOrUse; end
	if (not self.ProcsAndUse[itemid]) then return "", careProcsOrUse; end
	if (not Enhancer.db.profile.EPGems.EPGuesstimates) then return "", careProcsOrUse; end
	
	for k, _ in pairs(values) do
		if (self.ProcsAndUse[itemid][k]) then
			return TypeSufixString, true;
		end
	end
	
	return "", careProcsOrUse;
end

EnhancerEP.ProcessTypes = { [L["Armor"]] = true, [L["Gem"]] = true, [L["Weapon"]] = true, [L["Recipe"]] = true, }
EnhancerEP.AffectedByKings = { STR = true, AGI = true, STA = true, INT = true, SPI = true};
function EnhancerEP.ProcessTooltip(tooltip, name, link)
	if (link) then
		local self = EnhancerEP;
		
		--[[ Check if we care about this item ]]--
		local _, _, itemRarity, _, _, ItemType, ItemSubType, _, equipLocation = GetItemInfo(link)
		if (not self.ProcessTypes[ItemType]) then return; end
		
		local numberFormat = L["ep_numbers2"];
		
		--[[ ItemBonusLib doesn't count empty sockets wich we prefer since
				 inspected gear can have shit gems in them ;) ]]--
		local itemid;
		
		link, itemid = EnhancerEP:StripGemsAndEnchants(link);
		local bonuses = ibl:ScanItem(link, true, false);
		local knownUnvaluedProcs = { [32491] = true, [32770] = true, }
		
		--[[ Should add proc / use bonuses here ]]--
		if (tonumber(itemid) and self.ProcsAndUse[tonumber(itemid)] and Enhancer.db.profile.EPGems.EPGuesstimates and bonuses and not bonuses["Procs Added"]) then
			for k,v in pairs(self.ProcsAndUse[tonumber(itemid)]) do
				bonuses[k] = (bonuses[k] or 0) + v;
				bonuses["Procs Added"] = true;
			end
		end
		local hasProcsOrUse = bonuses["Procs Added"];
		local unknownProcs = false;
		local sufix, careProcsOrUse = "", false;
		
		local lineAdded = nil;
		local kingsMultiplier = (110 / 100);
		
		--[[ Count sockets ]]--
		local redSockets = bonuses["EMPTY_SOCKET_RED"] or 0;
		local blueSockets = bonuses["EMPTY_SOCKET_BLUE"] or 0;
		local yellowSockets = bonuses["EMPTY_SOCKET_YELLOW"] or 0;
		local metaSockets = bonuses["EMPTY_SOCKET_META"] or 0;
		local nonMetaSockets = redSockets + blueSockets + yellowSockets;
		
		if (Enhancer.debug) then Enhancer:Print("metaSockets", metaSockets, "-", "nonMetaSockets", nonMetaSockets) end
		
		--[[ Check Procs ]]--
		Gratuity:SetHyperlink(link)
		for i = 2, Gratuity:NumLines() do
			local line = Gratuity:GetLine(i)
			if ((string.find(line, L["Chance on hit:"]) and (not hasProcsOrUse)) or knownUnvaluedProcs[tonumber(itemid) or "0"]) then
				unknownProcs = true;
			end
		end
		
		local lastValue, lastKingsValue;
		local _, eClass = UnitClass("player");
		local ttR, ttG, ttB = RAID_CLASS_COLORS[eClass]["r"], RAID_CLASS_COLORS[eClass]["g"], RAID_CLASS_COLORS[eClass]["b"];
		
		lastValue, lastKingsValue = nil, nil; -- Reset these between different types of EP (used for compairing a main set with a subset, such as all values but hit)
		--[[ Do Attackpower Equivalence Points ]]--
		if (Enhancer.db.profile.AEP) then
			local values = {};
			for stat,value in pairs(Enhancer.db.profile.AEPNumbers) do
				values[stat] = {};
				values[stat]["value"] = Enhancer.db.profile.AEPNumbers[stat];
				values[stat]["kings"] = EnhancerEP.AffectedByKings[stat];
			end
			
			-- EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey, itemrarity)
			-- return total, kingstotal, gemName, kingsgemName, metagemName, kingsmetagemName;
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "AEP", itemRarity);
			sufix, careProcsOrUse = self:TypeSufix(values, itemid, careProcsOrUse);
			lastValue, lastKingsValue = EP, EPK;
			
			if ( EP > 0 or Enhancer.db.profile.EPZero ) then
				if (not lineAdded) then
					tooltip:AddLine(" ");
					tooltip:AddLine(string.format(L["eep_info"], ((unknownProcs and TopSufixString) or "")), ttR, ttG, ttB);
					lineAdded = true;
				end
				
				tooltip:AddDoubleLine(string.format(L["aep_tooltip"], sufix), string.format( numberFormat, EP, EPK ), ttR, ttG, ttB, ttR, ttG, ttB);
			end
		end
		
		--[[ Do Attackpower Equivalence Points but without hit ]]--
		if (Enhancer.db.profile.AEPH) then
			local values = {};
			for stat,value in pairs(Enhancer.db.profile.AEPNumbers) do
				if (stat ~= "CR_HIT") then -- WITHOUT HIT!
					values[stat] = {};
					values[stat]["value"] = Enhancer.db.profile.AEPNumbers[stat];
					values[stat]["kings"] = EnhancerEP.AffectedByKings[stat];
				end
			end
			
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "AEPH", itemRarity);
			sufix, careProcsOrUse = self:TypeSufix(values, itemid, careProcsOrUse);
			
			local skipThis = ( lastValue and lastKingsValue and lastValue == EP and lastKingsValue == EPK );
			if ( (EP > 0 or Enhancer.db.profile.EPZero) and (not skipThis) ) then
				if (not lineAdded) then
					tooltip:AddLine(" ");
					tooltip:AddLine(string.format(L["eep_info"], ((unknownProcs and TopSufixString) or "")), ttR, ttG, ttB);
					lineAdded = true;
				end
				
				tooltip:AddDoubleLine(string.format(L["aeph_tooltip"], sufix), string.format( numberFormat, EP, EPK ), ttR, ttG, ttB, ttR, ttG, ttB);
			end
		end
		
		lastValue, lastKingsValue = nil, nil; -- Reset these between different types of EP (used for compairing a main set with a subset, such as all values but hit)
		--[[ Do Healing Equivalence Points ]]--
		if (Enhancer.db.profile.HEP) then
			local values = {};
			for stat,value in pairs(Enhancer.db.profile.HEPNumbers) do
				values[stat] = {};
				values[stat]["value"] = Enhancer.db.profile.HEPNumbers[stat];
				values[stat]["kings"] = EnhancerEP.AffectedByKings[stat];
			end
			
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "HEP", itemRarity);
			sufix, careProcsOrUse = self:TypeSufix(values, itemid, careProcsOrUse);
			
			if ( EP > 0 or Enhancer.db.profile.EPZero) then
				if (not lineAdded) then
					tooltip:AddLine(" ");
					tooltip:AddLine(string.format(L["eep_info"], ((unknownProcs and TopSufixString) or "")), ttR, ttG, ttB);
					lineAdded = true;
				end
				
				tooltip:AddDoubleLine(string.format(L["hep_tooltip"], sufix), string.format( numberFormat, EP, EPK ), ttR, ttG, ttB, ttR, ttG, ttB);
			end
		end
		
		lastValue, lastKingsValue = nil, nil; -- Reset these between different types of EP (used for compairing a main set with a subset, such as all values but hit)
		--[[ Do spellDamage Equivalence Points ]]--
		if (Enhancer.db.profile.DEP) then
			local values = {};
			for stat,value in pairs(Enhancer.db.profile.DEPNumbers) do
				values[stat] = {};
				values[stat]["value"] = Enhancer.db.profile.DEPNumbers[stat];
				values[stat]["kings"] = EnhancerEP.AffectedByKings[stat];
			end
			
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "DEP", itemRarity);
			sufix, careProcsOrUse = self:TypeSufix(values, itemid, careProcsOrUse);
			lastValue, lastKingsValue = EP, EPK;
			
			if ( EP > 0 or Enhancer.db.profile.EPZero) then
				if (not lineAdded) then
					tooltip:AddLine(" ");
					tooltip:AddLine(string.format(L["eep_info"], ((unknownProcs and TopSufixString) or "")), ttR, ttG, ttB);
					lineAdded = true;
				end
				
				tooltip:AddDoubleLine(string.format(L["dep_tooltip"], sufix), string.format( numberFormat, EP, EPK ), ttR, ttG, ttB, ttR, ttG, ttB);
			end
		end
		
		--[[ Do spellDamage Equivalence Points but without hit ]]--
		if (Enhancer.db.profile.DEP) then
			local values = {};
			for stat,value in pairs(Enhancer.db.profile.DEPNumbers) do
				if (stat ~= "CR_SPELLHIT") then -- WITHOUT HIT!
					values[stat] = {};
					values[stat]["value"] = Enhancer.db.profile.DEPNumbers[stat];
					values[stat]["kings"] = EnhancerEP.AffectedByKings[stat];
				end
			end
			
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "DEP", itemRarity);
			sufix, careProcsOrUse = self:TypeSufix(values, itemid, careProcsOrUse);
			
			local skipThis = ( lastValue and lastKingsValue and lastValue == EP and lastKingsValue == EPK );
			if ( (EP > 0 or Enhancer.db.profile.EPZero) and (not skipThis) ) then
				if (not lineAdded) then
					tooltip:AddLine(" ");
					tooltip:AddLine(string.format(L["eep_info"], ((unknownProcs and TopSufixString) or "")), ttR, ttG, ttB);
					lineAdded = true;
				end
				
				tooltip:AddDoubleLine(string.format(L["deph_tooltip"], sufix), string.format( numberFormat, EP, EPK ), ttR, ttG, ttB, ttR, ttG, ttB);
			end
		end
		
		-- http://www.wowwiki.com/Formulas:Item_Values Calculate ItemLevel based on stats you care about ;)
		--[[ Do Enhancement ItemLevel ]]--
		if (Enhancer.db.profile.EIP) then
			--[[ Set point values here so it's easy to change ]]--
			values = {
				["ATTACKPOWER"] = { ["value"] = (5 / 10), ["kings"] = nil },
				
				["STR"] = { ["value"] = 1, ["kings"] = nil },
				["AGI"] = { ["value"] = 1, ["kings"] = nil },
				
				["CR_CRIT"] = { ["value"] = 1, ["kings"] = nil },
				["CR_HIT"] = { ["value"] = 1, ["kings"] = nil },
				["CR_HASTE"] = { ["value"] = 1, ["kings"] = nil },
			};
			
			local IP = EnhancerEP:ItemValue(values, bonuses, gemcount, metacount, link);
			sufix, careProcsOrUse = self:TypeSufix(values, itemid, careProcsOrUse);
			
			if ( IP > 0 or Enhancer.db.profile.EPZero) then
				tooltip:AddDoubleLine(string.format(L["eip_tooltip"], sufix), string.format("%.1f", IP), ttR, ttG, ttB, ttR, ttG, ttB);
				lineAdded = true;
			end
		end
		
		-- GOTO
		if (lineAdded and careProcsOrUse) then --hasProcsOrUse) then
			tooltip:AddLine( L["ep_procsanduse"], 1, 0, 0 );
		end
		if (lineAdded and unknownProcs) then
			tooltip:AddLine( L["ep_procsandusemissing"], 1, 0, 0 );
		end
		
		if (lineAdded) then
			tooltip:Show();
		end
	end
end

function EnhancerEP:StripGemsAndEnchants(itemlink)
	local found, _, itemstring = string.find(itemlink, "^|c%x+|H(.+)|h%[.+%]")
	if (not found) then return itemlink; end
	
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", itemstring)
	enchantId = "0";
	jewelId1 = "0";
	jewelId2 = "0";
	jewelId3 = "0";
	jewelId4 = "0";
	local newItemString = strjoin(":", linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId);
	local _, newLink = GetItemInfo(newItemString);
	return newLink, itemId;
end

function EnhancerEP:ItemValue(values, bonuses, gemcount, metacount, link)
	-- local ItemValue = math.pow( (math.pow( (12 * 1), 1.5 ) + math.pow( (22 * 1), 1.5 ) + math.pow( (9 * 1), 1.5 )), (2/3) );
	-- local ItemSlotValue = ItemValue * 1.82; -- Ring, skip
	-- local ilvl = ItemSlotValue * 1.3 + 1.30; -- Epic, skip
	
	local ItemValue = 0;
	
	for statKey, statTable in pairs(values) do
		ItemValue = ItemValue + math.pow( ((bonuses[statKey] or 0) * statTable.value), 1.5 );
	end
	
	return math.pow(ItemValue, (2/3));
end

local kingsMultiplier = (110 / 100);
function EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey, itemrarity)
	local total, kingstotal = 0, 0;
	local gemTotal, gemName = 0, nil;
	local kingsgemTotal, kingsgemName = 0, nil;
	local metagemTotal, metagemName = 0, nil;
	local kingsmetagemTotal, kingsmetagemName = 0, nil;
	
	for statKey, statTable in pairs(values) do
		total = total + ( (bonuses[statKey] or 0) * statTable.value );
		kingstotal = kingstotal + ( ((bonuses[statKey] or 0) * statTable.value) * ((statTable.kings and kingsMultiplier) or 1) );
	end
	
	if (gemcount and tonumber(gemcount) and tonumber(gemcount) > 0) then
		gemTotal, gemName = EnhancerEP:GemPicker(gemcachekey, values, false, false, false, itemrarity);
		kingsgemTotal, kingsgemName = EnhancerEP:GemPicker(gemcachekey, values, false, true, false, itemrarity);
		
		total = total + ( gemTotal * gemcount );
		kingstotal = kingstotal + ( kingsgemTotal * gemcount );
	end
	
	if (metacount and tonumber(metacount) and tonumber(metacount) > 0 and Enhancer.db.profile.EPGems.metaGems) then
		metagemTotal, metagemName = EnhancerEP:GemPicker(gemcachekey, values, true, false, false, itemrarity);
		kingsmetagemTotal, kingsmetagemName = EnhancerEP:GemPicker(gemcachekey, values, true, true, false, itemrarity)
		
		total = total + ( metagemTotal * metacount );
		kingstotal = kingstotal + ( kingsmetagemTotal * metacount );
	end
	
	return Enhancer:Round(total, 1), Enhancer:Round(kingstotal, 1), gemName, kingsgemName, metagemName, kingsmetagemName;
end

EnhancerEP.gemCache = {};
function EnhancerEP:ResetGemCache()
	EnhancerEP.gemCache = nil;
	EnhancerEP.gemCache = {};
end

function EnhancerEP:GemPicker(cachekey, values, meta, blessingofkings, color, itemrarity)
	local bestGem = { name = "None", value = 0 };
	local maxQuality = Enhancer.db.profile.EPGems.maxQuality;
	if (Enhancer.db.profile.EPGems.maxQualityNonEpic ~= 0 and itemrarity) then
		if (itemrarity < 4) then
			maxQuality = Enhancer.db.profile.EPGems.maxQualityNonEpic;
			-- 0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact
		end
	end
	local totalCacheKey = tostring(cachekey) .. "|" .. tostring(meta) .. "|" .. tostring(blessingofkings) .. "|" .. tostring(maxQuality);
	
	if (not cachekey or not EnhancerEP.gemCache[totalCacheKey]) then
		for gemName, gemBonusTable in pairs(EnhancerEP.gems) do
			
			local valid = false;
			if (meta) then
				valid = gemBonusTable["Meta Gem"];
			else
				if (not gemBonusTable["Meta Gem"]) then
					if (color) then
						valid = gemBonusTable[color] and (tonumber(gemBonusTable["Gem Quality"]) <= maxQuality);
					else
						valid = (tonumber(gemBonusTable["Gem Quality"]) <= maxQuality);
					end
				end
			end
			
			if (valid) then	
				local total = 0;
				for statKey, statTable in pairs(values) do
					total = total + ( ((gemBonusTable[statKey] or 0) * statTable.value) * (((blessingofkings and statTable.kings) and kingsMultiplier) or 1) );
				end
				if (Enhancer.db.profile.EPGems.EPGemGuesstimates) then
					total = total + (EnhancerEP.gems[gemName][cachekey] or 0);
				end
				
				if (Enhancer:Round(total, 1) > bestGem.value) then
					bestGem.value = total;
					bestGem.name = gemName;
				end
			end
			
			if (cachekey) then
				EnhancerEP.gemCache[totalCacheKey] = {}
				EnhancerEP.gemCache[totalCacheKey].value = bestGem.value;
				EnhancerEP.gemCache[totalCacheKey].name = bestGem.name;
			end
		end
		
		if (not cachekey) then
			return bestGem.value, bestGem.name
		end
	end
	
	return EnhancerEP.gemCache[totalCacheKey].value, EnhancerEP.gemCache[totalCacheKey].name;
end

function EnhancerEP:BestGem(inputValues, color, quiet)
	local values = {};
	-- Enhancer.db.profile.AEPNumbers
	for stat,value in pairs(inputValues) do
		values[stat] = {};
		values[stat]["value"] = inputValues[stat];
		values[stat]["kings"] = EnhancerEP.AffectedByKings[stat];
	end
	
	local value, name = EnhancerEP:GemPicker(nil, values, false, false, color, false);
	local kingsValue, kingsName = EnhancerEP:GemPicker(nil, values, false, true, color, false);
	
	local link, kingsLink = nil, nil;
	_, link = GetItemInfo( EnhancerEP.gems[name]["ItemID"] );
	_, kingsLink = GetItemInfo( EnhancerEP.gems[kingsName]["ItemID"] );
	
	local formatString = (link and L["bestgem_link"]) or L["bestgem_nolink"];
	if (quiet) then
		return name, kingsName;
	else
		Enhancer:Print( string.format(formatString, L[color or "Any"], link or name, value or 0, kingsLink or kingsName, kingsValue or 0) );
	end
end

--[[
		Tornhoof/Pater from http://elitistjerks.com/f31/t13297-enhance_shaman_collected_works_theorycraft_vol_i/
		Haste Rating = 2.2
		Strength = 2 (2.2 w/Kings)
		Crit Rating = 2
		Agility = 1.8 (2 w/Kings)
		Hit Rating = 1.4
		Attack Power = 1
		
		Used as default values
]]--

--[[
	STR = "Strength",
	AGI = "Agility",
	STA = "Stamina",
	INT = "Intellect",
	SPI = "Spirit",
	ARMOR = "Reinforced Armor",
	
	ARCANERES = "Arcane Resistance",
	FIRERES = "Fire Resistance",
	NATURERES = "Nature Resistance",
	FROSTRES = "Frost Resistance",
	SHADOWRES = "Shadow Resistance",
	
	FISHING = "Fishing",
	MINING = "Mining",
	HERBALISM = "Herbalism",
	SKINNING = "Skinning",
	DEFENSE = "Defense",
	
	BLOCK = "Chance to Block",
	BLOCKVALUE = "Block value",
	DODGE = "Dodge",
	PARRY = "Parry",
	ATTACKPOWER = "Attack Power",
	ATTACKPOWERUNDEAD = "Attack Power against Undead",
	ATTACKPOWERBEAST = "Attack Power against Beasts",
	ATTACKPOWERFERAL = "Attack Power in feral form",
	CRIT = "Crit. hits",
	RANGEDATTACKPOWER = "Ranged Attack Power",
	RANGEDCRIT = "Crit. Shots",
	TOHIT = "Chance to Hit",
	IGNOREARMOR = "Ignore Armor",
	
	DMG = "Spell Damage",
	DMGUNDEAD = "Spell Damage against Undead",
	ARCANEDMG = "Arcane Damage",
	FIREDMG = "Fire Damage",
	FROSTDMG = "Frost Damage",
	HOLYDMG = "Holy Damage",
	NATUREDMG = "Nature Damage",
	SHADOWDMG = "Shadow Damage",
	SPELLCRIT = "Crit. Spell",
	SPELLTOHIT = "Chance to Hit with spells",
	SPELLPEN = "Spell Penetration",
	HEAL = "Healing",
	HOLYCRIT = "Crit. Holy Spell",
	
	HEALTHREG = "Life Regeneration",
	MANAREG = "Mana Regeneration",
	HEALTH = "Life Points",
	MANA = "Mana Points",
	
	CR_WEAPON = "Weapon rating",
	CR_DEFENSE = "Defense rating",
	CR_DODGE = "Dodge rating",
	CR_PARRY = "Parry rating",
	CR_BLOCK = "Block rating",
	CR_HIT = "Hit rating",
	CR_CRIT = "Critical strike rating",
	CR_HASTE = "Haste rating",
	CR_SPELLHIT = "Hit with spell rating",
	CR_SPELLCRIT = "Critical strike with spell rating",
	CR_SPELLHASTE = "Spell haste rating",
	CR_RESILIENCE = "Resilience",
	CR_WEAPON_AXE = "Axe skill rating",
	CR_WEAPON_DAGGER = "Dagger skill rating",
	CR_WEAPON_MACE = "Mace skill rating",
	CR_WEAPON_SWORD = "Sword skill rating",
	CR_WEAPON_SWORD_2H = "Two-Handed Swords skill rating",
	SNARERES = "Snare and Root effects Resistance",
	
	WEAPON_MIN = dmg_min
	WEAPON_MAX = dmg_max
	WEAPON_SPEED
]]--