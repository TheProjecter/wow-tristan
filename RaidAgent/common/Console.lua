local L = AceLibrary("AceLocale-2.2"):new("RaidAgent")
local dewdrop = AceLibrary("Dewdrop-2.0")

--[[ Build Options ]]
function RaidAgent:BuildOptions()
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
			RaidStrength = {
				type = "toggle",
				name = L["RaidStrength_name"],
				desc = L["RaidStrength_desc"],
			  get = function() return DB.RaidStrength end,
			  set = function() DB.RaidStrength = not DB.RaidStrength self:Update() end,
			  order = 5,
			},
			RaidNumbersFu = {
				type = "toggle",
				name = L["RaidNumbersFu_name"],
				desc = L["RaidNumbersFu_desc"],
			  get = function() return DB.RaidNumbersFu end,
			  set = function() DB.RaidNumbersFu = not DB.RaidNumbersFu self:Update() end,
			  order = 5,
			},
			raidstrengthspacer = {
				type = "header",
				order = 10,
			},
			sendSync = {
				type = "execute",
				name = L["sync_name"],
				desc = L["sync_desc"],
			  func = function() self:Ping(true) end,
				order = 11,
			},
			sendUpdatedSync = {
				type = "execute",
				name = L["updateSync_name"],
				desc = L["updateSync_desc"],
			  func = function() self:UpdateOwnCensusData(true) end,
				order = 12,
			},
			askForSync = {
				type = "execute",
				name = L["askForSync_name"],
				desc = L["askForSync_desc"],
			  func = function() self:SendAddonMessage("sync") end,
				order = 13,
			},
			lookup = {
				type = "text",
				name = L["lookup_name"],
				desc = L["lookup_desc"],
			  get = function() return "" end,
			  set = function(aName) self:PrintFullCensusData(aName, false) end,
			  usage = "<Any string>",
				order = 14,
			},
			special = {
				type = "execute",
				name = L["special_name"],
				desc = L["special_desc"],
			  func = function() self:ShowCensusMenu() end,
				order = 15,
			},
			syncspacer = {
				type = "header",
				order = 16,
			},
			autoML = {
				type = "text",
				name = L["autoML_name"],
				desc = L["autoML_desc"],
			  get = function() return self.autoMLName end,
			  set = function(arg1) self.autoMLName = self:PlayerNameCase(arg1) self:Update() end,
			  usage = "<Any string>",
				order = 17,
			},
			randomML = {
				type = "toggle",
				name = L["randomML_name"],
				desc = L["randomML_desc"],
				get = function() return self.randomML end,
	  		set = function() self.randomML = not self.randomML end,
				order = 18,
			},
			autoMLItems = {
				type = "group",
	  		name = L["autoMLItems_name"],
	  		desc = L["autoMLItems_desc"],
	  		args = {
	  			BoE = {
	  				type = "toggle",
						name = L["BoE_name"],
						desc = L["BoE_desc"],
						get = function() return DB.autoML.BoE end,
			  		set = function() DB.autoML.BoE = not DB.autoML.BoE end,
						order = 1,
	  			},
	  			MC = {
	  				type = "toggle",
						name = L["MC_name"],
						desc = L["MC_desc"],
						get = function() return DB.autoML.MC end,
			  		set = function() DB.autoML.MC = not DB.autoML.MC end,
						order = 2,
	  			},
	  			BWL = {
	  				type = "toggle",
						name = L["BWL_name"],
						desc = L["BWL_desc"],
						get = function() return DB.autoML.BWL end,
			  		set = function() DB.autoML.BWL = not DB.autoML.BWL end,
						order = 2,
	  			},
	  			ZG = {
	  				type = "toggle",
						name = L["ZG_name"],
						desc = L["ZG_desc"],
						get = function() return DB.autoML.ZG end,
			  		set = function() DB.autoML.ZG = not DB.autoML.ZG end,
						order = 3,
	  			},
	  			AQ = {
	  				type = "toggle",
						name = L["AQ_name"],
						desc = L["AQ_desc"],
						get = function() return DB.autoML.AQ end,
			  		set = function() DB.autoML.AQ = not DB.autoML.AQ end,
						order = 4,
	  			},
	  			Naxx = {
	  				type = "toggle",
						name = L["Naxx_name"],
						desc = L["Naxx_desc"],
						get = function() return DB.autoML.Naxx end,
			  		set = function() DB.autoML.Naxx = not DB.autoML.Naxx end,
						order = 5,
	  			},
	  		},
	  		order = 19,
			},
			NoAnnounce = {
				type = "toggle",
				name = L["NoAnnounce_name"],
				desc = L["NoAnnounce_desc"],
				get = function() return DB.autoLootQuiet end,
	  		set = function() DB.autoLootQuiet = not DB.autoLootQuiet end,
				order = 20,
			},
			lastupdatespacer = {
				type = "header",
				order = 99,
			},
			headerLastUpdate = {
				type = "header",
				name = self:SetHexColor("Tristan", self:GoFigure(L["LastUpdatePrefixed"], self.lastUpdateDate)),
				order = 100,
			},
		},
	}
	
	if (not self.tAuthorInDD) then rVal.args.headerAuthor = nil end
	if (not self.tVersionInDD) then rVal.args.headerVersion = nil end
	
	return rVal
end

function RaidAgent:ShowCensusMenu()
	local ddOpts = nil
	local DB = self.db.profile
	if (not DB.censusOptions) then DB.censusOptions = { } end
	
	ddOpts = {
	  type = "group",
	  args = {
	  	headerName = {
				type = "execute",
				name = self:FancyName(),
				desc = self:FancyName(),
				icon = self.tTitleIcon,
				iconHeight = 16,
				iconWidth = 16,
				func = function() self:PrintAddonInfo() end,
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
			--[[datespacer = {
				type = "header",
				order = 6,
			},]]
			headerLastUpdate = {
				type = "header",
				name = self:SetHexColor("Tristan", self:GoFigure(L["LastUpdatePrefixed"], self.lastUpdateDate)),
				order = 7,
			},
		},
	}
	
	for englishClass, classTable in pairs(DB.censusOptions) do
		displayClass = englishClass
		if (L:HasTranslation(englishClass)) then displayClass = L[englishClass] end
		ddOpts.args[englishClass] = {
			type = "text",
			name = displayClass,
			desc = displayClass,
		  get = function() return self:ShowForClass(englishClass) end,
		  set = function(arg1) self:SetShowForClass(englishClass, arg1) end,
		  order = 5,
		}
		
		local haveData = false
		for talentKey, talentName in pairs(classTable) do
			ddOpts.args[englishClass].validate = classTable
			haveData = true
		end
		
		if (not haveData) then
			ddOpts.args[englishClass] = nil
		end
	end
	
	if (not self.tAuthorInDD) then ddOpts.args.headerAuthor = nil end
	if (not self.tVersionInDD) then ddOpts.args.headerVersion = nil end
	
	dewdrop:Open(UIParent, 'children', function() dewdrop:FeedAceOptionsTable(ddOpts) end, 'cursorX', true, 'cursorY', true)
end