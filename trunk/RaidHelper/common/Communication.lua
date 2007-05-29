local L = AceLibrary("AceLocale-2.2"):new("RaidHelper")
-- SetRaidTarget("unit", index) 

function RaidHelper:CHAT_MSG_ADDON(prefix, message, distributionType, sender)
	if ((prefix == self.addonFolder) and (distributionType == "RAID")) then
		local first, last = strsplit(" ", message ,2)
		first = string.lower(first)
		
		--[[
			Normally a delimited list of commands (or whatever) would be built up from
			for example "/raswap Tristan Isolde" sending "swap Tristan Isolde" to the
			AddOnChannel. So splitting the string and separate the first word is enough
			for now.
			
			The variable first will hold our own prefix (swap for example)
			The variable last will hold the rest (Tristan Isolde) that our function needs
		]]
		
		if ((first == "swap") and IsRaidLeader()) then
			if (self:RaidRank(sender) > 0) then
				self:DoSwap(last, sender)
				return
			end
		elseif ((first == "move") and IsRaidLeader()) then
			if (self:RaidRank(sender) > 0) then
				self:DoMove(last, sender)
				return
			end
		elseif ((first == "prom") and IsRaidLeader()) then
			if (self:RaidRank(sender) > 0) then
				self:DoPromote(last, sender)
				return
			end
		elseif ((first == "demo") and IsRaidLeader()) then
			if (self:RaidRank(sender) > 0) then
				self:DoDemote(last, sender)
				return
			end
		elseif ((first == "lead") and IsRaidLeader() and self.db.profile.leadership) then
			if (self:RaidRank(sender) > 0) then
				self:DoLeader(last, sender)
				return
			end
		elseif ((first == "offi") and IsRaidLeader()) then
			self:DoOfficer(last, sender)
			return
		elseif ((first == "redy") and IsRaidLeader()) then
			if (self:RaidRank(sender) > 0) then
				self:DoRdyCheck(sender)
				return
			end
		end
		
		if (IsRaidLeader()) then
			self:Print("Incomming command [|cff804040"..first.."|r] from "..sender.." was ignored")
		end
	elseif ((prefix == self.addonFolder) and (distributionType == "GUILD")) then
		local first, last = strsplit(" ", message ,2)
		first = string.lower(first)
		
		if (first == "invi") then
			self:DoInvite(last, sender)
			return
		end
	end
end

function RaidHelper:SendAddonMessage(text)
	SendAddonMessage(self.addonFolder, text, "RAID")
end
function RaidHelper:SendAddonMessageG(text)
	SendAddonMessage(self.addonFolder, text, "GUILD")
end
function RaidHelper:Inform(text, sender)
	if (sender == (UnitName("player"))) then return end
	self:Print(text)
end

function RaidHelper:Shorthands()
	self:Print("Adds the following slashcommands for your use (assuming the Raid Leader has this AddOn installed aswell)")
	self:Print("/raswap (Usage: \"/raswap Tristan Isolde\" will swap Tristan and Isolde into their respective groups.)")
	self:Print("/ramove (Usage: \"/ramove Tristan 2\" will move Tristan into group 2)")
	self:Print("/raprom (Usage: \"/raprom Tristan\" will promote Tristan to Raid Officer)")
	self:Print("/rademo (Usage: \"/rademo Tristan\" will demote Tristan from Raid Officer)")
	self:Print("/ralead (Usage: \"/ralead Tristan\" will request Leadership to Tristan, \"/ralead\" will request Leadership to yourself)")
	self:Print("/raredy (Usage: \"/raredy\" will ask Raid Leader to do a ready check!) (/rardy works too)")
	self:Print("You'll need to be promoted yourself to use the above commands and your raidleader needs this AddOn installed")
	self:Print("/raoffi (Usage: \"/raoffi god\" will request promotion with the password god)")
	-- self:Print("/rainvi (Usage: \"/rainvi Tristan god\" will request guildmember Tristan to invite you to his group with the password god)")
end

--[[ ************************* SWAP RAID MEMBERS ************************* ]]
-- self:RegisterShorthand("raswap", function(cmd) self:Swap(cmd) end )
function RaidHelper:Swap(commandline)
	local name1, name2 = strsplit(" ", commandline, 2)
	
	if (self:ValidPlayerName(name1) and self:ValidPlayerName(name2)) then
		self:SendAddonMessage("swap "..name1.." "..name2)
	else
		self:Print("Usage: \"/raswap Tristan Isolde\" will swap Tristan and Isolde into their respective groups.")
	end
end
function RaidHelper:DoSwap(commandline, sender)
	local name1, name2 = strsplit(" ", commandline, 2)
	if (self:ValidPlayerName(name1) and self:ValidPlayerName(name2)) then
		local index1, index2 = self:Name2RaidIndex(name1), self:Name2RaidIndex(name2)
		
		if (tonumber(index1) and tonumber(index2) and (index1 ~= index2)) then
			self:Print("Swapping "..name1.." with "..name2.." on behalf of "..sender)
			SwapRaidSubgroup(index1, index2)
			return
		end
	end
	
	self:Print("Couldn't help "..sender.." with his swap command ("..commandline..")")
end

--[[ ************************* MOVE RAID MEMBERS ************************* ]]
-- self:RegisterShorthand("ramove", function(cmd) self:Move(cmd) end )
function RaidHelper:Move(commandline)
	local name, group = strsplit(" ", commandline, 2)
	
	if (self:ValidPlayerName(name) and tonumber(group)) then
		self:SendAddonMessage("move "..name.." "..group)
	else
		self:Print("Usage: \"/ramove Tristan 2\" will move Tristan into group 2")
	end
end
function RaidHelper:DoMove(commandline, sender)
	local name, group = strsplit(" ", commandline, 2)
	
	if (self:ValidPlayerName(name)) then
		local index = self:Name2RaidIndex(name)
		
		if ((index) and tonumber(group)) then
			self:Print("Moving "..name.." into subgruop "..group.." on behalf of "..sender)
			SetRaidSubgroup(index, group)
			return
		end
	end
	
	self:Print("Couldn't help "..sender.." with his move command ("..commandline..")")
end

--[[ ************************* PROMOTE RAID MEMBERS ************************* ]]
-- self:RegisterShorthand("raprom", function(cmd) self:Promote(cmd) end )
function RaidHelper:Promote(commandline)
	local name = commandline
	
	if (self:ValidPlayerName(name)) then
		self:SendAddonMessage("prom "..name)
	else
		self:Print("Usage: \"/raprom Tristan\" will promote Tristan to Raid Officer")
	end
end
function RaidHelper:DoPromote(commandline, sender)
	local name = commandline
	
	if (self:ValidPlayerName(name)) then
		self:Print("Promoting "..name.." to Raid Officer on behalf of "..sender)
		PromoteToAssistant(name)
		return
	end
	
	self:Print("Couldn't help "..sender.." with his promote command ("..commandline..")")
end

--[[ ************************* DEMOTE RAID MEMBERS ************************* ]]
-- self:RegisterShorthand("rademo", function(cmd) self:Demote(cmd) end )
function RaidHelper:Demote(commandline)
	local name = commandline
	
	if (self:ValidPlayerName(name)) then
		self:SendAddonMessage("demo "..name)
	else
		self:Print("Usage: \"/rademo Tristan\" will demote Tristan from Raid Officer")
	end
end
function RaidHelper:DoDemote(commandline, sender)
	local name = commandline
	
	if (self:ValidPlayerName(name)) then
		self:Print("Demoting "..name.." from Raid Officer on behalf of "..sender)
		DemoteAssistant(name)
		return
	end
	
	self:Print("Couldn't help "..sender.." with his demote command ("..commandline..")")
end

--[[ ************************* HAND OVER LEADERSHIP ************************* ]]
-- self:RegisterShorthand("ralead", function(cmd) self:Leader(cmd) end )
function RaidHelper:Leader(commandline)
	local name = commandline
	if (string.len(self:Trim(name)) < 1) then name = UnitName("player") end
	
	if (self:ValidPlayerName(name)) then
		self:SendAddonMessage("lead "..name)
	else
		self:Print("Usage: \"/ralead Tristan\" will request Leadership to Tristan, \"/ralead\" will request Leadership to yourself")
	end
end
function RaidHelper:DoLeader(commandline, sender)
	local name = commandline
	
	if (self:ValidPlayerName(name)) then
		self:Print("Handing Raidleadership to "..name.." on behalf of "..sender)
		PromoteToLeader(name)
		return
	end
	
	self:Print("Couldn't help "..sender.." with his leader command ("..commandline..")")
end

--[[ ************************* READYCHECK ************************* ]]
-- self:RegisterShorthand("raredy", function(cmd) self:ReadyCheck(cmd) end )
function RaidHelper:RdyCheck()
	self:SendAddonMessage("redy")
end
function RaidHelper:DoRdyCheck(sender)
	if (sender ~= (UnitName("player"))) then
		SendChatMessage("Doing a ready check on behalf of "..sender, "RAID")
	end
	DoReadyCheck()
	return
end

--[[ ************************* REQUEST PROMOTION TO OFFICER ************************* ]]
-- self:RegisterShorthand("raoffi", function(cmd) self:Officer(cmd) end )
function RaidHelper:Officer(commandline)
	if (string.len(self:Trim(commandline)) > 0) then
		self:SendAddonMessage("offi "..commandline)
	else
		self:Print("Usage: \"/raoffi god\" will request promotion with the password god")
	end
end
function RaidHelper:DoOfficer(commandline, sender)
	if (self.db.char.opassword) then
		if (commandline == self.db.char.opassword) then
			self:Print("Promoting "..sender.." on request with password: "..commandline)
			PromoteToAssistant(sender)
		else
			SendChatMessage("Incorrect password for promotion!", "WHISPER", GetDefaultLanguage("player"), sender)
		end
	else
		SendChatMessage("I have no password set for auto-promotion!", "WHISPER", GetDefaultLanguage("player"), sender)
	end
end

--[[ ************************* INVITE GUILD MEMBERS BY PASSWORD ************************* ]]
-- self:RegisterShorthand("rainvi", function(cmd) self:Invite(cmd) end )
function RaidHelper:Invite(commandline)
	if (string.len(self:Trim(commandline)) > 0) then
		self:SendAddonMessageG("invi "..commandline)
	else
		self:Print("Usage: \"/rainvi Tristan god\" will request guildmember Tristan to invite you to his group with the password god")
	end
end
function RaidHelper:DoInvite(commandline, sender)
	local toName, invPassword = strsplit(" ", last ,2)
	self:Print(commandline)
	if (string.lower(toName) ~= string.lower(UnitName("player"))) then return end
	
	if (self.db.char.ipassword) then
		if (invPassword == self.db.char.ipassword and (IsRaidLeader() or IsRaidOfficer() or IsPartyLeader())) then
			self:Print("Inviting "..sender.." on request with password: "..commandline)
			InviteUnit(sender)
		elseif (invPassword == self.db.char.ipassword) then
			if ((GetNumRaidMembers() == 0) and (GetNumPartyMembers() == 0)) then
				SendChatMessage("I'm not grouped!", "WHISPER", GetDefaultLanguage("player"), sender)
			else
				SendChatMessage("I'm not eligable to invite!", "WHISPER", GetDefaultLanguage("player"), sender)
			end
		else
			SendChatMessage("Incorrect password for invite!", "WHISPER", GetDefaultLanguage("player"), sender)
		end
	else
		SendChatMessage("I have no password set for auto-invites!", "WHISPER", GetDefaultLanguage("player"), sender)
	end
end