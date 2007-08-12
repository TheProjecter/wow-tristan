function ShamanIO:EnterCombat()
	self.inCombat = true;
end

function ShamanIO:OutOfCombat()
	self.inCombat = nil;
end

function ShamanIO:PlayerDead()
	for _, element in pairs( self.totems ) do
		self[element].active = false;
	end
	
	ShamanIO:UpdateAlphaBegin( self.totems )
end

function ShamanIO:CastingTotem(player, totem, rank)
	-- Gets called for all spellcasting so just check if it was a totem :)
	
	if (totem == ShamanIO.BabbleSpell["Totemic Call"]) then
		for _, frame in pairs(self.totemframes) do
			self:FrameDeathBegin(frame);
		end
	elseif ShamanIO.Totems[totem] then
		
		--[[ Figure out what rank he cast ]]--
		local ranknumber;
		if (rank == "") then rank = nil; end
		
		if rank then
			ranknumber = tonumber(string.sub(rank, string.find(rank, "%d")));
		end
		
		if (totem == ShamanIO.BabbleSpell["Mana Spring Totem"] and not ranknumber) then
			totem = ShamanIO.BabbleSpell["Enamored Water Spirit"];
		end
		
		self:CreateTotem(totem, rank);
	end
end