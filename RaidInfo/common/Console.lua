local L = AceLibrary("AceLocale-2.2"):new("RaidInfo")
local L2 = AceLibrary("AceLocale-2.2"):new("RaidInfoSpecial")
local dewdrop = AceLibrary("Dewdrop-2.0")

--[[ Build Options ]]
function RaidInfo:BuildOptions()
	local DB = self.db.profile
	
	local rVal = {
		type = "group",
	  args = {
	  	headerName = {
				type = "header",
				name = self:FancyName(),
				-- desc = self:FancyName(),
				icon = self.tTitleIcon,
				iconHeight = 16,
				iconWidth = 16,
				-- func = function() self:PrintAddonInfo() end,
				order = 1,
			},
			headerAuthor = {
				type = "header",
				name = self:SetHexColor("Tristan", self:GoFigure(L["AuthorPrefixed"], self.author)),
				order = 2,
			},
			headerVersion = {
				type = "header",
				name = self:SetHexColor("Tristan", self:GoFigure(L["VersionPrefixed"], self.version)),
				order = 3,
			},
			headerspacer = {
				type = "header",
				order = 4,
			},
			SendInCombat = {
				type = "toggle",
				name = L["SendInCombat_name"],
				desc = L["SendInCombat_desc"],
			  get = function() return DB.SendInCombat end,
			  set = function() DB.SendInCombat = not DB.SendInCombat end,
			  order = 5,
			},
			ToggleAnchor = {
				type = "toggle",
				name = L["ToggleAnchor_name"],
				desc = L["ToggleAnchor_desc"],
			  get = function() return DB.anchorframehidden end,
			  set = function() 
			  	DB.anchorframehidden = not DB.anchorframehidden
			  	self:ToggleAnchorFrame()
			  end,
			  order = 6,
			},
			UpdateTooltip = {
				type = "toggle",
				name = L["UpdateTooltip_name"],
				desc = L["UpdateTooltip_desc"],
			  get = function() return DB.updatetooltip end,
			  set = function() 
			  	DB.updatetooltip = not DB.updatetooltip
			  	self:ToggleUpdateTooltip()
			  end,
			  order = 6,
			},
			autoshowspacer = {
				type = "header",
				order = 19,
			},
			AutoShow = {
				type = "group",
				name = L["AutoShow_name"],
				desc = L["AutoShow_desc"],
			  order = 20,
			  args = {
			  }
			},
			lastupdatespacer = {
				type = "header",
				order = 98,
			},
			headerLastUpdate = {
				type = "header",
				name = self:SetHexColor("Tristan", self:GoFigure(L["LastUpdatePrefixed"], self.lastUpdateDate)),
				order = 99,
			},
		},
	}
	
	for base,localized in L2:GetIterator() do
    rVal.args.AutoShow.args[base] = {
    	type = "toggle",
				name = localized,
				desc = localized,
			  get = function() return self.db.char[base] end,
			  set = function() 
			  	self.db.char[base] = not self.db.char[base]
			  end,
    }
	end
	
	if (not self.tAuthorInDD) then rVal.args.headerAuthor = nil end
	if (not self.tVersionInDD) then rVal.args.headerVersion = nil end
	
	return rVal
end