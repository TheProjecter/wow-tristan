local L = AceLibrary("AceLocale-2.2"):new("TGuildFrame")

function TGuildFrame:CHAT_MSG_ADDON(prefix, message, distributionType, sender)
	if (prefix ~= self.addonFolder) then return; end
	self:Debug("CHAT_MSG_ADDON", prefix, message, distributionType, sender);
	if ((UnitName("player")) == sender) then return; end
	if (distributionType ~= "GUILD") then return; end -- Probably very unnecessary but can't hurt much neither
	
	local ownPrefix, ownMessage = strsplit(" ", message ,2);
	if (ownPrefix == "PING") then
		self:PlayerSaveSync(sender);
		self:RosterUpdate();
	elseif (ownPrefix == "PONG") then
		self:Ping();
	elseif (ownPrefix == "SAVED") then
		local instanceName, instanceID = strsplit("!", ownMessage ,2);
		self:SaveInstanceID(sender, instanceName, instanceID);
		self:Debug("SAVED", sender, instanceName, instanceID);
		self:RosterUpdate();
	end
end

-- name, level, class, area, connected, status = GetFriendInfo(friendIndex);

function TGuildFrame:Ping()
	if (self.inCombat) then return; end
	
	if (not IsInGuild()) then
		self:Debug("Not guilded, so trying to sync!");
		return;
	end
	
	self:SendAddonMessage("PING", "?");
	self:Debug("Ping");
	
	if (GetNumSavedInstances() > 0) then
		for instanceNum=1, GetNumSavedInstances() do
			local instanceName, instanceID = GetSavedInstanceInfo(instanceNum);
			self:SendAddonMessage("SAVED", strjoin("!", instanceName, instanceID));
		end
	end
end

function TGuildFrame:SendAddonMessage(ownPrefix, text)
	self:Debug(ownPrefix, text);
	SendAddonMessage(self.addonFolder, ownPrefix.." "..text, "GUILD")
end

function TGuildFrame:PLAYER_REGEN_DISABLED()
	self.inCombat = true
end

function TGuildFrame:PLAYER_REGEN_ENABLED()
	self.inCombat = false
end