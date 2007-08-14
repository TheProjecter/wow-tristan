function Enhancer:ShowRunningModules()
	
	for _, frame in ipairs(self.totemframes) do
		Enhancer:ShowFrame(frame);
	end
	
	-- windfury, reincarnation and invigorated is enabled/disabled in their separate files
end

function Enhancer:CreateTotem(totem, rank)
	-- Pickup the data we need:
	
	local Icon = Enhancer.Totems[totem].Icon;
	local TimeToLive = Enhancer.Totems[totem].Time;
	local Element = Enhancer.Totems[totem].Element;
	local HitPoints = Enhancer.Totems[totem].Life;
	local Pulse = Enhancer.Totems[totem].Pulse;
	
	local frame = string.lower(Element);
	
	self.combatLog[totem] = frame;
	if (Enhancer.Totems[totem].CombatLog) then
		for _, logName in ipairs(Enhancer.Totems[totem].CombatLog) do
			self.combatLog[logName] = frame;
		end
	end
	
	self[frame].name = totem;
	self[frame].element = Element;
	self[frame].active = true;
	self[frame].hitPoints = HitPoints;
	self[frame].death = GetTime() + TimeToLive;
	if (TimeToLive > 7) then
		self[frame].warn = GetTime() + TimeToLive - 7;
	else
		self[frame].warn = nil;
	end
	self[frame].pulseAdd = Pulse;
	if (Pulse) then
		self[frame].pulse = GetTime() + self[frame].pulseAdd;
	else
		self[frame].pulse = nil
	end
	
	self[frame].lived = 0;
	self:ChangeIcon(frame, Icon);
	self[frame].mainframe:SetBackdropBorderColor(self[frame].borderColor["r"] or 1, self[frame].borderColor["g"] or 1, self[frame].borderColor["b"] or 1, 0);
	self:UpdateAlphaBegin(frame)
	
	self[frame].textcenter:SetText(Pulse);
	self[frame].textbelow:SetText( Enhancer:FormatTime(self[frame].death - GetTime()) );
	if ( not (self:IsEventScheduled(frame)) ) then
		self:ScheduleRepeatingEvent(frame, self.UpdateFrame, (1 / 2), self, frame)
	end
end

function Enhancer:ScreenMessage(message, r, g, b, a, h)
	UIErrorsFrame:AddMessage(message, r or 1, g or 1, b or 1, a or 1, h or 3);
end

function Enhancer:ToggleLock()
	for _, frame in ipairs(self.allframes) do
		if (self.db.profile.locked) then
			self[frame].anchor:Hide();
			self[frame].unlocked = nil;
		else
			if (self[frame].mainframe:IsVisible()) then
				self[frame].anchor:Show();
				self[frame].unlocked = true;
			end
		end
	end
	
	self:UpdateAlphaBegin(self.allframes);
end

function Enhancer:Resize()
	for _, frame in ipairs(self.allframes) do
		self[frame].mainframe:SetWidth(Enhancer.db.profile.framesize);
		self[frame].mainframe:SetHeight(Enhancer.db.profile.framesize);
		
		self[frame].cooldown:SetWidth(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / 3));
		self[frame].cooldown:SetHeight(Enhancer.db.profile.framesize - (Enhancer.db.profile.framesize / 3));
		
		self[frame].textbelow:SetWidth(Enhancer.db.profile.framesize);
		
		self[frame].textcenter:SetHeight(Enhancer.db.profile.framesize);
		self[frame].textcenter:SetWidth(Enhancer.db.profile.framesize);
	end
	
	self:UpdateFont();
end

function Enhancer:UpdateFont()
	Enhancer.db.profile.centerFontSize = (Enhancer.db.profile.framesize / 3);
	Enhancer.db.profile.centerFont = CreateFont("EnhancerCenterFont");
	Enhancer.db.profile.centerFont:SetFont(Enhancer.db.profile.centerFontName, Enhancer.db.profile.centerFontSize, Enhancer.db.profile.centerFontFlags);
	
	Enhancer.db.profile.belowFontSize = (Enhancer.db.profile.framesize / 4);
	Enhancer.db.profile.belowFont = CreateFont("EnhancerBelowFont");
	Enhancer.db.profile.belowFont:SetFont(Enhancer.db.profile.belowFontName, Enhancer.db.profile.belowFontSize, Enhancer.db.profile.belowFontFlags);
	
	for _, frame in ipairs(self.allframes) do
		self[frame].textbelow:SetHeight(Enhancer.db.profile.belowFontSize + 10);
	end
end

function Enhancer:FormatTime(seconds)
	seconds = floor(seconds);
	secs = mod(seconds, 60);
	mins = (seconds - secs) / 60;
	return mins..":"..string.sub("00"..secs, -2);
end