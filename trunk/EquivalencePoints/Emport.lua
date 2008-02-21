local AddOn = LibStub("AceAddon-3.0"):GetAddon("EquivalencePoints", true);
if (not AddOn) then return; end

local _G = getfenv(0);
-- Create our print :)
local print = function(...) _G["print"]("|cffffdc5f" .. "EquivalencePoints" .. "|r:", ...); end
-- Create our debug :)
local debug = function(...) if (AddOn.debug) then _G["print"]("|cffff7777" .. "EquivalencePoints Debug" .. "|r:", date("[%Y-%m-%d %H:%M:%S]"), ...); end end

AddOn.LookUps = {};
AddOn.LookUps.CrazyShaman = {
	["AP"] = "ATTACKPOWER",
	["STR"] = "STR",
	["AGI"] = "AGI",
	["STA"] = "STA",
	["CR"] = "CR_CRIT",
	["HR"] = "CR_HIT",
	["HsR"] = "CR_HASTE",
	["RS"] = "CR_RESILIENCE",
	["IA"] = "IGNOREARMOR",
	["ExP"] = "CR_EXPERTISE", -- Misstype should've been ExR but nvm.
	["ExR"] = "CR_EXPERTISE",
};

AddOn.LookUps.LootRank = {
	["STR"] = "STR",
	["ARM"] = "ARMOR",
	["EXP"] = "CR_EXPERTISE",
	["MP5"] = "MANAREG",
	["STA"] = "STA",
	["DEF"] = "CR_DEFENSE",
	["MCR"] = "CR_CRIT", --RANGEDCRIT
	["HEAL"] = "HEAL",
	["AGI"] = "AGI",
	["DOD"] = "CR_DODGE",
	["MHIT"] = "CR_HIT",
	["SPC"] = "CR_SPELLCRIT",
	["INT"] = "INT",
	["BLV"] = "BLOCKVALUE",
	["MAP"] = "ATTACKPOWER", --RANGEDATTACKPOWER
	["SPH"] = "CR_SPELLHIT",
	["SPI"] = "SPI",
	["BLR"] = "CR_BLOCK",
	--["FAP"] = "FAP", --Feral AP
	["SPD"] = "DMG",
	["PAR"] = "CR_PARRY",
	["ARP"] = "IGNOREARMOR",
	["FID"] = "FIREDMG",
	--["SCKM"] = "SCKM", -- Meta
	["RES"] = "CR_RESILIENCE",
	["MH"] = "CR_HASTE",
	["FRD"] = "FROSTDMG",
	--["DPS"] = "DPS", -- MH DPS
	["ARD"] = "ARCANEDMG",
	--["ODPS"] = "ODPS", -- OH DPS
	["NAD"] = "NATUREDMG",
	-- ["RDPS"] = "RDPS", --Ranged DPS
	["SHD"] = "SHADOWDMG",
	["HAS"] = "CR_SPELLHASTE",
	["SPP"] = "SPELLPEN",
	--title=DPS%20Warrior
};



function AddOn:CrazyShamanImport(data)
	-- Assume the data will look like this (to avoid locale errors with fraction separators):
	-- AP:100;CR:167;STR:200;AGI:148;HR:175;HsR:169;IA:023;ExP:258;
	
	local standardizedData = {}
	local updateValid = false;
	for _, dataPart in ipairs( { strsplit(";", data) } ) do
		if (dataPart and dataPart ~= "") then
			local identifier, number = strsplit(":", dataPart);
			
			local value = tonumber(number / 100);
			local key = self.LookUps and self.LookUps.CrazyShaman and self.LookUps.CrazyShaman[identifier];
			
			if (key and value) then
				standardizedData[key] = value;
				updateValid = true;
			end
			
			if (value > 10) then
				print("Values in this AddOn can't go above 10 please check your input");
				return;
			end
		end
	end
	
	if (updateValid) then
		self:ImportSet("CrazyShaman", standardizedData)
	end
end

function AddOn:LootrankImport(URL)
	-- http://www.lootrank.com/wow/rank.asp?Cla=1&Max=10&Slot=0&Gem=3&Art=0&Dif=146&Str=16&Arm=0&Exp=15&mp5=0&Sta=3&Def=0&mcr=20&heal=0&Agi=15&Dod=0&mhit=15&spc=0&Int=0&blv=0&map=7&sph=0&Spi=0&blr=0&fap=0&spd=0&par=0&arp=2&fid=0&Sckm=180&res=0&mh=28&frd=0&dps=100&ard=0&odps=50&nad=0&rdps=0&shd=0&has=0&spp=0&title=DPS%20Warrior
	local _, QueryString = strsplit("?", URL)
	-- Cla=1&Max=10&Slot=0&Gem=3&Art=0&Dif=146&Str=16&Arm=0&Exp=15&mp5=0&Sta=3&Def=0&mcr=20&heal=0&Agi=15&Dod=0&mhit=15&spc=0&Int=0&blv=0&map=7&sph=0&Spi=0&blr=0&fap=0&spd=0&par=0&arp=2&fid=0&Sckm=180&res=0&mh=28&frd=0&dps=100&ard=0&odps=50&nad=0&rdps=0&shd=0&has=0&spp=0&title=DPS%20Warrior
	
	local QueryStringParts = { strsplit("&", QueryString) }
	local SetTable, SetTitle = {}, "";
	for _, Part in ipairs(QueryStringParts) do
		local ID, Val = strsplit("=", Part);
		ID = ID and string.upper(ID);
		Val = tonumber(Val);
		
		local Key = ID and self.LookUps and self.LookUps.LootRank and self.LookUps.LootRank[ID];
		
		if (Key and Val) then
			SetTable[Key] = Val;
		elseif (ID == "TITLE") then
			--title=DPS%20Warrior
			Val = string.gsub(Val, "%%20", " ");
			Val = string.gsub(Val, "+", " ");
			SetTitle = string.format(" (%s)", Val);
		end
		
		if (Val > 10) then
			print("Values in this AddOn can't go above 10 please check your input");
			return;
		end
	end
	
	if (table.safecount(SetTable) > 0) then
		self:ImportSet("Lootrank"..SetTitle, SetTable)
		print("Lootrank doesn't differ between ranged/melee crit & hit, so if you wanted ranged you should import the set and change it's values! By default the import is to Melee!");
	end
end