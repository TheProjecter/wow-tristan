function ShamanIO:ShowRunningModules()
	self.earth.mainframe:Show();
	self.fire.mainframe:Show();
	self.water.mainframe:Show();
	self.air.mainframe:Show();
	
	-- windfury and reincarnation is enabled/disabled in their separate files
end

function ShamanIO:CreateTotem(totem, rank)
	-- Pickup the data we need:
	
	local Icon = ShamanIO.Totems[totem].Icon;
	local TimeToLive = ShamanIO.Totems[totem].Time;
	local Element = ShamanIO.Totems[totem].Element;
	local HitPoints = ShamanIO.Totems[totem].Life;
	local Pulse = ShamanIO.Totems[totem].Pulse;
	
	local frame = string.lower(Element);
	
	self[frame].name = totem;
	self[frame].element = Element;
	self[frame].active = true;
	self[frame].hitPoints = HitPoints;
	self[frame].death = GetTime() + TimeToLive;
	if (TimeToLive > 7) then
		self[frame].warn = GetTime() + TimeToLive - 7;
	end
	if (Pulse) then
		self[frame].pulseAdd = Pulse;
		self[frame].pulse = GetTime() + self[frame].pulseAdd;
	end
	self[frame].lived = 0;
	self:ChangeIcon(frame, Icon);
	self[frame].mainframe:SetBackdropBorderColor(self[frame].borderColor["r"] or 1, self[frame].borderColor["g"] or 1, self[frame].borderColor["b"] or 1, 0);
	self:UpdateAlphaBegin(frame)
	
	self[frame].textcenter:SetText(Pulse);
	self[frame].textbelow:SetText( ShamanIO:FormatTime(self[frame].death - GetTime()) );
	if ( not (self:IsEventScheduled(frame)) ) then
		self:ScheduleRepeatingEvent(frame, self.UpdateFrame, (1 / 2), self, frame)
	end
end

function ShamanIO:ScreenMessage(message, r, g, b, a, h)
	UIErrorsFrame:AddMessage(message, r or 1, g or 1, b or 1, a or 1, h or 3);
end

function ShamanIO:FormatTime(seconds)
	seconds = floor(seconds);
	secs = mod(seconds, 60);
	mins = (seconds - secs) / 60;
	return mins..":"..string.sub("00"..secs, -2);
end