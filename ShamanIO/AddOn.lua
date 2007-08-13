Enhancer = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0");
Enhancer:RegisterDB("EnhancerDB");

local L = AceLibrary("AceLocale-2.2"):new("Enhancer");
local deformat = AceLibrary("Deformat-2.0");
local db = Enhancer.db.profile;

local _, englishClass = UnitClass("player");
Enhancer.englishClass = englishClass;

function Enhancer:OnInitialize()
	if (self.englishClass ~= "SHAMAN") then return; end
	
	-- Create all frames!
	self.earth = self:CreateButton("EnhancerFrameEarth", "Spell_Totem_WardOfDraining");
	self.fire = self:CreateButton("EnhancerFrameFire", "Spell_Totem_WardOfDraining");
	self.water = self:CreateButton("EnhancerFrameWater", "Spell_Totem_WardOfDraining");
	self.air = self:CreateButton("EnhancerFrameAir", "Spell_Totem_WardOfDraining");
	self.windfury = self:CreateButton("EnhancerFrameWindfury", "Spell_Nature_Cyclone");
	self.reincarnation = self:CreateButton("EnhancerFrameReincarnation", "Spell_Nature_Reincarnation");
	self.invigorated = self:CreateButton("EnhancerFrameInvigorated", "Spell_Nature_NatureResistanceTotem");
	
	self.allframes = { "earth", "fire", "water", "air", "windfury", "reincarnation", "invigorated" };
	self.totemframes = { "earth", "fire", "water", "air" }
	
	-- Make all frames movable
	for _, frame in ipairs(self.allframes) do
		self:MakeMoveable(frame);
	end
		
	-- Set fancy border colors
	self.earth.borderColor = { ["r"] = (139/255), ["g"] = (69/255), ["b"] = (19/255), ["a"] = 1, }
	self.fire.borderColor = { ["r"] = (178/255), ["g"] = (34/255), ["b"] = (34/255), ["a"] = 1, }
	self.water.borderColor = { ["r"] = (0/255), ["g"] = (245/255), ["b"] = (255/255), ["a"] = 1, }
	self.air.borderColor = { ["r"] = (127/255), ["g"] = (255/255), ["b"] = (212/255), ["a"] = 1, }
	self.windfury.borderColor = { ["r"] = (127/255), ["g"] = (255/255), ["b"] = (212/255), ["a"] = 1, }
	self.reincarnation.borderColor = { ["r"] = (139/255), ["g"] = (69/255), ["b"] = (19/255), ["a"] = 1, }
	self.invigorated.borderColor = { ["r"] = (0/255), ["g"] = (245/255), ["b"] = (255/255), ["a"] = 1, }
	
	self:ShowRunningModules();
	
	self:DefaultPos();
	self:LoadPos();
	self:ToggleLock();
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