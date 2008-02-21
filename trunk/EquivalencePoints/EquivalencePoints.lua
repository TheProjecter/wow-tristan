assert(LibStub, string.format("EquivalencePoints requires LibStub"));
assert(LibStub("AceAddon-3.0"), string.format("EquivalencePoints requires AceAddon-3.0"));
assert(LibStub("AceConsole-3.0"), string.format("EquivalencePoints requires AceConsole-3.0"));
assert(LibStub("AceEvent-3.0"), string.format("EquivalencePoints requires AceEvent-3.0"));
assert(LibStub("AceTimer-3.0"), string.format("EquivalencePoints requires AceTimer-3.0"));
assert(LibStub("AceDB-3.0"), string.format("EquivalencePoints requires AceDB-3.0"));
assert(LibStub("AceSerializer-3.0"), string.format("EquivalencePoints requires AceSerializer-3.0"));
assert(LibStub("AceLocale-3.0"), string.format("EquivalencePoints requires AceLocale-3.0"));
assert(AceLibrary, string.format("EquivalencePoints requires Ace2"));
assert(AceLibrary("ItemBonusLib-1.0"), string.format("EquivalencePoints requires ItemBonusLib-1.0"));
assert(AceLibrary("TipHooker-1.0"), string.format("EquivalencePoints requires TipHooker-1.0"));

local AceLibrary = AceLibrary;
local AddOn = LibStub("AceAddon-3.0"):NewAddon("EquivalencePoints", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0");
local AceSerializer = LibStub("AceSerializer-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("EquivalencePoints", true)
local ItemBonusLib = AceLibrary("ItemBonusLib-1.0"); -- Ace2 atm
local TipHooker = AceLibrary("TipHooker-1.0"); -- Ace2 atm
local _G = getfenv(0);

-- Create our print :)
local print = function(...) _G["print"](L["_print"], ...); end
-- Create our debug :)
--local debug = function(...) if (AddOn.debug) then _G["print"](L["_debug"], date("[%Y-%m-%d %H:%M:%S]"), ...); end end
local debug = function(...) if (AddOn.debug) then _G["print"](L["_debug"], ...); end end --Above version looses string.format automagic

function AddOn:Print(...)
	print(...);
end
function AddOn:Debug(...)
	debug(...);
end

AddOn.InfoStorage = {};
AddOn.BonusEP = {};

AddOn.colors = {
	R = (127 / 255),
	G = (255 / 255),
	B = (212 / 255),
	info = { -- FFDC5F
		R = (255 / 255),
		G = (220 / 255),
		B = (95 / 255),
	},
	critical = {
		R = (226 / 255),
		G = (45 / 255),
		B = (75 / 255),
	},
};

function AddOn:OnInitialize()
	self:RegisterDB();
	self:Options();
	self:ScheduleTimer("TipHookerHack", 1);
	self:SetCleanup();
	_, self.ClassEN = UnitClass("player");
	_, self.RaceEN = UnitRace("player"); -- NightElf, Dwarf, Human, Gnome, Draenei, Orc, Tauren, Troll, Scourge, BloodElf
	
	self.colors.class = {
		R = RAID_CLASS_COLORS[self.ClassEN]["r"],
		G = RAID_CLASS_COLORS[self.ClassEN]["g"],
		B = RAID_CLASS_COLORS[self.ClassEN]["b"],
	};
	
	if (not self.db.profile.AutoImportedEnhancer and self.ClassEN == "SHAMAN" and _G["Enhancer"]) then
		local import = true;
		for _,v in pairs(self.db.profile.Values) do
			if (v ~= 0) then
				import = false;
				break;
			end
		end
		
		if (import) then
			self.db.profile.AutoImportedEnhancer = true;
			self:ImportEnhancerAEP();
			print(L["Auto imported your |cffff0000AEP|r values from Enhancer!"]);
		end
	end
end

function AddOn:OnEnable()
	TipHooker:Hook(self.ProcessTooltip, "item");
	self:RegisterComm("EQP_VALUES_SENDER", "RecieveValues");
	
	AddOn.ClientVersion = (GetBuildInfo());
end

function AddOn:OnDisable()
	-- self:UnregisterAllEvents();
	self:UnregisterComm("EQP_SENDER");
	
	TipHooker:Unhook(self.ProcessTooltip, "item");
end

function AddOn:SetCleanup()
	local SetsDelete = {};
	
	for SetName in pairs(self.db.profile.HiddenSet) do
		if (not self.db.profile.ValueSet[SetName]) then
			table.insert(SetsDelete, SetName);
		end
	end
	
	for _, SetName in ipairs(SetsDelete) do
		self.db.profile.HiddenSet[SetName] = nil;
	end
end

function AddOn:TipHookerHack()
	local FunctionThatNeverExecutes = TipHooker.OnEventFrame:GetScript("OnEvent");
	pcall( FunctionThatNeverExecutes );
end

local ttS = string.rep(" ", 3); --tooltipSpacer was so fecking long to type each time ;) also it's nice if I want to change the number of spaces
function AddOn.ProcessTooltip(tooltip, name, link)
	debug("ProcessTooltip Start -----------------");
	if (link) then
		local self = AddOn;
		
		local sItemLink, ItemID, ItemRarity, _, ItemSubType = self:StripInfo(link);
		ItemRarity = (self.db.profile.MatchRarity and ItemRarity) or self.db.profile.MaxRarity;
		ItemRarity = (ItemRarity > self.db.profile.MaxRarity) and self.db.profile.MaxRarity or ItemRarity;
		ItemRarity = (ItemRarity > self.db.profile.MaxAvailRarity) and self.db.profile.MaxAvailRarity or ItemRarity;
		
		if (not sItemLink or not ItemID or not ItemRarity) then return; end
		
		local bonuses, socketBonuses = {}, {};
		local iblInfo = ItemBonusLib:ScanItemLink(sItemLink, false);
		if (iblInfo.bonuses) then
			for k,v in pairs(iblInfo.bonuses) do
				bonuses[k] = v;
			end
		end
		
		-- Add bonuses to consumables (extras/Consumables.lua) as ItemBonusLib doesn't seem to catch it (if it does the select should return records):
		if (AddOn.BonusEP.Consumables and AddOn.BonusEP.Consumables[ItemID] and not bonuses["Consumables Added Allready"] and self.db.profile.Consumables) then
			debug("Adding Consumable bonuses");
			for k,v in pairs(AddOn.BonusEP.Consumables[ItemID]) do
				bonuses[k] = (bonuses[k] or 0) + v;
				bonuses["Consumables Added Allready"] = 0;
			end
		end
		local DataMined = bonuses["Consumables Added Allready"] and AddOn.BonusEP.ConsumablesVersion;
		
		-- Add procs and use bonuses (extras/ProcsAndUse.lua)
		local ProcsAndUse = false;
		if (AddOn.BonusEP.ProcsAndUse and AddOn.BonusEP.ProcsAndUse[ItemID] and not bonuses["ProcsAndUse Added Allready"] and self.db.profile.ProcsAndUse) then
			debug("Adding Procs and Use bonuses");
			for k,v in pairs(AddOn.BonusEP.ProcsAndUse[ItemID]) do
				bonuses[k] = (bonuses[k] or 0) + v;
				bonuses["ProcsAndUse Added Allready"] = 0;
			end
		end
		local ProcsAndUse = bonuses["ProcsAndUse Added Allready"] and AddOn.BonusEP.ProcsAndUseVersion;
		
		-- Add possible inactive gem bonus (always inactive as we strip gems from the link)
		if (iblInfo.inactive_gem_bonus) then
			debug("Adding socket bonuses to socket bonus table");
			for k,v in pairs(iblInfo.inactive_gem_bonus) do
				socketBonuses[k] = v;
			end
		end
		
		-- How much is 1 percent of something worth :)
		local CritPercent = (1 / ItemBonusLib:GetRatingBonus("CR_CRIT", 1));
		local RangedCritPercent = (1 / ItemBonusLib:GetRatingBonus("CR_RANGEDCRIT", 1));
		local ExpertisePercent = (1 / ItemBonusLib:GetRatingBonus("CR_EXPERTISE", 1));
		debug("1%% Crit needs %.2f in Rating for your level", CritPercent);
		debug("1%% Ranged Crit needs %.2f in Rating for your level", RangedCritPercent);
		debug("1 Expertise needs %.2f in Rating for your level", ExpertisePercent);
		
		-- Danger here is ItemSubType are localized on the client!
		local RaceBonus = false; -- Level 70 only as this changes while leveling there's really no point caring much about it at low levels except for possibly twinks
		if (self.db.profile.RaceSpecifics and self.RaceEN == "Dwarf" and ItemSubType == L["Guns"]) then
			-- Dwarf: 1% Crit with guns
			RaceBonus = string.format(L["Racial bonus added %.2f ranged crit rating"], RangedCritPercent);
			bonuses["RANGEDCRIT"] = (bonuses["RANGEDCRIT"] or 0) + RangedCritPercent;
		elseif (self.db.profile.RaceSpecifics and self.RaceEN == "Human" and (ItemSubType == L["One-Handed Maces"] or ItemSubType == L["One-Handed Swords"] or ItemSubType == L["Two-Handed Maces"] or ItemSubType == L["Two-Handed Swords"])) then
			-- Human: 5 Expertise with Sword and Mace
			RaceBonus = string.format(L["Racial bonus added %.2f expertise rating"], (5 * ExpertisePercent));
			bonuses["CR_EXPERTISE"] = (bonuses["CR_EXPERTISE"] or 0) + (5 * ExpertisePercent);
		elseif (self.db.profile.RaceSpecifics and self.RaceEN == "Orc" and (ItemSubType == L["One-Handed Axes"] or ItemSubType == L["Two-Handed Axes"])) then
			-- Orc: 5 Expertise with Axe
			RaceBonus = string.format(L["Racial bonus added %.2f expertise rating"], (5 * ExpertisePercent));
			bonuses["CR_EXPERTISE"] = (bonuses["CR_EXPERTISE"] or 0) + (5 * ExpertisePercent);
		elseif (self.db.profile.RaceSpecifics and self.RaceEN == "Troll" and (ItemSubType == L["Bows"] or ItemSubType == L["Thrown"])) then
			-- Troll: 1% Crit with Throwing Weapon and Bow
			RaceBonus = string.format(L["Racial bonus added %.2f ranged crit rating"], RangedCritPercent);
			bonuses["RANGEDCRIT"] = (bonuses["RANGEDCRIT"] or 0) + RangedCritPercent;
		end
		
		-- Todo: Get full Expertise bonus,  get new Expertise rating with this equipped, take the diff and use that!
		-- Expertise Hack Quick: floor(15/ExpertisePercent)*ExpertisePercent
		local ExpertiseHacked = false;
		if (self.db.profile.HackExpertise and bonuses["CR_EXPERTISE"]) then
			debug("Recalculating Expertise, Old value = [%.2f], New value = [%.2f]", bonuses["CR_EXPERTISE"], floor(bonuses["CR_EXPERTISE"] / ExpertisePercent) * ExpertisePercent);
			bonuses["CR_EXPERTISE"] = floor(bonuses["CR_EXPERTISE"] / ExpertisePercent) * ExpertisePercent;
			ExpertiseHacked = true;
		end
		
		local IgnoreSocketColors, newIgnoreSocketColors, EmptyLineAboveAdded, newEmptyLineAboveAdded = false, false, false, false;
		
		newIgnoreSocketColors, newEmptyLineAboveAdded = self:AddSetLines(tooltip, bonuses, socketBonuses, ItemRarity, EmptyLineAboveAdded);
		IgnoreSocketColors, EmptyLineAboveAdded = (IgnoreSocketColors or newIgnoreSocketColors), (EmptyLineAboveAdded or newEmptyLineAboveAdded);
		
		--[[ Also add saved sets except hidden ones ]]
		for SetName in pairs(self.db.profile.ValueSet) do
			if (not self.db.profile.HiddenSet[SetName]) then
				newIgnoreSocketColors, newEmptyLineAboveAdded = self:AddSetLines(tooltip, bonuses, socketBonuses, ItemRarity, EmptyLineAboveAdded, SetName);
				IgnoreSocketColors, EmptyLineAboveAdded = (IgnoreSocketColors or newIgnoreSocketColors), (EmptyLineAboveAdded or newEmptyLineAboveAdded);
			end
		end
		
		local red, green, blue = AddOn.db.profile.Color.r, AddOn.db.profile.Color.g, AddOn.db.profile.Color.b;
		
		if (IgnoreSocketColors) then
			tooltip:AddLine(ttS .. string.format(L["%s ignore socket colors"], L["_tooltip Ignore Color"]), AddOn.colors.info.R, AddOn.colors.info.G, AddOn.colors.info.B);
		end
		
		if (RaceBonus) then
			tooltip:AddLine(ttS .. RaceBonus, AddOn.colors.info.R, AddOn.colors.info.G, AddOn.colors.info.B);
		end
		
		if (ExpertiseHacked) then
			tooltip:AddLine(ttS .. string.format(L["Expertise is modified (floor([val]/%.2f)*%.2f)"], ExpertisePercent, ExpertisePercent), AddOn.colors.info.R, AddOn.colors.info.G, AddOn.colors.info.B);
		end
		
		if (ProcsAndUse) then
			ProcsAndUse = ((VersionCompare(ProcsAndUse, AddOn.ClientVersion) == 1) and "|cff" .. convert.rgb2hex(AddOn.colors.critical.R, AddOn.colors.critical.G, AddOn.colors.critical.B) .. ProcsAndUse .. "|r") or ProcsAndUse;
			
			tooltip:AddLine(ttS .. string.format(L["Proc/use are guestimated (v%s)"], ProcsAndUse), AddOn.colors.info.R, AddOn.colors.info.G, AddOn.colors.info.B);
		end
		
		if (DataMined) then
			DataMined = ((VersionCompare(DataMined, AddOn.ClientVersion) == 1) and "|cff" .. convert.rgb2hex(AddOn.colors.critical.R, AddOn.colors.critical.G, AddOn.colors.critical.B) .. DataMined .. "|r") or DataMined;
			
			tooltip:AddLine(ttS .. string.format(L["Values are datamined (v%s)"], DataMined), AddOn.colors.info.R, AddOn.colors.info.G, AddOn.colors.info.B);
		end
		
		-- Class specifif things?
		if (type(self[self.ClassEN]) == "function" and self.db.profile.ClassSpecifics) then
			if (self.db.profile.ClassSpecificsColor) then
				red, green, blue = AddOn.colors.class.R, AddOn.colors.class.G, AddOn.colors.class.B;
			end
			
			local classExec, classTitle, classTable = pcall(self[self.ClassEN], self, sItemLink, ItemID, ItemRarity, bonuses, socketBonuses);
			
			if (classExec) then
				if (classTitle or classTable) then
					if (classTitle and classTitle ~= "") then
						tooltip:AddLine(tostring(classTitle), red, green, blue);
					end
					
					for left, right in classTable:opairs() do
						if (not right or right == "") then
							tooltip:AddLine(ttS .. tostring(left), red, green, blue);
						else
							tooltip:AddDoubleLine(ttS .. tostring(left), tostring(right), red, green, blue, red, green, blue);
						end
					end
				end
			else
				print(L["Error adding class specifics for %s"], self.ClassEN);
			end
		end
		
		if (EmptyLineAboveAdded and self.db.profile.EmptyLineBelow) then
			tooltip:AddLine(" ", AddOn.db.profile.Color.r, AddOn.db.profile.Color.g, AddOn.db.profile.Color.b);
		end
	end
end

function AddOn:SetHasValues(values)
	for key, value in pairs(values) do
		if (value > 0 and key ~= "EMPTY_SOCKET_META") then return true; end
	end
	
	return false;
end

local normalSet = "db.profile"; -- this is the key used for the default set (ie not saved sets); (need it to separate sets for listing gems)
function AddOn:AddSetLines(tooltip, bonuses, socketBonuses, ItemRarity, EmptyLineAboveAdded, SetName)
	if (SetName and not self.db.profile.ValueSet[SetName]) then return false, EmptyLineAboveAdded; end -- Set was not found so ignore it
	
	local calcValues = ((SetName and self.db.profile.ValueSet[SetName]) or self.db.profile.Values);
	local total, kingsTotal, obeyColor, kingsObeyColor, gemsUsed, kingsGemsUsed = 0, 0, true, true, {}, {};
	
	if (self:SetHasValues(calcValues)) then
		gemsUsed, kingsGemsUsed = nil, nil;
		total, kingsTotal, obeyColor, kingsObeyColor, gemsUsed, kingsGemsUsed = self:Calculate(bonuses, socketBonuses, calcValues, ItemRarity);
	end
	
	local IgnoreSocketColors = false;
		
	-- All that calculating in vain :(
	if (not self.db.profile.ShowZero and total == 0 and kingsTotal == 0) then return; end
	if (not self.db.profile.ShowNoBonuses and table.safecount(bonuses) < 1) then return; end
	
	local red, green, blue = AddOn.db.profile.Color.r, AddOn.db.profile.Color.g, AddOn.db.profile.Color.b;
	
	if (not EmptyLineAboveAdded) then
		if (self.db.profile.EmptyLineAbove) then
			tooltip:AddLine(" ", red, green, blue);
		end
		EmptyLineAboveAdded = true;
	end
	if ((not obeyColor) or (not kingsObeyColor)) then
		IgnoreSocketColors = true;
	end
	
	local SetTitle = (SetName and string.format(L["|cff77ff77Saved [|r%s (BoK)|cff77ff77]|r"], SetName)) or L["Equivalence (BoK)"];
	
	tooltip:AddDoubleLine(SetTitle, string.format(L["%.2f%s (%.2f%s)"], total, ((obeyColor and "") or "|cffff0000*|r"), kingsTotal, ((kingsObeyColor and "") or "|cffff0000*|r")), red, green, blue, red, green, blue);
	if ((((#gemsUsed > 0 or #kingsGemsUsed > 0) and self.db.profile.ListGems and not SetName) or ((#gemsUsed > 0 or #kingsGemsUsed > 0) and self.db.profile.ListGems and self.db.profile.ListSetGems and SetName)) and (total > 0 or kingsTotal > 0)) then
		-- Wich one has most gems *sigh*
		loopEnd = #gemsUsed;
		if (#kingsGemsUsed > loopEnd) then loopEnd = #kingsGemsUsed; end
		
		tooltip:AddDoubleLine(" ", L["Gem List:"], red, green, blue, red, green, blue);
		for loopNum=1, loopEnd do
			local gem, kingsGem = gemsUsed[loopNum], kingsGemsUsed[loopNum];
			if (gem == kingsGem) then
				gem = (gem and tostring(gem)) or "";
				kingsGem = "";
			else
				gem = (gem and tostring(gem)) or "";
				kingsGem = (kingsGem and "(".. tostring(kingsGem) .. ")") or "";
			end
			
			tooltip:AddDoubleLine(" ", strtrim(string.format(L["_tooltip _rightside Gem List"],  gem, kingsGem)), red, green, blue, red, green, blue);
		end
	end
	
	return IgnoreSocketColors, EmptyLineAboveAdded;
end

function AddOn:GetCacheKey(valuesTbl)
	local cacheKey = "";
	for key,value in self:DefaultValues():opairs() do
  	cacheKey = cacheKey .. key .. ((valuesTbl and valuesTbl[key]) or 0) ..";";
	end
	return cacheKey;
end

local statsAffectedByKings = { STR = true, AGI = true, STA = true, INT = true, SPI = true};
local kingsMultiplier = (110 / 100);
function AddOn:Calculate(itemValues, socketValues, calcValues, itemRarity)
	itemValues = itemValues or {};
	socketValues = socketValues or {};
	
	local gemsUsed, kingsGemsUsed = {}, {};
	local GemCacheKeyBase = self:GetCacheKey(calcValues);
	
	local total, kingsTotal, obeyColor, kingsObeyColor = 0, 0, true, true;
	for stat, amount in pairs(itemValues) do
		total = total + ((calcValues[stat] or 0) * amount);
		kingsTotal = kingsTotal + (((calcValues[stat] or 0) * amount) * ((statsAffectedByKings[stat] and kingsMultiplier) or 1));
	end
	
	if (itemValues["EMPTY_SOCKET_META"] or itemValues["EMPTY_SOCKET_RED"] or itemValues["EMPTY_SOCKET_BLUE"] or itemValues["EMPTY_SOCKET_YELLOW"]) then
		
		if (itemValues["EMPTY_SOCKET_META"] and itemValues["EMPTY_SOCKET_META"] > 0) then
		--// META GEMS
			local gemTotalMeta, kingsGemTotalMeta, _, _, gemNameMeta, kingsGemNameMeta = AddOn:BestGem("META", calcValues, itemRarity, GemCacheKeyBase);
			gemTotalMeta, kingsGemTotalMeta = gemTotalMeta * (itemValues["EMPTY_SOCKET_META"] or 0), kingsGemTotalMeta * (itemValues["EMPTY_SOCKET_META"] or 0);
			
			total = total + gemTotalMeta;
			kingsTotal = kingsTotal + kingsGemTotalMeta;
			
			tinsert(gemsUsed, gemNameMeta);
			tinsert(kingsGemsUsed, kingsGemNameMeta);
		end
		
		local allGems = ((itemValues["EMPTY_SOCKET_RED"] or 0) + (itemValues["EMPTY_SOCKET_BLUE"] or 0) + (itemValues["EMPTY_SOCKET_YELLOW"] or 0));
		if (allGems > 0) then
			local gemTotalAny, kingsGemTotalAny, _, _, gemNameAny, kingsGemNameAny = AddOn:BestGem("ANYCOLOR", calcValues, itemRarity, GemCacheKeyBase);
			gemTotalAny, kingsGemTotalAny = gemTotalAny * allGems, kingsGemTotalAny * allGems;
			
			local gemTotalColor, kingsGemTotalColor = 0, 0;
			local gemTable, kingsGemTable = {}, {};
			for gemType, gemAmount in pairs({ RED = "EMPTY_SOCKET_RED", BLUE = "EMPTY_SOCKET_BLUE", YELLOW = "EMPTY_SOCKET_YELLOW" }) do
				if (itemValues[gemAmount] and itemValues[gemAmount] > 0) then
					local gemColor, kingsGemColor, _, _, gemNameColor, kingsGemNameColor = AddOn:BestGem(gemType, calcValues, itemRarity, GemCacheKeyBase);
					
					if (itemValues[gemAmount] and itemValues[gemAmount] > 0) then
						tinsert(gemTable, gemNameColor);
						tinsert(kingsGemTable, kingsGemNameColor);
					end
					
					gemTotalColor = gemTotalColor + (gemColor * (itemValues[gemAmount] or 0));
					kingsGemTotalColor = kingsGemTotalColor + (kingsGemColor * (itemValues[gemAmount] or 0));
				end
			end
			
			local bonus, kingsBonus = 0, 0;
			for stat, amount in pairs(socketValues) do
				bonus = bonus + ((calcValues[stat] or 0) * amount);
				kingsBonus = kingsBonus + (((calcValues[stat] or 0) * amount) * ((statsAffectedByKings[stat] and kingsMultiplier) or 1));
			end
			
			if (gemTotalAny > (gemTotalColor + bonus)) then
				total = total + gemTotalAny;
				obeyColor = false;
				
				tinsert(gemsUsed, gemNameAny);
			else
				total = total + (gemTotalColor + bonus);
				
				for _, v in pairs(gemTable) do
					tinsert(gemsUsed, v);
				end
			end
			
			if (kingsGemTotalAny > (kingsGemTotalColor + kingsBonus)) then
				kingsTotal = kingsTotal + kingsGemTotalAny;
				kingsObeyColor = false;
				
				tinsert(kingsGemsUsed, kingsGemNameAny);
			else
				kingsTotal = kingsTotal + (kingsGemTotalColor + kingsBonus);
				
				for _, v in pairs(kingsGemTable) do
					tinsert(kingsGemsUsed, v);
				end
			end
		end
	end
	
	return math.round(total, 2), math.round(kingsTotal, 2), obeyColor, kingsObeyColor, gemsUsed, kingsGemsUsed;
end

function AddOn:PrintBestGem(color)
	local gemValue, kingsGemValue, gemID, kingsGemID, gemName, kingsGemName = AddOn:BestGem(color, self.db.profile.Values, self.db.profile.MaxAvailRarity, self:GetCacheKey(self.db.profile.Values));
	local _, gemLink = GetItemInfo(gemID);
	local _, kingsGemLink = GetItemInfo(kingsGemID);
	
	print(L["Best %s gem is %s at %.2f"], color, (gemLink or gemName), gemValue)
	print(L["Best %s gem BoK is %s at %.2f"], color, (kingsGemLink or kingsGemName), kingsGemValue)
end

-- Has to specify META for meta gems, BLUE for blue, RED for red and YELLOW for yellow. Any other value is interpreted as any color except Meta
local gemCache, kingsGemCache = {}, {};
local gemIDCache, kingsGemIDCache, gemNameCache, kingsGemNameCache = {}, {}, {}, {};
function AddOn:BestGem(color, calcValues, itemRarity, GemCacheKeyBase)
	-- set all values to valid values
	color = (color and string.upper(color)) or "ANYCOLOR";
	if (color ~= "META" and color ~= "RED" and color ~= "BLUE" and color ~= "YELLOW" and color ~= "ANYCOLOR") then color = "ANYCOLOR"; end
	
	assert(tonumber(itemRarity), string.format(L["for function [BestGem] itemRarity has to be a number!"]));
	assert(GemCacheKeyBase, string.format(L["for function [BestGem] GemCacheKeyBase must be included!"]));
	
	itemRarity = tonumber(itemRarity);
	
	local bestValue, kingsBestValue, gemID, gemName, kingsGemID, kingsGemName = 0, 0, nil, nil, nil, nil;
	
	local cacheKey = GemCacheKeyBase .. ";" .. itemRarity .. ";" .. color;
	if (gemCache[cacheKey] and kingsGemCache[cacheKey]) then
		return gemCache[cacheKey], kingsGemCache[cacheKey], gemIDCache[cacheKey], kingsGemIDCache[cacheKey], gemNameCache[cacheKey], kingsGemNameCache[cacheKey];
	end
	
	if (color == "ANYCOLOR") then
		-- Crap special case :(
		for ID, gemInfo in pairs(AddOn.InfoStorage.Gems) do
			if (not gemInfo["Color"]["META"] and gemInfo["Rarity"] <= itemRarity) then
				local gem, gemKings = self:Calculate(gemInfo["Bonus"], nil, calcValues, itemRarity)
				
				if (gem >= bestValue) then
					bestValue = gem;
					gemID, gemName = ID, gemInfo["Name"];
				end
				
				if (gemKings >= kingsBestValue) then
					kingsBestValue = gemKings;
					kingsGemID, kingsGemName = ID, gemInfo["Name"];
				end
			end
		end
	else
		for ID, gemInfo in pairs(AddOn.InfoStorage.Gems) do
			if (gemInfo["Color"][color] and gemInfo["Rarity"] <= itemRarity) then
				-- Valid gem to calc
				local gem, gemKings = self:Calculate(gemInfo["Bonus"], nil, calcValues, itemRarity)
				
				if (gem >= bestValue) then
					bestValue = gem;
					gemID, gemName = ID, gemInfo["Name"];
				end
				
				if (gemKings >= kingsBestValue) then
					kingsBestValue = gemKings;
					kingsGemID, kingsGemName = ID, gemInfo["Name"];
				end
			end
		end
	end
	
	-- Save in cache
	gemCache[cacheKey], kingsGemCache[cacheKey] = math.round(bestValue, 2), math.round(kingsBestValue, 2);
	gemIDCache[cacheKey], kingsGemIDCache[cacheKey], gemNameCache[cacheKey], kingsGemNameCache[cacheKey] = gemID, kingsGemID, gemName, kingsGemName;
	return gemCache[cacheKey], kingsGemCache[cacheKey], gemIDCache[cacheKey], kingsGemIDCache[cacheKey], gemNameCache[cacheKey], kingsGemNameCache[cacheKey];
end

function AddOn:StripInfo(Itemlink)
	local found, _, itemstring = string.find(Itemlink, "^|c%x+|H(.+)|h%[.+%]")
	if (not found) then return Itemlink; end
	
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", itemstring)
	enchantId = "0";
	jewelId1 = "0";
	jewelId2 = "0";
	jewelId3 = "0";
	jewelId4 = "0";
	local newItemString = strjoin(":", linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId);
	local _, newLink, itemRarity, _, _, ItemType, ItemSubType  = GetItemInfo(newItemString);
	--itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(itemID or "itemString" or "itemName" or "itemLink")
	
	return newLink, tonumber(itemId), tonumber(itemRarity), ItemType, ItemSubType;
end

StaticPopupDialogs["PROWLERPAGECONFIRM"] = { };
function AddOn:RecieveValues(event, text, distribution, sender, ...)
	print(L["Receiving data from %s"], sender);
	
	if (self.db.profile.ReceiveValues) then
		self:Deserialize(text, sender);
	else
		print(L["Import ignored due to settings, you can find the toggle under the import tab in /eqp config"]);
	end
end

function AddOn:SendValues(name)
	-- Sends values Serialized to a named friend :)
	local values = self:Serialize();
	self:SendCommMessage("EQP_VALUES_SENDER", values, "WHISPER", name);
end

function AddOn:Serialize()
	return AceSerializer:Serialize(self:TrimTable(self.db.profile.Values));
end

function AddOn:Deserialize(serialized, SetPrefix)
	local CouldDeserialize, tbl = AceSerializer:Deserialize(serialized);
		
	if (CouldDeserialize and type(tbl) == "table") then
		AddOn:ImportSet(SetPrefix, tbl);
	else
		if (not CouldDeserialize) then
			print(L["Import failed, could not deserialize the data!"]);
		elseif (type(tbl) ~= "table") then
			print(L["Import failed, the data wasn't a table with values!"]);
		end
	end
end

function AddOn:ImportSet(SetPrefix, SetTable)
	local FreeSpot = 0;
	while (true) do
		FreeSpot = FreeSpot + 1;
		SetName = string.format("%s_%.3i", SetPrefix, FreeSpot);
		if (not self.db.profile.ValueSet[SetName]) then
			self.db.profile.ValueSet[SetName] = table.copy(SetTable);
			
			for key in pairs(self.db.profile.ValueSet[SetName]) do
				-- Make sure we don't import crap keys
				if (not self.db.profile.Values[key]) then
					self.db.profile.ValueSet[SetName][key] = nil;
				elseif (not tonumber(self.db.profile.ValueSet[SetName][key]) or tonumber(self.db.profile.ValueSet[SetName][key]) == 0) then
					self.db.profile.ValueSet[SetName][key] = nil;
				end
			end
			
			print(L["Set imported as [%s]"], SetName);
			break;
		end
	end
end

function AddOn:Import(standardizedData)
	-- Clear all values:
	for key,_ in pairs(self.db.profile.Values) do
		self.db.profile.Values[key] = 0;
	end
	
	local affected = {};
	-- Set new values but don't insert new keys:
	for key, value in pairs(standardizedData) do
		if (self.db.profile.Values[key] and value > 0) then
			self.db.profile.Values[key] = value;
			tinsert(affected, self:TranslateValueKey(key));
		end
	end
	
	print(L["Import complete stats affected:"], unpack(affected));
end

function AddOn:TranslateValueKey(key)
	if (key == "EMPTY_SOCKET_META") then return L["Bonus Value to Meta Gems"]; end -- We don't care what it's called in IBL we use it for meta gem bonus ;)
	
	local ibl = ItemBonusLib:GetBonusFriendlyName(key);
	return (ibl and (ibl == "CR_EXPERTISE") and "Expertise Rating") or ibl or key;
end

function AddOn:TrimTable(tbl)
	retTbl = table.copy(tbl);
	for k in pairs(retTbl) do
		if (retTbl[k] == 0) then retTbl[k] = nil; end
	end
	return retTbl;
end

function AddOn:ImportPreSets(set)
	if (not set) then
		print(L["Set not specified, import aborted!"]);
		return;
	end
	
	-- God I wish keys where not case sensitive
	for k, v in pairs(self.db.profile.Presets) do
		if (string.lower(k) == string.lower(set)) then
			self:Import(v);
			return;
		end
	end
	
	print(L["set [%s] not found, import aborted!"], set);
end

function AddOn:SpamSafe(text)
	return string.gsub(string.gsub(text, " %[at%] ", "@"), " %[dot%] ", ".");
end