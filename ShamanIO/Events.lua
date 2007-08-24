function Enhancer:EnterCombat()
	self.inCombat = true;
	
	self:UpdateAlphaBegin(self.allframes);
end

function Enhancer:OutOfCombat()
	self.inCombat = nil;
	
	self:UpdateAlphaBegin(self.allframes);
end

function Enhancer:PlayerDead()
	for _, frame in ipairs(self.totemframes) do
		self:FrameDeathPreBegin(frame)
	end
end

function Enhancer:CastingTotem(unit, totem, rank)
	-- Gets called for all spellcasting so just check if it was a totem :)
	if (unit ~= "player") then return; end
	
	if (totem == Enhancer.BS["Totemic Call"]) then
		for _, frame in ipairs(self.totemframes) do
			self:FrameDeathPreBegin(frame);
		end
	elseif Enhancer.Totems[totem] then
		
		--[[ Figure out what rank was cast ]]--
		local ranknumber = nil;
		if (rank == "") then rank = nil; end
		if rank then
			ranknumber = tonumber(string.sub(rank, string.find(rank, "%d")));
		end
		rank = ranknumber;
		
		if (totem == Enhancer.BS["Mana Spring Totem"] and not ranknumber) then
			totem = Enhancer.BS["Enamored Water Spirit"];
		end
		
		self:CreateTotem(totem, rank);
	end
end