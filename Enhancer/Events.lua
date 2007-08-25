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

local LRank = AceLibrary("AceLocale-2.2"):new("EnhancerRank")
function Enhancer:CastingTotem(unit, totem, rank)
	-- Gets called for all spellcasting so just check if it was a totem :)
	if (unit ~= "player") then return; end
	
	if (totem == Enhancer.BS["Totemic Call"]) then
		for _, frame in ipairs(Enhancer.tFrames) do
			self:FrameDeathPreBegin(frame);
		end
	elseif Enhancer.Totems[totem] then
		if (totem == Enhancer.BS["Mana Spring Totem"] and LRank[rank] == 0) then
			totem = Enhancer.BS["Enamored Water Spirit"];
		end
		
		self:CreateTotem(totem, LRank[rank]);
	end
end

function Enhancer:Ding()
	self.PlayerLevel = arg1;
end