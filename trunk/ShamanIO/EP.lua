local L = AceLibrary("AceLocale-2.2"):new("EnhancerEP")
EnhancerEP = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0");

local ibl = AceLibrary("ItemBonusLib-1.0");
local TipHooker = AceLibrary("TipHooker-1.0");
local Gratuity = AceLibrary("Gratuity-2.0")

local c = {
	["r"] = (47 / 100);
	["g"] = (100 / 100);
	["b"] = (073 / 100);
};
-- c["r"], c["g"], c["b"]

function EnhancerEP:OnInitialize()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
end

function EnhancerEP:OnEnable()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
	if (not Enhancer.db.profile.EP) then return; end
	self.enabled = true;
	TipHooker:Hook(self.ProcessTooltip, "item");
	
	--[[ For some reason I can't get TipHooker to work without enabling
			 RatingBuster wich sux so I hacked a bit here ]]--
	self:ScheduleEvent("Tooltip", self.Tooltip, 1, self);
end

function EnhancerEP:OnDisable()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
	self.enabled = false;
	
	TipHooker:Unhook(self.ProcessTooltip, "item");
end

function EnhancerEP:Tooltip()
	--[[ For some reason I can't get TipHooker to work without enabling
			 RatingBuster wich sux so I hacked a bit here ]]--
	local FunctionThatNeverExecutes = TipHooker.OnEventFrame:GetScript("OnEvent");
	pcall( FunctionThatNeverExecutes );
end

function EnhancerEP:Toggle()
	if (self.enabled) then
		Enhancer.db.profile.EP = false;
		self:OnDisable();
	else
		Enhancer.db.profile.EP = true;
		self:OnEnable();
	end
end

function EnhancerEP:Active()
	return self.enabled;
end

EnhancerEP.ProcessTypes = { [L["Armor"]] = true, [L["Gem"]] = true, [L["Weapon"]] = true, [L["Recipe"]] = true, } -- [L["Projectile"]] = true, [L["Quiver"]] = true, 
EnhancerEP.NotProcessSubTypes = { [L["Plate"]] = true, [L["Idols"]] = true, [L["Librams"]] = true, [L["Fishing Pole"]] = true, [L["One-Handed Swords"]] = true, [L["Polearms"]] = true, [L["Two-Handed Swords"]] = true, [L["Bows"]] = true, [L["Crossbows"]] = true, [L["Guns"]] = true, [L["Thrown"]] = true, [L["Wands"]] = true, }
function EnhancerEP.ProcessTooltip(tooltip, name, link)
	
	if (link) then
		
		--[[ Check if we care about this item ]]--
		local _, _, _, _, _, ItemType, ItemSubType = GetItemInfo(link)
		if (not EnhancerEP.ProcessTypes[ItemType]) then return; end
		if (EnhancerEP.NotProcessSubTypes[ItemSubType]) then return; end
		
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
		
		--[[ Do Attackpower Equivalence Points ]]--
		if (Enhancer.db.profile.AEP) then
			local AEP, AEPK = 0, 0;
			local gemAEPBlue, gemAEPKBlue = 0, 0;
			local gemAEPGreen, gemAEPKGreen = 0, 0;
			
			--[[ Set point values here so it's easy to change ]]--
			local hasteVal = 22;
			local strVal = 20;
			local critVal = 20;
			local agiVal = 18;
			local hitVal = 14;
			local apVal = 10;
			
			AEP = AEP + ( (bonuses.CR_HASTE or 0) * hasteVal );
			AEP = AEP + ( (bonuses.STR or 0) * strVal );
			AEP = AEP + ( (bonuses.CR_CRIT or 0) * critVal );
			AEP = AEP + ( (bonuses.AGI or 0) * agiVal );
			AEP = AEP + ( (bonuses.CR_HIT or 0) * hitVal );
			AEP = AEP + ( (bonuses.ATTACKPOWER or 0) * apVal );
			gemAEPBlue = (8 * strVal) * nonMetaSockets; -- Bold Living Ruby 8 str
			gemAEPGreen = (6 * strVal) * nonMetaSockets; -- Bold Blood Garnet 8 str
			AEP = AEP + ( ((12 * agiVal) + 750) * metaSockets ); -- Relentless Earthstorm Diamond: +12 Agility & 3% Increased Critical Damage -- 3% Increased Critical Damage can't be calculated so using a fixed value for it -- Apply Aura: Mod Crit Damage Bonus (Melee) (895)
			
			AEPK = AEPK + ( (bonuses.CR_HASTE or 0) * hasteVal );
			AEPK = AEPK + ( (bonuses.STR or 0) * (strVal * kingsMultiplier) );
			AEPK = AEPK + ( (bonuses.CR_CRIT or 0) * critVal );
			AEPK = AEPK + ( (bonuses.AGI or 0) * (agiVal * kingsMultiplier) );
			AEPK = AEPK + ( (bonuses.CR_HIT or 0) * hitVal );
			AEPK = AEPK + ( (bonuses.ATTACKPOWER or 0) * apVal );
			gemAEPKBlue = ((8 * strVal) * kingsMultiplier) * nonMetaSockets;
			gemAEPKGreen = ((6 * strVal) * kingsMultiplier) * nonMetaSockets;
			AEPK = AEPK + ( (((12 * agiVal) * kingsMultiplier) + 750) * metaSockets );
			
			if ( (AEP + gemAEPBlue + gemAEPGreen) > 0 or (AEPK + gemAEPKBlue + gemAEPKGreen) > 0 or Enhancer.db.profile.EPZero) then
				if (not lineAdded) then
					tooltip:AddLine(" ");
					tooltip:AddLine("Enhancer Equivalence Points:", c["r"], c["g"], c["b"]);
					lineAdded = true;
				end
				
				
				if ( (gemAEPBlue == gemAEPGreen) and (gemAEPKBlue == gemAEPKGreen) ) then
					tooltip:AddDoubleLine(L["aep_tooltip0"], string.format( L["ep_numbers"], (AEP + gemAEPBlue), (AEPK + gemAEPKBlue) ), c["r"], c["g"], c["b"], c["r"], c["g"], c["b"]);
				else
					tooltip:AddDoubleLine(L["aep_tooltip1"], string.format( L["ep_numbers"], (AEP + gemAEPBlue), (AEPK + gemAEPKBlue) ), c["r"], c["g"], c["b"], c["r"], c["g"], c["b"]);
					tooltip:AddDoubleLine(L["aep_tooltip2"], string.format( L["ep_numbers"], (AEP + gemAEPGreen), (AEPK + gemAEPKGreen) ), c["r"], c["g"], c["b"], c["r"], c["g"], c["b"]);
				end
				
				tinsert(infos, L["aep_info"]);
			end
		end
		
		--[[ Do Attackpower Equivalence Points but without hit ]]--
		if (Enhancer.db.profile.AEPH) then
			if (Enhancer.db.profile.AEP and not bonuses.CR_HIT) then
				-- We allready added AEP (with Hit) but since the item doesn't have any Hit it's pointless ;)
				-- so skip it
			else
				local AEP, AEPK = 0, 0;
				local gemAEPBlue, gemAEPKBlue = 0, 0;
				local gemAEPGreen, gemAEPKGreen = 0, 0;
				
				--[[ Set point values here so it's easy to change ]]--
				local hasteVal = 22;
				local strVal = 20;
				local critVal = 20;
				local agiVal = 18;
				local apVal = 10;
				
				AEP = AEP + ( (bonuses.CR_HASTE or 0) * hasteVal );
				AEP = AEP + ( (bonuses.STR or 0) * strVal );
				AEP = AEP + ( (bonuses.CR_CRIT or 0) * critVal );
				AEP = AEP + ( (bonuses.AGI or 0) * agiVal );
				AEP = AEP + ( (bonuses.ATTACKPOWER or 0) * apVal );
				gemAEPBlue = (8 * strVal) * nonMetaSockets; -- Bold Living Ruby 8 str
				gemAEPGreen = (6 * strVal) * nonMetaSockets; -- Bold Blood Garnet 8 str
				AEP = AEP + ( ((12 * agiVal) + 750) * metaSockets ); -- Relentless Earthstorm Diamond: +12 Agility & 3% Increased Critical Damage -- 3% Increased Critical Damage can't be calculated so using a fixed value for it -- Apply Aura: Mod Crit Damage Bonus (Melee) (895)
				-- 3% Increased Critical Damage doesn't show in ItemBonusLib
				
				AEPK = AEPK + ( (bonuses.CR_HASTE or 0) * hasteVal );
				AEPK = AEPK + ( (bonuses.STR or 0) * (strVal * kingsMultiplier) );
				AEPK = AEPK + ( (bonuses.CR_CRIT or 0) * critVal );
				AEPK = AEPK + ( (bonuses.AGI or 0) * (agiVal * kingsMultiplier) );
				AEPK = AEPK + ( (bonuses.ATTACKPOWER or 0) * apVal );
				gemAEPKBlue = ((8 * strVal) * kingsMultiplier) * nonMetaSockets;
				gemAEPKGreen = ((6 * strVal) * kingsMultiplier) * nonMetaSockets;
				AEPK = AEPK + ( (((12 * agiVal) * kingsMultiplier) + 750) * metaSockets );
				
				if ( (AEP + gemAEPBlue + gemAEPGreen) > 0 or (AEPK + gemAEPKBlue + gemAEPKGreen) > 0 or Enhancer.db.profile.EPZero) then
					if (not lineAdded) then
						tooltip:AddLine(" ");
						tooltip:AddLine("Enhancer Equivalence Points:", c["r"], c["g"], c["b"]);
						lineAdded = true;
					end
					
					if ( (gemAEPBlue == gemAEPGreen) and (gemAEPKBlue == gemAEPKGreen) ) then
						tooltip:AddDoubleLine(L["aeph_tooltip0"], string.format( L["ep_numbers"], (AEP + gemAEPBlue), (AEPK + gemAEPKBlue) ), c["r"], c["g"], c["b"], c["r"], c["g"], c["b"]);
					else
						tooltip:AddDoubleLine(L["aeph_tooltip1"], string.format( L["ep_numbers"], (AEP + gemAEPBlue), (AEPK + gemAEPKBlue) ), c["r"], c["g"], c["b"], c["r"], c["g"], c["b"]);
						tooltip:AddDoubleLine(L["aeph_tooltip2"], string.format( L["ep_numbers"], (AEP + gemAEPGreen), (AEPK + gemAEPKGreen) ), c["r"], c["g"], c["b"], c["r"], c["g"], c["b"]);
					end
					
					if (not Enhancer.db.profile.AEP) then
						tinsert(infos, L["aep_info"]);
					end
				end
			end
		end
		
		--[[ Do Healing Equivalence Points ]]--
		if (Enhancer.db.profile.HEP) then
			local HEP, HEPK = 0, 0;
			local gemHEPBlue, gemHEPKBlue = 0, 0;
			local gemHEPGreen, gemHEPKGreen = 0, 0;
			
			--[[ Set point values here so it's easy to change ]]--
			local intVal = 8;
			local healVal = 10;
			local scritVal = 1;
			local regenVal = 50;
			-- Values used are probably still shit is a primary concern :P
			
			HEP = HEP + ( (bonuses.INT or 0) * intVal );
			HEP = HEP + ( (bonuses.HEAL or 0) * healVal );
			HEP = HEP + ( (bonuses.CR_SPELLCRIT or 0) * scritVal );
			HEP = HEP + ( (bonuses.MANAREG or 0) * regenVal );
			
			gemHEPBlue = ( (9 * healVal) + (2 * regenVal) ) * nonMetaSockets;
			-- Royal Nightseye +9 Healing Spells and +2 Mana every 5 seconds 90 + 100 = 190
			-- Teardrop Living Ruby +18 Healing 180 = 180
			
			gemHEPGreen = (13 * healVal) * nonMetaSockets;
			-- Teardrop Blood Garnet +13 Healing 130
			-- Royal Shadow Draenite +7 Healing Spells & +1 Mana per 5 Seconds  70 + 50 = 120
			-- Luminous Flame Spessarite +7 Healing Spells and +3 Intellect 70 + 24 = 94
			
			HEP = HEP + ((26 * healVal) * metaSockets);
			-- Bracing Earthstorm Diamond +26 Healing Spells & 2% Reduced Threat -- THREATREDUCTION = 2 (in ItemBonusLib)
			
			HEPK = HEPK + ( (bonuses.INT or 0) * (intVal * kingsMultiplier) );
			HEPK = HEPK + ( (bonuses.HEAL or 0) * healVal );
			HEPK = HEPK + ( (bonuses.CR_SPELLCRIT or 0) * scritVal );
			HEPK = HEPK + ( (bonuses.MANAREG or 0) * regenVal );
			gemHEPKBlue = gemHEPBlue;
			gemHEPKGreen = gemHEPGreen;
			HEPK = HEPK + ( (26 * healVal) * metaSockets );
			
			if ( (HEP + gemHEPBlue + gemHEPGreen) > 0 or (HEPK + gemHEPKBlue + gemHEPKGreen) > 0 or Enhancer.db.profile.EPZero) then
				if (not lineAdded) then
					tooltip:AddLine(" ");
					tooltip:AddLine("Enhancer Equivalence Points:", c["r"], c["g"], c["b"]);
					lineAdded = true;
				end
				
				if ( (gemHEPBlue == gemHEPGreen) and (gemHEPKBlue == gemHEPKGreen) ) then
					tooltip:AddDoubleLine(L["hep_tooltip0"], string.format( L["ep_numbers"], (HEP + gemHEPBlue), (HEPK + gemHEPKBlue) ), c["r"], c["g"], c["b"], c["r"], c["g"], c["b"]);
				else
					tooltip:AddDoubleLine(L["hep_tooltip1"], string.format( L["ep_numbers"], (HEP + gemHEPBlue), (HEPK + gemHEPKBlue) ), c["r"], c["g"], c["b"], c["r"], c["g"], c["b"]);
					tooltip:AddDoubleLine(L["hep_tooltip2"], string.format( L["ep_numbers"], (HEP + gemHEPGreen), (HEPK + gemHEPKGreen) ), c["r"], c["g"], c["b"], c["r"], c["g"], c["b"]);
				end
				
				-- tinsert(infos, L["hep_info"]);
			end
		end
		
		if (lineAdded) then
			for _, infoLine in ipairs(infos) do
				tooltip:AddLine( infoLine, c["r"], c["g"], c["b"] );
			end
			
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

--[[
		Tornhoof/Pater from http://elitistjerks.com/f31/t13297-enhance_shaman_collected_works_theorycraft_vol_i/
		Haste Rating = 2.2
		Strength = 2 (2.2 w/Kings)
		Crit Rating = 2
		Agility = 1.8 (2 w/Kings)
		Hit Rating = 1.4
		Attack Power = 1
		
		Debug stuff:
		Bonuses for: [Swiftsteel Bludgeon]
		WEAPON_MAX = 196
		WEAPON_SPEED = 1.5
		ATTACKPOWER = 40
		CR_HASTE = 27
		CR_HIT = 19
		WEAPON_MIN = 105
]]--

--[[
	Healing Equivalency Points: (Not sure at all about numbers)

	Healing = 1.12
	SpellCrit = 0.101
	MP5 = 6.403
	INT = 0.8975
	
	-- HEAL, INT, MANAREG, CR_SPELLCRIT, DMG
	-- Question comes in here Damage/Healing is caught as Healing or not by ItemBonusLib: it is
	
	Int = 15 Mana, 0.083 MP5, 0.336 Healing, 0.0279 Spell Crit
	http://forums.wow-europe.com/thread.html?topicId=14551513&sid=1
	
	INT = 0.8
	HEAL = 1
	CR_SPELLCRIT = 0.1
	MANAREG = 5.7
]]--