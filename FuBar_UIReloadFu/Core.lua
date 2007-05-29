UIReloadFu = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "FuBarPlugin-2.0", "AceEvent-2.0")
local Tablet = AceLibrary("Tablet-2.0")
local L = AceLibrary("AceLocale-2.2"):new("FuBar_UIReloadFu")

-- StaticPopupDialogs["UIRELOADFUCONFIRM"] = { text = "Do you really want to Reload the User Interface?\n\nSome changes may get lost!", button1 = "Yes", button2 = "No", timeout = 0, whileDead = 1, OnAccept = function() UIReloadFu:DoReload() end}
StaticPopupDialogs["UIRELOADFUCONFIRM"] = { }
StaticPopupDialogs["UIRELOADFUINFORM"] = { }

UIReloadFu:RegisterDB("UIReloadFuDB")
UIReloadFu:RegisterDefaults('char', {
	useConfirm = true,
})

UIReloadFu.hasIcon = "Interface\\Icons\\Ability_Mount_Dreadsteed"
UIReloadFu.hideMenuTitle = true
UIReloadFu.hasNoColor = true
UIReloadFu.hasNoText = true
UIReloadFu.clickableTooltip = true
UIReloadFu.defaultPosition = "CENTER"

UIReloadFu.OnMenuRequest = {
	type = 'group',
	args = {
		header = {
			type = "header",
			name = L["addonname"],
			icon = UIReloadFu.hasIcon,
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
			get = function() return UIReloadFu.db.char.useConfirm end,
			set = function() UIReloadFu.db.char.useConfirm = not UIReloadFu.db.char.useConfirm end,
			order = 3
		},
	},
}

function UIReloadFu:OnInitialize()
	--[[ Register chat commands ]]
  self:RegisterChatCommand(L["consolecommands"], self.OnMenuRequest)
end

function UIReloadFu:OnEnable()
	self:Print(L["translator"])
end

function UIReloadFu:OnClick()
	self:Confirm(L["ReloadUI_confirm"], function() ReloadUI() end)
end

function UIReloadFu:Confirm(text, onAccept, timeout, whileDead)
	if (self.db.char.useConfirm) then
		if (not timeout) then timeout = 0 end
		if (not whileDead) then whileDead = 1 end
		
		StaticPopupDialogs["UIRELOADFUCONFIRM"].text = text
		StaticPopupDialogs["UIRELOADFUCONFIRM"].button1 = L["Yes"]
		StaticPopupDialogs["UIRELOADFUCONFIRM"].button2 = L["No"]
		StaticPopupDialogs["UIRELOADFUCONFIRM"].timeout = timeout
		StaticPopupDialogs["UIRELOADFUCONFIRM"].whileDead = whileDead
		StaticPopupDialogs["UIRELOADFUCONFIRM"].OnAccept = onAccept
		StaticPopup_Show("UIRELOADFUCONFIRM")
	else
		pcall(onAccept) -- Just execute the damn function
	end
end

function UIReloadFu:Inform(text, timeout, whileDead)
	if (not timeout) then timeout = 0 end
	if (not whileDead) then whileDead = 1 end
	
	StaticPopupDialogs["UIRELOADFUINFORM"].text = text
	StaticPopupDialogs["UIRELOADFUINFORM"].button1 = L["Ok"]
	StaticPopupDialogs["UIRELOADFUINFORM"].button2 = nil
	StaticPopupDialogs["UIRELOADFUINFORM"].timeout = timeout
	StaticPopupDialogs["UIRELOADFUINFORM"].whileDead = whileDead
	StaticPopupDialogs["UIRELOADFUINFORM"].OnAccept = nil
	StaticPopup_Show("UIRELOADFUINFORM")
end

function UIReloadFu:OnTooltipUpdate()
	cat = Tablet:AddCategory(
  	'columns', 1
  )
  
  cat:AddLine(
    'text', " "
  )
  cat:AddLine(
    'text', L["ReloadUI"],
    'func', function() UIReloadFu:Confirm(L["ReloadUI_confirm"], function() ReloadUI() end) end,
    'justify', "CENTER"
  )
  cat:AddLine(
  	'text', L["LeaveParty"],
    'func', function() UIReloadFu:Confirm(L["LeaveParty_confirm"], function() LeaveParty() end) end,
    'justify', "CENTER"
  )
  
  Tablet:SetHint(L["FuBarHint"])
end