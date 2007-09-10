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
	
	local totemX, totemY, totemZone;
	if (Cartographer and self.coords) then
		totemX, totemY, totemZone = Cartographer:GetCurrentPlayerPosition();
	end
	
	if (totem == Enhancer.BS["Totemic Call"]) then
		for _, frame in ipairs(Enhancer.tFrames) do
			self:FrameDeathPreBegin(frame);
		end
	elseif Enhancer.Totems[totem] then
		if (totem == Enhancer.BS["Mana Spring Totem"] and L:GetReverseTranslation(rank) == "0") then
			totem = Enhancer.BS["Enamored Water Spirit"];
		end
		
		self:CreateTotem(totem, L:GetReverseTranslation(rank), totemX, totemY, totemZone);
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

function Enhancer:TotemWasDestroyed(info)
	-- Fired when a totem dies naturally if our timer is badly synced or w/e then this is what we want
	-- Might want to use this to end a totem rather then the timer?
	local what = self.deformat(info, UNITDESTROYEDOTHER);
	if (what and self.combatLog[what]) then
		
		local framename = self.combatLog[what];
		local message = string.format(L["TotemDeath"], self[framename].name, self[framename].element);
		self:ScreenMessage(message, 1, (1/2), 0);
		self:FrameDeathPreBegin(framename);
	end
end

function Enhancer:Zoning()
	local inInstance, instanceType = IsInInstance();
	if (self.currentInstanceType ~= instanceType) then
		-- Player zoned in our out of an instance
		self.currentInstanceType = instanceType;
		
		if (instanceType == "none" or instanceType == "pvp") then
			self.coords = true;
		else
			self.coords = nil;
		end
		
		for _, framename in ipairs(Enhancer.tFrames) do
			self:FrameDeathPreBegin(framename)
		end
	end
	--[[
		"none" when outside an instance
		"pvp" when in a battleground
		"arena" when in an arena
		"party" when in a 5-man instance
		"raid" when in a raid instance
	]]--
end