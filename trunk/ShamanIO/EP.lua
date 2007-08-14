local L = AceLibrary("AceLocale-2.2"):new("EnhancerEP")
EnhancerEP = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0");

local ibl = AceLibrary("ItemBonusLib-1.0");
local TipHooker = AceLibrary("TipHooker-1.0");
local Gratuity = AceLibrary("Gratuity-2.0")

function EnhancerEP:OnInitialize()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
end

function EnhancerEP:OnEnable()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
	if (not Enhancer.db.profile.EP) then return; end
	self.enabled = true;
	TipHooker:Hook(self.ProcessTooltip, "item");
	
	--[[ For some reason I can't get TipHooker to work without enabling RatingBuster wich sux so I hacked a bit here ]]--
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

EnhancerEP.ProcessTypes = { [L["Armor"]] = true, [L["Gem"]] = true, [L["Weapon"]] = true, } -- [L["Projectile"]] = true, [L["Quiver"]] = true, 
EnhancerEP.NotProcessSubTypes = { [L["Plate"]] = true, [L["Idols"]] = true, [L["Librams"]] = true, [L["Fishing Pole"]] = true, [L["One-Handed Swords"]] = true, [L["Polearms"]] = true, [L["Two-Handed Swords"]] = true, [L["Bows"]] = true, [L["Crossbows"]] = true, [L["Guns"]] = true, [L["Thrown"]] = true, [L["Wands"]] = true, }
function EnhancerEP.ProcessTooltip(tooltip, name, link)
	
	if (link) then
		
		--[[ Check if we care about this item ]]--
		local _, _, _, _, _, ItemType, ItemSubType = GetItemInfo(link)
		if (not EnhancerEP.ProcessTypes[ItemType]) then return; end
		if (EnhancerEP.NotProcessSubTypes[ItemSubType]) then return; end
		
		--[[ ItemBonusLib doesn't count empty sockets wich we prefer since
				 inspected gear can have shit gems in them ;) ]]--
		link = EnhancerEP:StripGems(link);
		bonuses = ibl:ScanItem(link, true, false);
		local lineAdded = nil;
		local infos = {};
		
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
			
			-- Relentless Earthstorm Diamond: +12 Agility & 3% Increased Critical Damage -- Apply Aura: Mod Crit Damage Bonus (Melee) (895)
			-- The Agi Bonus can be calculated
			-- 3% Increased Critical Damage can't be calculated so using a fixed value for it, 750
			-- 
			-- Make Hit Optional (as second Paranthesised value)
			
			AEP = AEP + (bonuses.CR_HASTE or 0) * 22;
			AEP = AEP + (bonuses.STR or 0) * 20;
			AEP = AEP + (bonuses.CR_CRIT or 0) * 20;
			AEP = AEP + (bonuses.AGI or 0) * 18;
			AEP = AEP + (bonuses.CR_HIT or 0) * 14;
			AEP = AEP + (bonuses.ATTACKPOWER or 0) * 10;
			gemAEPBlue = nonMetaSockets * 160;
			AEP = AEP + (((12 * 18) + 750) * metaSockets);
			
			AEPK = AEPK + (bonuses.CR_HASTE or 0) * 22 / 10;
			AEPK = AEPK + (bonuses.STR or 0) * 22;
			AEPK = AEPK + (bonuses.CR_CRIT or 0) * 20;
			AEPK = AEPK + (bonuses.AGI or 0) * 20;
			AEPK = AEPK + (bonuses.CR_HIT or 0) * 14;
			AEPK = AEPK + (bonuses.ATTACKPOWER or 0) * 10;
			gemAEPKBlue = nonMetaSockets * 176;
			AEPK = AEPK + (((12 * 20) + 750) * metaSockets);
	
			
			if (AEP > 0 or AEPK > 0 or true) then
				if (not lineAdded) then tooltip:AddLine(" "); end
				lineAdded = true;
				
				if ( (gemAEPBlue == gemAEPGreen) and (gemAEPKBlue == gemAEPKGreen) ) then
					tooltip:AddLine( string.format( L["aep_tooltip0"], (AEP + gemAEPBlue), (AEPK + gemAEPKBlue) ) );
				else
					tooltip:AddLine( string.format( L["aep_tooltip1"], (AEP + gemAEPBlue), (AEPK + gemAEPKBlue) ) );
					tooltip:AddLine( string.format( L["aep_tooltip2"], (AEP + gemAEPGreen), (AEPK + gemAEPKGreen) ) );
				end
				
				tinsert(infos, L["aep_info"]);
			end
		end
		
		--[[ Do Healing Equivalence Points ]]--
		if (Enhancer.db.profile.HEP) then
			-- Values used are shit is a primary concern :P
			
			local HEP, HEPK = 0, 0;
			local gemHEPBlue, gemHEPKBlue = 0, 0;
			local gemHEPGreen, gemHEPKGreen = 0, 0;
			
			HEP = HEP + (bonuses.INT or 0) * 80;
			HEP = HEP + (bonuses.HEAL or 0) * 100;
			HEP = HEP + (bonuses.CR_SPELLCRIT or 0) * 10;
			HEP = HEP + (bonuses.MANAREG or 0) * 570;
			--gemHEPBlue = nonMetaSockets * 160;
			--HEP = HEP + (((12 * 18) + 750) * metaSockets);
			
			HEPK = HEPK + (bonuses.INT or 0) * 88;
			HEPK = HEPK + (bonuses.HEAL or 0) * 100;
			HEPK = HEPK + (bonuses.CR_SPELLCRIT or 0) * 10;
			HEPK = HEPK + (bonuses.MANAREG or 0) * 570;
			--gemHEPKBlue = nonMetaSockets * 176;
			--HEPK = HEPK + (((12 * 20) + 750) * metaSockets);
	
			
			if (HEP > 0 or HEPK > 0 or true) then
				if (not lineAdded) then tooltip:AddLine(" "); end
				lineAdded = true;
				
				if ( (gemHEPBlue == gemHEPGreen) and (gemHEPKBlue == gemHEPKGreen) ) then
					tooltip:AddLine( string.format( L["hep_tooltip0"], (HEP + gemHEPBlue), (HEPK + gemHEPKBlue) ) );
				else
					tooltip:AddLine( string.format( L["hep_tooltip1"], (HEP + gemHEPBlue), (HEPK + gemHEPKBlue) ) );
					tooltip:AddLine( string.format( L["hep_tooltip2"], (HEP + gemHEPGreen), (HEPK + gemHEPKGreen) ) );
				end
				
				tinsert(infos, L["hep_info"]);
			end
		end
		
		if (lineAdded) then
			for _, infoLine in ipairs(infos) do
				tooltip:AddLine( infoLine );
			end
			
			tooltip:Show();
		end
	end
end

function EnhancerEP:StripGems(itemlink)
	local found, _, itemstring = string.find(itemlink, "^|c%x+|H(.+)|h%[.+%]")
	if (not found) then return itemlink; end
	
	local linkType, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId = strsplit(":", itemstring)
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