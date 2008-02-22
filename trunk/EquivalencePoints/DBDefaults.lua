local AddOn = LibStub("AceAddon-3.0"):GetAddon("EquivalencePoints", true);
if (not AddOn) then return; end
local L = LibStub("AceLocale-3.0"):GetLocale("EquivalencePoints", true)

-- Create special table so it looks pretty in Ace3 Config :)
-- http://lua-users.org/wiki/OrderedTableSimple
function AddOn:OPairTable(tbl)
	local mt = {}
   -- set methods
   mt.__index = {
      -- set key order table inside __index for faster lookup
      _korder = {},
      -- traversal of hidden values
      hidden = function() return pairs( mt.__index ) end,
      -- traversal of table ordered: returning index, key
      ipairs = function( self ) return ipairs( self._korder ) end,
      -- traversal of table
      pairs = function( self ) return pairs( self ) end,
      -- traversal of table ordered: returning key,value
      opairs = function( self )
         local i = 0
         local function iter( self )
            i = i + 1
            local k = self._korder[i]
            if k then
               return k,self[k]
            end
         end
         return iter,self
      end,
      -- to be able to delete entries we must write a delete function
      del = function( self,key )
         if self[key] then
            self[key] = nil
            for i,k in ipairs( self._korder ) do
               if k == key then
                  table.remove( self._korder, i )
                  return
               end
            end
         end
      end,
   }
   -- set new index handling
   mt.__newindex = function( self,k,v )
      if k ~= "del" and v then
         rawset( self,k,v )
         table.insert( self._korder, k )
      end      
   end
   return setmetatable(tbl or {}, mt);
end

local EPValues = AddOn:OPairTable(); -- Make this a muppet table with opairs so we can make sure we get values the exact same order (like an ipairs but for "hash-tables")
EPValues["EMPTY_SOCKET_META"] = 0; -- Meta gem Bonus

EPValues["STR"] = 0;
EPValues["AGI"] = 0;
EPValues["STA"] = 0;
EPValues["INT"] = 0;
EPValues["SPI"] = 0;

EPValues["ATTACKPOWER"] = 0;
EPValues["CR_HIT"] = 0;
EPValues["CR_CRIT"] = 0;
EPValues["CR_HASTE"] = 0;

EPValues["RANGEDATTACKPOWER"] = 0;
--EPValues["CR_RANGEDHIT"] = 0;
EPValues["RANGEDCRIT"] = 0;
--EPValues["CR_RANGEDHASTE"] = 0;
--CR_RANGEDCRIT

EPValues["CR_EXPERTISE"] = 0;
EPValues["IGNOREARMOR"] = 0;

EPValues["THREATREDUCTION"] = 0;

EPValues["DMG"] = 0;
EPValues["ARCANEDMG"] = 0;
EPValues["FIREDMG"] = 0;
EPValues["FROSTDMG"] = 0;
EPValues["HOLYDMG"] = 0;
EPValues["NATUREDMG"] = 0;
EPValues["SHADOWDMG"] = 0;
EPValues["SPELLPEN"] = 0;
EPValues["HEAL"] = 0;
EPValues["MANAREG"] = 0;
EPValues["CR_SPELLHIT"] = 0;
EPValues["CR_SPELLCRIT"] = 0;
EPValues["HOLYCRIT"] = 0;
EPValues["CR_SPELLHASTE"] = 0;
EPValues["CR_RESILIENCE"] = 0;

EPValues["ARMOR"] = 0;
EPValues["DEFENSE"] = 0;
EPValues["CR_DEFENSE"] = 0;
EPValues["CR_DODGE"] = 0;
EPValues["CR_PARRY"] = 0;
EPValues["CR_BLOCK"] = 0;
EPValues["BLOCKVALUE"] = 0;
EPValues["HEALTHREG"] = 0;
-- MH_DPS = 9.03,
-- OH_DPS = 3.7,

function AddOn:DefaultValues()
	-- use 'for key, value in EPValues:opairs() do' to get items in the order they where/are inserted
	return EPValues;
end

local defaults = {
	profile = {
		Values = EPValues,
		ValueSet = {},
		HiddenSet = {},
		HackExpertise = true,
		ShowZero = true,
		ShowNoBonuses = false,
		MatchRarity = true,
		MaxRarity = 4,
		MaxAvailRarity = 3,
		Consumables = true,
		ProcsAndUse = true,
		ListGems = true,
		ListSetGems = false,
		ClassSpecifics = true,
		ClassSpecificsColor = true,
		RaceSpecifics = true,
		EmptyLineAbove = true,
		EmptyLineBelow = false,
		ReceiveValues = false,
		-- I'm forgetting a setting I've been thinking of countless times so this is a reminder
		Color = {
			r = (127 / 255),
			g = (255 / 255),
			b = (212 / 255),
			a = 1,
		},
		Presets = {
			[L["_preset Shaman (Enhance Low-Level)"]] = {
				ATTACKPOWER = 1,
				STR = 2,
				AGI = 1.74,
				CR_CRIT = 1.97,
				CR_HIT = 1.34,
				CR_HASTE = 1.28,
				IGNOREARMOR = 0.22,
				
				CR_EXPERTISE = 2.48,  -- Multiply hit rating AEP by 1.8 if you assume that the mob will never cast and never parry.
				
				--MH_DPS = 9.03,
				--OH_DPS = 3.7,
			},
			
			[L["_preset Shaman (Enhance Medium-Level)"]] = {
				ATTACKPOWER = 1,
				STR = 2,
				AGI = 1.8,
				CR_CRIT = 2,
				CR_HIT = 1.4,
				CR_HASTE = 1.48,
				IGNOREARMOR = 0.28,
				
				CR_EXPERTISE = 2.52,  -- Multiply hit rating AEP by 1.8 if you assume that the mob will never cast and never parry.
				
				--MH_DPS = 9.03,
				--OH_DPS = 3.7,
			},
			
			[L["_preset Shaman (Enhance High-Level)"]] = {
				ATTACKPOWER = 1,
				STR = 2,
				AGI = 2,
				CR_CRIT = 2,
				CR_HIT = 1.9,
				CR_HASTE = 2,
				IGNOREARMOR = 0.37,
				
				CR_EXPERTISE = 3.42,  -- Multiply hit rating AEP by 1.8 if you assume that the mob will never cast and never parry.
				
				--MH_DPS = 9.03,
				--OH_DPS = 3.7,
			},
			
			[L["_preset Shaman (Restoration Medium-Level)"]] = {
				--Mid-Level Shaman (Tier 5) 
				STA = 0.30,
				INT = 0.75,
				SPI = 0.1,
				HEAL = 1.1,
				CR_SPELLCRIT = 0.5,
				MANAREG = 3.75,
				CR_SPELLHASTE = 0.75,
				--Meta = 74.625 (based on [Insightful Earthstorm Diamond] proc equalling 17.5 mp5)
			},
			
			[L["_preset Shaman (Restoration High-Level)"]] = {
				--High-Level Shaman (Tier 6)
				STA = 0.30,
				INT = 0.55,
				SPI = 0.1,
				HEAL = 1.3,
				CR_SPELLCRIT = 0.5,
				MANAREG = 3,
				CR_SPELLHASTE = 2,
				--Meta = 59.1 (based on [Insightful Earthstorm Diamond] proc equalling 17.5 mp5)
			},
			
			-- spell hit rating (to cap) > spell haste rating > spell damage > spell crit rating > spell penetration
			[L["_preset Mage (Frost)"]] = {
				DMG = 1, FROSTDMG = 0.9, -- Considering respeccs etc I don't value this as high as I prefer normal spell damage
				INT = 0.3, SPI = 00.1, MANAREG = 1,
				CR_SPELLHIT = 0.8, CR_SPELLCRIT = 0.7, CR_SPELLHASTE = 1.2, SPELLPEN = 0.8,
			},
			
			[L["_preset Mage (Fire)"]] = {
				DMG = 1, FIREDMG = 0.9, -- Considering respeccs etc I don't value this as high as I prefer normal spell damage
				INT = 0.3, SPI = 00.1, MANAREG = 1,
				CR_SPELLHIT = 0.8, CR_SPELLCRIT = 0.7, CR_SPELLHASTE = 1.2, SPELLPEN = 0.8,
			},
			
			-- Lootrank templates:
			[L["_preset Rogue"]] = {
					ATTACKPOWER = 0.5, IGNOREARMOR = 0.15, CR_HIT = 1.15, CR_HASTE = 1, STR = 0.55, CR_EXPERTISE = 1.25, AGI = 1.1, CR_CRIT = 0.9,
			},
			
			[L["_preset Priest (Holy)"]] = {
				MANAREG = 2.4, CR_SPELLHASTE = 0.5, INT = 0.6, HEAL = 1, STA = 0.2, SPI = 0.8,
			},
			
			[L["_preset Warlock (Affliction)"]] = {
				CR_SPELLHIT = 1.5, SHADOWDMG = 2.2, CR_SPELLHASTE = 0.5, INT = 0.2, STA = 1, CR_SPELLCRIT = 1, DMG = 2.5,
			},
			
			[L["_preset Paladin (Protection)"]] = {
				CR_SPELLHIT = 1, CR_DODGE = 7.5, INT = 2, CR_BLOCK = 5, CR_DEFENSE = 8, STA = 7.8, CR_EXPERTISE = 4, ARMOR = 0.6, BLOCKVALUE = 2, AGI = 6.5, DMG = 2, CR_PARRY = 7,
			},
			
			[L["_preset Druid (Restoration)"]] = {
				MANAREG = 2.4, INT = 0.6, HEAL = 1, STA = 0.4, SPI = 0.8,
			},
			
			[L["_preset Warlock (Destruction)"]] = {
				CR_SPELLHIT = 1.5, SHADOWDMG = 2.2, CR_SPELLHASTE = 1.5, INT = 0.2, STA = 1, CR_SPELLCRIT = 2, DMG = 2.5,
			},
			
			[L["_preset Warrior (Protection)"]] = {
				CR_HIT = 3, STA = 7.8, CR_BLOCK = 0.6, CR_DODGE = 7.5, CR_EXPERTISE = 6, ARMOR = 0.6, BLOCKVALUE = 4.5, AGI = 6.5, CR_DEFENSE = 8, CR_PARRY = 7, STR = 2,
			},
			
			[L["_preset Warrior (DPS)"]] = {
				STR = 1.6, STA = 0.3, AGI = 1.5, CR_EXPERTISE = 1.5, CR_CRIT = 2, CR_HIT = 1.5, ATTACKPOWER = 0.7, IGNOREARMOR = 0.2, CR_HASTE = 2.8,
			},
			
			[L["_preset Hunter (Beast Mastery)"]] = {
				MANAREG = 1.6, CR_HASTE = 0.2, INT = 0.7, RANGEDCRIT = 0.8, AGI = 1, RANGEDATTACKPOWER = 0.5, CR_HIT = 1.1, IGNOREARMOR = 0.05,
			},
		},
	},
};

function AddOn:RegisterDB()
	self.db = LibStub("AceDB-3.0"):New("EquivalencePointsDB", defaults);
end