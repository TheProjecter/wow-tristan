local L = AceLibrary("AceLocale-2.2"):new("RaidAgent")

local strengths = { }
strengths.DRUID =   { DPS = 2, AoE = 2, Heal = 3, Tank = 3, CC = 0, Pull = 3, Buff = 4, Debuff = 1, MA = 1 }
strengths.HUNTER =  { DPS = 3, AoE = 2, Heal = 0, Tank = 1, CC = 3, Pull = 4, Buff = 1, Debuff = 1, MA = 4 }
strengths.MAGE =    { DPS = 4, AoE = 4, Heal = 0, Tank = 0, CC = 3, Pull = 1, Buff = 2, Debuff = 0, MA = 3 }
strengths.PALADIN = { DPS = 1, AoE = 1, Heal = 2, Tank = 3, CC = 1, Pull = 0, Buff = 4, Debuff = 1, MA = 3 }
strengths.PRIEST =  { DPS = 1, AoE = 0, Heal = 4, Tank = 0, CC = 2, Pull = 1, Buff = 3, Debuff = 2, MA = 0 }
strengths.ROGUE =   { DPS = 4, AoE = 0, Heal = 0, Tank = 1, CC = 2, Pull = 4, Buff = 0, Debuff = 2, MA = 4 }
strengths.SHAMAN =  { DPS = 2, AoE = 1, Heal = 2, Tank = 2, CC = 1, Pull = 1, Buff = 2, Debuff = 2, MA = 1 }
strengths.WARLOCK = { DPS = 3, AoE = 3, Heal = 0, Tank = 1, CC = 3, Pull = 3, Buff = 1, Debuff = 3, MA = 2 }
strengths.WARRIOR = { DPS = 3, AoE = 1, Heal = 0, Tank = 4, CC = 1, Pull = 3, Buff = 1, Debuff = 2, MA = 2 }
strengths.EMPTY =   { DPS = 0, AoE = 0, Heal = 0, Tank = 0, CC = 0, Pull = 0, Buff = 0, Debuff = 0, MA = 0 }


function RaidAgent:RaidStrengthValues(localClass)
	return strengths[localClass]
end

--[[

DPS Effectiveness of dealing "Damage per Second"  
AoE Effectiveness at dealing damage to multiple enemies (AoE stands for "Area of Effect")  
Heal Effectiveness of healing  
Tank Effectiveness at holding aggro and soaking up damage.  
CC Ability to control crowds of mobs or enemies  
Pull Effectiveness at pulling  
Buff Effectiveness of buffing others  
Dbf Effectiveness of debuffing enemies. This includes from DoTs and other weakening effects.  
MA Usefulness as the main assist, the one of the group calling the next target for all members  

http://www.wowwiki.com/Class
]]