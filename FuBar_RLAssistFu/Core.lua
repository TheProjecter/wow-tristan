RLAssistFu = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "FuBarPlugin-2.0", "AceEvent-2.0")
local Tablet = AceLibrary("Tablet-2.0")
local L = AceLibrary("AceLocale-2.2"):new("FuBar_RLAssistFu")

StaticPopupDialogs["RLAssistFUCONFIRM"] = { }
StaticPopupDialogs["RLAssistFUINFORM"] = { }

RLAssistFu:RegisterDB("RLAssistFuDB")
RLAssistFu:RegisterDefaults('char', {
	useConfirm = true,
	countdownMessage = L["Countdown_message"],
	countdownGoMessage = L["Countdown_GO"],
	countdownAbortMessage = L["Countdown_Abort"],
	pullingMessage = L["Pulling_message"],
})

RLAssistFu.hasIcon = "Interface\\Icons\\Ability_Warrior_BattleShout"
RLAssistFu.hideMenuTitle = true
RLAssistFu.hasNoColor = true
RLAssistFu.clickableTooltip = true
RLAssistFu.countdownInterval = { [5] = true, [15] = true, [20] = true}

RLAssistFu.OnMenuRequest = {
	type = "group",
	args = {
		header = {
			type = "header",
			name = L["addonname"],
			icon = RLAssistFu.hasIcon,
			iconHeight = 16,
			iconWidth = 16,
			order = 1
		},
		headerspacer = {
			type = "header",
			order = 2
		},
		confirm = {
			type = "toggle",
			name = L["confirm_name"],
			desc = L["confirm_desc"],
			get = function() return RLAssistFu.db.char.useConfirm end,
			set = function() RLAssistFu.db.char.useConfirm = not RLAssistFu.db.char.useConfirm end,
			order = 3
		},
		resetPositions = {
			type = "execute",
		  name = L["resetpos_name"],
			desc = L["resetpos_desc"],
		  func = function() RLAssistFu:ResetPositions() end,
		  order = 4,
		},
		messagesspacer = {
			type = "header",
			order = 5
		},
		messages = {
			type = "group",
			name = L["messages_name"],
			desc = L["messages_desc"],
			order = 6,
			args = {
				countdownMessage = {
					type = "text",
				  name = L["countdownMessage_name"],
					desc = L["countdownMessage_desc"],
					get = function() return RLAssistFu.db.char.countdownMessage end,
				  set = function(arg1) RLAssistFu.db.char.countdownMessage = arg1 end,
				  usage = "<any string>",
		      order = 1,
				},
				countdownGoMessage = {
					type = "text",
				  name = L["countdownGoMessage_name"],
					desc = L["countdownGoMessage_desc"],
					get = function() return RLAssistFu.db.char.countdownGoMessage end,
				  set = function(arg1) RLAssistFu.db.char.countdownGoMessage = arg1 end,
				  usage = "<any string>",
		      order = 2,
				},
				countdownAbortMessage = {
					type = "text",
				  name = L["countdownAbortMessage_name"],
					desc = L["countdownAbortMessage_desc"],
					get = function() return RLAssistFu.db.char.countdownAbortMessage end,
				  set = function(arg1) RLAssistFu.db.char.countdownAbortMessage = arg1 end,
				  usage = "<any string>",
		      order = 3,
				},
				pullingMessage = {
					type = "text",
				  name = L["pullingMessage_name"],
					desc = L["pullingMessage_desc"],
					get = function() return RLAssistFu.db.char.pullingMessage end,
				  set = function(arg1) RLAssistFu.db.char.pullingMessage = arg1 end,
				  usage = "<any string>",
		      order = 4,
				},
			},
		},
		resetTexts = {
			type = "execute",
		  name = L["resettxt_name"],
			desc = L["resettxt_desc"],
		  func = function() RLAssistFu:ResetTexts() end,
		  order = 7,
		},
	},
}

function RLAssistFu:OnInitialize()
	self.AbortCountDownButton = CreateFrame("Button", "RLAssistFuButtonAbort", self.AbortCountDownButton, "OptionsButtonTemplate")
	self.AbortCountDownButton:SetText(L["AbortButtonText"])
	self.AbortCountDownButton:SetWidth(115)
	self.AbortCountDownButton:SetHeight(20)
	self.AbortCountDownButton:SetPoint("CENTER", 0, 100)
	self.AbortCountDownButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	self.AbortCountDownButton:SetScript("OnClick",self.AbortCountDown)
	self.AbortCountDownButton:RegisterForDrag("LeftButton")
	self.AbortCountDownButton:SetMovable(true)
	self.AbortCountDownButton:SetScript("OnDragStart", function() if IsAltKeyDown() then self.AbortCountDownButton:StartMoving() end end)
	self.AbortCountDownButton:SetScript("OnDragStop", function() self.AbortCountDownButton:StopMovingOrSizing() end)
	self.AbortCountDownButton:SetScript("OnEnter", function() GameTooltip_SetDefaultAnchor(GameTooltip, self.AbortCountDownButton) GameTooltip:AddLine(L["AbortButtonTooltip"]) GameTooltip:Show() end)
	self.AbortCountDownButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self.AbortCountDownButton:Hide()
	
	self.PullingButton = CreateFrame("Button", "RLAssistFuButtonPulling", self.PullingButton, "OptionsButtonTemplate")
	self.PullingButton:SetText(L["PullingButtonText"])
	self.PullingButton:SetWidth(115)
	self.PullingButton:SetHeight(20)
	self.PullingButton:SetPoint("CENTER", 0, 120)
	self.PullingButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	self.PullingButton:SetScript("OnClick", function() if (arg1=="LeftButton") then self:AnnouncePull() elseif (arg1=="RightButton") then self.PullingButton:Hide() end end)
	self.PullingButton:RegisterForDrag("LeftButton")
	self.PullingButton:SetMovable(true)
	self.PullingButton:SetScript("OnDragStart", function() if IsAltKeyDown() then self.PullingButton:StartMoving() end end)
	self.PullingButton:SetScript("OnDragStop", function() self.PullingButton:StopMovingOrSizing() end)
	self.PullingButton:SetScript("OnEnter", function() GameTooltip_SetDefaultAnchor(GameTooltip, self.PullingButton) GameTooltip:AddLine(L["PullingButtonTooltip"]) GameTooltip:Show() end)
	self.PullingButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
	self.PullingButton:Hide()
	

  --[[ Register chat commands ]]
  self:RegisterChatCommand(L["consolecommands"], self.OnMenuRequest)
end

function RLAssistFu:OnEnable()
	self:Print(L["translator"])
end

function RLAssistFu:OnClick()
	self:AnnouncePull()
end

function RLAssistFu:OnTextUpdate()
	self:SetText(L["addonnameFu"])
end

function RLAssistFu:StartCountDown(fromNum)
	if (self:IsEventScheduled("DoCountDown")) then
		self:Inform(L["Countdown_AllreadyRunning"])
		return;
	end
	RLAssistFu.countDown = fromNum
	self.AbortCountDownButton:Show()
	self:ScheduleRepeatingEvent("DoCountDown", self.DoCountDown, 1, self)
	-- if (IsRaidLeader()) then DoReadyCheck() end
end

function RLAssistFu:DoCountDown()
	if not (self:IsEventScheduled("DoCountDown")) then return end
	local message = string.gsub(self.db.char.countdownMessage, "{n}", RLAssistFu.countDown)
	local receiver = "RAID"
	if ((IsRaidLeader()) or (IsRaidOfficer())) then receiver = "RAID_WARNING" end
	
	if (RLAssistFu.countDown == 0) then
		RLAssistFu:SendRaidMessage(self.db.char.countdownGoMessage, receiver)
		self:StopCountDown()
	elseif (mod(RLAssistFu.countDown, 30) == 0) then
		RLAssistFu:SendRaidMessage(message, receiver)
	elseif (self.countdownInterval[RLAssistFu.countDown]) then
		RLAssistFu:SendRaidMessage(message, receiver)
	elseif ((RLAssistFu.countDown < 5) and (mod(RLAssistFu.countDown, 2) == 1)) then
		RLAssistFu:SendRaidMessage(message, receiver)
	end
	RLAssistFu.countDown = RLAssistFu.countDown - 1
end

function RLAssistFu:StopCountDown()
	self:CancelScheduledEvent("DoCountDown")
	self.AbortCountDownButton:Hide()
end

function RLAssistFu:AbortCountDown() --[[ Can't use 'self' in this part so using 'RLAssistFu' here ]]
	if not (RLAssistFu:IsEventScheduled("DoCountDown")) then return end
	RLAssistFu:StopCountDown()
	
	local receiver = "RAID"
	if ((IsRaidLeader()) or (IsRaidOfficer())) then receiver = "RAID_WARNING" end
	
	if (RLAssistFu.announceAbort) then
		
		RLAssistFu:SendRaidMessage(RLAssistFu.db.char.countdownAbortMessage, receiver)
		RLAssistFu.announceAbort = nil
	end
end

function RLAssistFu:SendRaidMessage(message, receiver)
	self.announceAbort = true
	if ((self.debugging) or (not UnitInRaid("player"))) then
		UIErrorsFrame:AddMessage(message, 255/255, 127/255, 0/255)
	else
		SendChatMessage(message, receiver)
	end
end

function RLAssistFu:AnnouncePull() --[[ Can't use 'self' in this part so using 'RLAssistFu' here ]]
	local receiver = "RAID"
	if ((IsRaidLeader()) or (IsRaidOfficer())) then receiver = "RAID_WARNING" end
	
	RLAssistFu:SendRaidMessage(RLAssistFu.db.char.pullingMessage, receiver)
end

function RLAssistFu:Confirm(text, onAccept, timeout, whileDead)
	if (self.db.char.useConfirm) then
		if (not timeout) then timeout = 0 end
		if (not whileDead) then whileDead = 1 end
		
		StaticPopupDialogs["RLAssistFUCONFIRM"].text = text
		StaticPopupDialogs["RLAssistFUCONFIRM"].button1 = L["Yes"]
		StaticPopupDialogs["RLAssistFUCONFIRM"].button2 = L["No"]
		StaticPopupDialogs["RLAssistFUCONFIRM"].timeout = timeout
		StaticPopupDialogs["RLAssistFUCONFIRM"].whileDead = whileDead
		StaticPopupDialogs["RLAssistFUCONFIRM"].OnAccept = onAccept
		StaticPopup_Show("RLAssistFUCONFIRM")
	else
		pcall(onAccept) -- Just execute the damn function
	end
end

function RLAssistFu:Inform(text, timeout, whileDead)
	if (not timeout) then timeout = 0 end
	if (not whileDead) then whileDead = 1 end
	
	StaticPopupDialogs["RLAssistFUINFORM"].text = text
	StaticPopupDialogs["RLAssistFUINFORM"].button1 = L["Ok"]
	StaticPopupDialogs["RLAssistFUINFORM"].button2 = nil
	StaticPopupDialogs["RLAssistFUINFORM"].timeout = timeout
	StaticPopupDialogs["RLAssistFUINFORM"].whileDead = whileDead
	StaticPopupDialogs["RLAssistFUINFORM"].OnAccept = nil
	StaticPopup_Show("RLAssistFUINFORM")
end

function RLAssistFu:OnTooltipUpdate()
	cat = Tablet:AddCategory(
  	'columns', 1
  )
  
  cat:AddLine(
    'text', " "
  )
  cat:AddLine(
  	'text', (string.gsub(L["Countdown"], "{n}", 30)),
    'func', function() RLAssistFu:Confirm((string.gsub(L["Countdown_confirm"], "{n}", 30)), function() RLAssistFu:StartCountDown(30) end) end,
    'justify', "CENTER"
  )
  cat:AddLine(
  	'text', (string.gsub(L["Countdown"], "{n}", 20)),
    'func', function() RLAssistFu:Confirm((string.gsub(L["Countdown_confirm"], "{n}", 20)), function() RLAssistFu:StartCountDown(20) end) end,
    'justify', "CENTER"
  )
  cat:AddLine(
  	'text', (string.gsub(L["Countdown"], "{n}", 15)),
    'func', function() RLAssistFu:Confirm((string.gsub(L["Countdown_confirm"], "{n}", 15)), function() RLAssistFu:StartCountDown(15) end) end,
    'justify', "CENTER"
  )
  
  cat:AddLine(
    'text', " "
  )
  local countdownNum = 30
  cat:AddLine(
  	'text', L["PullButton"],
    'func', function() RLAssistFu.PullingButton:Show() end,
    'justify', "CENTER"
  )
  
  cat:AddLine(
    'text', " "
  )
  cat:AddLine(
  	'text', L["LeaveParty"],
    'func', function() RLAssistFu:Confirm(L["LeaveParty_confirm"], function() LeaveParty() end) end,
    'justify', "CENTER"
  )
    
  Tablet:SetHint(L["FuBarHint"])
end

function RLAssistFu:ResetPositions()
	self.AbortCountDownButton:ClearAllPoints()
	self.AbortCountDownButton:SetPoint("CENTER", 0, 100)
	self.PullingButton:ClearAllPoints()
	self.PullingButton:SetPoint("CENTER", 0, 120)
end

function RLAssistFu:ResetTexts()
	self.db.char.countdownMessage = L["Countdown_message"]
	self.db.char.countdownGoMessage = L["Countdown_GO"]
	self.db.char.countdownAbortMessage = L["Countdown_Abort"]
	self.db.char.pullingMessage = L["Pulling_message"]
end