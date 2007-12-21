--[[ Emport is just a mix of Import and Export ]]--
local L = AceLibrary("AceLocale-2.2"):new("Enhancer");

function Enhancer:StandardAEPImport(standardizedData)
	local unused, changed = {}, {};
	
	for key, value in pairs(standardizedData) do
		if (self.db.profile.AEPNumbers[key]) then
			changed[key] = true;
			self.db.profile.AEPNumbers[key] = value;
		else
			tinsert(unused, key);
			--[[
			Not used for anything atm but this function should be very seldomly called so figure saving them
			for future eventual use is of little to none harm.
			]]
		end
	end
	
	local userShouldCheck = nil;
	for key, _ in pairs(self.db.profile.AEPNumbers) do
		if (not changed[key]) then
			-- self.db.profile.AEPNumbers[key] = 0;
			
			if (key == "MH_DPS" or key == "OH_DPS") then
				-- Ignore!
			elseif (userShouldCheck) then
				userShouldCheck = strjoin(", ", userShouldCheck, L[key]);
			else
				userShouldCheck = L[key];
			end
			
		end
	end
	
	if (userShouldCheck) then
		self:Print(string.format(L["aep_import_warning"], userShouldCheck));
	else
		self:Print(L["Import_complete"]);
	end
end

function Enhancer:CrazyShamanImport(data)
	-- Assume the data will look like this (to avoid locale errors with fraction separators):
	-- AP:10;STR:20;AGI:18;STA:0;CR:20;HR:14;HsR:15;RS:0;IA:10;
	-- AP:100;CR:167;STR:200;AGI:148;HR:175;HsR:169;IA:023;ExP:258;
	
	local CrazyShamanLookup = {
		["AP"] = "ATTACKPOWER",
		["STR"] = "STR",
		["AGI"] = "AGI",
		["STA"] = "STA",
		["CR"] = "CR_CRIT",
		["HR"] = "CR_HIT",
		["HsR"] = "CR_HASTE",
		["RS"] = "CR_RESILIENCE",
		["IA"] = "IGNOREARMOR",
		["ExP"] = "CR_EXPERTISE",
	};
	
	local standardizedData = {}
	local updateValid = false;
	for _, dataPart in ipairs( { strsplit(";", data) } ) do
		if (dataPart and dataPart ~= "") then
			local identifier, number = strsplit(":", dataPart);
			
			local value = number / 100;
			local key = CrazyShamanLookup[identifier];
			
			if (key) then
				standardizedData[key] = value;
				updateValid = true;
			end
		end
	end
	
	if (updateValid) then
		self:StandardAEPImport(standardizedData)
	end
end

function Enhancer:StandardEPSets(name)
	local standardizedData;
	
	if (name == "medium") then
		standardizedData = {
			ATTACKPOWER = 1,
			STR = 2,
			AGI = (18/10),
			CR_CRIT = 2,
			CR_HIT = (14/10),
			CR_HASTE = (148/100),
			IGNOREARMOR = (28/100),
			
			CR_EXPERTISE = (252/100),  -- Multiply hit rating AEP by 1.8 if you assume that the mob will never cast and never parry.
			
			STA = 0,
			CR_RESILIENCE = 0,
			MH_DPS = (903 / 100),
			OH_DPS = (37 / 10),
		};
		self:StandardAEPImport(standardizedData);
		return;
	end
	
	if (name == "high") then
		standardizedData = {
			ATTACKPOWER = 1,
			STR = 2,
			AGI = 2,
			CR_CRIT = 2,
			CR_HIT = (19/10),
			CR_HASTE = 2,
			IGNOREARMOR = (37/100),
			
			CR_EXPERTISE = (342/100),  -- Multiply hit rating AEP by 1.8 if you assume that the mob will never cast and never parry.
			
			STA = 0,
			CR_RESILIENCE = 0,
			MH_DPS = (903 / 100),
			OH_DPS = (37 / 10),
		};
		self:StandardAEPImport(standardizedData);
		return;
	end
	
end