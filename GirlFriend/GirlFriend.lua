--[[ Friends list as type? ]]
--[[ Guild members as type? ]]
local L = AceLibrary("AceLocale-2.2"):new("GirlFriend")

L:RegisterTranslations("enUS", function() return {
	["lock"] = true,
	["Lock"] = true,
	["Toggle locking of the GirlFriend frame."] = true,

	["display"] = true,
	["Display Mode"] = true,
	["Select behavior for display of messages."] = true,

	["None"] = true,
	["Default"] = true,

	["font"] = true,
	["Font"] = true,
	["Set the font for the display of messages in the Default frame."] = true,

	["height"] = true,
	["Height"] = true,
	["Set the height for the Default frame."] = true,

	["Small"] = true,
	["Normal"] = true,
	["Large"] = true,
	["Huge"] = true,

	["test"] = true,
	["Test"] = true,
	["Test with some dummy GirlFriend messages."] = true,

	["insertmode"] = true,
	["Insert Mode"] = true,
	["Set the insert mode for the Default frame."] = true,
	["Bottom"] = true,
	["Top"] = true,

	["DRAG HERE"] = true,

	["Types"] = true,
	["Types to monitor"] = true,
	["Guild"] = true,
	["Officer"] = true,
	["Party"] = true,
	["Raid"] = true,
	["Raid Leader"] = true,
	["Raid Warning"] = true,
	["Say"] = true,
	["Whisper"] = true,
	["Whisper (out)"] = true,
	["Yell"] = true,
	
	["Whisper from"] = true,
	["Whisper to"] = true,
	
	["Add"] = true,
	["Add someone to list"] = true,
	["Remove"] = true,
	["Remove someone from list"] = true,
	[" has been added"] = true,
	[" has been removed"] = true,
} end )

local defaults = {
	display = L["Default"],
	insertmode = L["Top"],
	lock = true,
	height = 160,
	type = { guild = false, officer = false, party = false, raid = false, raidleader = false, raidwarning = false, say = false, whisper = false, whisperout = false, yell = false, },
	name = {},
}

local consoleoptions = {
	type = "group",
	args = {
		[L["lock"]] = {
			name = L["Lock"], type = "toggle",
			desc = L["Toggle locking of the GirlFriend frame."],
			get = function() return GirlFriend.db.profile.lock end,
			set = function(v)
				GirlFriend.db.profile.lock = v
				GirlFriend:UpdateLock()
			end,
			order = 21,
		},
		[L["insertmode"]] = {
			name = L["Insert Mode"], type = "text",
			desc = L["Set the insert mode for the Default frame."],
			validate = { L["Top"], L["Bottom"] },
			get = function() return GirlFriend.db.profile.insertmode end,
			set = function(v)
				GirlFriend.db.profile.insertmode = v
				if GirlFriend.msgframe then
					if v == L["Bottom"] then
						GirlFriend.msgframe:SetInsertMode("BOTTOM")
					else
						GirlFriend.msgframe:SetInsertMode("TOP")
					end
				end
			end,
			order = 21,
		},
		[L["display"]] = {
			name = L["Display Mode"], type = "text",
			desc = L["Select behavior for display of messages."],
			validate = {L["None"], L["Default"]},
			get = function() return GirlFriend.db.profile.display end,
			set = function(v)
				GirlFriend.db.profile.display = v
				if v == L["None"] then
				if GirlFriend:IsEventRegistered("GirlFriend_Message") then GirlFriend:UnregisterEvent("GirlFriend_Message") end
				else
				if not GirlFriend:IsEventRegistered("GirlFriend_Message") then GirlFriend:RegisterEvent("GirlFriend_Message") end
				end
			end,
			order = 21,
		},
		[L["font"]] = {
			name = L["Font"], type = "text",
			desc = L["Set the font for the display of messages in the Default frame."],
			validate = {L["Small"], L["Normal"], L["Large"], L["Huge"]},
			get = function() return GirlFriend.db.profile.font end,
			set = function(v)
				GirlFriend.db.profile.font = v
				GirlFriend:SetFont()
			end,
			order = 21,
		},
		[L["height"]] = {
			name = L["Height"], type = "range",
			desc = L["Set the height for the Default frame."],
			min = 40,
			max = 200,
			step = 5,
			get = function() return GirlFriend.db.profile.height end,
			set = function(v)
				GirlFriend.db.profile.height = v
				if GirlFriend.msgframe then
					GirlFriend.msgframe:SetHeight( v )
				end
			end,
			order = 21,
		},
		[L["Add"]] = {
			name = L["Add"], type = "text",
			desc = L["Add someone to list"],
			usage = "Player Name",
			get = false,
			set = function(v)
				if (not GirlFriend.db.profile.name[strlower(v)]) then
					GirlFriend.db.profile.name[strlower(v)] = true;
					GirlFriend:Print(GirlFriend:TitleCase(v)..L[" has been added"]);
				end
			end,
			order = 1,
		},
		[L["Remove"]] = {
			name = L["Remove"], type = "text",
			desc = L["Remove someone from list"],
			usage = "Player Name",
			get = false,
			set = function(v)
				if (GirlFriend.db.profile.name[strlower(v)]) then
					GirlFriend.db.profile.name[strlower(v)] = nil;
					GirlFriend:Print(GirlFriend:TitleCase(v)..L[" has been removed"]);
				end
			end,
			order = 2,
		},
		[L["Types"]] = {
			name = L["Types"], type = "group",
			desc = L["Types to monitor"],
			order = 3,
			args = {
				[L["Guild"]] = {
					name = L["Guild"], type = "toggle",
					desc = L["Guild"],
					get = function() return GirlFriend.db.profile.type.guild; end,
					set = function()
						GirlFriend.db.profile.type.guild = not GirlFriend.db.profile.type.guild;
					end,
				},
				[L["Officer"]] = {
					name = L["Officer"], type = "toggle",
					desc = L["Officer"],
					get = function() return GirlFriend.db.profile.type.officer; end,
					set = function()
						GirlFriend.db.profile.type.officer = not GirlFriend.db.profile.type.officer;
					end,
				},
				[L["Party"]] = {
					name = L["Party"], type = "toggle",
					desc = L["Party"],
					get = function() return GirlFriend.db.profile.type.party; end,
					set = function()
						GirlFriend.db.profile.type.party = not GirlFriend.db.profile.type.party;
					end,
				},
				[L["Raid"]] = {
					name = L["Raid"], type = "toggle",
					desc = L["Raid"],
					get = function() return GirlFriend.db.profile.type.raid; end,
					set = function()
						GirlFriend.db.profile.type.raid = not GirlFriend.db.profile.type.raid;
					end,
				},
				[L["Raid Leader"]] = {
					name = L["Raid Leader"], type = "toggle",
					desc = L["Raid Leader"],
					get = function() return GirlFriend.db.profile.type.raidleader; end,
					set = function()
						GirlFriend.db.profile.type.raidleader = not GirlFriend.db.profile.type.raidleader;
					end,
				},
				[L["Say"]] = {
					name = L["Say"], type = "toggle",
					desc = L["Say"],
					get = function() return GirlFriend.db.profile.type.say; end,
					set = function()
						GirlFriend.db.profile.type.say = not GirlFriend.db.profile.type.say;
					end,
				},
				[L["Whisper"]] = {
					name = L["Whisper"], type = "toggle",
					desc = L["Whisper"],
					get = function() return GirlFriend.db.profile.type.whisper; end,
					set = function()
						GirlFriend.db.profile.type.whisper = not GirlFriend.db.profile.type.whisper;
					end,
				},
				[L["Whisper (out)"]] = {
					name = L["Whisper (out)"], type = "toggle",
					desc = L["Whisper (out)"],
					get = function() return GirlFriend.db.profile.type.whisperout; end,
					set = function()
						GirlFriend.db.profile.type.whisperout = not GirlFriend.db.profile.type.whisperout;
					end,
				},
				[L["Yell"]] = {
					name = L["Yell"], type = "toggle",
					desc = L["Yell"],
					get = function() return GirlFriend.db.profile.type.yell; end,
					set = function()
						GirlFriend.db.profile.type.yell = not GirlFriend.db.profile.type.yell;
					end,
				},
			},
		},
		[L["test"]] = {
			name = L["Test"], type = "execute",
			desc = L["Test with some dummy GirlFriend messages."],
			func = function()
				GirlFriend:TriggerEvent("GirlFriend_Message", "Any raid up tonight?", "Tristan", "CHAT_MSG_OFFICER")
				GirlFriend:TriggerEvent("GirlFriend_Message", "WTB Portal to Shattrath", "Tristan", "CHAT_MSG_YELL")
				GirlFriend:TriggerEvent("GirlFriend_Message", "Hey wanna cybor?", "Tristan", "CHAT_MSG_WHISPER")
			end,
			order = 11,
		},
	}
}

GirlFriend = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0")
GirlFriend:RegisterDB("GirlFriendDB")
GirlFriend:RegisterDefaults('profile', defaults)
GirlFriend:RegisterChatCommand( { "/gf", "/GirlFriend" }, consoleoptions )


--[[ Initialization ------------------------------------------------------------------]]

function GirlFriend:OnInitialize()

end

function GirlFriend:OnEnable()
	-- Setup the frame
	if not self.msgframe then self:SetupFrames(); end

	-- Register our own events
	self:RegisterEvent("GirlFriend_Message")

	-- Register the WoW events
	self:RegisterEvent("CHAT_MSG_GUILD");
	self:RegisterEvent("CHAT_MSG_OFFICER");
	self:RegisterEvent("CHAT_MSG_PARTY");
	self:RegisterEvent("CHAT_MSG_RAID");
	self:RegisterEvent("CHAT_MSG_RAID_LEADER");
	-- self:RegisterEvent("CHAT_MSG_RAID_WARNING"); -- Added it but wtf ;)
	self:RegisterEvent("CHAT_MSG_SAY");
	self:RegisterEvent("CHAT_MSG_WHISPER");
	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM");
	self:RegisterEvent("CHAT_MSG_YELL");
end

function GirlFriend:OnDisable()

end

--[[ Functions -----------------------------------------------------------------------]]

function GirlFriend:SetFont()
	if self.db.profile.font == L["Huge"] then
		self.msgframe:SetFontObject(GameFontNormalHuge)
	elseif self.db.profile.font == L["Small"] then
		self.msgframe:SetFontObject(GameFontNormalSmall)
	elseif self.db.profile.font == L["Large"] then
		self.msgframe:SetFontObject(GameFontNormalLarge)
	else
		self.msgframe:SetFontObject(GameFontNormal)
	end
end

function GirlFriend:SetupFrames()
	self.dragbutton = CreateFrame("Button",nil,UIParent)
	self.dragbutton.owner = self
	self.dragbutton:Hide()
	self.dragbutton:ClearAllPoints()
	self.dragbutton:SetWidth(200)
	self.dragbutton:SetHeight(25)

	if self.db.profile.x and self.db.profile.y then
		self.dragbutton:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.db.profile.x, self.db.profile.y)
	else
		self.dragbutton:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 0, 0)
	end
	self.dragbutton:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right =5, top = 5, bottom = 5 }
	})
	self.dragbutton:SetBackdropColor(1,0,0,.4)

	self.dragbutton:SetMovable(true)
	self.dragbutton:RegisterForDrag("LeftButton")
	self.dragbutton:SetScript("OnDragStart", function() this.owner.dragbutton:StartMoving() end )
	self.dragbutton:SetScript("OnDragStop",
		function()
			this.owner.dragbutton:StopMovingOrSizing()
			local _,_,_,x,y = this:GetPoint("CENTER")
			this.owner.db.profile.x = x
			this.owner.db.profile.y = y
		end
	)
	-- self.dragbutton:RegisterForClicks("RightButtonUp")
	-- self.dragbutton:SetScript("OnClick", function() self:UpdateLock() end);

	self.dragtext = self.dragbutton:CreateFontString(nil, "OVERLAY")
	self.dragtext.owner = self
	self.dragtext:SetFontObject(GameFontNormalSmall)
	self.dragtext:ClearAllPoints()
	self.dragtext:SetTextColor(1, 1, 1, 1)
	self.dragtext:SetWidth(200)
	self.dragtext:SetHeight(25)
	self.dragtext:SetPoint("TOPLEFT", self.dragbutton, "TOPLEFT")
	self.dragtext:SetJustifyH("CENTER")
	self.dragtext:SetJustifyV("MIDDLE")
	self.dragtext:SetText(L["DRAG HERE"])

	self.msgframe = CreateFrame("MessageFrame")
	self.msgframe.owner = self
	self.msgframe:ClearAllPoints()
	self.msgframe:SetWidth(600)
	self.msgframe:SetHeight(160) -- self.db.profile.height)
	self.msgframe:SetPoint("TOP", self.dragbutton, "TOP", 0, 0)
	if self.db.profile.insertmode == L["Bottom"] then
		self.msgframe:SetInsertMode("BOTTOM")
	else
		self.msgframe:SetInsertMode("TOP")
	end
	self.msgframe:SetFrameStrata("HIGH")
	self.msgframe:SetToplevel(true)

	self:UpdateLock()
	self:SetFont()

	self.msgframe:Show()
end

function GirlFriend:UpdateLock()
	if not self.msgframe then self:SetupFrames() end
	if self.db.profile.lock then
		self.dragbutton:SetMovable(false)
		self.dragbutton:RegisterForDrag()
		self.msgframe:SetBackdrop(nil)
		self.msgframe:SetBackdropColor(0,0,0,0)
		self.dragbutton:Hide()
	else
		self.dragbutton:Show()
		self.dragbutton:SetMovable(true)
		self.dragbutton:RegisterForDrag("LeftButton")
		self.msgframe:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right =5, top = 5, bottom = 5 }
		})
		self.msgframe:SetBackdropColor(1,0,0,.4)
	end
end

function GirlFriend:TitleCase(message)
	message = string.gsub(message, "%_", " ")
	return string.gsub(message, "(%a)([%w']*)", function (first,last) return strupper(first)..strlower(last); end);
end

--[[ Custom event --------------------------------------------------------------------]]

--
function GirlFriend:GirlFriend_Message(message, author, event)
	if not message then return end
	local type = strsub(event, 10);
	local info = ChatTypeInfo[type];
	local frame = self.msgframe
	local typeF = self:TitleCase(type)
	
	if (event == "CHAT_MSG_WHISPER") then typeF = L["Whisper from"]; end
	if (event == "CHAT_MSG_WHISPER_INFORM") then typeF = L["Whisper to"]; end

	if frame then frame:AddMessage("["..typeF.."] ["..author.."]: "..message, info.r or 1, info.g or 1, info.b or 1, 1, UIERRORS_HOLD_TIME) end
end

--[[ Subscribed events ---------------------------------------------------------------]]

function GirlFriend:CHAT_MSG_GUILD(message, author)
	--[[ arg1 - Message that was sent | arg2 - Author | arg3 - Language that the message was sent in ]]
	
	if (GirlFriend.db.profile.type.guild or GirlFriend.db.profile.name[strlower(author)]) then
		self:TriggerEvent("GirlFriend_Message", message, author, "CHAT_MSG_GUILD");
	end 
end

function GirlFriend:CHAT_MSG_OFFICER(message, author)
	--[[ arg1 - Message that was received | arg2 - Author | arg3 - Language used ]]
	
	if (GirlFriend.db.profile.type.officer or GirlFriend.db.profile.name[strlower(author)]) then
		self:TriggerEvent("GirlFriend_Message", message, author, "CHAT_MSG_OFFICER");
	end
end

function GirlFriend:CHAT_MSG_PARTY(message, author)
	--[[ arg1 - Message that was received | arg2 - Author | arg3 - Language used ]]
	
	if (GirlFriend.db.profile.type.party or GirlFriend.db.profile.name[strlower(author)]) then
		self:TriggerEvent("GirlFriend_Message", message, author, "CHAT_MSG_PARTY");
	end
end

function GirlFriend:CHAT_MSG_RAID(message, author)
	--[[ arg1 - chat message	| arg2 - author | arg3 - language ]]
	
	if (GirlFriend.db.profile.type.raid or GirlFriend.db.profile.name[strlower(author)]) then
		self:TriggerEvent("GirlFriend_Message", message, author, "CHAT_MSG_RAID");
	end
end

function GirlFriend:CHAT_MSG_RAID_LEADER(message, author)
	--[[ arg1 - chat message | arg2 - author | arg3 - language ]]
	
	if (GirlFriend.db.profile.type.raidleader or GirlFriend.db.profile.name[strlower(author)]) then
		self:TriggerEvent("GirlFriend_Message", message, author, "CHAT_MSG_RAID_LEADER");
	end
end

function GirlFriend:CHAT_MSG_RAID_WARNING(message, author)
	--[[ arg1 - chat message | arg2 - author | arg3 - language ]]
	
	if (GirlFriend.db.profile.type.raidwarning or GirlFriend.db.profile.name[strlower(author)]) then
		--self:TriggerEvent("GirlFriend_Message", message, author, "CHAT_MSG_RAID_WARNING");
	end
end

function GirlFriend:CHAT_MSG_SAY(message, author)
	--[[ arg1 - chat message | arg2 - author | arg3 - language ]]
	
	if (GirlFriend.db.profile.type.say or GirlFriend.db.profile.name[strlower(author)]) then
		self:TriggerEvent("GirlFriend_Message", message, author, "CHAT_MSG_SAY");
	end
end

function GirlFriend:CHAT_MSG_WHISPER(message, author)
	--[[ arg1 - Message received | arg2 - Author | arg6 - status ]]
	
	if (GirlFriend.db.profile.type.whisper or GirlFriend.db.profile.name[strlower(author)]) then
	 self:TriggerEvent("GirlFriend_Message", message, author, "CHAT_MSG_WHISPER");
	end
end

function GirlFriend:CHAT_MSG_WHISPER_INFORM(message, receiver)
	--[[ arg1  - Message sent | arg2 - Player who was sent the whisper | arg3 - Language ]]
	
	local author = UnitName("player");
	--if (GirlFriend.db.profile.type.whisperout or GirlFriend.db.profile.name[strlower(author)]) then
	if (GirlFriend.db.profile.type.whisperout or GirlFriend.db.profile.name[strlower(receiver)]) then
		self:TriggerEvent("GirlFriend_Message", message, receiver, "CHAT_MSG_WHISPER_INFORM");
	end
end

function GirlFriend:CHAT_MSG_YELL(message, author)
	--[[ arg1 - Message that was received | arg2 - Author | arg3 - Language used	]]
	
	if (GirlFriend.db.profile.type.yell or GirlFriend.db.profile.name[strlower(author)]) then
		self:TriggerEvent("GirlFriend_Message", message, author, "CHAT_MSG_YELL");
	end
end