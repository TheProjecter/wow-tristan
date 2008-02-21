local AddOn = LibStub("AceAddon-3.0"):GetAddon("EquivalencePoints", true);
if (not AddOn) then return; end
local _G = getfenv(0);
local L = LibStub("AceLocale-3.0"):GetLocale("EquivalencePoints", true)
local print = function(...) AddOn:Print(...); end
local debug = function(...) AddOn:Debug(...); end

--[[ I LOVE THESE ]]--
local orderNum = 0;
local function OrderNum()
	orderNum = orderNum + 1;
	return orderNum;
end

local function BR()
	return {order = OrderNum(), type = "description", name = " " };
end

local headerNum = 0;
local function HeaderName()
	headerNum = headerNum + 1;
	return "Header"..headerNum;
end

local function Header(text, Width)
	return { name = text, order = OrderNum(), type = "header", cmdHidden = true, width = (Width or "full") };
end

-- Returns a table for an execute option
local function CreateExecute(Name, Description, Exec, Width)
	return {
		name = Name,
		type = "execute",
		order = OrderNum(),
		desc = Description,
		func = Exec,
		width = Width,
	};
end

local function getBaseOption(info)
	return AddOn.db.profile[info[#info]];
end

local function setBaseOption(info, value)
	AddOn.db.profile[info[#info]] = value;
end

local function tglBaseOption(info)
	AddOn.db.profile[info[#info]] = not AddOn.db.profile[info[#info]];
end

local function getValueOption(info)
	return AddOn.db.profile.Values[info[#info]];
end

local function setValueOption(info, value)
	AddOn.db.profile.Values[info[#info]] = value;
end

local function getColor(info)
	return AddOn.db.profile[info[#info]].r, AddOn.db.profile[info[#info]].g, AddOn.db.profile[info[#info]].b, AddOn.db.profile[info[#info]].a;
end

local function setColor(info, r, g, b, a)
	AddOn.db.profile[info[#info]] = { r = r, g = g, b = b, a = a };	
end

local epMin = 0;
local epMax = 10;
local epStep = (1 / 100);

function AddOn:Options()
	local options = {
		type = "group",
		icon = [[Interface/Icons/INV_Jewelcrafting_LivingRuby_02]],
		name = L["_cmd _name EquivalencePoints"],
		childGroups = "tree",
		args = {
			Config = {
				name = L["_cmd _name Config"],
				type = "execute",
				order = OrderNum(),
				desc = L["_cmd _desc Config"],
				func = function() LibStub("AceConfigDialog-3.0"):Open("EquivalencePoints") end,
				guiHidden = true,
				dialogHidden = true,
				dropdownHidden = true,
			},
			HackExpertise = {
				order = OrderNum(),
				name = L["_cmd _name Hack Expertise"],
				type = "toggle",
				desc = L["_cmd _desc Hack Expertise"],
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			
			Consumables = {
				order = OrderNum(),
				name = L["_cmd _name Consumables"],
				type = "toggle",
				desc = L["_cmd _desc Consumables"],
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			ProcsAndUse = {
				order = OrderNum(),
				name = L["_cmd _name Procs and Use"],
				type = "toggle",
				desc = L["_cmd _desc Procs and Use"],
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			
			ListGems = {
				order = OrderNum(),
				name = L["_cmd _name List Gems"],
				type = "toggle",
				desc = L["_cmd _desc List Gems"],
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			ListSetGems = {
				order = OrderNum(),
				name = L["_cmd _name List Set Gems"],
				type = "toggle",
				desc = L["_cmd _desc List Set Gems"],
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			ClassSpecifics = {
				order = OrderNum(),
				name = L["_cmd _name Class Specifics"],
				type = "toggle",
				desc = L["_cmd _desc Class Specifics"],
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			RaceSpecifics = {
				order = OrderNum(),
				name = L["_cmd _name Race Specifics"],
				type = "toggle",
				desc = L["_cmd _desc Race Specifics"],
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			
			Layout = {
				order = OrderNum(),
				name = L["_cmd _name Layout"],
				type = "group",
				cmdHidden = true,
				args = {
					[HeaderName()] = Header(L["_cmd _name Zero values options"]),
					ShowZero = {
						order = OrderNum(),
						name = L["_cmd _name Show Zero"],
						type = "toggle",
						desc = L["_cmd _desc Show Zero"],
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
					ShowNoBonuses = {
						order = OrderNum(),
						name = L["_cmd _name Show no Bonus items"],
						type = "toggle",
						desc = L["_cmd _desc Show no Bonus items"],
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
					
					[HeaderName()] = Header("Empty lines"),
					EmptyLineAbove = {
						order = OrderNum(),
						name = L["_cmd _name Empty Line Above"],
						type = "toggle",
						desc = L["_cmd _desc Empty Line Above"],
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
					EmptyLineBelow = {
						order = OrderNum(),
						name = L["_cmd _name Empty Line Below"],
						type = "toggle",
						desc = L["_cmd _desc Empty Line Below"],
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
					
					[HeaderName()] = Header(L["_cmd _name Colors"]),
					
					Color = {
						order = OrderNum(),
						name = L["_cmd _name Color"],
						type = "color",
						desc = L["_cmd _desc Color"],
						hasAlpha = false,
						--arg = "PartyFrameColors",
						get = getColor,
						set = setColor,
					},
					
					ClassSpecificsColor = {
						order = OrderNum(),
						name = L["_cmd _name Class color"],
						type = "toggle",
						desc = L["_cmd _desc Class color"],
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
				},
			},
			
			Values = {
				order = OrderNum(),
				name = L["_cmd _name Values"],
				type = "group",
				cmdHidden = true,
				args = {
					-- insert with for loop, cbfa updating it manually ;)
				},
			},
			
			-- LibStub("AceSerializer-3.0");
			-- Sets (save and load from sets)
			Sets = {
				order = OrderNum(),
				name = L["_cmd _name Sets"],
				type = "group",
				cmdHidden = true,
				args = {
					[HeaderName()] = Header(L["_cmd _name Set operations"]),
					Save = {
						order = OrderNum(),
						name = L["_cmd _name Save as Set"],
						type = "input",
						width = "full",
						desc = L["_cmd _desc Save as Set"],
						get = function() return ""; end,
						set = function(info, value)
							self.db.profile.ValueSet[value] = nil;
							self.db.profile.ValueSet[value] = table.copy(self:TrimTable(self.db.profile.Values));
						end,
						validate = function(info, value)
							if (self.db.profile.ValueSet[value]) then return string.format(L["Set [%s] allready exists!"], value); end
							return true;
						end
					},
					Delete = {
						name = L["_cmd _name Delete set"],
						order = OrderNum(),
						type = "select",
						desc = L["_cmd _desc Delete set"],
						width = "full",
						values = function()
							local presets = {};
							for set in pairs(self.db.profile.ValueSet) do
								presets[set] = set;
							end
							return presets;
						end,
						set = function(info, value)
							self.db.profile.ValueSet[value] = nil;
							self:SetCleanup();
						end,
						validate = function(info, value)
							if (not self.db.profile.ValueSet[value]) then return string.format(L["Set [%s] doesn't exist!"], value); end
							return true;
						end
					},
					Load = {
						name = L["_cmd _name Load set"],
						order = OrderNum(),
						type = "select",
						desc = L["_cmd _desc Load set"],
						width = "full",
						values = function()
							local presets = {};
							for set in pairs(self.db.profile.ValueSet) do
								presets[set] = set;
							end
							return presets;
						end,
						set = function(info, value) self:Import(self.db.profile.ValueSet[value]); end,
						validate = function(info, value)
							if (not self.db.profile.ValueSet[value]) then return string.format(L["Set [%s] doesn't exist!"], value); end
							return true;
						end
					},
					
					[HeaderName()] = Header(L["_cmd _name Set Visibility"]),
					Hide = {
						name = L["_cmd _name Hide set"],
						order = OrderNum(),
						type = "select",
						desc = L["_cmd _desc Hide set"],
						width = "full",
						values = function()
							local presets = {};
							for set in pairs(self.db.profile.ValueSet) do
								if (not self.db.profile.HiddenSet[set]) then
									presets[set] = set;
								end
							end
							return presets;
						end,
						set = function(info, value) self.db.profile.HiddenSet[value] = true; end,
						validate = function(info, value)
							if (not self.db.profile.ValueSet[value]) then return string.format(L["Set [%s] doesn't exist!"], value); end
							if (self.db.profile.HiddenSet[value]) then return string.format(L["Set [%s] is allready hidden!"], value); end
							return true;
						end
					},
					UnHide = {
						name = L["_cmd _name UnHide set"],
						order = OrderNum(),
						type = "select",
						desc = L["_cmd _desc UnHide set"],
						width = "full",
						values = function()
							local presets = {};
							for set in pairs(self.db.profile.HiddenSet) do
								if (self.db.profile.ValueSet[set]) then
									presets[set] = set;
								end
							end
							return presets;
						end,
						set = function(info, value) self.db.profile.HiddenSet[value] = nil; end,
						validate = function(info, value)
							if (not self.db.profile.HiddenSet[value]) then return string.format(L["Set [%s] isn't hidden!"], value); end
							return true;
						end
					},
				},
			},
			
			Import = {
				order = OrderNum(),
				name = L["_cmd _name Import"],
				type = "group",
				cmdHidden = true,
				args = {
					--[HeaderName()] = Header("http://theorycraft.narod.ru/"),
					LootrankImport = {
						order = OrderNum(),
						name = L["_cmd _name Lootrank http://www.lootrank.com/"],
						type = "input",
						width = "full",
						desc = L["_cmd _desc Lootrank http://www.lootrank.com/"],
						get = function() return ""; end,
						set = function(info, value) self:LootrankImport(value); end,
						multiline = true,
					},
					
					CrazyShamanImport = {
						order = OrderNum(),
						name = L["_cmd _name CrazyShaman http://theorycraft.narod.ru/"],
						type = "input",
						width = "full",
						desc = L["_cmd _desc CrazyShaman http://theorycraft.narod.ru/"],
						get = function() return L["__CRAZYSHAMAN_URL__"]; end,
						set = function(info, value) self:CrazyShamanImport(value); end,
					},
					
					ImportPresets = {
						name = L["_cmd _name Preset values"],
						order = OrderNum(),
						type = "select",
						desc = L["_cmd _desc Preset values"],
						width = "full",
						values = function()
							local presets = {};
							for set in pairs(self.db.profile.Presets) do
								presets[set] = set;
							end
							return presets;
						end,
						set = function(info, value) self:ImportPreSets(value); end,
					},
					
					[HeaderName()] = Header(L["_cmd _name Settings"]),
					
					ReceiveValues = {
						order = OrderNum(),
						name = L["_cmd _name Receive values"],
						type = "toggle",
						desc = L["_cmd _desc Receive values"],
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
					
					[HeaderName()] = Header(L["_cmd _name Session"]),
					SessionImport = {
						order = OrderNum(),
						name = L["_cmd _name Import"],
						type = "input",
						width = "full",
						desc = L["_cmd _desc Import"],
						get = function() return ""; end,
						set = function(info, value) self:Deserialize(value, "Session"); end,
						multiline = true,
					},
					
					EnhancerImportHeader = Header(L["_cmd _name Enhancer Import Options"]),
					EAEP = CreateExecute(L["_cmd _name EAEP"], L["_cmd _desc EAEP"], function() AddOn:ImportEnhancerAEP(); end),
					EHEP = CreateExecute(L["_cmd _name EHEP"], L["_cmd _desc EHEP"], function() AddOn:ImportEnhancerHEP(); end),
					EDEP = CreateExecute(L["_cmd _name EDEP"], L["_cmd _desc EDEP"], function() AddOn:ImportEnhancerDEP(); end),
				},
			},
			
			Export = {
				order = OrderNum(),
				name = L["_cmd _name Export"],
				type = "group",
				cmdHidden = true,
				args = {
					SendValues = {
						order = OrderNum(),
						name = L["_cmd _name Send values"],
						type = "input",
						width = "full",
						desc = L["_cmd _desc Send values"],
						get = function() return ""; end,
						set = function(info, value) self:SendValues(value); end,
					},
					
					[HeaderName()] = Header(L["_cmd _name Session"]),
					SessionExport = {
						order = OrderNum(),
						name = L["_cmd _name Export"],
						type = "input",
						width = "full",
						desc = L["_cmd _desc Export"],
						get = function() return self:Serialize(); end,
						set = function(info, value) return; end,
						multiline = true,
					},
				},
			},
			
			Gems = {
				order = OrderNum(),
				name = L["_cmd _name Gems"],
				type = "group",
				cmdHidden = true,
				args = {
					
					MatchRarity = {
						order = OrderNum(),
						name = L["_cmd _name Match Rarity"],
						type = "toggle",
						desc = L["_cmd _desc Match Rarity"],
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
					
					[HeaderName()] = Header(L["_cmd _name Rarity Settings"]),
					
					MaxRarity = {
						order = OrderNum(),
						name = L["_cmd _name Max Rarity"],
						type = "range",
						desc = L["_cmd _desc Max Rarity"],
						min = 1,
						max = 4,
						step = 1,
						get = getBaseOption,
						set = setBaseOption,
						width = nil,
					},
					MaxAvailRarity = {
						order = OrderNum(),
						name = L["_cmd _name Max Avail Rarity"],
						type = "range",
						desc = L["_cmd _desc Max Avail Rarity"],
						min = 1,
						max = 4,
						step = 1,
						get = getBaseOption,
						set = setBaseOption,
						width = nil,
					},
					
					[HeaderName()] = Header(L["_cmd _name Best colored Gem"]),
					
					Blue 					 = CreateExecute(L["_cmd _name Blue"], L["_cmd _desc Blue"], function() AddOn:PrintBestGem("Blue"); end),
					Red 					 = CreateExecute(L["_cmd _name Red"], L["_cmd _desc Red"], function() AddOn:PrintBestGem("Red"); end),
					Yellow 				 = CreateExecute(L["_cmd _name Yellow"], L["_cmd _desc Yellow"], function() AddOn:PrintBestGem("Yellow"); end),
					
					[HeaderName()] = Header(L["_cmd _name Best meta Gem"]),
					
					Meta 					 = CreateExecute(L["_cmd _name Meta"], L["_cmd _desc Meta"], function() AddOn:PrintBestGem("Meta"); end),
					
					[HeaderName()] = Header(L["_cmd _name Best non-meta Gem"]),
					
					Any 					 = CreateExecute(L["_cmd _name Any"], L["_cmd _desc Any"], function() AddOn:PrintBestGem("AnyColor"); end),
				},
			},
			
			Dev = {
				order = OrderNum(),
				name = L["_cmd _name Dev Tools"],
				type = "group",
				cmdHidden = true,
				args = {
					Debug = {
						order = OrderNum(),
						name = L["_cmd _name Debug"],
						type = "toggle",
						desc = L["_cmd _desc Debug"],
						get = function() return AddOn.debug; end,
						set = function(info, value) AddOn.debug = not AddOn.debug; end,
					},
					
					[HeaderName()] = Header(L["_cmd _name Contact"]),
					
					EMAIL = {
						order = OrderNum(),
						name = L["_cmd _name E-mail"],
						type = "input",
						width = "full",
						desc = L["_cmd _desc E-mail"],
						get = function() return self:SpamSafe(L["__EMAIL__"]); end,
						set = function(info, value) return; end,
					},
					
					CrazyShamanImport = {
						order = OrderNum(),
						name = L["_cmd _name Website"],
						type = "input",
						width = "full",
						desc = L["_cmd _desc Website"],
						get = function() return self:SpamSafe(L["__URL__"]); end,
						set = function(info, value) return; end,
					},
				},
			}
		},
	};
	
	if (not _G["Enhancer"]) then
		options.args.Import.args.EnhancerImportHeader = nil;
		options.args.Import.args.EAEP = nil;
		options.args.Import.args.EHEP = nil;
		options.args.Import.args.EDEP = nil;
	end
	
	options.args.Values.args["Reset"] = CreateExecute(L["_cmd _name Reset"], L["_cmd _desc Reset"], function() for key in pairs(self.db.profile.Values) do self.db.profile.Values[key] = 0; end end, "full")
	for key,value in self:DefaultValues():opairs() do
		if (key == "EMPTY_SOCKET_META") then -- not limited to value 10 etc
			if (self.db.profile.Values[key] and tonumber(self.db.profile.Values[key])) then
				options.args.Values.args[key]	= {
					order = OrderNum(),
					name = self:TranslateValueKey(key),
					type = "range",
					desc = string.format(L["_cmd _desc _Values"], self:TranslateValueKey(key)),
					min = 0,
					max = 250,
					step = epStep,
					bigStep = 1,
					get = getValueOption,
					set = setValueOption,
					width = "full",
				};
				options.args.Values.args[key .. "_BR"] = BR();
			end
		else
			if (self.db.profile.Values[key] and tonumber(self.db.profile.Values[key])) then
				options.args.Values.args[key]	= {
					order = OrderNum(),
					name = self:TranslateValueKey(key),
					type = "range",
					desc = string.format(L["_cmd _desc _Values"], self:TranslateValueKey(key)),
					min = epMin,
					max = epMax,
					step = epStep,
					bigStep = (epStep * 10),
					get = getValueOption,
					set = setValueOption,
					width = "full",
				};
				options.args.Values.args[key .. "_BR"] = BR();
			end
		end
	end
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("EquivalencePoints", options, {L["/EqP"], L["/Equiv"], L["/EquivalencePoints"]});
end