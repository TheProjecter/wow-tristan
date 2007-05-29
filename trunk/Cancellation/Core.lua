--[[
	Misc Info
	Options for each spell is one of the following "NONE", "CHAT", "SCREEN", "CANCEL"
	TODO:
	* Use Brain when coding, take name and texture from default-db and don't save it twice (not like it will change ;)
]]
--[[ *** Create Ace2 AddOn *** ]]
Cancellation = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0")
local L = AceLibrary("AceLocale-2.2"):new("Cancellation")
local dewdrop = AceLibrary("Dewdrop-2.0")

Cancellation.validActions = { ["NONE"] = L["01. Do Nothing"], ["CHAT"] = L["02. Fire an alert in the chat"], ["SCREEN"] = L["03. Fire an alert on the screen"], ["CANCEL"] = L["04. Auto-Cancel it"], ["CANCELLOG"] = L["05. Auto-Cancel it and log"] }
Cancellation.defaultAction = "NONE"
Cancellation.Debug = false
Cancellation.spellCategoryUnknown = "UnCategorized"
Cancellation.spellCategoryHidden = "Hide"
Cancellation.spellSpecialCategories = { ["Threat"] = true, ["Intellect"] = true, ["Int"] = true, ["Spirit"] = true, ["Spi"] = true, ["Mana"] = true, ["Attack"] = true, ["AttackPower"] = true, ["Power"] = true,["Agility"] = true, ["Agi"] = true, ["Strength"] = true, ["Str"] = true, ["Stamina"] = true, ["Sta"] = true, ["Regen"] = true, ["Armor"] = true, ["Quantification"] = true, ["Resistance"] = true, }

--[[ *** Initialize the AddOn *** ]]
function Cancellation:OnInitialize()
	--[[ Register a DB for saving ]]
	self:RegisterDB("CancellationDB")
	
	--[[ Register chat commands ]]
  self.opts = {
  	type = "group",
	  args = {
	  	header = {
				type = "header",
				name = L["addonname"],
				icon = "Interface\\Icons\\INV_ValentinesBoxOfChocolates02",
				iconHeight = 16,
				iconWidth = 16,
				order = 1,
			},
			firstMainSpacer = {
				type = "header",
				order = 2,
			},
			menu = {
				type = "execute",
				name = L["Menu"],
				desc = L["Show Menu"],
				func = function() Cancellation:ShowMenu() end,
				order = 3,
			},
			recategorize = {
				type = "execute",
				name = L["ReCategorize"],
				desc = L["This clears all categories\nTo only clear from one buff set that to empty"],
				func = function() Cancellation:ClearCategories() end,
				order = 4,
			},
			secondMainSpacer = {
				type = "header",
				order = 5,
			},
			cleanup = {
				type = "group",
	  		name = L["Clean up the DB"],
	  		desc = L["Clean up the DB"],
	  		args = {
	  			v1 = {
	  				type = "execute",
						name = L["v1"],
						desc = L["Cleans up stuff obsolete from v1 that may still linger in your SavedVariables"],
						func = function() Cancellation:CleanV1() end,
						order = 1,
	  			},
	  		},
	  		order = 6,
			}
		},
	}
  self:RegisterChatCommand(L["consolecommands"], self.opts)
	
	
	--[[ Do we have arrays ]]
	if (not self.db.profile.spellDB) then self.db.profile.spellDB = { } end
	if (not self.db.char.spellDB) then self.db.char.spellDB = { } end
	
	--[[ Fill userDB with profileDB ]]
	for spellDBID, spellDBSingleTable in pairs(Cancellation.db.profile.spellDB) do
		if (self.db.char.spellDB[spellDBID] == nil) then
			self.db.char.spellDB[spellDBID] = { }
			for spellDBIDkey, spellDBIDvalue in pairs(Cancellation.db.profile.spellDB[spellDBID]) do
				self.db.char.spellDB[spellDBID][spellDBIDkey] = spellDBIDvalue
			end
  		self.db.char.spellDB[spellDBID]["scanned"] = nil
  		self.db.char.spellDB[spellDBID]["action"] = self.defaultAction
		end
	end
	
	--[[ Tell user we loaded ]]
	self:Print(L["translator"])
end

--[[ *** Do stuff when enabled? *** ]]
function Cancellation:OnEnable()
	--[[ Register Events for example ]]
  self:RegisterEvent("PLAYER_AURAS_CHANGED")
end

--[[ *** Do stuff when disabled? *** ]]
function Cancellation:OnDisable()
  --[[ Unregister Events for example ]]
  self:UnregisterAllEvents()
  
  --[[ Clear Memory ]]
  for spellDBID, spellDBSingleTable in pairs(Cancellation.db.char.spellDB) do
		Cancellation.db.char.spellDB[spellDBID]["scanned"] = nil
	end
end

--[[ *** EVENTS *** ]]
function Cancellation:PLAYER_AURAS_CHANGED()
	--[[ First see if we can learn any new auras ]]
  buffId = 1
  local buffIndex = GetPlayerBuff(buffId, "HELPFUL|PASSIVE");
  while (buffIndex ~= 0) do
  	-- if buffIndex == 0 then break end
  	local buffTexture = GetPlayerBuffTexture(buffIndex)
  	local buffName, buffRank = GetPlayerBuffName(buffIndex)
  	
  	if ((buffTexture) and (buffName)) then
  		local spellDBID = buffTexture.."_"..buffName
  		if (self.db.profile.spellDB[spellDBID] == nil) then
  			self.db.profile.spellDB[spellDBID] = { }
  			self.db.profile.spellDB[spellDBID]["texture"] = buffTexture
  			self.db.profile.spellDB[spellDBID]["name"] = buffName
  		end
  		if (self.db.char.spellDB[spellDBID] == nil) then
  			self.db.char.spellDB[spellDBID] = { }
  			self.db.char.spellDB[spellDBID]["scanned"] = nil
  			self.db.char.spellDB[spellDBID]["action"] = self.defaultAction
  		end
  	end
  	
  	buffId = buffId + 1
  	buffIndex = GetPlayerBuff(buffId, "HELPFUL|PASSIVE");
  end
  
	self:CancelBuffs()
end

--[[ *** Functions *** ]]
function Cancellation:CancelBuffs()
	 local listofAurasNotToReset = { }
  --[[ Now cancel auras that should be cancelled ]]
  buffId = 1
  local buffIndex = GetPlayerBuff(buffId, "HELPFUL|PASSIVE");
  while (buffIndex ~= 0) do
  	--if buffIndex == 0 then break end
  	local buffTexture = GetPlayerBuffTexture(buffIndex)
  	local buffName, buffRank = GetPlayerBuffName(buffIndex)
  	
  	if ((buffTexture) and (buffName)) then
  		local spellDBID = buffTexture.."_"..buffName
  		
  		if (self.db.char.spellDB[spellDBID] ~= nil) then
	  		if (self.db.char.spellDB[spellDBID]["category"] ~= self.spellCategoryHidden) then
	  			if ((self.db.char.spellDB[spellDBID]["action"] ~= nil) and (self.db.char.spellDB[spellDBID]["action"] ~= "NONE")) then
	  				if (self.db.char.spellDB[spellDBID]["action"] == "CHAT") then
	  					if (self.db.char.spellDB[spellDBID]["scanned"] ~= "CHAT") then
	  						local alertMessage = string.gsub(string.gsub(string.gsub(L["AlertMessage"], "{c}", ""), "{b}", buffName), "{a}", L[" detected"])
	  						self:Print(alertMessage)
	  						self.db.char.spellDB[spellDBID]["scanned"] = "CHAT"
	  					end
	  					listofAurasNotToReset[spellDBID] = true
	  				elseif (self.db.char.spellDB[spellDBID]["action"] == "SCREEN") then
	  					if (self.db.char.spellDB[spellDBID]["scanned"] ~= "SCREEN") then
	  						local alertMessage = string.gsub(string.gsub(string.gsub(L["AlertMessage"], "{c}", "---> "), "{b}", buffName..L[" detected"]), "{a}", " <---")
	  						UIErrorsFrame:AddMessage(alertMessage)
	  						self.db.char.spellDB[spellDBID]["scanned"] = "SCREEN"
	  					end
	  					listofAurasNotToReset[spellDBID] = true
	  				elseif ((self.db.char.spellDB[spellDBID]["action"] == "CANCEL") or (self.db.char.spellDB[spellDBID]["action"] == "CANCELLOG")) then
	  					local resultCanc = CancelPlayerBuff(buffIndex)
	  					-- self:Print(resultCanc) gave nil when it cancelled what is unsuccessful? -1?
	  					if (self.db.char.spellDB[spellDBID]["action"] == "CANCELLOG") then
	  						local alertMessage = string.gsub(string.gsub(string.gsub(L["AlertMessage"], "{c}", ""), "{b}", buffName), "{a}", L[" detected"])
	  						self:Print(alertMessage)
	  					end
	  					self.db.char.spellDB[spellDBID]["scanned"] = nil
	  				end
	  			else
	  				self.db.char.spellDB[spellDBID]["scanned"] = nil
	  			end
	  		end
  		end
  	end
  	
  	buffId = buffId + 1
  	buffIndex = GetPlayerBuff(buffId, "HELPFUL|PASSIVE");
  end
  
  --[[ finally reset all auras that timed out or got cancelled manually ]]
  for k, v in pairs(self.db.char.spellDB) do
  	if (not listofAurasNotToReset[k]) then
  		self.db.char.spellDB[k]["scanned"] = nil
  	end
  end
end

function Cancellation:GetPlayerBuffName(buffIndex)
	local name, rank = GetPlayerBuffName(id)
	return name;
end

function Cancellation:ShowMenu()
	self.ddOpts = nil
	
	self.ddOpts = {
	  type = "group",
	  args = {
	  	header = {
				type = "header",
				name = L["addonname"],
				icon = "Interface\\Icons\\INV_ValentinesBoxOfChocolates02",
				iconHeight = 16,
				iconWidth = 16,
				order = 1
			},
			firstSpacer = {
				type = "header",
				order = 2
			},
			categories = {
				type = "group",
	  		name = L["Set Categories"],
	  		desc = L["Set Categories"],
	  		args = { },
	  		order = 3,
			},
			secondSpacer = {
				type = "header",
				order = 4
			},
		},
	}
	
	for spellDBID, spellDBSingleTable in pairs(self.db.char.spellDB) do
		if (self.db.profile.spellDB[spellDBID]) then
			local menuName = self:CleanString(spellDBID)
			local spellDBIDlocal = spellDBID
			--[[ Categorization a work in progress :/ ]]
			local spellCategory = self.db.char.spellDB[spellDBID]["category"] or self.spellCategoryHidden --self.spellCategoryUnknown
			local spellCategoryMenu = self:CleanString(spellCategory)
			
			if ((self.ddOpts.args[spellCategoryMenu] == nil) and (spellCategoryMenu ~= self.spellCategoryHidden)) then
				local orderNum = 6
				if (spellCategory == self.spellCategoryUnknown) then orderNum = 8 end
				if (self.spellSpecialCategories[spellCategory]) then orderNum = 5 end
				self.ddOpts.args[spellCategoryMenu] = {
					type = "group",
		  		name = string.gsub(spellCategory, "_", " "),
		  		desc = string.gsub(spellCategory, "_", " "),
		  		args = { },
					order = orderNum,
				}
				if (orderNum == 8) then
					self.ddOpts.args["thirdSpacer"] = {
						type = "header",
						order = 7,
					}
				end
				
				self.ddOpts.args[spellCategoryMenu].args["Set-All"] = {
					type = "text",
					name = L["Set All"],
					desc = L["Sets the option for all buffs in this category"],
					-- icon = self.db.char.spellDB[spellDBID]["texture"],
					get = function()
						return "UNKNOWN"
					end,
					set = function(arg1)
						Cancellation:OptionToCategory(spellCategory, arg1)
						Cancellation:CancelBuffs()
					end,
					validate = self.validActions,
					order = 1,
				}
			end
			if (self.ddOpts.args.categories.args[spellCategoryMenu] == nil) then
				if (spellCategory ~= self.spellCategoryUnknown) then
					local orderNum = 3
					if (spellCategory == self.spellCategoryUnknown) then orderNum = 4 end
					if (self.spellSpecialCategories[spellCategory]) then orderNum = 2 end
					self.ddOpts.args.categories.args[spellCategoryMenu] = {
						type = "group",
			  		name = string.gsub(spellCategory, "_", " "),
			  		desc = string.gsub(spellCategory, "_", " "),
			  		args = { },
			  		order = orderNum,
					}
				end
			end
			
			if (spellCategory == self.spellCategoryUnknown) then
				-- Add directly under
				self.ddOpts.args.categories.args[menuName] = {
				type = "text",
				name = self.db.profile.spellDB[spellDBID]["name"],
				desc = string.gsub(L["Set the category to {c} to hide it from the interface"], "{c}", "'"..Cancellation.spellCategoryHidden.."'"),
				icon = self.db.profile.spellDB[spellDBID]["texture"],
				get = function()
					return Cancellation.db.char.spellDB[spellDBIDlocal]["category"] or self.spellCategoryHidden --self.spellCategoryUnknown
				end,
				set = function(arg1)
					Cancellation:SetCategory(spellDBIDlocal, arg1)
				end,
				usage = "<any string>",
				order = 1,
			}
			else
				-- Add in it's category
				self.ddOpts.args.categories.args[spellCategoryMenu].args[menuName] = {
				type = "text",
				name = self.db.profile.spellDB[spellDBID]["name"],
				desc = string.gsub(L["Set the category to {c} to hide it from the interface"], "{c}", "'"..Cancellation.spellCategoryHidden.."'"),
				icon = self.db.profile.spellDB[spellDBID]["texture"],
				get = function()
					return Cancellation.db.char.spellDB[spellDBIDlocal]["category"] or self.spellCategoryHidden --self.spellCategoryUnknown
				end,
				set = function(arg1)
					Cancellation:SetCategory(spellDBIDlocal, arg1)
				end,
				usage = "<any string>",
				order = 1,
			}
			end
			
			if (spellCategoryMenu ~= self.spellCategoryHidden) then
				self.ddOpts.args[spellCategoryMenu].args[menuName] = {
					type = "text",
					name = self.db.profile.spellDB[spellDBID]["name"],
					desc = string.gsub(L["Category: {c}"], "{c}", spellCategory),
					icon = self.db.profile.spellDB[spellDBID]["texture"],
					get = function()
						if (Cancellation.db.char.spellDB[spellDBIDlocal]["action"]) then
							return Cancellation.db.char.spellDB[spellDBIDlocal]["action"]
						else
							return self.defaultAction
						end
					end,
					set = function(arg1)
						Cancellation.db.char.spellDB[spellDBIDlocal]["action"] = arg1
						Cancellation:CancelBuffs()
					end,
					validate = self.validActions,
					order = 2,
				}
			end
		end
	end
	
	dewdrop:Open(UIParent, 'children', function() dewdrop:FeedAceOptionsTable(self.ddOpts) end, 'cursorX', true, 'cursorY', true)
end

function Cancellation:SetCategory(spellDBID, category)
	local dissallowedCategories = {
		["hidden"] = true,
		["args"] = true,
		["get"] = true,
		["set"] = true,
		["icon"] = true,
		["name"] = true,
		["desc"] = true,
		["type"] = true,
		["validate"] = true,
		["usage"] = true,
		["order"] = true,
		["category"] = true,
	}
	
	if (dissallowedCategories[category]) then
		self:Print(string.gsub(L["|cffff7f7f{n}|r is not an allowed Category, please try again"], "{n}", category))
	elseif ((category == "") or (category == nil)) then
		self.db.char.spellDB[spellDBID]["category"] = nil
	else
		self.db.char.spellDB[spellDBID]["category"] = category
	end
end

function Cancellation:ClearCategories()
	for spellDBID, spellDBSingleTable in pairs(self.db.char.spellDB) do
		self.db.char.spellDB[spellDBID]["category"] = nil
	end
end

function Cancellation:OptionToCategory(category, action)
	for spellDBID, spellDBSingleTable in pairs(self.db.char.spellDB) do
		if (self.db.char.spellDB[spellDBID]["category"] == category) then
			self.db.char.spellDB[spellDBID]["action"] = action
		end
	end
end

function Cancellation:CleanString(arg1)
	if (arg1) then
		local retVal = string.gsub(arg1, "_", "")
		retVal = string.gsub(retVal, " ", "_")
		retVal = string.gsub(retVal, "[^%w%a]", "")
		return retVal
	else
		return nil
	end
end

function Cancellation:CleanV1()
	for spellDBID, spellDBSingleTable in pairs(self.db.char.spellDB) do
		if (self.db.char.spellDB[spellDBID]["texture"]) then self.db.char.spellDB[spellDBID]["texture"] = nil end
		if (self.db.char.spellDB[spellDBID]["name"]) then self.db.char.spellDB[spellDBID]["name"] = nil end
	end
end