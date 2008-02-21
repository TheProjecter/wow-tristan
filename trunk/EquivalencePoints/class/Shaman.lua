local AddOn = LibStub("AceAddon-3.0"):GetAddon("EquivalencePoints", true);
if (not AddOn) then return; end

local itemEquipLoc2Slot = {
	INVTYPE_WEAPON = { [16] = 16, [17] = 17 },
	INVTYPE_SHIELD = { [17] = 17 },
	--INVTYPE_2HWEAPON = { [16] = 16 },
	INVTYPE_WEAPONMAINHAND = { [16] = 16 },
	INVTYPE_WEAPONOFFHAND = { [17] = 17 },
	INVTYPE_HOLDABLE = { [17] = 17 },
};
--[[
http://www.wowwiki.com/API_GetItemInfo

http://www.wowwiki.com/ItemEquipLoc
	"INVTYPE_WEAPON"  One-Hand  16,17  
	"INVTYPE_SHIELD"  Shield  17  
	"INVTYPE_2HWEAPON"  Two-Handed  16  
	"INVTYPE_WEAPONMAINHAND"  Main-Hand Weapon  16  
	"INVTYPE_WEAPONOFFHAND"  Off-Hand Weapon  17  
	"INVTYPE_HOLDABLE"  Held In Off-Hand  17
]]

function AddOn:SHAMAN(sItemLink, ItemID, ItemRarity, bonuses, socketBonuses)
	local title, tbl = nil, AddOn:OPairTable();
	local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(sItemLink);
	
	--[[ Weapon Equivalence Points ]]--
	if (bonuses["WEAPON_SPEED"] and bonuses["WEAPON_MAX"] and bonuses["WEAPON_MIN"]) then
		local dps = math.round(((bonuses["WEAPON_MAX"] + bonuses["WEAPON_MIN"] ) / 2) / bonuses["WEAPON_SPEED"]);
		local multiplier = bonuses["WEAPON_SPEED"] / (26 / 10);
		
		--// this might need some place where it can be edited but for now this'll do:
		local mhaep = dps * (903 / 100) * multiplier;
		local ohaep = dps * (37 / 10) * multiplier;
		local total, kingsTotal, obeyColor, kingsObeyColor, gemsUsed, kingsGemsUsed = self:Calculate(bonuses, socketBonuses, self.db.profile.Values, ItemRarity);
		    --total, kingsTotal, obeyColor, kingsObeyColor, gemsUsed, kingsGemsUsed = self:Calculate(bonuses, socketBonuses, self.db.profile.Values, ItemRarity);
		
		if ((mhaep > 0 or self.db.profile.ShowZero) and itemEquipLoc2Slot[itemEquipLoc] and itemEquipLoc2Slot[itemEquipLoc][16]) then
			tbl["Main Hand"] = string.format("%.2f%s (%.2f%s)", (total + mhaep), ((obeyColor and "") or "|cffff0000*|r"), (kingsTotal + mhaep), ((kingsObeyColor and "") or "|cffff0000*|r"));
			title = "Weapon EP";
		end
		
		if ((ohaep > 0 or self.db.profile.ShowZero) and itemEquipLoc2Slot[itemEquipLoc] and itemEquipLoc2Slot[itemEquipLoc][17]) then
			tbl["Off Hand"] = string.format("%.2f%s (%.2f%s)", (total + ohaep), ((obeyColor and "") or "|cffff0000*|r"), (kingsTotal + ohaep), ((kingsObeyColor and "") or "|cffff0000*|r"));
			title = "Weapon EP";
		end
	end
	
	return title, tbl;
end

function AddOn:ImportEnhancerAEP()
	if (not Enhancer) then print("Enhancer not found, import aborted"); end
	local standardizedData = {};
    
	-- Set new values but don't insert new keys:
	for key, value in pairs(Enhancer.db.profile.AEPNumbers) do
	  standardizedData[key] = value;
	end
	
	self:Import(standardizedData);
end

function AddOn:ImportEnhancerHEP()
	if (not Enhancer) then print("Enhancer not found, import aborted"); end
	local standardizedData = {};
    
	-- Set new values but don't insert new keys:
	for key, value in pairs(Enhancer.db.profile.HEPNumbers) do
	  standardizedData[key] = value;
	end
	
	self:Import(standardizedData);
end

function AddOn:ImportEnhancerDEP()
	if (not Enhancer) then print("Enhancer not found, import aborted"); end
	local standardizedData = {};
    
	-- Set new values but don't insert new keys:
	for key, value in pairs(Enhancer.db.profile.DEPNumbers) do
	  standardizedData[key] = value;
	end
	
	self:Import(standardizedData);
end