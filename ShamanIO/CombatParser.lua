local L = AceLibrary("AceLocale-2.2"):new("Enhancer")

function Enhancer:ParserDamage(info)
	-- if (info.sourceID == "player") then self:WFTest(info); end
	
	if ( (info.abilityName == Enhancer.BS["Windfury"] or info.abilityName == Enhancer.BS["Windfury Attack"]) and info.sourceID == "player" ) then
		self:WindfuryHit();
	end
	
	if (self.PrintCrappyMessages and string.find(info.recipientName, "Totem")) then
		if (ChatFrame4) then
			ChatFrame4:AddMessage(info.recipientName);
		end
	end
	
	if (not self.combatLog[info.recipientName]) then return; end
	
	local frame = self.combatLog[info.recipientName];
	self[frame].hitPoints = self[frame].hitPoints - info.amount;
	
	if (self[frame].hitPoints <= 0) then
		local message = string.format(L["TotemSlain"], self[frame].name, self[frame].element);
		self:ScreenMessage(message, 1, 0, 0);
		
		self:FrameDeathPreBegin(frame)
	end
end

function Enhancer:ParserMiss(info)
	-- if (info.sourceID == "player") then self:WFTest(info); end
end