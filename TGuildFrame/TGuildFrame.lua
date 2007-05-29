--[[
			TODO List:
			
			Faint class colors for people online instead of grey. Strong class colors for people online and synced. Grey for people on alts
			Return of alt-names but with Toggles so the user can select himself what to show :) or by regex such as "%n [%c] %l %z"
			Return zone but in the tooltip or something
			Tidy up the highlighting to make room for the scrollbar, duh for spending more then a few mins on expanding it when few was online
]]

BINDING_NAME_TOGGLETGUILD = "Toggle Tristan's Advanced Guild Frame";
BINDING_HEADER_TGUILDFRAME = "Tristan's Advanced Guild Frame";
UIPanelWindows["TGuildFrame_List"] = { area = "left", pushable = 5, whileDead = 1 };

local L = AceLibrary("AceLocale-2.2"):new("TGuildFrame")
--[[ *** Create Ace2 AddOn *** ]]
TGuildFrame = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "AceHook-2.1")
TGuildFrame.addonFolder = "TGuildFrame" -- This is used for Communications via AddOns and Shorthands etc :P

TGuildFrame.unsavedTag = "Unsaved"; -- "-----"
TGuildFrame.unknownTag = "Unknown"; -- "~~~~~"

function TGuildFrame:OnDisable()
  self:UnregisterAllEvents()
end

function TGuildFrame:RegisterShorthand(shorthand, func)
	if (shorthand and shorthand ~= "") then
		local type = strupper(self.addonFolder).."_SHORTHAND_"..strupper(shorthand)
		SlashCmdList[type] = func
		setglobal("SLASH_"..type.."1", "/"..strlower(shorthand))
	end
end

function TGuildFrame:OnInitialize()
	--[[ Get revision, and fill special strings ]]
	_, _, self.majorVersion, self.minorVersion, self.revisionVersion = string.find(self.version, "(%d+)%.(%d+)%.(%d+)")
	_, _, self.lastUpdateDate = string.find(GetAddOnMetadata(self.addonFolder, "X-LastUpdate"), "(%d+%-%d+%-%d+ %d+%:%d+)")
	
	--[[ Register chat commands ]]
  -- self.options = self:BuildOptions()
  -- self:RegisterChatCommand(L["ConsoleCommands"], self.options)
  
	self:MakeButtons()
  
  UIDropDownMenu_SetWidth(180, TGuildFrame_List_Instance)
  TGuildFrame_List_Instance:SetPoint("TOPRIGHT", TGuildFrame_List_CloseButton, "BOTTOMRIGHT", 0, -5)
  
  tinsert(UISpecialFrames, "TGuildFrame_List");
end

function TGuildFrame:OnEnable()
	self:RegisterEvent("GUILD_ROSTER_UPDATE");
	self:RegisterEvent("PLAYER_GUILD_UPDATE");
	
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", "GUILD_ROSTER_UPDATE");
	--self:RegisterEvent("RAID_ROSTER_UPDATE", "GUILD_ROSTER_UPDATE");
	
	self:RegisterEvent("CHAT_MSG_ADDON");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	
	self:SecureHook("FriendsFrame_ShowSubFrame", "GUILDFRAME_OPENED")
	self:SecureHook("FriendsFrame_OnShow", "GUILDFRAME_OPENED")
	self:SecureHook("FriendsFrame_OnHide", "GUILDFRAME_CLOSED")
	
	self:RegisterShorthand("tg", function(cmd) self:Toggle(); end )
	
	if (IsInGuild()) then
		self:ScheduleRepeatingEvent("Ping", self.Ping, 360, self)
		GuildRoster();
	end
	self:PlayerSaveSync((UnitName("player")))
end

function TGuildFrame:PLAYER_GUILD_UPDATE()
	if (IsInGuild()) then
		if (not self:IsEventScheduled("Ping")) then
			self:ScheduleRepeatingEvent("Ping", self.Ping, 360, self);
			GuildRoster();
		end
	else
		if (self:IsEventScheduled("Ping")) then
			self:CancelScheduledEvent("Ping");
			GuildRoster();
		end
	end
end

function TGuildFrame:GUILD_ROSTER_UPDATE()
	if (not IsInGuild()) then return; end
	
	self.Roster = nil;
	self.Roster = {};
	self.Lookup = nil;
	self.Lookup = {};
	
	--for guildIndex=1, GetNumGuildMembers(true) do
	for guildIndex=GetNumGuildMembers(true), 1, -1 do
		local info = {};
		info.name, info.rank, _, info.level, info.class, info.zone, info.note, info.officernote, info.online, info.status = GetGuildRosterInfo(guildIndex);
		info.statusShort = "";
		if (strupper(info.status) == "<AFK>") then info.statusShort = "<A>"; end
		if (strupper(info.status) == "<DND>") then info.statusShort = "<D>"; end
		self.Lookup[info.name] = info;
		
		if (info.online) then
			tinsert(self.Roster, info);
		end
	end
	
	FauxScrollFrame_Update(TGuildFrame_List_Scroll, getn(self.Roster), 22, 16, nil, nil, nil, TGuildFrame_List_HighlightFrame, 293, 316);
	self:RosterUpdate();
end

function TGuildFrame:RosterUpdate2()
	TGuildFrame:RosterUpdate();
end

function TGuildFrame:RosterUpdate()
	if (not self.Roster) then
		
		self:GUILD_ROSTER_UPDATE();
		return;
	end
	if (not TGuildFrame_List:IsVisible()) then return; end
	
	local rosterTotal = getn(self.Roster);
	for scrollIndex=1, 22 do
		local rosterIndex = scrollIndex + FauxScrollFrame_GetOffset(TGuildFrame_List_Scroll);
		local info = self.Roster[rosterIndex];
		local infoButton = getglobal("TGuildFrame_List_Title"..scrollIndex);
		local infoTitle = getglobal("TGuildFrame_List_Title"..scrollIndex.."Title");
		local infoTitleID = getglobal("TGuildFrame_List_Title"..scrollIndex.."Tag");
		
		local group = {}
		group[(UnitName("player"))] = true;
		if (GetNumRaidMembers() > 0) then
			for raidIndex=1, GetNumRaidMembers() do
				--if ( (UnitName("raid"..raidIndex)) ) then group[(UnitName("raid"..raidIndex))] = true; end
				group[( (UnitName("raid"..raidIndex)) or (UnitName("player")) )] = true;
			end
		elseif (GetNumPartyMembers() > 0) then
			for partyIndex=1, GetNumPartyMembers() do
				--if ( (UnitName("party"..partyIndex)) ) then group[(UnitName("party"..partyIndex))] = true; end
				group[( (UnitName("party"..partyIndex)) or (UnitName("player")) )] = true;
			end
		end
		
		if (rosterIndex <= rosterTotal) then
			local mainFound, _, mainName = string.find(info.note or "", "%[Main%:?%s?(%w+)%]")
			
			local dispCombine = (info.statusShort or "");
			if (mainFound and self.Lookup[mainName]) then
				--[[ This executes if the person is an alt ]]
				-- dispCombine = dispCombine.." "..self:ColorName(mainName, info.online, group).." ("..self:ColorName(info.name, info.online, group)..")".." ["..self:ColorExpressionByClass(self.Lookup[mainName].class, self.Lookup[mainName].class).."] "..self.Lookup[mainName].level.." "..(self.Lookup[mainName].zone or "");
				-- dispCombine = dispCombine.." !"..self:ColorName(mainName, info.online, group).." ["..self:ColorExpressionByClass(self.Lookup[mainName].class, self.Lookup[mainName].class).."] "..self.Lookup[mainName].level..", "..self.Lookup[mainName].rank.." "..(self.Lookup[mainName].zone or "");
				dispCombine = dispCombine.." !"..self:ColorName(mainName, info.online, group).." ["..self:ColorExpressionByClass(self.Lookup[mainName].class, self.Lookup[mainName].class).."] "..self.Lookup[mainName].level..", "..self.Lookup[mainName].rank;
			else
				--[[ This executes if the person is a main ]]
				mainName = info.name;
				-- dispCombine = dispCombine.." "..self:ColorName(info.name, info.online, group).." ["..self:ColorExpressionByClass(info.class, info.class).."]".." "..info.level..", "..info.rank.." "..(info.zone or "");
				dispCombine = dispCombine.." "..self:ColorName(info.name, info.online, group).." ["..self:ColorExpressionByClass(info.class, info.class).."]".." "..info.level..", "..info.rank;
			end
			
			local dispID = "";
			if (self.selectedInstanceName) then
				dispID = self:GetInstanceID(mainName, self.selectedInstanceName);
				if (mainName ~= info.name) then
					dispID = dispID.." ("..self:GetInstanceID(info.name, self.selectedInstanceName)..")";
				end
			else
				dispID = "!";
			end
			
			infoButton.mainName = mainName;
			infoButton.thisName = info.name;
			--infoButton:SetText("ZOMG :P");
			infoTitle:SetText(dispCombine);
			--infoTitle:SetTextColor(0.65, 0.20, 0.40);
			infoTitleID:SetText(dispID);
			--infoTitleID:SetTextColor(0.65, 0.20, 0.40);
			
			if (self:PlayerSynced(mainName)) then
				infoTitle:SetTextColor(1, 1, 1);
				infoTitleID:SetTextColor(1, 1, 1);
			else
				infoTitle:SetTextColor(0.6, 0.6, 0.6);
				infoTitleID:SetTextColor(0.6, 0.6, 0.6);
			end
			
			infoButton:Show();
			infoTitle:Show();
			infoTitleID:Show();
		else
			infoButton:Hide();
			infoTitle:Hide();
			infoTitleID:Hide();
		end
	end
	
	FauxScrollFrame_Update(TGuildFrame_List_Scroll, getn(self.Roster), 22, 16, nil, nil, nil, TGuildFrame_List_HighlightFrame, 293, 316);
end

function TGuildFrame:DropDown()
	local self = TGuildFrame;
	--self:Print("DropDown")
	
	self.instancesAdded = nil;
	self.instancesAdded = {};
	self.instancesAdded["?"] = true;
	
	if (GetNumSavedInstances() > 0) then
		for instanceNum=1, GetNumSavedInstances() do
			local instanceName, instanceID = GetSavedInstanceInfo(instanceNum);
			
			local info        = {};
			info.text         = instanceName;
			info.value        = instanceID;
			info.func         = function() TGuildFrame:DropDownSelected(this); end;
			info.owner 			  = this:GetParent();
		--info.icon 			  = nil;
			info.notCheckable = 1;
			info.tooltipTitle = instanceName;
			info.tooltipText  = instanceID;
			UIDropDownMenu_AddButton(info);
			
			self.instancesAdded[instanceName] = true;
			self:SaveInstanceID((UnitName("player")), instanceName, instanceID)
		end
	end
	
	if (self.IDDB) then
	 	for playerName, _ in pairs(self.IDDB) do
	 		for instanceName, instanceID in pairs(self.IDDB[playerName]) do
	 			if (not self.instancesAdded[instanceName]) then
	 				-- New Instance
	 				local info        = {};
					info.text         = instanceName;
					info.value        = self.unsavedTag;
					info.func         = function() TGuildFrame:DropDownSelected(this); end;
					info.owner 			  = this:GetParent();
				--info.icon 			  = nil;
					info.notCheckable = 1;
					info.tooltipTitle = instanceName;
					info.tooltipText  = self.unsavedTag;
					UIDropDownMenu_AddButton(info);
					
					self.instancesAdded[instanceName] = true;
	 			end
	 		end
	 	end
 	end
end

function TGuildFrame:DropDownSelected(this)
	if (this.value ~= 0) then
		self:Debug("Instance: "..this:GetText().." selected");
		
		self.selectedInstanceName = this:GetText();
		--self.selectedInstanceID = this.value;
		getglobal("TGuildFrame_List_Instance_title"):SetText(this:GetText().." has ID: "..this.value);
		self.DropDownID = this:GetID()
	else
		self.selectedInstanceName = nil;
		--self.selectedInstanceID = nil;
		getglobal("TGuildFrame_List_Instance_title"):SetText("Select an instance:");
	end
	
	UIDropDownMenu_SetSelectedID(TGuildFrame_List_Instance, self.DropDownID)
	UIDropDownMenu_SetSelectedID(TGuildFrame_List_Instance, 0)
	
	self:RosterUpdate();
end

function TGuildFrame:Toggle()
	if (TGuildFrame_List:IsVisible()) then
		HideUIPanel(TGuildFrame_List);
	else
		ShowUIPanel(TGuildFrame_List);
		if (self.DropDownID) then
			UIDropDownMenu_SetSelectedID(TGuildFrame_List_Instance, self.DropDownID)
		end
		UIDropDownMenu_SetSelectedID(TGuildFrame_List_Instance, 0)
		self:RosterUpdate();
	end
end

function TGuildFrame:FrameNameClick(button)
	self:Debug("TGuildFrame:FrameNameClick");
	local clickText = button.thisName;--button:GetText(); <------------------ Gah, this held me up for an hour before realising I changed to a fontstring instead of button text. Go me!
	if (not clickText) then return; end
	local clickName = button.thisName;
	clickName = strtrim(clickName);
	
	self:Debug(button.mainName);
	self:Debug(button.thisName);
	
	if (arg1 == "LeftButton") then
		if ( ChatFrameEditBox:IsVisible() ) then
			--ChatFrameEditBox:Insert("/w "..clickName.." ");
			ChatFrameEditBox:SetText("/w "..clickName.." ");
		else
			ChatFrame_OpenChat("/w "..clickName.." ");
		end
	elseif (arg1 == "RightButton") then
		InviteUnit(clickName);
	end
end

function TGuildFrame:SaveInstanceID(playerName, instanceName, instanceID)
	if (not self.IDDB) then self.IDDB = {} end
	if (not self.IDDB[playerName]) then self.IDDB[playerName] = {} end
	
	self.IDDB[playerName][instanceName] = instanceID;
	self:PlayerSaveSync(playerName);
end

function TGuildFrame:GetInstanceID(playerName, instanceName)
	if (not self.IDDB) then self.IDDB = {} end
	if (not self.IDDB[playerName]) then self.IDDB[playerName] = {} end
	if (not self.IDDB[(UnitName("player"))]) then self.IDDB[(UnitName("player"))] = {} end
	
	if (self.IDDB[playerName][instanceName]) then
		if (tostring(self.IDDB[playerName][instanceName]) == tostring(self.IDDB[(UnitName("player"))][instanceName])) then
			return "|cff00ff00"..tostring(self.IDDB[playerName][instanceName]).."|r";
		else
			return "|cffff0000"..tostring(self.IDDB[playerName][instanceName]).."|r";
		end
	else
		if (self:PlayerSynced(playerName)) then
			return "|cff00ff00"..self.unsavedTag.."|r";
		else
			return "|cffffff00"..self.unknownTag.."|r";
		end
	end
end

function TGuildFrame:PlayerSaveSync(playerName)
	if (not self.IDDB) then self.IDDB = {} end
	if (not self.IDDB[playerName]) then self.IDDB[playerName] = {} end
	
	self.IDDB[playerName]["?"] = true;
end

function TGuildFrame:PlayerSynced(playerName)
	if (not self.IDDB) then self.IDDB = {} end
	if (not self.IDDB[playerName]) then self.IDDB[playerName] = {} end
	
	return self.IDDB[playerName]["?"];
end

function TGuildFrame:ColorName(playerName, online, myGroup)
	local playerSuffix = ((myGroup[playerName] and "*") or "");
	
	if (self:PlayerSynced(playerName)) then
		if (online) then
			return "|cff00ff00"..playerName..playerSuffix.."|r";
		else
			return "|cff7fff7f"..playerName..playerSuffix.."|r";
		end
	else
		return "|cff999999"..playerName..playerSuffix.."|r";
	end
end

function TGuildFrame:Debug(...)
	if (self.debugging) then self:Print("DEBUG:", ...); end
end

function TGuildFrame:ColorExpressionByClass(expression, class)
	return "|cff"..self:ClassColor(class)..expression.."|r";
end

function TGuildFrame:ClassColor(class)
	if ( class ~= string.upper(class) ) then class = L[class]; end
	return self:RGBPercToHex(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b);
end

function TGuildFrame:RGBPercToHex(r, g, b)
	return string.format("%02x%02x%02x", r*255, g*255, b*255);
end