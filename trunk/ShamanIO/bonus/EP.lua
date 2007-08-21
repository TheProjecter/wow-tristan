local L = AceLibrary("AceLocale-2.2"):new("EnhancerEP")
EnhancerEP = Enhancer:NewModule("EP", "AceEvent-2.0");
Enhancer:SetModuleDefaultState("EP", true);

local ibl = AceLibrary("ItemBonusLib-1.0");
local TipHooker = AceLibrary("TipHooker-1.0");
local Gratuity = AceLibrary("Gratuity-2.0")

function EnhancerEP:OnInitialize()
	-- Just a place to give bonus to special gems
	EnhancerEP.gems["Relentless Earthstorm Diamond"]["AEP"] = 750;
	EnhancerEP.gems["Relentless Earthstorm Diamond"]["AEPH"] = 750;
	
	--[[
                3% Increased Critical Damage -- is given 750 for Enhancement above
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
end

function EnhancerEP:OnEnable()
	TipHooker:Hook(self.ProcessTooltip, "item");
	
	--[[ For some reason I can't get TipHooker to work without enabling
			 RatingBuster wich sux so I hacked a bit here ]]--
	self:ScheduleEvent("Tooltip", self.Tooltip, 1, self);
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

EnhancerEP.ProcessTypes = { [L["Armor"]] = true, [L["Gem"]] = true, [L["Weapon"]] = true, [L["Recipe"]] = true, } -- [L["Projectile"]] = true, [L["Quiver"]] = true, 
EnhancerEP.NotProcessSubTypes = { [L["Plate"]] = true, [L["Idols"]] = true, [L["Librams"]] = true, [L["Fishing Pole"]] = true, [L["One-Handed Swords"]] = true, [L["Polearms"]] = true, [L["Two-Handed Swords"]] = true, [L["Bows"]] = true, [L["Crossbows"]] = true, [L["Guns"]] = true, [L["Thrown"]] = true, [L["Wands"]] = true, }
EnhancerEP.AffectedByKings = { STR = true, AGI = true, STA = true, INT = true, SPI = true};
function EnhancerEP.ProcessTooltip(tooltip, name, link)
	if (link) then
		
		--[[ Check if we care about this item ]]--
		local _, _, _, _, _, ItemType, ItemSubType = GetItemInfo(link)
		if (not EnhancerEP.ProcessTypes[ItemType]) then return; end
		if (EnhancerEP.NotProcessSubTypes[ItemSubType]) then return; end
		
		local numberFormat = L["ep_numbers2"];
		
		--[[ ItemBonusLib doesn't count empty sockets wich we prefer since
				 inspected gear can have shit gems in them ;) ]]--
		link = EnhancerEP:StripGemsAndEnchants(link);
		bonuses = ibl:ScanItem(link, true, false);
		local lineAdded = nil;
		local infos = {};
		local kingsMultiplier = (110 / 100);
		
		--[[ Count sockets ]]--
		local redSockets, blueSockets, yellowSockets, metaSockets, nonMetaSockets = 0, 0, 0, 0, 0;
		Gratuity:SetHyperlink(link)
		for i = 2, Gratuity:NumLines() do
			local line = Gratuity:GetLine(i)
			if (line == L["Red Socket"]) then
				redSockets = redSockets + 1;
				nonMetaSockets = nonMetaSockets + 1;
			elseif (line == L["Blue Socket"]) then
				blueSockets = blueSockets + 1;
				nonMetaSockets = nonMetaSockets + 1;
			elseif (line == L["Yellow Socket"]) then
				yellowSockets = yellowSockets + 1;
				nonMetaSockets = nonMetaSockets + 1;
			elseif (line == L["Meta Socket"]) then
				metaSockets = metaSockets + 1;
			end
		end
		-- nonMetaSockets, metaSockets
		
		--[[ Do Attackpower Equivalence Points ]]--
		local lastValue, lastKingsValue = nil, nil;
		if (Enhancer.db.profile.AEP) then
			local values = {};
			for stat,value in pairs(Enhancer.db.profile.AEPNumbers) do
				values[stat] = {};
				values[stat]["value"] = Enhancer.db.profile.AEPNumbers[stat];
				values[stat]["kings"] = EnhancerEP.AffectedByKings[stat];
			end
			
			-- EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey)
			-- return total, kingstotal, gemName, kingsgemName, metagemName, kingsmetagemName;
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "AEP");
			lastValue, lastKingsValue = EP, EPK;
			
			if ( EP > 0 or Enhancer.db.profile.EPZero ) then
				if (not lineAdded) then
					tooltip:AddLine(" ");
					tooltip:AddLine(L["eep_info"], RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"]);
					lineAdded = true;
				end
				
				tooltip:AddDoubleLine(L["aep_tooltip"], string.format( numberFormat, EP, EPK ), RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"], RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"]);
				
				tinsert(infos, L["aep_info"]);
			end
		end
		
		--[[ Do Attackpower Equivalence Points but without hit ]]--
		if (Enhancer.db.profile.AEPH) then
			local values = {};
			for stat,value in pairs(Enhancer.db.profile.AEPNumbers) do
				if (stat ~= "CR_HIT") then
					values[stat] = {};
					values[stat]["value"] = Enhancer.db.profile.AEPNumbers[stat];
					values[stat]["kings"] = EnhancerEP.AffectedByKings[stat];
				end
			end
			
			-- EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey)
			-- return total, kingstotal, gemName, kingsgemName, metagemName, kingsmetagemName;
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "AEPH");
			
			local skipThis = ( lastValue and lastKingsValue and lastValue == EP and lastKingsValue == EPK );
			if ( (EP > 0 or Enhancer.db.profile.EPZero) and (not skipThis) ) then
				if (not lineAdded) then
					tooltip:AddLine(" ");
					tooltip:AddLine(L["eep_info"], RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"]);
					lineAdded = true;
				end
				
				tooltip:AddDoubleLine(L["aeph_tooltip"], string.format( numberFormat, EP, EPK ), RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"], RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"]);
				
				if (not Enhancer.db.profile.AEP) then
					tinsert(infos, L["aep_info"]);
				end
			end
		end
		
		--[[ Do Healing Equivalence Points ]]--
		if (Enhancer.db.profile.HEP) then
			local values = {};
			for stat,value in pairs(Enhancer.db.profile.HEPNumbers) do
				values[stat] = {};
				values[stat]["value"] = Enhancer.db.profile.HEPNumbers[stat];
				values[stat]["kings"] = EnhancerEP.AffectedByKings[stat];
			end
			
			-- EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey)
			-- return total, kingstotal, gemName, kingsgemName, metagemName, kingsmetagemName;
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "HEP");
			
			if ( EP > 0 or Enhancer.db.profile.EPZero) then
				if (not lineAdded) then
					tooltip:AddLine(" ");
					tooltip:AddLine(L["eep_info"], RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"]);
					lineAdded = true;
				end
				
				tooltip:AddDoubleLine(L["hep_tooltip"], string.format( numberFormat, EP, EPK ), RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"], RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"]);
				
				-- tinsert(infos, L["hep_info"]);
			end
		end
		
		--[[ Do spellDamage Equivalence Points ]]--
		if (Enhancer.db.profile.DEP) then
			local values = {};
			for stat,value in pairs(Enhancer.db.profile.DEPNumbers) do
				values[stat] = {};
				values[stat]["value"] = Enhancer.db.profile.DEPNumbers[stat];
				values[stat]["kings"] = EnhancerEP.AffectedByKings[stat];
			end
			
			-- EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey)
			-- return total, kingstotal, gemName, kingsgemName, metagemName, kingsmetagemName;
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "DEP");
			
			if ( EP > 0 or Enhancer.db.profile.EPZero) then
				if (not lineAdded) then
					tooltip:AddLine(" ");
					tooltip:AddLine(L["eep_info"], RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"]);
					lineAdded = true;
				end
				
				tooltip:AddDoubleLine(L["dep_tooltip"], string.format( numberFormat, EP, EPK ), RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"], RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"]);
				
				-- tinsert(infos, L["dep_info"]);
			end
		end
		
		if (lineAdded) then
			for _, infoLine in ipairs(infos) do
				tooltip:AddLine( infoLine, RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"] );
			end
			-- Add a warning about using Equivalence Points at skew values
		end
		
		-- http://www.wowwiki.com/Formulas:Item_Values Calculate ItemLevel based on stats you care about ;)
		--[[ Do Enhancement ItemLevel ]]--
		if (Enhancer.db.profile.EIL or true) then
			--[[ Set point values here so it's easy to change ]]--
			values = {
				["ATTACKPOWER"] = { ["value"] = (5 / 10), ["kings"] = nil },
				
				["STR"] = { ["value"] = 1, ["kings"] = nil },
				["AGI"] = { ["value"] = 1, ["kings"] = nil },
				
				["CR_CRIT"] = { ["value"] = 1, ["kings"] = nil },
				["CR_HIT"] = { ["value"] = 1, ["kings"] = nil },
				["CR_HASTE"] = { ["value"] = 1, ["kings"] = nil },
			}
			
			-- EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey)
			-- return total, kingstotal, gemName, kingsgemName, metagemName, kingsmetagemName;
			local IL = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "EIL");
			
			if ( IL > 0 or Enhancer.db.profile.EPZero) then
				tooltip:AddDoubleLine(L["eil_tooltip"], IL, RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"], RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"]);
				lineAdded = true;
				-- tooltip:AddLine( L["eil_info"], RAID_CLASS_COLORS["SHAMAN"]["r"], RAID_CLASS_COLORS["SHAMAN"]["g"], RAID_CLASS_COLORS["SHAMAN"]["b"] );
			end
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
	return newLink;
end

local kingsMultiplier = (110 / 100);
function EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey)
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
		gemTotal, gemName = EnhancerEP:GemPicker(gemcachekey, values, false, false, false);
		kingsgemTotal, kingsgemName = EnhancerEP:GemPicker(gemcachekey, values, false, true, false);
		
		total = total + ( gemTotal * gemcount );
		kingstotal = kingstotal + ( kingsgemTotal * gemcount );
	end
	
	if (metacount and tonumber(metacount) and tonumber(metacount) > 0 and Enhancer.db.profile.EPGems.metaGems) then
		metagemTotal, metagemName = EnhancerEP:GemPicker(gemcachekey, values, true, false, false);
		kingsmetagemTotal, kingsmetagemName = EnhancerEP:GemPicker(gemcachekey, values, true, true, false)
		
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

function EnhancerEP:GemPicker(cachekey, values, meta, blessingofkings, color)
	local bestGem = { name = "None", value = 0 };
	local totalCacheKey = tostring(cachekey) .. "|" .. tostring(meta) .. "|" .. tostring(blessingofkings) .. "|" .. tostring(Enhancer.db.profile.EPGems.maxQuality);
	
	if (not cachekey or not EnhancerEP.gemCache[totalCacheKey]) then
		for gemName, gemBonusTable in pairs(EnhancerEP.gems) do
			
			local valid = false;
			if (meta) then
				valid = gemBonusTable["Meta Gem"];
			else
				if (not gemBonusTable["Meta Gem"]) then
					if (color) then
						valid = gemBonusTable[color] and (tonumber(gemBonusTable["Gem Quality"]) <= Enhancer.db.profile.EPGems.maxQuality);
					else
						valid = (tonumber(gemBonusTable["Gem Quality"]) <= Enhancer.db.profile.EPGems.maxQuality);
					end
				end
			end
			
			if (valid) then	
				local total = 0;
				for statKey, statTable in pairs(values) do
					total = total + ( ((gemBonusTable[statKey] or 0) * statTable.value) * (((blessingofkings and statTable.kings) and kingsMultiplier) or 1) );
				end
				total = total + (EnhancerEP.gems[gemName][cachekey] or 0);
				
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

function EnhancerEP:BestGem(inputValues, color)
	local values = {};
	-- Enhancer.db.profile.AEPNumbers
	for stat,value in pairs(inputValues) do
		values[stat] = {};
		values[stat]["value"] = inputValues[stat];
		values[stat]["kings"] = EnhancerEP.AffectedByKings[stat];
	end
	
	local value, name = EnhancerEP:GemPicker(nil, values, false, false, color);
	local kingsValue, kingsName = EnhancerEP:GemPicker(nil, values, false, true, color);
	local link, kingsLink = nil, nil;
	if (EnhancerEP.gems[name]) then _, link = GetItemInfo( EnhancerEP.gems[name]["ItemID"] ); end
	if (EnhancerEP.gems[kingsName]) then _, kingsLink = GetItemInfo( EnhancerEP.gems[name]["ItemID"] ); end
	
	local formatString = (link and L["bestgem_link"]) or L["bestgem_nolink"];
	Enhancer:Print( string.format(formatString, L[color or "Any"], link or name, value or 0, kingsLink or kingsName, kingsValue or 0) );
end

--function EnhancerEP:Round(number, decimals)
--  return Enhancer:Round(number, decimals);
--end

--[[
		Tornhoof/Pater from http://elitistjerks.com/f31/t13297-enhance_shaman_collected_works_theorycraft_vol_i/
		Haste Rating = 2.2
		Strength = 2 (2.2 w/Kings)
		Crit Rating = 2
		Agility = 1.8 (2 w/Kings)
		Hit Rating = 1.4
		Attack Power = 1
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