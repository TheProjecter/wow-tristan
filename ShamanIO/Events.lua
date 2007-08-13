function Enhancer:EnterCombat()
	self.inCombat = true;
	
	self:UpdateAlphaBegin(self.allframes);
end

function Enhancer:OutOfCombat()
	self.inCombat = nil;
	
	self:UpdateAlphaBegin(self.allframes);
end

function Enhancer:PlayerDead()
	for _, element in ipairs(self.totemframes) do
		self:FrameDeathBegin(frame)
	end
end

function Enhancer:CastingTotem(player, totem, rank)
	-- Gets called for all spellcasting so just check if it was a totem :)
	
	if (totem == Enhancer.BabbleSpell["Totemic Call"]) then
		for _, frame in ipairs(self.totemframes) do
			self:FrameDeathBegin(frame);
		end
	elseif Enhancer.Totems[totem] then
		
		--[[ Figure out what rank he cast ]]--
		local ranknumber;
		if (rank == "") then rank = nil; end
		
		if rank then
			ranknumber = tonumber(string.sub(rank, string.find(rank, "%d")));
		end
		
		if (totem == Enhancer.BabbleSpell["Mana Spring Totem"] and not ranknumber) then
			totem = Enhancer.BabbleSpell["Enamored Water Spirit"];
		end
		
		self:CreateTotem(totem, rank);
	end
end