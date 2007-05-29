local L = AceLibrary("AceLocale-2.2"):new("ShammySpy");
local deformat = AceLibrary("Deformat-2.0");

--[[ Ace Events ----------------------------------------------------------------------]]
function ShammySpy:OnInitialize()
	local _, englishClass = UnitClass("player");
	self.englishClass = englishClass;
	if (self.englishClass == "SHAMAN") then
		self.doPulse = {};
	end
end

function ShammySpy:OnEnable()
	if (self.englishClass == "SHAMAN") then --only register events and create frames for Shamans
		-- Setup the frame
		self:SetupFrames();
		self:UpdateLock();
		
		-- Register the WoW events
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
		self:RegisterEvent("BAG_UPDATE");
		self:RegisterEvent("PLAYER_DEAD");
		-- self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH");
		
		-- Can't use Reincarnation after releasing anyway -- self:RegisterEvent("PLAYER_UNGHOST", "PLAYER_MAY_HAVE_REINCARNATED");
		self:RegisterEvent("PLAYER_ALIVE", "PLAYER_MAY_HAVE_REINCARNATED");
		
		self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "TOTEM_GETTING_POUNDED_ON");
		self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS", "TOTEM_GETTING_POUNDED_ON");
		self:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE", "TOTEM_GETTING_POUNDED_ON");
		self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS", "TOTEM_GETTING_POUNDED_ON");
		
		-- Queue a check in case Reincarnation is on CD
		self:ScheduleEvent("DelayCheckOnEnable", self.ScheduleCheck, 7, self)
	end
end

function ShammySpy:OnDisable()
	self:UnregisterAllEvents();
end

--[[ Functions -----------------------------------------------------------------------]]
function ShammySpy:FormatTime(seconds)
	seconds = floor(seconds);
	secs = mod(seconds, 60);
	mins = (seconds - secs) / 60;
	return mins..":"..string.sub("00"..secs, -2);
end

function ShammySpy:CreateTotemElement(totem, rank)
	if (rank == "") then rank = nil; end
	local element = ShammySpy.Totems[totem].Element;
	self:KillTotemElement(element); -- Just in case
	local frame = getglobal("ShammySpy"..element.."Frame");
	local text = getglobal("ShammySpy"..element.."FrameText1");
	local text2 = getglobal("ShammySpy"..element.."FrameText2");
	
	local TotemTime = ShammySpy.Totems[totem].Time;
	if (not TotemTime) then
		if (ShammySpy.Totems[totem][rank]) then
			TotemTime = ShammySpy.Totems[totem][rank].Time;
		end
	end
	
	local TotemLife = ShammySpy.Totems[totem].Life;
	if (not TotemLife) then
		if (ShammySpy.Totems[totem][rank]) then
			TotemLife = ShammySpy.Totems[totem][rank].Life;
		end
	end
	
	frame.Die = time() + TotemTime;
	frame.Spell = totem;
	frame.Health = TotemLife;
	frame.Warn = time() + TotemTime - 10;
	frame.CombatLog = totem;
	frame.Alive = time();
	frame.Pulse = ShammySpy.Totems[totem].Pulse;
	frame.PulseDec = nil;
	self:RemPulse(element);
	
	if (TotemTime < 11) then frame.Warn = nil; end -- Skip warning on Nova Totem for example
	if (rank) then frame.CombatLog = totem.." "..ShammySpy.Ranks[rank]; end -- Add Roman Numbers for the combatlog parsing
	
	frame:SetBackdrop({
		bgFile = "Interface/Icons/"..ShammySpy.Totems[totem].Icon,
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right =5, top = 5, bottom = 5 }
	});
	frame:SetBackdropColor(1, 1, 1, 1);
	frame:SetBackdropBorderColor(1, 1, 1, 0);
	text:SetText(self:FormatTime(frame.Die - time()));
	frame:SetHeight(35);
	frame:SetWidth(35);
	
	self:UpdateFrames(element)
	if ( not (self:IsEventScheduled("UpdateFrames"..element)) ) then
		self:ScheduleRepeatingEvent("UpdateFrames"..element, self.UpdateFrames, 1, self, element)
	end
	
	if (totem == L["Enamored Water Spirit"]) then
		-- Uncomment lines below when testing with the trinket
		-- frame.Spell = L["Mana Spring Totem"];
		-- frame.CombatLog = L["Mana Spring Totem"];
	end
end

function ShammySpy:KillTotemElement(element)
	local frame = getglobal("ShammySpy"..element.."Frame");
	local text = getglobal("ShammySpy"..element.."FrameText1");
	local text2 = getglobal("ShammySpy"..element.."FrameText2");
	
	if (self:IsEventScheduled("UpdateFrames"..element)) then
		self:CancelScheduledEvent("UpdateFrames"..element)
	end
	
	frame.Warn = nil;
	frame.Die = nil;
	frame.Spell = nil;
	frame.Health = nil;
	frame.CombatLog = nil;
	frame.Alive = nil;
	frame.Pulse = nil;
	frame.PulseDec = nil;
	self:AddPulse(element);
	frame:SetBackdrop({
		bgFile = "Interface/Icons/Spell_Totem_WardOfDraining",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right =5, top = 5, bottom = 5 }
	})
	frame:SetBackdropColor(1, 1, 1, (1/3))
	frame:SetBackdropBorderColor(1, 1, 1, 0);
	text:SetText(L[element])
	text2:SetText("");
	frame:SetHeight(35);
	frame:SetWidth(35);
end

function ShammySpy:CountAnkhs()
	local ankhCount = 0;
	for bagId=0, 4, 1 do
		for slotId=1, GetContainerNumSlots(bagId), 1 do
			local itemLink = GetContainerItemLink(bagId, slotId);
			if (itemLink) then
				local _, _, itemString = string.find(itemLink, "^|c%x+|H(.+)|h%[.+%]");
				if (itemString) then
					local _, _, itemId = string.find(itemString, "^item:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)");
					if (itemId) then
						if ( (itemId == 17030) or (itemId == "17030") ) then
							local _, itemCount = GetContainerItemInfo(bagId, slotId);
							ankhCount = ankhCount + itemCount;
						end
					end
				end
			end
		end
	end
	
	local text = getglobal("ShammySpyReincarnationFrameText2");
	text:SetText(ankhCount)
end

function ShammySpy:InformUser(message, red, green, blue, alpha, holdTime)
	UIErrorsFrame:AddMessage(message, red, green, blue, alpha, holdTime);
	
	if (ShammySpy.db.profile.chatframe) then
		local color = string.format("%02x%02x%02x", red*255, green*255, blue*255);
		self:Print("|cff"..color..message.."|r");
	end
end

function ShammySpy:GetSpellID(spellNameFind)
	local spellCheckID = 1;
	local spellID = nil;
	while true do
		local spellName, spellRank = GetSpellName(spellCheckID, BOOKTYPE_SPELL)
		
		if (spellName == spellNameFind) then spellID = spellCheckID; do break end end
   	if not spellName then do break end end
		
		spellCheckID = spellCheckID + 1
	end
	
	return spellID;
end

function ShammySpy:GetReincarnationID()
	if (not self.reincarnationID) then
		self.reincarnationID = ShammySpy:GetSpellID(L["Reincarnation"])
	else
		local spellName, spellRank = GetSpellName(self.reincarnationID, BOOKTYPE_SPELL)
		if (spellName ~= L["Reincarnation"]) then
			self.reincarnationID = ShammySpy:GetSpellID(L["Reincarnation"])
		end
	end
end

function ShammySpy:ScheduleCheck()
	if ( not (self:IsEventScheduled("UpdateFramesR")) ) then
		self:ScheduleRepeatingEvent("UpdateFramesR", self.UpdateFramesR, 1, self)
	end
end

function ShammySpy:Round(number, digits)
	local multiplier = 10^(digits or 0);
	return floor(number * multiplier + 0.5) / multiplier;
end

function ShammySpy:Debug(...)
	if (self.debugging) then
		self:Print(...);
	end
end

function ShammySpy:AddPulse(element)
	self.doPulse[element] = true;
end

function ShammySpy:RemPulse(element)
	self.doPulse[element] = nil;
end

function ShammySpy:Test()
	--[[ For testing purpose, will fake 4 totem casts ]]
	self:UNIT_SPELLCAST_SUCCEEDED("player", L["Tremor Totem"], L["Rank 1"]);
	self:UNIT_SPELLCAST_SUCCEEDED("player", L["Mana Tide Totem"], L["Rank 1"]);
	self:UNIT_SPELLCAST_SUCCEEDED("player", L["Magma Totem"], L["Rank 1"]);
	self:UNIT_SPELLCAST_SUCCEEDED("player", L["Windfury Totem"], L["Rank 1"]);
end

--[[ Custom events -------------------------------------------------------------------]]
function ShammySpy:UpdateFrames(element)
	self:Debug("UpdateFrames");
	local canStop = true;
	
	local frame = getglobal("ShammySpy"..element.."Frame");
	local text = getglobal("ShammySpy"..element.."FrameText1");
	local text2 = getglobal("ShammySpy"..element.."FrameText2");
	
	if (frame.Warn) then
		if (time() >= frame.Warn) then
			local userInfo = string.format(L["%s (%s) is about to expire..."], frame.Spell, L[element]);
			ShammySpy:InformUser(userInfo, 1, 1, 0, 1, 3);
			
			frame.Warn = nil;
		end
	elseif (frame.Die) then
		if (time() >= frame.Die) then
			local userInfo = string.format(L["%s (%s) has expired."], frame.Spell, L[element]);
			ShammySpy:InformUser(userInfo, 1, (1/2), 0, 1, 3);
			
			self:KillTotemElement(element)
		end
	end
	
	if (frame.Die) then
		text:SetText(self:FormatTime(frame.Die - time()))
		canStop = false;
		
		if (frame.Pulse) then
			local Lived = self:Round(time() - frame.Alive);
			local pulse = frame.Pulse - mod(Lived, frame.Pulse);
			if (pulse == frame.Pulse) then pulse = nil; end
			text2:SetText(pulse);
			
			if (self.db.profile.oldpulse) then
				if (mod(Lived, frame.Pulse) == 0) then
					if (element == "Earth") then
						frame:SetBackdropBorderColor( (139/255), (69/255), (19/255), 1 );
					elseif (element == "Fire") then
						frame:SetBackdropBorderColor( (178/255), (34/255), (34/255), 1 );
					elseif (element == "Water") then
						frame:SetBackdropBorderColor( (0/255), (245/255), (255/255), 1 );
					elseif (element == "Air") then
						frame:SetBackdropBorderColor( (127/255), (255/255), (212/255), 1 );
					end
				else
					frame:SetBackdropBorderColor(1,1,1,0);
				end
			else
				if (not pulse) then
					self:AddPulse(element);
				end
			end
		end
	end
	
	if (canStop and self:IsEventScheduled("UpdateFrames"..element)) then
		self:CancelScheduledEvent("UpdateFrames"..element)
	end
end

function ShammySpy:UpdateFramesR()
	self:Debug("UpdateFramesR");
	local canStop = true;
	--[[ Check Reincarnation Cooldown ]]
	self:GetReincarnationID();
	if (self.reincarnationID) then
		local start, duration = GetSpellCooldown(self.reincarnationID, BOOKTYPE_SPELL);
		if ( start > 0 and duration > 0) then
			local frame = getglobal("ShammySpyReincarnationFrame");
			local text = getglobal("ShammySpyReincarnationFrameText1");
			local reincarnationCD = duration - ( GetTime() - start);
			
			frame:SetBackdrop({
				bgFile = "Interface/Icons/Spell_Nature_Reincarnation",
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = false, tileSize = 16, edgeSize = 16,
				insets = { left = 5, right =5, top = 5, bottom = 5 }
			})
			frame:SetBackdropColor(1, 1, 1, 1);
			frame:SetBackdropBorderColor(1, 1, 1, 0);
			text:SetText(self:FormatTime(reincarnationCD))
			canStop = false;
		else
			local frame = getglobal("ShammySpyReincarnationFrame");
			local text = getglobal("ShammySpyReincarnationFrameText1");
			
			frame:SetBackdrop({
				bgFile = "Interface/Icons/Spell_Nature_Reincarnation",
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = false, tileSize = 16, edgeSize = 16,
				insets = { left = 5, right =5, top = 5, bottom = 5 }
			})
			frame:SetBackdropColor(1, 1, 1, (1/3));
			frame:SetBackdropBorderColor(1, 1, 1, 0);
			text:SetText("00:00")
		end
	end
	
	if (canStop and self:IsEventScheduled("UpdateFramesR")) then
		self:CancelScheduledEvent("UpdateFramesR")
	end
end

ShammySpy.doPulse = {};
ShammySpyPulseFrame = CreateFrame("Frame")
ShammySpyPulseFrame:SetScript("OnUpdate", function()
	if ( (ShammySpy.englishClass) and (ShammySpy.englishClass == "SHAMAN") ) then
		for element, _ in pairs(ShammySpy.doPulse) do
			ShammySpy:Pulse(element)
		end
	end
end)

function ShammySpy:Pulse(element)
	local frame = getglobal("ShammySpy"..element.."Frame");
	local size = frame:GetHeight();
	local maxSize = 55;
	if (not frame.Die) then maxSize = 80; end
	
	if size >= maxSize then
		frame.PulseDec = true;
	end
	
	local newSize = size;
	if frame.PulseDec then
		newSize = newSize - (newSize * (1/9));
	else
		newSize = newSize + (newSize * (1/9));
	end
	
	if (newSize > maxSize) then newSize = maxSize; end
	
	if newSize <= 35 then
		frame:SetHeight(35)
		frame:SetWidth(35)
		self:RemPulse(element);
		frame.PulseDec = nil
	else
		frame:SetHeight(newSize)
		frame:SetWidth(newSize)
	end
end

--[[ Subscribed events ---------------------------------------------------------------]]
function ShammySpy:UNIT_SPELLCAST_SUCCEEDED(unit, spell, rank) -- "player", spell, rank
	if unit ~= "player" then return; end
	
	if (spell == L["Mana Spring Totem"] and not rank) then
		spell = L["Enamored Water Spirit"];
	end
	
	if (ShammySpy.Totems[spell]) then
		self:CreateTotemElement(spell, rank);
	elseif (spell == L["Totemic Call"]) then
		for _, element in ipairs({"Earth","Fire","Water","Air"}) do
			self:KillTotemElement(element);
		end
	end
end

function ShammySpy:PLAYER_DEAD()
	for _, element in ipairs({"Earth","Fire","Water","Air"}) do
		self:KillTotemElement(element);
	end
end

function ShammySpy:PLAYER_MAY_HAVE_REINCARNATED()
	self:ScheduleEvent("DelayCheckReincarnation", self.ScheduleCheck, 7, self); -- Just delay a check since the player ressed and may have used Reincarnation for it ;)
end

function ShammySpy:BAG_UPDATE()
	self:CountAnkhs();
end

function ShammySpy:CHAT_MSG_COMBAT_FRIENDLY_DEATH(message)
	-- Not sure if this ever happens since it doesn't seem to trigger when someone hits the totem
	--[[
	local item = deformat(message, UNITDESTROYEDOTHER);
	
	if (item) then -- %s is destroyed.
		for _, element in ipairs({"Earth","Fire","Water","Air"}) do
			local frame = getglobal("ShammySpy"..element.."Frame");
			if (frame.Die) then
				if ( (frame.CombatLog == item) and (time() <= (frame.Die - 1)) ) then
					local userInfo = string.format(L["%s (%s) was slain!!!"], frame.Spell, L[element]);
					ShammySpy:InformUser(userInfo, 1, 0, 0, 1, 3);
					
					self:KillTotemElement(element);
					break;
				end
			end
		end
	end
	]]
end

function ShammySpy:TOTEM_GETTING_POUNDED_ON(message)
	if not string.find(string.lower(message), string.lower(L["totem"])) then return; end
	local totem, damage
	for _,v in ipairs({SPELLLOGCRITOTHEROTHER, SPELLLOGCRITSCHOOLOTHEROTHER, SPELLLOGOTHEROTHER, SPELLLOGSCHOOLOTHEROTHER, COMBATHITCRITOTHEROTHER, COMBATHITOTHEROTHER}) do
		local arg1, arg2, arg3, arg4 = deformat(message, v)
		if arg4 and type(arg4)=='number' then
			totem, damage = arg3, arg4;
			break;
		elseif arg2 and type(arg3)=='number' then
			totem, damage = arg2, arg3;
			break;
		end
	end

	if totem and damage then
		local theTotem = nil;
		for _, element in ipairs({"Earth","Fire","Water","Air"}) do
			local frame = getglobal("ShammySpy"..element.."Frame");
			if (frame.Die) then
				if (frame.CombatLog == totem) then
					theTotem = frame.Spell;
					break;
				end
			end
		end
		
		if ( (theTotem) and (L:HasTranslation(theTotem)) ) then
			local element = ShammySpy.Totems[L[theTotem]].Element;
			local frame = getglobal("ShammySpy"..element.."Frame");
			frame.Health = frame.Health - damage;
			if (frame.Health < 1) then
				local userInfo = string.format(L["%s (%s) was slain!!!"], frame.Spell, L[element]);
				ShammySpy:InformUser(userInfo, 1, 0, 0, 1, 3);
				
				self:KillTotemElement(element);
			end
		else
			--self:Print(totem, "-", theTotem);
		end
	end
end