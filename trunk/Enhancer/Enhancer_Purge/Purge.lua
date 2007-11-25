EnhancerPurge = Enhancer:NewModule("Purge", "AceEvent-2.0", "Parser-3.0");
Enhancer:SetModuleDefaultState("Purge", true);

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerPurge:GetConsoleOptions()
	return L["purge_cmd"], L["purge_desc"];
end

function EnhancerPurge:OnInitialize()
	
end

-- tyvm WitchHunt
local dispelParserEventOrig = {
	recipientID = false,
	sourceID_ne = false,
	eventType = "Dispel",
	event_in = {
		CHAT_MSG_SPELL_BREAK_AURA = true,
	}
}

local dispelParserEvent = {
	sourceID = "player",
	eventType = "Dispel",
	event_in = {
		CHAT_MSG_SPELL_BREAK_AURA = true,
	}
}

function EnhancerPurge:OnEnable()
	self:RegisterParserEvent( dispelParserEvent, "Purge" )
end

function EnhancerPurge:OnDisable()
	self:UnregisterAllEvents();
end

function EnhancerPurge:Purge(info)
	if (info.isFailed == false and info.sourceAbilityName == Enhancer.BS["Purge"]) then
		Enhancer:Pour(string.format(L["purge_info"], info.recipientAbilityName));
		-- Enhancer:Print(info.recipientName);
		-- ["purge_info_long"] = "Purged %s from %s",
	end
end