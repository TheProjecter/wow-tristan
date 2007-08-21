Enhancer = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0", "AceModuleCore-2.0", "Parser-3.0");
Enhancer:RegisterDB("EnhancerDB");

local L = AceLibrary("AceLocale-2.2"):new("Enhancer");
local deformat = AceLibrary("Deformat-2.0");
local db = Enhancer.db.profile;
local Aura = AceLibrary("SpecialEvents-Aura-2.0")

local _, englishClass = UnitClass("player");
Enhancer.englishClass = englishClass;

function Enhancer:OnInitialize()
	if (self.englishClass ~= "SHAMAN") then return; end
	
	self:Setup();
	self:InspectEPValues()
end

function Enhancer:OnEnable()
	if (self.englishClass ~= "SHAMAN") then return; end
	
	-- Register our events :>
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "OutOfCombat");
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "EnterCombat");
	self:RegisterEvent("PLAYER_DEAD", "PlayerDead");
	
	-- Check if the player casts a totem :)
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "CastingTotem")
end

function Enhancer:OnDisable()
	if (self.englishClass ~= "SHAMAN") then return; end
	
	self:UnregisterAllEvents();
end