local L = AceLibrary("AceLocale-2.2"):new("Enhancer")

--[[ HEALS? ]]--

function Enhancer:ParserDamage(info)
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