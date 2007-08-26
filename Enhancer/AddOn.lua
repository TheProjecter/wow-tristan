--[[
Left to do:
	Windfury calculation and display! (FontString midscreen that grows on crit?)
]]--
--[[ http://www.wowace.com/wiki/Joker ]]--
Enhancer = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0", "AceModuleCore-2.0", "Parser-3.0");
Enhancer:RegisterDB("EnhancerDB");

local L = AceLibrary("AceLocale-2.2"):new("Enhancer");
Enhancer.deformat = AceLibrary("Deformat-2.0");
Enhancer.BS = AceLibrary("Babble-Spell-2.2");
--local Aura = AceLibrary("SpecialEvents-Aura-2.0")

local _, englishClass = UnitClass("player");
Enhancer.englishClass = englishClass;

Enhancer.aFrames = {}; -- All Frames
Enhancer.tFrames = {}; -- Totem Frames
Enhancer.dFrames = {}; -- Death Frames
Enhancer.combatLog = {}; -- List of all "unit"s we are intressted in for the combatlog :)

function Enhancer:OnInitialize()
	if (self.englishClass ~= "SHAMAN") then return; end
	
	self:InspectEPValues(); -- Check so not using old values
	
	if (not self.db.profile.startAnnounceDisabled) then
		self:ScheduleEvent("DelayAnnounce", self.DelayAnnounce, 10, self)
	end
end

function Enhancer:OnEnable()
	if (self.englishClass ~= "SHAMAN") then return; end
	Enhancer.PlayerLevel = UnitLevel("player");
	
	-- Register our events :>
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "OutOfCombat");
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "EnterCombat");
	self:RegisterEvent("PLAYER_DEAD", "PlayerDead");
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "CastingTotem");
	self:RegisterEvent("PLAYER_LEVEL_UP", "Ding");
	
	-- ShieldFrame? Water, Lightning on self - Earth on whoever :>
	
	self:RegisterParserEvent({
		eventType = 'Damage',
	}, "ParserDamage");
	self:RegisterParserEvent({
		eventType = 'Miss',
		sourceID = "player",
	}, "ParserMiss");
end

function Enhancer:OnDisable()
	if (self.englishClass ~= "SHAMAN") then return; end
	
	self:UnregisterAllEvents();
	self:UnregisterAllParserEvents();
end

function Enhancer:DelayAnnounce()
	self:Print(L["Announcement"]);
end

function Enhancer:InspectEPValues()
	local resetNeeded = false;
	
	for _, value in pairs(Enhancer.db.profile.AEPNumbers) do
		if (value > 5) then
			resetNeeded = true;
		end
	end
	for _, value in pairs(Enhancer.db.profile.HEPNumbers) do
		if (value > 5) then
			resetNeeded = true;
		end
	end
	for _, value in pairs(Enhancer.db.profile.DEPNumbers) do
		if (value > 5) then
			resetNeeded = true;
		end
	end
	
	if (resetNeeded) then
		for key, value in pairs(defaults.AEPNumbers) do
			Enhancer.db.profile.AEPNumbers[key] = defaults.AEPNumbers[key];
		end
		for key, value in pairs(defaults.HEPNumbers) do
			Enhancer.db.profile.HEPNumbers[key] = defaults.HEPNumbers[key];
		end
		for key, value in pairs(defaults.DEPNumbers) do
			Enhancer.db.profile.DEPNumbers[key] = defaults.DEPNumbers[key];
		end
		
		self:Print("Your AEP values have been reset due to a major change, there was sadly no alternative!");
	end
end