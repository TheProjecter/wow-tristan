local L = AceLibrary("AceLocale-2.2"):new("Enhancer")

function Enhancer:ParserDamage(info)
	if (info.sourceID == "player") then self:WFTest(info); end
	
	if ( (info.abilityName == Enhancer.BS["Windfury"] or info.abilityName == Enhancer.BS["Windfury Attack"]) and info.sourceID == "player" ) then
		self:WindfuryHit();
	end
	
	if (not self.combatLog[info.recipientName]) then return; end
	
	Enhancer:Debug(info.recipientName .. " - " .. info.amount)
	
	local frame = self.combatLog[info.recipientName];
	self[frame].hitPoints = self[frame].hitPoints - info.amount;
	
	if (self[frame].hitPoints <= 0) then
		local message = string.format(L["TotemSlain"], self[frame].name, self[frame].element);
		self:ScreenMessage(message, 1, 0, 0);
		
		self:FrameDeathPreBegin(frame)
	end
end

function Enhancer:ParserMiss(info)
	if (info.sourceID == "player") then self:WFTest(info); end
end

local totDmg = 0;
local wfProcs = 0;
function Enhancer:WFTest(info)
	-- if (info.Miss = "Miss") then
	do return; end
	--[[
				This part should be in it's own "module" and get called from here when loaded if it should be included at all ;)
				
				Basically it needs to:
					1) Check for mob death -- might die after first WF Proc
					2) Possibly other things aswell
				
	]]--
	
	if ( (not info.abilityName) or (info.abilityName == Enhancer.BS["Stormstrike"]) ) then
		totDmg = info.amount or 0;
		wfProcs = 0;
	end
	
	if (info.abilityName == Enhancer.BS["Windfury"] or info.abilityName == Enhancer.BS["Windfury Attack"]) then
		totDmg = totDmg + info.amount or 0;
		wfProcs = wfProcs + 1;
	end
	
	if (wfProcs == 2) then
		Enhancer:Debug("Windfury Total: " .. totDmg);
		totDmg = 0;
		wfProcs = 0;
	end
end