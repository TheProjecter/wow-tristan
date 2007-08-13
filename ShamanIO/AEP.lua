local L = AceLibrary("AceLocale-2.2"):new("EnhancerAEP")
EnhancerAEP = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0");

local ibl = AceLibrary("ItemBonusLib-1.0");
local TipHooker = AceLibrary("TipHooker-1.0");
local Gratuity = AceLibrary("Gratuity-2.0")

function EnhancerAEP:OnInitialize()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
end

function EnhancerAEP:OnEnable()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
	if (not Enhancer.db.profile.AEP) then return; end
	self.enabled = true;
	TipHooker:Hook(self.ProcessTooltip, "item");
	
	--[[ For some reason I can't get TipHooker to work without enabling RatingBuster wich sux so I hacked a bit here ]]--
	self:ScheduleEvent("Tooltip", self.Tooltip, 1, self);
end

function EnhancerAEP:OnDisable()
	if (Enhancer.englishClass ~= "SHAMAN") then return; end
	self.enabled = false;
	
	TipHooker:Unhook(self.ProcessTooltip, "item");
end

function EnhancerAEP:Tooltip()
	--[[ For some reason I can't get TipHooker to work without enabling
			 RatingBuster wich sux so I hacked a bit here ]]--
	local FunctionThatNeverExecutes = TipHooker.OnEventFrame:GetScript("OnEvent");
	pcall( FunctionThatNeverExecutes );
end

function EnhancerAEP:Toggle()
	if (self.enabled) then
		Enhancer.db.profile.AEP = false;
		self:OnDisable();
	else
		Enhancer.db.profile.AEP = true;
		self:OnEnable();
	end
end

function EnhancerAEP:Active()
	return self.enabled;
end

EnhancerAEP.ProcessTypes = { [L["Armor"]] = true, [L["Gem"]] = true, [L["Weapon"]] = true, } -- [L["Projectile"]] = true, [L["Quiver"]] = true, 
EnhancerAEP.NotProcessSubTypes = { [L["Plate"]] = true, [L["Idols"]] = true, [L["Librams"]] = true, [L["Fishing Pole"]] = true, [L["One-Handed Swords"]] = true, [L["Polearms"]] = true, [L["Two-Handed Swords"]] = true, [L["Bows"]] = true, [L["Crossbows"]] = true, [L["Guns"]] = true, [L["Thrown"]] = true, [L["Wands"]] = true, }
function EnhancerAEP.ProcessTooltip(tooltip, name, link)
	
	if (link) then
		
		--[[ Check if we care about this item ]]--
		local _, _, _, _, _, ItemType, ItemSubType = GetItemInfo(link)
		if (not EnhancerAEP.ProcessTypes[ItemType]) then return; end
		if (EnhancerAEP.NotProcessSubTypes[ItemSubType]) then return; end
		
		--[[ ItemBonusLib doesn't count empty sockets wich we prefer since
				 inspected gear can have shit gems in them ;) ]]--
		link = EnhancerAEP:StripGems(link);
		bonuses = ibl:ScanItem(link, true, false);
		
		local AEP, AEPK = 0, 0;
		
		AEP = AEP + (bonuses.CR_HASTE or 0) * 22;
		AEP = AEP + (bonuses.STR or 0) * 20;
		AEP = AEP + (bonuses.CR_CRIT or 0) * 20;
		AEP = AEP + (bonuses.AGI or 0) * 18;
		AEP = AEP + (bonuses.CR_HIT or 0) * 14;
		AEP = AEP + (bonuses.ATTACKPOWER or 0) * 10;
		
		AEPK = AEPK + (bonuses.CR_HASTE or 0) * 22 / 10;
		AEPK = AEPK + (bonuses.STR or 0) * 22;
		AEPK = AEPK + (bonuses.CR_CRIT or 0) * 20;
		AEPK = AEPK + (bonuses.AGI or 0) * 20;
		AEPK = AEPK + (bonuses.CR_HIT or 0) * 14;
		AEPK = AEPK + (bonuses.ATTACKPOWER or 0) * 10;

--[[
		Haste Rating = 2.2
		Strength = 2 (2.2 w/Kings)
		Crit Rating = 2
		Agility = 1.8 (2 w/Kings)
		Hit Rating = 1.4
		Attack Power = 1
		
		Bonuses for: [Swiftsteel Bludgeon]
		WEAPON_MAX = 196
		WEAPON_SPEED = 1.5
		ATTACKPOWER = 40
		CR_HASTE = 27
		CR_HIT = 19
		WEAPON_MIN = 105
]]--
		
		--[[ Parse Sockets ]]--
		Gratuity:SetHyperlink(link)
		for i = 2, Gratuity:NumLines() do
			local line = Gratuity:GetLine(i)
			if (line == "Red Socket" or line == "Blue Socket" or line == "Yellow Socket") then
				AEP = AEP + 16;
				AEPK = AEPK + (176 / 10);
			elseif (line == "Meta Socket") then
				-- Relentless Earthstorm Diamond: +12 Agility & 3% Increased Critical Damage -- Apply Aura: Mod Crit Damage Bonus (Melee) (895)
				-- The Agi Bonus can be calculated
				-- 3% Increased Critical Damage can't be calculated so using a fixed value for it, 750
				AEP = AEP + (12 * 18) + 750;
				AEPK = AEPK + (12 * 20) + 750;
			end
		end
		
		if (AEP > 0 or AEPK > 0 or true) then
			tooltip:AddLine(" ");
			tooltip:AddLine( string.format(L["aep_tooltip"], AEP, AEPK) );
			tooltip:AddLine( L["aep_info"] );
			tooltip:Show();
		end
	end
end

function EnhancerAEP:StripGems(itemlink)
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