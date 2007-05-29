local _, englishClass = UnitClass("player")
if ((englishClass ~= "WARRIOR") and (englishClass ~= "DRUID")) then
	DisableAddOn("Tankalyze")
	return
end

--[[ *** Create Ace2 AddOn *** ]]
Tankalyze = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0")
local L = AceLibrary("AceLocale-2.2"):new("Tankalyze")
--[2.0]local status = AceLibrary("SpellStatus-1.0")
local dewdrop = AceLibrary("Dewdrop-2.0")

_, Tankalyze.englishClass = UnitClass("player")

--[[ *** Initialize the AddOn *** ]]
function Tankalyze:OnInitialize()
	self:Print(L["translator"])
	
	--[[ Register a DB for saving ]]
	self:RegisterDB("TankalyzeDB")

	self:RegisterDefaults('char', {
		resists = {
			taunt = true,
			growl = false,
			mocking = true,
			shout = false,
			roar = false,
			channel = "Tankalyze",
			type = "CHANNEL", -- "GROUP_RW", "GROUP", "RAID", "PARTY", "CHANNEL", "YELL", "SAY", "DEBUG"
			messages = {
				taunt = L["TauntMessage"],
				tauntSCT = L["TauntMessageSCT"],
				growl = L["GrowlMessage"],
				growlSCT = L["GrowlMessageSCT"],
				mocking = L["MockingMessage"],
				mockingSCT = L["MockingMessageSCT"],
				shout = L["ShoutMessage"],
				shoutSCT = L["ShoutMessageSCT"],
				roar = L["RoarMessage"],
				roarSCT = L["RoarMessageSCT"],
			},
		},
		
		announces = {
			wall = false,
			stand = false,
			gem = false,
			shout = false,
			roar = false,
			channel = "Tankalyze",
			type = "SAY", -- "GROUP_RW", "GROUP", "RAID", "PARTY", "CHANNEL", "YELL", "SAY", "DEBUG"
			messages = {
				wall = L["WallUsedMessage"],
				stand = L["StandUsedMessage"],
				gem = L["GemUsedMessage"],
				shout = L["ShoutUsedMessage"],
				roar = L["RoarUsedMessage"],
			},
		},
		
		alertSelf = false,
		disableInBG = true,
		sct = false,
		humour = true,
		
		challengingShoutFrequency = 3,
		lastChallengingShout = time(),
		challengingRoarFrequency = 3,
		lastChallengingRoar = time(),
		
		isLogging = false,
		logShout = { },
		logRoar = { },
	})

	--[[ Build Options ]]
	self:BuildOpts()
	self:HideOpts(self.englishClass)

  --[[ Register chat commands ]]
  self:RegisterChatCommand(L["consolecommands"], self.opts)
end

--[[ *** Do stuff when enabled? *** ]]
function Tankalyze:OnEnable()
	--[[ Register Events for example ]]
  self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE") -- Taunt, Growl & Mocking should stay in here
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") -- "player", spell, rank
end

--[[ *** Do stuff when disabled? *** ]]
function Tankalyze:OnDisable()
  --[[ Unregister Events for example ]]
  self:UnregisterAllEvents()
end

--[[ *** EVENTS *** ]]
function Tankalyze:CHAT_MSG_SPELL_SELF_DAMAGE()
	--[[ An event we are subscribing to ]]

	local _, _, TauntFailed = string.find(arg1, L["ResistTauntRX"])
	local _, _, GrowlFailed = string.find(arg1, L["ResistGrowlRX"])
	local _, _, UsedMockingBlow = string.find(arg1, L["MockingBlowRX"])
	local _, _, ChallengingShoutFailed = string.find(arg1, L["ResistChallengingShoutRX"])
	local _, _, ChallengingRoarFailed = string.find(arg1, L["ResistChallengingRoarRX"])
	local _, _, UsedChallengingShout = string.find(arg1, L["ChallengingShoutRX"])
	local _, _, UsedChallengingRoar = string.find(arg1, L["ChallengingRoarRX"])

	if (TauntFailed) then
		self:AnnounceResist(self.db.char.resists.messages.taunt, self.db.char.resists.messages.tauntSCT)
	end
	
	if (GrowlFailed) then
		self:AnnounceResist(self.db.char.resists.messages.growl, self.db.char.resists.messages.growlSCT)
	end

	if (UsedMockingBlow) then
		local MockingBlowHit = string.find(arg1, L["MockingBlowSuccessRX"])

		if (not MockingBlowHit) then
			self:AnnounceResist(self.db.char.resists.messages.mocking, self.db.char.resists.messages.mockingSCT)
		end
	end
	
	if (ChallengingShoutFailed) then
		-- Don't announce 300 times if in a big chunk of critters
		if ((self.db.char.lastChallengingShout + self.db.char.challengingShoutFrequency) < time()) then
			self.db.char.lastChallengingShout = time()
			local msg = string.gsub(string.gsub(self.db.char.resists.messages.shout, "{t}", ChallengingShoutFailed), "{l}", "")
			local msgSCT = string.gsub(string.gsub(self.db.char.resists.messages.shoutSCT, "{t}", ChallengingShoutFailed), "{l}", "")
			self:AnnounceResist(msg, msgSCT)
		end
	end
	
	if (ChallengingRoarFailed) then
		-- Don't announce 300 times if in a big chunk of critters
		if ((self.db.char.lastChallengingRoar + self.db.char.challengingRoarFrequency) < time()) then
			self.db.char.lastChallengingRoar = time()
			local msg = string.gsub(string.gsub(self.db.char.resists.messages.roar, "{t}", ChallengingRoarFailed), "{l}", L["Unknown"])
			local msgSCT = string.gsub(string.gsub(self.db.char.resists.messages.roarSCT, "{t}", ChallengingRoarFailed), "{l}", L["Unknown"])
			self:AnnounceResist(msg, msgSCT)
		end
	end

	if ((UsedChallengingShout) and (self.db.char.isLogging)) then
		self.db.char.logShout[time()] = "(1) "..arg1
	end
	if ((UsedChallengingRoar) and (self.db.char.isLogging)) then
		self.db.char.logRoar[time()] = "(1) "..arg1
	end
end

function Tankalyze:UNIT_SPELLCAST_SUCCEEDED(unit, spell, rank) -- "player", spell, rank
	if ((spell == L["Shield Wall"]) and (self.db.char.announces.wall)) then
		self:AnnounceInfo(self.db.char.announces.messages.wall)
  elseif ((spell == L["Last Stand"]) and (self.db.char.announces.stand)) then
		self:AnnounceInfo(self.db.char.announces.messages.stand)
	elseif ((spell == L["Lifegiving Gem"]) and (self.db.char.announces.gem)) then
		--[[ Wont Work, need to parse combat log or find another trigger ]]
		self:AnnounceInfo(self.db.char.announces.messages.gem)
	elseif ((spell == L["Challenging Shout"]) and (self.db.char.announces.shout)) then
		self:AnnounceInfo(self.db.char.announces.messages.shout)
  elseif ((spell == L["Challenging Roar"]) and (self.db.char.announces.roar)) then
		self:AnnounceInfo(self.db.char.announces.messages.roar)
  elseif ((spell == L["Rend"]) and (self.db.char.humour) and (UnitClassification("target") == L["ClassificationBoss"])) then
  	self:Announce(L["GG, I just put rend on a worldboss!"], "GROUP")
  end
end

--[[ *** Functions *** ]]
function Tankalyze:AnnounceResist(msg, msgSCT)
	local TargetName = UnitName("target")
	local TargetLevel = UnitLevel("target") -- If the unit's level is unknown, i.e. a Level ?? target, or is a special boss, UnitLevel() will return -1
	local TargetClassification = UnitClassification("target") -- "worldboss", "rareelite", "elite", "rare" or "normal"
	if ((not TargetLevel) or (TargetLevel == -1)) then TargetLevel = "??" end
	if (not TargetName) then TargetName = L["<No Target>"] end
	
	if (TargetClassification == L["ClassificationBoss"]) then
		TargetLevel = "Boss"
		-- TargetLevel = L["level "].."??, Boss"
	elseif (TargetClassification == L["ClassificationElite"]) then
		TargetLevel = L["level "].."+"..TargetLevel
	else
		TargetLevel = L["level "]..TargetLevel
	end
	
	if ((UnitIsFriend("player", "target")) and (self.db.char.humour)) then
		TargetName = L["<Friendly Target>"]
		TargetLevel = L["go me"]
	end

	local alertString = string.gsub(string.gsub(msg, "{t}", TargetName), "{l}", TargetLevel)
	local alertStringShort = string.gsub(string.gsub(msgSCT, "{t}", TargetName), "{l}", TargetLevel)

	if (self.db.char.alertSelf) then
		UIErrorsFrame:AddMessage(alertString)
	end
	if ((self.db.char.sct) and IsAddOnLoaded("sct")) then --if ((self.db.char.sct) and (SCT))then
		-- SCT:Display_Event("SHOWMISS", alertStringShort)
		SCT:Display_Event("SHOWCOMBAT", alertStringShort)
	end
	
	self:Announce(alertString, self.db.char.resists.type, self.db.char.resists.channel)
end

function Tankalyze:AnnounceInfo(msg)
	self:Announce(msg, self.db.char.announces.type, self.db.char.announces.channel)
end

function Tankalyze:Announce(msg, type, channel)
	if ((self.db.char.disableInBG) and (self:IsInBattleground())) then return end
	
	if ((type == "GROUP") or (type == "GROUP_RW")) then
		local whereTo = nil
		if (GetNumRaidMembers() > 0) then
			whereTo = "RAID"
			if (type == "GROUP_RW") then
				 if (IsRaidOfficer()) then
					whereTo = "RAID_WARNING"
				end
			end
    elseif (GetNumPartyMembers() > 0) then
      whereTo = "PARTY"
    end
		if (whereTo) then
			SendChatMessage(msg, whereTo)
		--[[ else
			self:Print(L["|cffffff7fDebug : |r"]..msg) ]]
		end
	elseif (type == "DEBUG") then
		self:Print(L["|cffffff7fDebug : |r"]..msg)
	elseif (type == "CHANNEL") then
		local chanIndex = GetChannelName(channel)
		if ((chanIndex) and (chanIndex > 0)) then
			SendChatMessage(msg, type, nil, chanIndex);
		else
			local chanError = string.gsub(L["Custom channel not found"], "{c}", channel)
			self:Print(chanError)
		end
	else
		SendChatMessage(msg, type)
	end
end

function Tankalyze:ShowMenu()
	dewdrop:Open(UIParent, 'children', function() dewdrop:FeedAceOptionsTable(self.opts) end, 'cursorX', true, 'cursorY', true)
end

function Tankalyze:Test()
	if (self.englishClass == "WARRIOR") then
		self:AnnounceResist("(TEST)"..self.db.char.resists.messages.taunt, "(TEST)"..self.db.char.resists.messages.tauntSCT)
		self:AnnounceInfo("(TEST)"..self.db.char.announces.messages.shout)
	elseif (self.englishClass == "DRUID") then
		self:AnnounceResist("(TEST)"..self.db.char.resists.messages.growl, "(TEST)"..self.db.char.resists.messages.growlSCT)
		self:AnnounceInfo("(TEST)"..self.db.char.announces.messages.roar)
	end
	
	self:Announce("(TEST)", "CHANNEL", "WhatSanePersonWouldBeInAChanWithThisName")
end

function Tankalyze:BuildOpts()
	self.opts = {
	  type = "group",
	  args = {
	  	header = {
				type = "header",
				name = L["addonname"],
				icon = "Interface\\Icons\\Spell_Nature_Reincarnation",
				iconHeight = 16,
				iconWidth = 16,
				order = 1
			},
			headerspacer = {
				type = "header",
				order = 2
			},
	  	resists = {
	  		type = "group",
	  		order = 3,
	  		name = L["Resists"],
	  		desc = L["Settings for resists"],
	  		--icon = "Interface\\Icons\\Spell_Nature_Reincarnation",
	  		args = {
	  			taunt = {
			      type = "toggle",
			      name = L["Taunt"],
			      desc = L["Announces resisted taunts"],
			      icon = "Interface\\Icons\\Spell_Nature_Reincarnation",
			      get = function()
			        return self.db.char.resists.taunt
			      end,
			      set = function()
			        self.db.char.resists.taunt = not self.db.char.resists.taunt
			      end,
			      order = 1,
			    },
			    growl = {
			      type = "toggle",
			      name = L["Growl"],
			      desc = L["Announces resisted growls"],
			      icon = "Interface\\Icons\\Ability_Physical_Taunt",
			      get = function()
			        return self.db.char.resists.growl
			      end,
			      set = function()
			        self.db.char.resists.growl = not self.db.char.resists.growl
			      end,
			      order = 2,
			    },
			    mocking = {
			      type = "toggle",
			      name = L["Mocking Blow"],
			      desc = L["Announces missed Mocking Blows"],
			      icon = "Interface\\Icons\\Ability_Warrior_PunishingBlow",
			      get = function()
			        return self.db.char.resists.mocking
			      end,
			      set = function()
			        self.db.char.resists.mocking = not self.db.char.resists.mocking
			      end,
			      order = 10,
			    },
			    shout = {
			      type = "toggle",
			      name = L["Challenging Shout"],
			      desc = L["Announces resisted challenging shouts"],
			      icon = "Interface\\Icons\\Ability_BullRush",
			      get = function()
			        return self.db.char.resists.shout
			      end,
			      set = function()
			        self.db.char.resists.shout = not self.db.char.resists.shout
			      end,
			      order = 20,
			    },
			    roar = {
			      type = "toggle",
			      name = L["Challenging Roar"],
			      desc = L["Announces resisted challenging roars"],
			      icon = "Interface\\Icons\\Ability_Druid_ChallangingRoar",
			      get = function()
			        return self.db.char.resists.roar
			      end,
			      set = function()
			        self.db.char.resists.roar = not self.db.char.resists.roar
			      end,
			      order = 21,
			    },
					type = {
						type = "text",
					  name = L["Announce To"],
						desc = L["Set where to announce"],
						--icon = "Interface\\Icons\\Ability_Warrior_BattleShout",
						get = function()
							return self.db.char.resists.type
						end,
						set = function(arg1)
							self.db.char.resists.type = arg1
						end,
						validate = { "GROUP_RW", "GROUP", "RAID", "PARTY", "CHANNEL", "YELL", "SAY", "DEBUG" },
			      order = 30,
					},
			    channel = {
						type = "text",
					  name = L["Custom Chan"],
						desc = L["Name of the channel to send to (only used if Announce To is set to CHANNEL)"],
						--icon = "Interface\\Icons\\Spell_ChargePositive",
						get = function()
							return self.db.char.resists.channel
						end,
					  set = function(arg1)
					  	self.db.char.resists.channel = arg1
					  end,
					  usage = "<any string>",
			      order = 31,
					},
					messages = {
			  		type = "group",
			  		order = 40,
			  		name = L["Resists Messages"],
			  		desc = L["Message settings for resists"],
			  		--icon = "Interface\\Icons\\INV_Misc_Note_01",
			  		args = {
			  			taunt = {
								type = "text",
							  name = L["Taunt"],
								desc = L["MessagesInfo"],
								icon = "Interface\\Icons\\Spell_Nature_Reincarnation",
								get = function()
									return self.db.char.resists.messages.taunt
								end,
							  set = function(arg1)
							  	self.db.char.resists.messages.taunt = arg1
							  end,
							  usage = "<any string>",
					      order = 1,
							},
							growl = {
								type = "text",
							  name = L["Growl"],
								desc = L["MessagesInfo"],
								icon = "Interface\\Icons\\Ability_Physical_Taunt",
								get = function()
									return self.db.char.resists.messages.growl
								end,
							  set = function(arg1)
							  	self.db.char.resists.messages.growl = arg1
							  end,
							  usage = "<any string>",
					      order = 2,
							},
							mocking = {
								type = "text",
							  name = L["Mocking Blow"],
								desc = L["MessagesInfo"],
								icon = "Interface\\Icons\\Ability_Warrior_PunishingBlow",
								get = function()
									return self.db.char.resists.messages.mocking
								end,
							  set = function(arg1)
							  	self.db.char.resists.messages.mocking = arg1
							  end,
							  usage = "<any string>",
					      order = 3,
							},
							shout = {
								type = "text",
							  name = L["Challenging Shout"],
								desc = L["MessagesInfo"],
								icon = "Interface\\Icons\\Ability_BullRush",
								get = function()
									return self.db.char.resists.messages.shout
								end,
							  set = function(arg1)
							  	self.db.char.resists.messages.shout = arg1
							  end,
							  usage = "<any string>",
					      order = 4,
							},
							roar = {
								type = "text",
							  name = L["Challenging Roar"],
								desc = L["MessagesInfo"],
								icon = "Interface\\Icons\\Ability_Druid_ChallangingRoar",
								get = function()
									return self.db.char.resists.messages.roar
								end,
							  set = function(arg1)
							  	self.db.char.resists.messages.roar = arg1
							  end,
							  usage = "<any string>",
					      order = 5,
							},
			  		},
			  	},
				},
	  	},
	  	announces = {
	  		type = "group",
	  		order = 4,
	  		name = L["Announces"],
	  		desc = L["Settings for announces"],
	  		--icon = "Interface\\Icons\\Spell_Holy_AshesToAshes",
	  		args = {
	  			wall = {
			      type = "toggle",
			      name = L["Shield Wall"],
			      desc = L["Shield Wall"],
			      icon = "Interface\\Icons\\Ability_Warrior_ShieldWall",
			      get = function()
			        return self.db.char.announces.wall
			      end,
			      set = function()
			        self.db.char.announces.wall = not self.db.char.announces.wall
			      end,
			      order = 1,
			    },
			    stand = {
			      type = "toggle",
			      name = L["Last Stand"],
			      desc = L["Last Stand"],
			      icon = "Interface\\Icons\\Spell_Holy_AshesToAshes",
			      get = function()
			        return self.db.char.announces.stand
			      end,
			      set = function()
			        self.db.char.announces.stand = not self.db.char.announces.stand
			      end,
			      order = 2,
			    },
			    gem = {
			      type = "toggle",
			      name = L["Lifegiving Gem Menu"],
			      desc = L["Lifegiving Gem Menu"],
			      icon = "Interface\\Icons\\INV_Misc_Gem_Pearl_05",
			      get = function()
			        return self.db.char.announces.gem
			      end,
			      set = function()
			        self.db.char.announces.gem = not self.db.char.announces.gem
			      end,
			      order = 3,
			    },
			    shout = {
			      type = "toggle",
			      name = L["Challenging Shout"],
			      desc = L["Challenging Shout"],
			      icon = "Interface\\Icons\\Ability_BullRush",
			      get = function()
			        return self.db.char.announces.shout
			      end,
			      set = function()
			        self.db.char.announces.shout = not self.db.char.announces.shout
			      end,
			      order = 4,
			    },
			    roar = {
			      type = "toggle",
			      name = L["Challenging Roar"],
			      desc = L["Challenging Roar"],
			      icon = "Interface\\Icons\\Ability_Druid_ChallangingRoar",
			      get = function()
			        return self.db.char.announces.roar
			      end,
			      set = function()
			        self.db.char.announces.roar = not self.db.char.announces.roar
			      end,
			      order = 5,
			    },
			    type = {
						type = "text",
					  name = L["Announce To"],
						desc = L["Set where to announce"],
						--icon = "Interface\\Icons\\Ability_Warrior_BattleShout",
						get = function()
							return self.db.char.announces.type
						end,
						set = function(arg1)
							self.db.char.announces.type = arg1
						end,
						validate = { "GROUP_RW", "GROUP", "RAID", "PARTY", "CHANNEL", "YELL", "SAY", "DEBUG" },
			      order = 30,
					},
			    channel = {
						type = "text",
					  name = L["Custom Chan"],
						desc = L["Name of the channel to send to (only used if Announce To is set to CHANNEL)"],
						--icon = "Interface\\Icons\\Spell_ChargePositive",
						get = function()
							return self.db.char.announces.channel
						end,
					  set = function(arg1)
					  	self.db.char.announces.channel = arg1
					  end,
					  usage = "<any string>",
			      order = 31,
					},
					messages = {
			  		type = "group",
			  		order = 40,
			  		name = L["Announce Messages"],
			  		desc = L["Message settings for announces"],
			  		--icon = "Interface\\Icons\\INV_Misc_Note_01",
			  		args = {
			  			wall = {
								type = "text",
							  name = L["Shield Wall"],
								desc = L["MessagesInfoNoTarget"],
								icon = "Interface\\Icons\\Ability_Warrior_ShieldWall",
								get = function()
									return self.db.char.announces.messages.wall
								end,
							  set = function(arg1)
							  	self.db.char.announces.messages.wall = arg1
							  end,
							  usage = "<any string>",
					      order = 1,
							},
							stand = {
								type = "text",
							  name = L["Last Stand"],
								desc = L["MessagesInfoNoTarget"],
								icon = "Interface\\Icons\\Spell_Holy_AshesToAshes",
								get = function()
									return self.db.char.announces.messages.stand
								end,
							  set = function(arg1)
							  	self.db.char.announces.messages.stand = arg1
							  end,
							  usage = "<any string>",
					      order = 2,
							},
							gem = {
								type = "text",
							  name = L["Lifegiving Gem Menu"],
								desc = L["MessagesInfoNoTarget"],
								icon = "Interface\\Icons\\INV_Misc_Gem_Pearl_05",
								get = function()
									return self.db.char.announces.messages.gem
								end,
							  set = function(arg1)
							  	self.db.char.announces.messages.gem = arg1
							  end,
							  usage = "<any string>",
					      order = 3,
							},
							shout = {
								type = "text",
							  name = L["Challenging Shout"],
								desc = L["MessagesInfoNoTarget"],
								icon = "Interface\\Icons\\Ability_BullRush",
								get = function()
									return self.db.char.announces.messages.shout
								end,
							  set = function(arg1)
							  	self.db.char.announces.messages.shout = arg1
							  end,
							  usage = "<any string>",
					      order = 4,
							},
							roar = {
								type = "text",
							  name = L["Challenging Roar"],
								desc = L["MessagesInfoNoTarget"],
								icon = "Interface\\Icons\\Ability_Druid_ChallangingRoar",
								get = function()
									return self.db.char.announces.messages.roar
								end,
							  set = function(arg1)
							  	self.db.char.announces.messages.roar = arg1
							  end,
							  usage = "<any string>",
					      order = 5,
							},
						},
					},
				},
	  	},
	  	spacerInFrontOfAlert = {
				type = "header",
				order = 9,
			},
			alertSelf = {
	      type = "toggle",
	      name = L["Alert Self"],
	      desc = L["Toggles alert in the standard UI Error Frame"],
	      icon = "Interface\\Icons\\Ability_Warrior_BattleShout",
	      get = function()
	        return self.db.char.alertSelf
	      end,
	      set = function()
	        self.db.char.alertSelf = not self.db.char.alertSelf
	      end,
	      order = 10,
	    },
	    DisableInBG = {
	    	type = "toggle",
	    	name = L["Don't send in BG's"],
	    	desc = L["Toggles wheter to send messages inside battlegrounds or not"],
	    	icon = "Interface\\Icons\\Spell_Lightning_LightningBolt01",
	      get = function()
	        return self.db.char.disableInBG
	      end,
	      set = function()
	        self.db.char.disableInBG = not self.db.char.disableInBG
	      end,
	      order = 11,
	    },
	    sct = {
	    	type = "toggle",
	    	name = L["Scrolling Combat Text Alert"],
	    	desc = L["Toggles message sent to Scrolling Combat Text (if installed) as Combat Flag"],
	    	icon = "Interface\\Icons\\Spell_Lightning_LightningBolt01",
	      get = function()
	        return self.db.char.sct
	      end,
	      set = function()
	        self.db.char.sct = not self.db.char.sct
	      end,
	      order = 12,
	    },
	    spacerInFrontOfHumour = {
				type = "header",
				order = 19,
			},
			humour = {
	      type = "toggle",
	      name = L["Humour"],
	      desc = L["Do you have it?"],
	      icon = "Interface\\Icons\\Ability_Suffocate",
	      get = function()
	        return self.db.char.humour
	      end,
	      set = function()
	        self.db.char.humour = not self.db.char.humour
	      end,
	      order = 80,
	    },
	    log = {
	      type = "toggle",
	      name = L["Logging"],
	      desc = L["Logging for Challenging Shout/Roar if you want to help"],
	      icon = "Interface\\Icons\\INV_Misc_Note_01",
	      get = function()
	        return self.db.char.isLogging
	      end,
	      set = function()
	        self.db.char.isLogging = not self.db.char.isLogging
	      end,
	      order = 81,
	    },
			spacerInFrontOfTest = {
				type = "header",
				order = 99,
			},
			test = {
				type = "execute",
			  name = L["Test"],
				desc = L["Send test messages with current settings"],
			  func = function() Tankalyze:Test() end,
			  order = 100,
			},
			menu = {
				type = "execute",
				name = L["Menu"],
				desc = L["Show Menu"],
				func = function() Tankalyze:ShowMenu() end,
				order = 101,
			}
	  },
  }
end

function Tankalyze:HideOpts(englishClass)
  if (englishClass ~= "WARRIOR") then
		-- Ugly hide non-Warrior options
		self.opts.args.resists.args.taunt = nil
		self.opts.args.resists.args.mocking = nil
		self.opts.args.resists.args.shout = nil
		self.opts.args.resists.args.messages.args.taunt = nil
		self.opts.args.resists.args.messages.args.mocking = nil
		self.opts.args.resists.args.messages.args.shout = nil
		
		self.opts.args.announces.args.wall = nil
		self.opts.args.announces.args.stand = nil
		self.opts.args.announces.args.gem = nil
		self.opts.args.announces.args.shout = nil
		self.opts.args.announces.args.messages.args.wall = nil
		self.opts.args.announces.args.messages.args.stand = nil
		self.opts.args.announces.args.messages.args.gem = nil
		self.opts.args.announces.args.messages.args.shout = nil
	elseif (englishClass ~= "DRUID") then
		-- Ugly hide non-Druid options
		self.opts.args.resists.args.growl = nil
		self.opts.args.resists.args.roar = nil
		self.opts.args.resists.args.messages.args.growl = nil
		self.opts.args.resists.args.messages.args.roar = nil
		
		self.opts.args.announces.args.roar = nil
		self.opts.args.announces.args.messages.args.roar = nil
	end
end

function Tankalyze:IsInBattleground()
	local inInstance, instanceType = IsInInstance() 
	
	if (instanceType == "pvp") then return true else return false end
	-- Prolly don't work with arena but w/e
end
