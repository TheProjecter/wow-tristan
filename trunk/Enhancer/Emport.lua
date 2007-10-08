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
			for future eventuall use is of little to none harm.
			]]
		end
	end
	
	local userShouldCheck = nil;
	for key, _ in pairs(self.db.profile.AEPNumbers) do
		if (not changed[key]) then
			-- self.db.profile.AEPNumbers[key] = 0;
			
			if (userShouldCheck) then
				userShouldCheck = strjoin(", ", userShouldCheck, L[key]);
			else
				userShouldCheck = L[key];
			end
			
		end
	end
	
	if (userShouldCheck) then
		self:Print(string.format(L["aep_import_warning"], userShouldCheck));
	end
end

function Enhancer:CrazyShamanImport(data)
	-- Assume the data will look like this (to avoid locale errors with fraction separators):
	-- AP:10;STR:20;AGI:18;STA:0;CR:20;HR:14;HsR:15;RS:0;IA:10;
	
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
	};
	
	local standardizedData = {}
	local updateValid = false;
	for _, dataPart in ipairs( { strsplit(";", data) } ) do
		if (dataPart and dataPart ~= "") then
			local identifier, number = strsplit(":", dataPart);
			
			local value = number / 10;
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