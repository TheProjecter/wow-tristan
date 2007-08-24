Enhancer.BS = AceLibrary("Babble-Spell-2.2");
local Parser = AceLibrary:HasInstance("Parser-3.0")

function Enhancer:Setup()
	-- Create all frames!
	self.earth = self:CreateButton("EnhancerFrameEarth", "Spell_Totem_WardOfDraining");
	self.fire = self:CreateButton("EnhancerFrameFire", "Spell_Totem_WardOfDraining");
	self.water = self:CreateButton("EnhancerFrameWater", "Spell_Totem_WardOfDraining");
	self.air = self:CreateButton("EnhancerFrameAir", "Spell_Totem_WardOfDraining");
	self.windfury = self:CreateButton("EnhancerFrameWindfury", "Spell_Nature_Cyclone");
	self.reincarnation = self:CreateButton("EnhancerFrameReincarnation", "Spell_Nature_Reincarnation");
	self.invigorated = self:CreateButton("EnhancerFrameInvigorated", "Spell_Nature_NatureResistanceTotem");
	
	self.allframes = { "earth", "fire", "water", "air", "windfury", "reincarnation", "invigorated" };
	self.totemframes = { "earth", "fire", "water", "air" };
	self.combatLog = {};
	
	-- Make all frames movable
	for _, frame in ipairs(self.allframes) do
		self:MakeMoveable(frame);
	end
		
	-- Set some fancy border colors
	self.earth.borderColor = { ["r"] = (139/255), ["g"] = (69/255), ["b"] = (19/255), ["a"] = 1, }
	self.fire.borderColor = { ["r"] = (178/255), ["g"] = (34/255), ["b"] = (34/255), ["a"] = 1, }
	self.water.borderColor = { ["r"] = (0/255), ["g"] = (245/255), ["b"] = (255/255), ["a"] = 1, }
	self.air.borderColor = { ["r"] = (127/255), ["g"] = (255/255), ["b"] = (212/255), ["a"] = 1, }
	self.windfury.borderColor = { ["r"] = (127/255), ["g"] = (255/255), ["b"] = (212/255), ["a"] = 1, }
	self.reincarnation.borderColor = { ["r"] = (139/255), ["g"] = (69/255), ["b"] = (19/255), ["a"] = 1, }
	self.invigorated.borderColor = { ["r"] = (0/255), ["g"] = (245/255), ["b"] = (255/255), ["a"] = 1, }
	
	self:RegisterParserEvent({
		eventType = 'Damage',
	}, "ParserDamage");
	self:RegisterParserEvent({
		eventType = 'Miss',
		sourceID = "player",
	}, "ParserMiss");
	
	self:DefaultPos();
	self:LoadPos();
	self:ToggleLock();
end

--[[

Left to do:

	Windfury calculation and display! (FontString midscreen that grows on crit?)
]]--