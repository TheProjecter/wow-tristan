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
function EnhancerEP.ProcessTooltip(tooltip, name, link)
	if (link) then
		
		--[[ Check if we care about this item ]]--
		local _, _, _, _, _, ItemType, ItemSubType = GetItemInfo(link)
		if (not EnhancerEP.ProcessTypes[ItemType]) then return; end
		if (EnhancerEP.NotProcessSubTypes[ItemSubType]) then return; end
		
		local numberFormat = L["ep_numbers1"];
		if (Enhancer.db.profile.DivideBy10) then numberFormat = L["ep_numbers2"]; end
		
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
			--[[ Set point values here so it's easy to change ]]--
			values = {
				["ATTACKPOWER"] = { ["value"] = Enhancer.db.profile.AEPNumbers.ATTACKPOWER, ["kings"] = nil },
				
				["STR"] = { ["value"] = Enhancer.db.profile.AEPNumbers.STR, ["kings"] = true },
				["AGI"] = { ["value"] = Enhancer.db.profile.AEPNumbers.AGI, ["kings"] = true },
				
				["CR_CRIT"] = { ["value"] = Enhancer.db.profile.AEPNumbers.CR_CRIT, ["kings"] = nil },
				["CR_HIT"] = { ["value"] = Enhancer.db.profile.AEPNumbers.CR_HIT, ["kings"] = nil },
				["CR_HASTE"] = { ["value"] = Enhancer.db.profile.AEPNumbers.CR_HASTE, ["kings"] = nil },
				
				["IGNOREARMOR"] = { ["value"] = Enhancer.db.profile.AEPNumbers.IGNOREARMOR, ["kings"] = nil },
			}
			
			-- EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey)
			-- return Enhancer:Round(total), Enhancer:Round(kingstotal), gemName, kingsgemName, metagemName, kingsmetagemName;
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "AEP");
			EP = Enhancer:Round((EP / ((Enhancer.db.profile.DivideBy10 and 10) or 1)), ((Enhancer.db.profile.DivideBy10 and 1) or nil));
			EPK = Enhancer:Round((EPK / ((Enhancer.db.profile.DivideBy10 and 10) or 1)), ((Enhancer.db.profile.DivideBy10 and 1) or nil));
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
			--[[ Set point values here so it's easy to change ]]--
			values = {
				["ATTACKPOWER"] = { ["value"] = Enhancer.db.profile.AEPNumbers.ATTACKPOWER, ["kings"] = nil },
				
				["STR"] = { ["value"] = Enhancer.db.profile.AEPNumbers.STR, ["kings"] = true },
				["AGI"] = { ["value"] = Enhancer.db.profile.AEPNumbers.AGI, ["kings"] = true },
				
				["CR_CRIT"] = { ["value"] = Enhancer.db.profile.AEPNumbers.CR_CRIT, ["kings"] = nil },
				["CR_HASTE"] = { ["value"] = Enhancer.db.profile.AEPNumbers.CR_HASTE, ["kings"] = nil },
				
				["IGNOREARMOR"] = { ["value"] = Enhancer.db.profile.AEPNumbers.IGNOREARMOR, ["kings"] = nil },
			}
			
			-- EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey)
			-- return Enhancer:Round(total), Enhancer:Round(kingstotal), gemName, kingsgemName, metagemName, kingsmetagemName;
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "AEPH");
			EP = Enhancer:Round((EP / ((Enhancer.db.profile.DivideBy10 and 10) or 1)), ((Enhancer.db.profile.DivideBy10 and 1) or nil));
			EPK = Enhancer:Round((EPK / ((Enhancer.db.profile.DivideBy10 and 10) or 1)), ((Enhancer.db.profile.DivideBy10 and 1) or nil));
			
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
			--[[ Set point values here so it's easy to change ]]--
			values = {
				["HEAL"] = { ["value"] = Enhancer.db.profile.HEPNumbers.HEAL, ["kings"] = nil },
				
				["INT"] = { ["value"] = Enhancer.db.profile.HEPNumbers.INT, ["kings"] = true },
				["SPI"] = { ["value"] = Enhancer.db.profile.HEPNumbers.SPI, ["kings"] = true },
				
				["CR_SPELLCRIT"] = { ["value"] = Enhancer.db.profile.HEPNumbers.CR_SPELLCRIT, ["kings"] = nil },
				["CR_SPELLHASTE"] = { ["value"] = Enhancer.db.profile.HEPNumbers.CR_SPELLHASTE, ["kings"] = nil },
				
				["MANAREG"] = { ["value"] = Enhancer.db.profile.HEPNumbers.MANAREG, ["kings"] = nil },
			}
			
			-- EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey)
			-- return Enhancer:Round(total), Enhancer:Round(kingstotal), gemName, kingsgemName, metagemName, kingsmetagemName;
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "HEP");
			EP = Enhancer:Round((EP / ((Enhancer.db.profile.DivideBy10 and 10) or 1)), ((Enhancer.db.profile.DivideBy10 and 1) or nil));
			EPK = Enhancer:Round((EPK / ((Enhancer.db.profile.DivideBy10 and 10) or 1)), ((Enhancer.db.profile.DivideBy10 and 1) or nil));
			
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
			--[[ Set point values here so it's easy to change ]]--
			values = {
				["DMG"] = { ["value"] = Enhancer.db.profile.DEPNumbers.DMG, ["kings"] = nil },
				
				["INT"] = { ["value"] = Enhancer.db.profile.DEPNumbers.INT, ["kings"] = true },
				["SPI"] = { ["value"] = Enhancer.db.profile.DEPNumbers.SPI, ["kings"] = true },
				
				["CR_SPELLCRIT"] = { ["value"] = Enhancer.db.profile.DEPNumbers.CR_SPELLCRIT, ["kings"] = nil },
				["CR_SPELLHIT"] = { ["value"] = Enhancer.db.profile.DEPNumbers.CR_SPELLHIT, ["kings"] = nil },
				["CR_SPELLHASTE"] = { ["value"] = Enhancer.db.profile.DEPNumbers.CR_SPELLHASTE, ["kings"] = nil },
				["MANAREG"] = { ["value"] = Enhancer.db.profile.DEPNumbers.MANAREG, ["kings"] = nil },
			}
			
			-- EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey)
			-- return Enhancer:Round(total), Enhancer:Round(kingstotal), gemName, kingsgemName, metagemName, kingsmetagemName;
			local EP, EPK, gem1, gem2, gem3, gem4 = EnhancerEP:Calculate(values, bonuses, nonMetaSockets, metaSockets, "DEP");
			EP = Enhancer:Round((EP / ((Enhancer.db.profile.DivideBy10 and 10) or 1)), ((Enhancer.db.profile.DivideBy10 and 1) or nil));
			EPK = Enhancer:Round((EPK / ((Enhancer.db.profile.DivideBy10 and 10) or 1)), ((Enhancer.db.profile.DivideBy10 and 1) or nil));
			
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
				["IGNOREARMOR"] = { ["value"] = 0, ["kings"] = nil }, -- local apVal = 10-20;
				
				["WEAPON_MAX"] = { ["value"] = (25 / 100), ["kings"] = nil },
				["WEAPON_SPEED"] = { ["value"] = 2, ["kings"] = nil },
			}
			
			-- EnhancerEP:Calculate(values, bonuses, gemcount, metacount, gemcachekey)
			-- return Enhancer:Round(total), Enhancer:Round(kingstotal), gemName, kingsgemName, metagemName, kingsmetagemName;
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
		gemTotal, gemName = EnhancerEP:GemPicker(gemcachekey, values, false, false);
		kingsgemTotal, kingsgemName = EnhancerEP:GemPicker(gemcachekey, values, false, true);
		
		total = total + ( gemTotal * gemcount );
		kingstotal = kingstotal + ( kingsgemTotal * gemcount );
	end
	
	if (metacount and tonumber(metacount) and tonumber(metacount) > 0 and Enhancer.db.profile.EPGems.metaGems) then
		metagemTotal, metagemName = EnhancerEP:GemPicker(gemcachekey, values, true, false);
		kingsmetagemTotal, kingsmetagemName = EnhancerEP:GemPicker(gemcachekey, values, true, true)
		
		total = total + ( metagemTotal * metacount );
		kingstotal = kingstotal + ( kingsmetagemTotal * metacount );
	end
	
	return Enhancer:Round(total), Enhancer:Round(kingstotal), gemName, kingsgemName, metagemName, kingsmetagemName;
end

function EnhancerEP:GemPicker(cachekey, values, meta, blessingofkings)
	local bestGem = { name = "", value = 0 };
	local totalCacheKey = tostring(cachekey) .. "|" .. tostring(meta) .. "|" .. tostring(blessingofkings) .. "|" .. tostring(Enhancer.db.profile.EPGems.maxQuality);
	
	if (not EnhancerEP.gemCache[totalCacheKey]) then
		for gemName, gemBonusTable in pairs(EnhancerEP.gems) do
			
			local valid = false;
			if (meta) then
				valid = gemBonusTable["Meta Gem"];
			else
				if (not gemBonusTable["Meta Gem"]) then
					valid = (tonumber(gemBonusTable["Gem Quality"]) <= Enhancer.db.profile.EPGems.maxQuality);
				end
			end
			
			if (valid) then	
				local total = 0;
				for statKey, statTable in pairs(values) do
					total = total + ( ((gemBonusTable[statKey] or 0) * statTable.value) * (((blessingofkings and statTable.kings) and kingsMultiplier) or 1) );
				end
				total = total + (EnhancerEP.gems[gemName][cachekey] or 0);
				
				if (Enhancer:Round(total) > bestGem.value) then
					bestGem.value = total;
					bestGem.name = gemName;
				end
			end
			
			EnhancerEP.gemCache[totalCacheKey] = {}
			EnhancerEP.gemCache[totalCacheKey].value = bestGem.value;
			EnhancerEP.gemCache[totalCacheKey].name = bestGem.name;
		end
	end
	
	return EnhancerEP.gemCache[totalCacheKey].value, EnhancerEP.gemCache[totalCacheKey].name;
end

function EnhancerEP:Round(number, decimals)
  return Enhancer:Round(number, decimals);
end

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
EnhancerEP.gemCache = {}
EnhancerEP.gems = {
	["Balanced Nightseye"] = {
		["Gem Quality"] = 3,
		["ATTACKPOWER"] = 8,
		["STA"] = 6,
	},
	["Bold Living Ruby"] = {
		["Gem Quality"] = 3,
		["STR"] = 8,
	},
	["Bracing Earthstorm Diamond"] = {
		["Gem Quality"] = 3,
		["HEAL"] = 26,
		["Meta Gem"] = true,
	},
	["Bright Living Ruby"] = {
		["Gem Quality"] = 3,
		["ATTACKPOWER"] = 16,
	},
	["Brilliant Dawnstone"] = {
		["Gem Quality"] = 3,
		["INT"] = 8,
	},
	["Brutal Earthstorm Diamond"] = {
		["Gem Quality"] = 3,
		["Meta Gem"] = true,
	},
	["Dazzling Talasite"] = {
		["Gem Quality"] = 3,
		["INT"] = 4,
		["MANAREG"] = 2,
	},
	["Delicate Living Ruby"] = {
		["Gem Quality"] = 3,
		["AGI"] = 8,
	},
	["Destructive Skyfire Diamond"] = {
		["Gem Quality"] = 3,
		["Meta Gem"] = true,
	},
	["Enduring Talasite"] = {
		["Gem Quality"] = 3,
		["STA"] = 6,
		["CR_DEFENSE"] = 4,
	},
	["Enigmatic Skyfire Diamond"] = {
		["Gem Quality"] = 3,
		["CR_CRIT"] = 12,
		["Meta Gem"] = true,
	},
	["Flashing Living Ruby"] = {
		["Gem Quality"] = 3,
		["CR_PARRY"] = 8,
	},
	["Gleaming Dawnstone"] = {
		["Gem Quality"] = 3,
		["CR_SPELLCRIT"] = 8,
	},
	["Glinting Noble Topaz"] = {
		["Gem Quality"] = 3,
		["AGI"] = 4,
		["CR_HIT"] = 4,
	},
	["Glowing Nightseye"] = {
		["Gem Quality"] = 3,
		["STA"] = 6,
		["DMG"] = 5,
	},
	["Great Dawnstone"] = {
		["Gem Quality"] = 3,
		["CR_SPELLHIT"] = 8,
	},
	["Imbued Unstable Diamond"] = {
		["Gem Quality"] = 3,
		["DMG"] = 14,
		["Meta Gem"] = true,
	},
	["Infused Nightseye"] = {
		["Gem Quality"] = 3,
		["ATTACKPOWER"] = 8,
		["MANAREG"] = 2,
	},
	["Inscribed Noble Topaz"] = {
		["Gem Quality"] = 3,
		["STR"] = 4,
		["CR_CRIT"] = 4,
	},
	["Insightful Earthstorm Diamond"] = {
		["Gem Quality"] = 3,
		["INT"] = 12,
		["Meta Gem"] = true,
	},
	["Jagged Talasite"] = {
		["Gem Quality"] = 3,
		["CR_CRIT"] = 4,
		["STA"] = 6,
	},
	["Luminous Noble Topaz"] = {
		["Gem Quality"] = 3,
		["INT"] = 4,
		["HEAL"] = 9,
	},
	["Lustrous Star of Elune"] = {
		["Gem Quality"] = 3,
		["MANAREG"] = 3,
	},
	["Mystic Dawnstone"] = {
		["Gem Quality"] = 3,
		["CR_RESILIENCE"] = 8,
	},
	["Mystical Skyfire Diamond"] = {
		["Gem Quality"] = 3,
		["Meta Gem"] = true,
	},
	["Potent Noble Topaz"] = {
		["Gem Quality"] = 3,
		["CR_SPELLCRIT"] = 4,
		["DMG"] = 5,
	},
	["Potent Unstable Diamond"] = {
		["Gem Quality"] = 3,
		["ATTACKPOWER"] = 24,
		["Meta Gem"] = true,
	},
	["Powerful Earthstorm Diamond"] = {
		["Gem Quality"] = 3,
		["STA"] = 18,
		["Meta Gem"] = true,
	},
	["Prismatic Sphere"] = {
		["Gem Quality"] = 3,
	},
	["Purified Shadow Pearl"] = {
		["Gem Quality"] = 3,
		["SPI"] = 4,
		["HEAL"] = 9,
	},
	["Radiant Talasite"] = {
		["Gem Quality"] = 3,
		["SPELLPEN"] = 5,
		["CR_SPELLCRIT"] = 4,
	},
	["Relentless Earthstorm Diamond"] = {
		["Gem Quality"] = 3,
		["AGI"] = 12,
		["Meta Gem"] = true,
	},
	["Rigid Dawnstone"] = {
		["Gem Quality"] = 3,
		["CR_HIT"] = 8,
	},
	["Royal Nightseye"] = {
		["Gem Quality"] = 3,
		["MANAREG"] = 2,
		["HEAL"] = 9,
	},
	["Runed Living Ruby"] = {
		["Gem Quality"] = 3,
		["DMG"] = 9,
	},
	["Shifting Nightseye"] = {
		["Gem Quality"] = 3,
		["AGI"] = 4,
		["STA"] = 6,
	},
	["Smooth Dawnstone"] = {
		["Gem Quality"] = 3,
		["CR_CRIT"] = 8,
	},
	["Solid Star of Elune"] = {
		["Gem Quality"] = 3,
		["STA"] = 12,
	},
	["Sovereign Nightseye"] = {
		["Gem Quality"] = 3,
		["STR"] = 4,
		["STA"] = 6,
	},
	["Sparkling Star of Elune"] = {
		["Gem Quality"] = 3,
		["SPI"] = 8,
	},
	["Steady Talasite"] = {
		["Gem Quality"] = 3,
		["STA"] = 6,
		["CR_RESILIENCE"] = 4,
	},
	["Stormy Star of Elune"] = {
		["Gem Quality"] = 3,
		["SPELLPEN"] = 10,
	},
	["Subtle Living Ruby"] = {
		["Gem Quality"] = 3,
		["CR_DODGE"] = 8,
	},
	["Swift Skyfire Diamond"] = {
		["Gem Quality"] = 3,
		["ATTACKPOWER"] = 24,
		["Meta Gem"] = true,
	},
	["Teardrop Living Ruby"] = {
		["Gem Quality"] = 3,
		["HEAL"] = 18,
	},
	["Tenacious Earthstorm Diamond"] = {
		["Gem Quality"] = 3,
		["CR_DEFENSE"] = 12,
		["Meta Gem"] = true,
	},
	["Thick Dawnstone"] = {
		["Gem Quality"] = 3,
		["CR_DEFENSE"] = 8,
	},
	["Thundering Skyfire Diamond"] = {
		["Gem Quality"] = 3,
		["Meta Gem"] = true,
	},
	["Veiled Noble Topaz"] = {
		["Gem Quality"] = 3,
		["CR_SPELLHIT"] = 4,
		["DMG"] = 5,
	},
	["Wicked Noble Topaz"] = {
		["Gem Quality"] = 3,
		["ATTACKPOWER"] = 8,
		["CR_CRIT"] = 4,
	},
	["Balanced Shadow Draenite"] = {
		["Gem Quality"] = 2,
		["ATTACKPOWER"] = 6,
		["STA"] = 4,
	},
	["Bold Blood Garnet"] = {
		["Gem Quality"] = 2,
		["STR"] = 6,
	},
	["Bright Blood Garnet"] = {
		["Gem Quality"] = 2,
		["ATTACKPOWER"] = 12,
	},
	["Brilliant Golden Draenite"] = {
		["Gem Quality"] = 2,
		["INT"] = 6,
	},
	["Dazzling Deep Peridot"] = {
		["Gem Quality"] = 2,
		["INT"] = 3,
		["MANAREG"] = 1,
	},
	["Delicate Blood Garnet"] = {
		["Gem Quality"] = 2,
		["AGI"] = 6,
	},
	["Enduring Deep Peridot"] = {
		["Gem Quality"] = 2,
		["STA"] = 4,
		["CR_DEFENSE"] = 3,
	},
	["Gleaming Golden Draenite"] = {
		["Gem Quality"] = 2,
		["CR_SPELLCRIT"] = 6,
	},
	["Glinting Flame Spessarite"] = {
		["Gem Quality"] = 2,
		["AGI"] = 3,
		["CR_HIT"] = 3,
	},
	["Glowing Shadow Draenite"] = {
		["Gem Quality"] = 2,
		["STA"] = 4,
		["DMG"] = 4,
	},
	["Great Golden Draenite"] = {
		["Gem Quality"] = 2,
		["CR_SPELLHIT"] = 6,
	},
	["Infused Shadow Draenite"] = {
		["Gem Quality"] = 2,
		["ATTACKPOWER"] = 6,
		["MANAREG"] = 1,
	},
	["Inscribed Flame Spessarite"] = {
		["Gem Quality"] = 2,
		["STR"] = 3,
		["CR_CRIT"] = 3,
	},
	["Jagged Deep Peridot"] = {
		["Gem Quality"] = 2,
		["CR_CRIT"] = 3,
		["STA"] = 4,
	},
	["Luminous Flame Spessarite"] = {
		["Gem Quality"] = 2,
		["INT"] = 3,
		["HEAL"] = 7,
	},
	["Lustrous Azure Moonstone"] = {
		["Gem Quality"] = 2,
		["MANAREG"] = 2,
	},
	["Potent Flame Spessarite"] = {
		["Gem Quality"] = 2,
		["CR_SPELLCRIT"] = 3,
		["DMG"] = 4,
	},
	["Purified Jaggal Pearl"] = {
		["Gem Quality"] = 2,
		["SPI"] = 3,
		["HEAL"] = 7,
	},
	["Radiant Deep Peridot"] = {
		["Gem Quality"] = 2,
		["SPELLPEN"] = 4,
		["CR_SPELLCRIT"] = 3,
	},
	["Rigid Golden Draenite"] = {
		["Gem Quality"] = 2,
		["CR_HIT"] = 6,
	},
	["Royal Shadow Draenite"] = {
		["Gem Quality"] = 2,
		["MANAREG"] = 1,
		["HEAL"] = 7,
	},
	["Runed Blood Garnet"] = {
		["Gem Quality"] = 2,
		["DMG"] = 7,
	},
	["Shifting Shadow Draenite"] = {
		["Gem Quality"] = 2,
		["AGI"] = 3,
		["STA"] = 4,
	},
	["Smooth Golden Draenite"] = {
		["Gem Quality"] = 2,
		["CR_CRIT"] = 6,
	},
	["Solid Azure Moonstone"] = {
		["Gem Quality"] = 2,
		["STA"] = 9,
	},
	["Sovereign Shadow Draenite"] = {
		["Gem Quality"] = 2,
		["STR"] = 3,
		["STA"] = 4,
	},
	["Sparkling Azure Moonstone"] = {
		["Gem Quality"] = 2,
		["SPI"] = 6,
	},
	["Stormy Azure Moonstone"] = {
		["Gem Quality"] = 2,
		["SPELLPEN"] = 8,
	},
	["Teardrop Blood Garnet"] = {
		["Gem Quality"] = 2,
		["HEAL"] = 13,
	},
	["Thick Golden Draenite"] = {
		["Gem Quality"] = 2,
		["CR_DEFENSE"] = 6,
	},
	["Veiled Flame Spessarite"] = {
		["Gem Quality"] = 2,
		["CR_SPELLHIT"] = 3,
		["DMG"] = 4,
	},
	["Wicked Flame Spessarite"] = {
		["Gem Quality"] = 2,
		["ATTACKPOWER"] = 6,
		["CR_CRIT"] = 3,
	},
	["Bold Tourmaline"] = {
		["Gem Quality"] = 1,
		["STR"] = 4,
	},
	["Bright Tourmaline"] = {
		["Gem Quality"] = 1,
		["ATTACKPOWER"] = 8,
	},
	["Brilliant Amber"] = {
		["Gem Quality"] = 1,
		["INT"] = 4,
	},
	["Delicate Tourmaline"] = {
		["Gem Quality"] = 1,
		["AGI"] = 4,
	},
	["Gleaming Amber"] = {
		["Gem Quality"] = 1,
		["CR_SPELLCRIT"] = 4,
	},
	["Lustrous Zircon"] = {
		["Gem Quality"] = 1,
		["MANAREG"] = 1,
	},
	["Rigid Amber"] = {
		["Gem Quality"] = 1,
		["CR_HIT"] = 4,
	},
	["Runed Tourmaline"] = {
		["Gem Quality"] = 1,
		["DMG"] = 5,
	},
	["Smooth Amber"] = {
		["Gem Quality"] = 1,
		["CR_CRIT"] = 4,
	},
	["Solid Zircon"] = {
		["Gem Quality"] = 1,
		["STA"] = 6,
	},
	["Sparkling Zircon"] = {
		["Gem Quality"] = 1,
		["SPI"] = 4,
	},
	["Teardrop Tourmaline"] = {
		["Gem Quality"] = 1,
		["HEAL"] = 9,
	},
	["Thick Amber"] = {
		["Gem Quality"] = 1,
		["CR_DEFENSE"] = 4,
	},
}