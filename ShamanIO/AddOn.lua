ShamanIO = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0");
ShamanIO:RegisterDB("ShamanIODB");

local L = AceLibrary("AceLocale-2.2"):new("ShamanIO");
local deformat = AceLibrary("Deformat-2.0");
local db = ShamanIO.db.profile;
local _, englishClass = UnitClass("player");

function ShamanIO:OnInitialize()
	if (englishClass ~= "SHAMAN") then return; end
	
	-- Create 6 frames!
	self.earth = self:CreateButton("ShamanIOEarth", "Spell_Totem_WardOfDraining");
	self.fire = self:CreateButton("ShamanIOFire", "Spell_Totem_WardOfDraining");
	self.water = self:CreateButton("ShamanIOWater", "Spell_Totem_WardOfDraining");
	self.air = self:CreateButton("ShamanIOAir", "Spell_Totem_WardOfDraining");
	self.windfury = self:CreateButton("ShamanIOWindfury", "Spell_Nature_Cyclone");
	self.reincarnation = self:CreateButton("ShamanIOReincarnation", "Spell_Nature_Reincarnation");
	
	self:MakeMoveable(self.earth.anchor);
	self:MakeMoveable(self.fire.anchor);
	self:MakeMoveable(self.water.anchor);
	self:MakeMoveable(self.air.anchor);
	self:MakeMoveable(self.windfury.anchor);
	self:MakeMoveable(self.reincarnation.anchor);
		
	-- Set Border Colors
	self.earth.borderColor = { ["r"] = (139/255), ["g"] = (69/255), ["b"] = (19/255), ["a"] = 1, }
	self.fire.borderColor = { ["r"] = (178/255), ["g"] = (34/255), ["b"] = (34/255), ["a"] = 1, }
	self.water.borderColor = { ["r"] = (0/255), ["g"] = (245/255), ["b"] = (255/255), ["a"] = 1, }
	self.air.borderColor = { ["r"] = (127/255), ["g"] = (255/255), ["b"] = (212/255), ["a"] = 1, }
	self.windfury.borderColor = { ["r"] = (127/255), ["g"] = (255/255), ["b"] = (212/255), ["a"] = 1, }
	self.reincarnation.borderColor = { ["r"] = (139/255), ["g"] = (69/255), ["b"] = (19/255), ["a"] = 1, }
	
	self.allframes = { "earth", "fire", "water", "air", "windfury", "reincarnation" };
	self.totemframes = { "earth", "fire", "water", "air" }
	
	self:ShowRunningModules();
	
	self:LoadPos()
	--self:DefaultPos()
end

function ShamanIO:OnEnable()
	if (englishClass ~= "SHAMAN") then return; end
	
	-- Register our events :>
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "OutOfCombat");
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "EnterCombat");
	self:RegisterEvent("PLAYER_DEAD", "PlayerDead");
	
	-- Check if the player casts a totem :)
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "CastingTotem")
end

function ShamanIO:OnDisable()
	if (englishClass ~= "SHAMAN") then return; end
	
	self:UnregisterAllEvents();
end