local L = AceLibrary("AceLocale-2.2"):new("Enhancer")

function Enhancer:EnterCombat()
	self.inCombat = true;
	
	self:UpdateAlphaBegin(Enhancer.aFrames);
end

function Enhancer:OutOfCombat()
	self.inCombat = nil;
	
	self:UpdateAlphaBegin(Enhancer.aFrames);
end

function Enhancer:PlayerDead()
	for _, frame in ipairs(Enhancer.dFrames) do
		self:FrameDeathPreBegin(frame)
	end
end

function Enhancer:CastingTotem(unit, totem, rank)
	-- Gets called for all spellcasting so just check if it was a totem :)
	if (unit ~= "player") then return; end
	if (rank == "") then rank = L[0]; end
	
	if (totem == Enhancer.BS["Totemic Call"]) then
		for _, frame in ipairs(Enhancer.tFrames) do
			self:FrameDeathPreBegin(frame);
		end
	elseif Enhancer.Totems[totem] then
		if (totem == Enhancer.BS["Mana Spring Totem"] and L:GetReverseTranslation(rank) == "0") then
			totem = Enhancer.BS["Enamored Water Spirit"];
		end
		
		self:CreateTotem(totem, L:GetReverseTranslation(rank));
	end
end

function Enhancer:Ding()
	self.PlayerLevel = arg1;
end

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

function Enhancer:SomethingDied(info)
	-- Fired when a friendly player dies - arg1 - chat message (format: "%s dies")
	if (self.debug) then
		self:Print(info); -- Stoneclaw Totem VII is destroyed
											-- You die
	end
end