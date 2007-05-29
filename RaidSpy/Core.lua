--[[ *** Create Ace2 AddOn *** ]]
RaidSpy = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDebug-2.0", "AceConsole-2.0", "AceDB-2.0", "FuBarPlugin-2.0")
local L = AceLibrary("AceLocale-2.2"):new("RaidSpy")
local Tablet = AceLibrary("Tablet-2.0")

-- RaidSpy.hasIcon = "Interface\\Icons\\INV_Misc_Spyglass_03"
RaidSpy.hasIcon = "Interface\\AddOns\\RaidSpy\\icon"
RaidSpy.hideMenuTitle = true
RaidSpy.hasNoColor = true
RaidSpy.tooltipHiddenWhenEmpty = true
RaidSpy.tAuthorInDD = true

--[[ *** Initialize the AddOn *** ]]
function RaidSpy:OnInitialize()
	--[[ Register a DB for saving ]]
	self:RegisterDB("RaidSpyDB")
	self:RegisterDefaults('profile', {
		checks = {
			item = true,
			dura = true,
			reag = true,
			resi = true,
			chatR = true,
			erroR = true,
		},
		spies = {
			duraSpy = false,
			itemSpy = false,
		},
	})
	
	--[[ cleanup old crap ]]
	self.db.profile.checks.saveData = nil
	
	self:BuildOpts()
	self.OnMenuRequest = self.opts
  
  --[[ Register chat commands ]]    
  self:RegisterChatCommand(L["consolecommands"], self.opts)
  
  --[[ Tell user we loaded ]]
	self:Print(L["translator"])
end

--[[ *** Do stuff when enabled? *** ]]
function RaidSpy:OnEnable()
	self.saved = { }
	
	--[[ Register Events for example ]]
  self:RegisterEvent("CHAT_MSG_ADDON")
  self:RegisterEvent("RAID_ROSTER_UPDATE")
end

--[[ *** Do stuff when disabled? *** ]]
function RaidSpy:OnDisable()
  --[[ Unregister Events for example ]]
  self:UnregisterAllEvents()
end
--[[ *** FuBar Text *** ]]
function RaidSpy:OnTextUpdate()
    self:SetText(self:FuName())
end

local textR, textG, textB = 230/255, 204/255, 128/255
--[[ *** FuBar Tooltip *** ]]
function RaidSpy:OnTooltipUpdate()
	Tablet:SetTitle(RaidSpy:FuName())
	local cat = Tablet:AddCategory(
  	'columns', 1,
  	'child_textR', textR,
  	'child_textG', textG,
  	'child_textB', textB
  )
  
  if UnitInRaid("player") then
  	if (not self.raidMembers) then self:RAID_ROSTER_UPDATE() end
  	
  	if (self:ActiveSpies()) then
  		if ((self.saved.itemSpy) or (self.saved.duraSpy)) then
  			cat:AddLine(
			    'text', self:SetHexColor("Tristan", "Spy Info (validity unknown ;)"),
			    'justify', "CENTER"
			  )
			  
			  cat = Tablet:AddCategory(
			  	'columns', 3,
			  	'hideBlankLine', true,
			  	'child_textR', textR,
			  	'child_textG', textG,
			  	'child_textB', textB,
			  	'child_text2R', textR,
			  	'child_text2G', textG,
			  	'child_text2B', textB,
			  	'child_text3R', textR,
			  	'child_text3G', textG,
			  	'child_text3B', textB,
			  	'child_text4R', textR,
			  	'child_text4G', textG,
			  	'child_text4B', textB,
			  	'child_text5R', textR,
			  	'child_text5G', textG,
			  	'child_text5B', textB,
			  	'child_text6R', textR,
			  	'child_text6G', textG,
			  	'child_text6B', textB
			  )
			  local infoData = { text = "Name", text2 = "Item", text3 = "Durability", text4 = "", text5 = "", text6 = "" }
			  cat:AddLine(infoData)
			  
			  for playername, _ in pairs(self.raidMembers) do
					local infoData = { text = "", text2 = "", text3 = "", text4 = "", text5 = "", text6 = "" }
					local isInteressting = false
				
				 	infoData["text"] = playername
				 	if (self.saved.itemSpy and self.db.profile.spies.itemSpy) then
					 	if (self.saved.itemSpy[playername]) then
					 		infoData["text2"] = self.saved.itemSpy[playername]
					 		isInteressting = true
					 	end
				 	end
				 	
				 	if (self.saved.duraSpy and self.db.profile.spies.duraSpy) then
					 	if (self.saved.duraSpy[playername]) then
					 		local p = math.floor(self.saved.duraSpy[playername]["cur"] / self.saved.duraSpy[playername]["max"] * 100)
					 		infoData["text3"] = p.."% ("..self.saved.duraSpy[playername]["broken"]..")"
					 		isInteressting = true
					 	end
				 	end
				 	
				 	if (isInteressting) then cat:AddLine(infoData) end
				end
			else
				cat:AddLine(
			    'text', "Spy has no info (yet)",
			    'justify', "CENTER"
			  )
			end
		else
  		cat:AddLine(
		    'text', "No spy is currently active",
		    'justify', "CENTER"
		  )
		end
	else
		cat:AddLine(
	    'text', "You are not in a raid",
	    'justify', "CENTER"
	  )
	end
  
  
  Tablet:SetHint(L["tabletHint"])
end

--[[ *** EVENTS *** ]]
function RaidSpy:CHAT_MSG_ADDON()
	if ( arg1 == "CTRA" and arg3 == "RAID" ) then
		local msg = string.gsub(arg2, "%$", "s");
		msg = string.gsub(msg, "§", "S");
		if (strsub(msg, strlen(msg)-7) == " ...hic!") then
			msg = strsub(msg, 1, strlen(msg)-8);
		end
		
		if (string.find(msg, "#")) then
			for k, v in pairs(self:Split(msg, "#")) do
				self:CheckEvent(arg4, v)
			end
		else
			self:CheckEvent(arg4, msg)
		end
	end
end

function RaidSpy:RAID_ROSTER_UPDATE()
	self.raidMembers = nil
	self.raidMembers = { }
	
	for i=1, GetNumRaidMembers() do
		self.raidMembers[(UnitName("raid"..i))] = true
	end
end

--[[ *** Functions *** ]]
function RaidSpy:CheckEvent(nick, msg)
	if (msg == "RSTC" and self.db.profile.checks.resi) then -- Resists
		self:Report(nick, L["ResistanceText"])
	elseif (msg == "REAC" and self.db.profile.checks.reag) then -- Reagents
		self:Report(nick, L["ReagentsText"])
	elseif (msg == "DURC" and self.db.profile.checks.dura) then --Durabillity
		self:Report(nick, L["DurabilityText"])
	elseif (string.find(msg, "^ITMC ") and self.db.profile.checks.item) then -- Items
		local _, _, itemName = string.find(msg, "^ITMC (.+)$")
		if (itemName) then
			if (self.db.profile.spies.itemSpy) then
				if (not self.saved.itemSpy) then self.saved.itemSpy = { } end
				for nick, info in pairs(self.saved.itemSpy) do
					if (not string.find(self.saved.itemSpy[nick], "^%~")) then  self.saved.itemSpy[nick] = "~"..self.saved.itemSpy[nick] end
				end
			end
			self:Report(nick, (string.gsub(L["ItemText"], "{i}", itemName)))
		end
	end
	
	--[[ Tihi ]]
	if (not self.saved) then self.saved = { } end
	if (not self:ActiveSpies()) then return end
	
	-- "ITM "..numitems.." "..itemname.." "..author
	if ((string.find(msg, "^ITM ")) and (self.db.profile.spies.itemSpy)) then
		if (not self.saved.itemSpy) then self.saved.itemSpy = { } end
		local _,_,numitems,itemname,requestby = string.find(msg, "^ITM ([-%d]+) (.+) ([^%s]+)$")
		self.saved.itemSpy[nick] = numitems.."x"..itemname
	end
	
	-- string.format("DUR %s %s %s %s", cur, max, broken, author)
	if ((string.find(msg, "^DUR ")) and (self.db.profile.spies.duraSpy)) then
		if (not self.saved.duraSpy) then self.saved.duraSpy = { } end
		local _,_,cur,max,broken,requestby = string.find(msg, "^DUR (%d+) (%d+) (%d+) ([^%s]+)$")
		self.saved.duraSpy[nick] = { }
		self.saved.duraSpy[nick]["cur"] = cur
		self.saved.duraSpy[nick]["max"] = max
		self.saved.duraSpy[nick]["broken"] = broken
	end
end

function RaidSpy:Report(nick, msg)
	if ((nick == UnitName("player")) and (not self.debugging)) then return end
	if (self.db.profile.checks.chatR) then
		self:Print(nick.." "..msg)
	end
	if (self.db.profile.checks.erroR) then
		UIErrorsFrame:AddMessage(L["AddOnErrorMessagePrefix"]..nick.." "..msg)
	end
end

function RaidSpy:Split(text, delimiter)
	local list = {}
  local pos = 1
  if strfind("", delimiter, 1) then -- this would result in endless loops
    error("delimiter matches empty string!")
  end
  while 1 do
    local first, last = strfind(text, delimiter, pos)
    if first then -- found?
      tinsert(list, strsub(text, pos, first-1))
      pos = last+1
    else
      tinsert(list, strsub(text, pos))
      break
    end
  end
  return list
end

function RaidSpy:PerformItemCheck(item)
	if (not UnitInRaid("player")) then
		self:Print(L["UnitNotInRaid"])
		return
	end
	if (IsAddOnLoaded("oRA2")) then
		-- IsRaidOfficer() -- IsRaidLeader()
		oRALItem:PerformItemCheck(item)
	elseif (IsAddOnLoaded("CT_RaidAssist")) then
		SlashCmdList["RAITEM"](item)
	else
		self:Print(L["cantdoitemcheck"])
	end
end

function RaidSpy:BuildOpts()
	self.opts = {
	  type = "group",
	  args = {
	  	headerName = {
				type = "header",
				name = self:FancyName(),
				-- desc = self:FancyName(),
				icon = self.hasIcon,
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
			typespacer = {
				type = "header",
				order = 6,
			},
			spiesheader = {
				type = "header",
				order = 8,
			},
			checksspacer = {
				type = "header",
				order = 10,
			},
			checks = {
				type = "group",
				name = L["predefinedChecks_name"],
				desc = L["predefinedChecks_desc"],
				order = 11,
				args = {
					std = {
						type = "group",
						name = L["predefinedChecks_std_name"],
						desc = L["predefinedChecks_std_desc"],
						order = 1,
						args = { },
					},
					zg = {
						type = "group",
						name = L["predefinedChecks_zg_name"],
						desc = L["predefinedChecks_zg_desc"],
						order = 2,
						args = { },
					},
					mc = {
						type = "group",
						name = L["predefinedChecks_mc_name"],
						desc = L["predefinedChecks_mc_desc"],
						order = 2,
						args = { },
					},
					bwl = {
						type = "group",
						name = L["predefinedChecks_bwl_name"],
						desc = L["predefinedChecks_bwl_desc"],
						order = 2,
						args = { },
					},
					aq = {
						type = "group",
						name = L["predefinedChecks_aq_name"],
						desc = L["predefinedChecks_aq_desc"],
						order = 2,
						args = { },
					},
					naxx = {
						type = "group",
						name = L["predefinedChecks_naxx_name"],
						desc = L["predefinedChecks_naxx_desc"],
						order = 2,
						args = { },
					},
					kara = {
						type = "group",
						name = L["predefinedChecks_kara_name"],
						desc = L["predefinedChecks_kara_desc"],
						order = 2,
						args = { },
					},
				},
			},
	  },
	}
	
	for k,v in pairs(self.db.profile.checks) do
		self.opts.args[L[k.."_cmd"]] = {
			type = "toggle",
      name = L[k.."_name"],
      desc = L[k.."_desc"],
      get = function()
        return self.db.profile.checks[k]
      end,
      set = function()
        self.db.profile.checks[k] = not self.db.profile.checks[k]
      end,
      order = tonumber(L[k.."_order"]),
		}
	end
	
	for k,v in pairs(self.db.profile.spies) do
		self.opts.args[L[k.."_cmd"]] = {
			type = "toggle",
      name = L[k.."_name"],
      desc = L[k.."_desc"],
      get = function()
        return self.db.profile.spies[k]
      end,
      set = function()
        self.db.profile.spies[k] = not self.db.profile.spies[k]
        self:UpdateSpies()
      end,
      order = tonumber(L[k.."_order"]),
		}
	end
	
	self.opts.args.checks.args[L["Hearthstone_name"]] = {
		type = "execute",
		name = "["..L["Hearthstone_name"].."]",
		desc = L["Hearthstone_desc"],
	  func = function() self:PerformItemCheck(L["Hearthstone_name"]) end,
	}
	
	for k,_ in pairs(L["predefinedCheckItems"]) do
		for _,v in pairs(L["predefinedCheckItems"][k]) do
			local orderNum = 1
			local itemName = v
			if (string.find(itemName, "|")) then
				orderNum = tonumber(self:Split(itemName, "|")[1])
				itemName = self:Split(itemName, "|")[2]
			end
			self.opts.args.checks.args[k].args[string.gsub(itemName, "[^A-Za-z1-9_]", "")] = {
				type = "execute",
				name = "["..itemName.."]",
				desc = L["Run a check for: "]..itemName,
			  func = function() self:PerformItemCheck(itemName) end,
			  order = orderNum
			}
		end
	end
	
	return self.opts
end

function RaidSpy:UpdateSpies()
	for key, value in pairs(self.db.profile.spies) do
		if (not value) then self.saved[key] = nil end
	end
end

function RaidSpy:ActiveSpies()
	for key, value in pairs(self.db.profile.spies) do
		if (value) then return true end
	end
	return false
end

function RaidSpy:FuName()
	local AddOnName = self:Trim(string.gsub(GetAddOnMetadata("RaidSpy", "Title"), "%|cff7fff7f %-Ace2%-%|r$", ""))
	return "|cffa334ee"..AddOnName.."|r"
end

function RaidSpy:Trim(expression)
	return string.gsub(expression, "^%s*(.-)%s*$", "%1")
end

function RaidSpy:FancyName()
	-- ["fancyname"] = "{author} {addon} {ace}",
	local Title = GetAddOnMetadata("RaidSpy", "Title")
	local Author = self:SetHexColor("Tristan", self:AuthorOwner())
	local Ace = "|cff7fff7f -Ace2-|r"
	Title = self:SetHexColor("Tristan", self:Trim(string.gsub(Title, "%|cff7fff7f %-Ace2%-%|r$", "")))
	
	if (self.tAuthorInDD) then Author = "" end
	
	return self:Trim(self:GoFigure(L["fancyname"], { ["Author"] = Author, ["Title"] = Title, ["Ace"] = Ace}))
end

function RaidSpy:GoFigure(expression, insert)
	if (type(insert) == "table") then
		for key, value in pairs(insert) do
			expression = ( gsub(expression, "{"..key.."}", value) )
		end
		return expression
	else
		return ( gsub(expression, "{$}", insert) )
	end
end

function RaidSpy:SetHexColor(color, expression)
	if (not string.find(color, "%x%x%x%x%x%x")) then
		return "|cffe6cc80"..expression.."|r"
	else
		return "|cff"..color..expression.."|r"
	end
end

function RaidSpy:AuthorOwner()
	return self:DoOwnage(GetAddOnMetadata("RaidSpy", "Author"))
end

function RaidSpy:DoOwnage(expression)
	local rVal = expression
	if (string.find(string.lower(self.author), "s", -1)) then rVal = rVal.."'" else rVal = rVal.."'s" end
	return rVal
end
