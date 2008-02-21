local AddOn = LibStub("AceAddon-3.0"):GetAddon("EquivalencePoints", true);
if (not AddOn) then return; end
local _G = getfenv(0);
local L = LibStub("AceLocale-3.0"):GetLocale("EquivalencePoints", true)
local print = function(...) AddOn:Print(...); end
local debug = function(...) AddOn:Debug(...); end end

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
				name = L["_cmd _name config"],
				type = "execute",
				order = OrderNum(),
				desc = "desc",
				func = function() LibStub("AceConfigDialog-3.0"):Open("EquivalencePoints") end,
				guiHidden = true,
				dialogHidden = true,
				dropdownHidden = true,
			},
			HackExpertise = {
				order = OrderNum(),
				name = L["_cmd _name Hack Expertise"],
				type = "toggle",
				desc = "Only account for usable Expertise Rating on items.",
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			
			Consumables = {
				order = OrderNum(),
				name = L["_cmd _name Consumables"],
				type = "toggle",
				desc = "DataMined bonuses for Consumables.",
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			ProcsAndUse = {
				order = OrderNum(),
				name = L["_cmd _name Procs and Use"],
				type = "toggle",
				desc = "Calculated bonuses for procs and/or use effects.",
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			
			ListGems = {
				order = OrderNum(),
				name = L["_cmd _name List Gems"],
				type = "toggle",
				desc = "List gems used in calculations.",
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			ListSetGems = {
				order = OrderNum(),
				name = L["_cmd _name List Set Gems"],
				type = "toggle",
				desc = "List gems used in calculations even for sets.",
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			ClassSpecifics = {
				order = OrderNum(),
				name = "Class Specifics",
				type = "toggle",
				desc = "Some classes have a bit more info that EP can display, check this if you want to see it.",
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			RaceSpecifics = {
				order = OrderNum(),
				name = "Race Specifics",
				type = "toggle",
				desc = "Adds expertise to swords if you're Human, expertise to axes if you're an Orc etc etc.",
				get = getBaseOption,
				set = tglBaseOption,
				width = nil,
			},
			
			Layout = {
				order = OrderNum(),
				name = "Layout",
				type = "group",
				cmdHidden = true,
				args = {
					[HeaderName()] = Header("Zero values options"),
					ShowZero = {
						order = OrderNum(),
						name = "Show Zero",
						type = "toggle",
						desc = "Show Equivalence Points even if the values is zero.",
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
					ShowNoBonuses = {
						order = OrderNum(),
						name = "Show no Bonus items",
						type = "toggle",
						desc = "Show the zero even if the item has no bonuses at all (only when ShowZero is active).",
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
					
					[HeaderName()] = Header("Empty lines"),
					EmptyLineAbove = {
						order = OrderNum(),
						name = "Empty Line Above",
						type = "toggle",
						desc = "Adds an empty line above the data in the tooltip.",
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
					EmptyLineBelow = {
						order = OrderNum(),
						name = "Empty Line Below",
						type = "toggle",
						desc = "Adds an empty line below the data in the tooltip.",
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
					
					[HeaderName()] = Header("Colors"),
					
					Color = {
						order = OrderNum(),
						name = "Color",
						type = "color",
						desc = "Change the color of the text in tooltips.",
						hasAlpha = false,
						--arg = "PartyFrameColors",
						get = getColor,
						set = setColor,
					},
					
					ClassSpecificsColor = {
						order = OrderNum(),
						name = "Class color",
						type = "toggle",
						desc = "Colors the class specific data with class colors.",
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
				},
			},
			
			Values = {
				order = OrderNum(),
				name = "Values",
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
				name = "Sets",
				type = "group",
				cmdHidden = true,
				args = {
					[HeaderName()] = Header("Set operations"),
					Save = {
						order = OrderNum(),
						name = "Save as Set",
						type = "input",
						width = "full",
						desc = "Save current values as an alternative Set",
						get = function() return ""; end,
						set = function(info, value)
							self.db.profile.ValueSet[value] = nil;
							self.db.profile.ValueSet[value] = table.copy(self:TrimTable(self.db.profile.Values));
						end,
						validate = function(info, value)
							if (self.db.profile.ValueSet[value]) then return string.format("Set [%s] allready exists!", value); end
							return true;
						end
					},
					Delete = {
						name = "Delete set",
						order = OrderNum(),
						type = "select",
						desc = "Delete a saved set.",
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
							if (not self.db.profile.ValueSet[value]) then return string.format("Set [%s] doesn't exist!", value); end
							return true;
						end
					},
					Load = {
						name = "Load set",
						order = OrderNum(),
						type = "select",
						desc = "Load a saved set.",
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
							if (not self.db.profile.ValueSet[value]) then return string.format("Set [%s] doesn't exist!", value); end
							return true;
						end
					},
					
					[HeaderName()] = Header("Set Visibility"),
					Hide = {
						name = "Hide set",
						order = OrderNum(),
						type = "select",
						desc = "Prevents a saved set from showing up in tooltips.",
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
							if (not self.db.profile.ValueSet[value]) then return string.format("Set [%s] doesn't exist!", value); end
							if (self.db.profile.HiddenSet[value]) then return string.format("Set [%s] is allready hidden!", value); end
							return true;
						end
					},
					UnHide = {
						name = "UnHide set",
						order = OrderNum(),
						type = "select",
						desc = "Make a hidden set show up in tooltips again.",
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
							if (not self.db.profile.HiddenSet[value]) then return string.format("Set [%s] isn't hidden!", value); end
							return true;
						end
					},
				},
			},
			
			Import = {
				order = OrderNum(),
				name = "Import",
				type = "group",
				cmdHidden = true,
				args = {
					--[HeaderName()] = Header("http://theorycraft.narod.ru/"),
					LootrankImport = {
						order = OrderNum(),
						name = "Lootrank http://www.lootrank.com/",
						type = "input",
						width = "full",
						desc = "Import data from lootrank by entering a lootrank url.",
						get = function() return ""; end,
						set = function(info, value) self:LootrankImport(value); end,
						multiline = true,
					},
					
					CrazyShamanImport = {
						order = OrderNum(),
						name = "CrazyShaman http://theorycraft.narod.ru/",
						type = "input",
						width = "full",
						desc = "Import data from CrazyShaman simulator.",
						get = function() return ""; end,
						set = function(info, value) self:CrazyShamanImport(value); end,
					},
					
					ImportPresets = {
						name = "Preset values you can import",
						order = OrderNum(),
						type = "select",
						desc = "Import preset values.",
						width = "full",
						values = function()
							local presets = {};
							--for _, set in ipairs({"Shaman Enhance (low)", "Shaman Enhance (medium)", "Shaman Enhance (high)", "Rogue Dagger Twink (29)"}) do
							for set in pairs(self.db.profile.Presets) do
								presets[set] = set;
							end
							return presets;
						end,
						set = function(info, value) self:ImportPreSets(value); end,
					},
					
					[HeaderName()] = Header("Settings"),
					
					ReceiveValues = {
						order = OrderNum(),
						name = "Receive values",
						type = "toggle",
						desc = "Allow other users of this AddOn to send you their values.",
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
					
					[HeaderName()] = Header("Session"),
					SessionImport = {
						order = OrderNum(),
						name = "Import",
						type = "input",
						width = "full",
						desc = "Import data from another session.",
						get = function() return ""; end,
						set = function(info, value) self:Deserialize(value, "Session"); end,
						multiline = true,
					},
					
					EnhancerImportHeader = Header("Enhancer Import Options"),
					EAEP = CreateExecute("EAEP", "Enhancer AEP", function() AddOn:ImportEnhancerAEP(); end),
					EHEP = CreateExecute("EHEP", "Enhancer HEP", function() AddOn:ImportEnhancerHEP(); end),
					EDEP = CreateExecute("EDEP", "Enhancer DEP", function() AddOn:ImportEnhancerDEP(); end),
				},
			},
			
			Export = {
				order = OrderNum(),
				name = "Export",
				type = "group",
				cmdHidden = true,
				args = {
					SendValues = {
						order = OrderNum(),
						name = "Send values",
						type = "input",
						width = "full",
						desc = "Send your main values to a friend.",
						get = function() return ""; end,
						set = function(info, value) self:SendValues(value); end,
					},
					
					[HeaderName()] = Header("Session"),
					SessionExport = {
						order = OrderNum(),
						name = "Export",
						type = "input",
						width = "full",
						desc = "Copy paste what's in the textbox and you can import it to another char via import tab.",
						get = function() return self:Serialize(); end,
						set = function(info, value) return; end,
						multiline = true,
					},
				},
			},
			
			Gems = {
				order = OrderNum(),
				name = "Gems",
				type = "group",
				cmdHidden = true,
				args = {
					
					MatchRarity = {
						order = OrderNum(),
						name = "Match Rarity",
						type = "toggle",
						desc = "MatchRarity will use rare gems for rare gear, epic gems for epic gear and so forth.",
						get = getBaseOption,
						set = tglBaseOption,
						width = nil,
					},
					
					[HeaderName()] = Header("Rarity Settings"),
					
					MaxRarity = {
						order = OrderNum(),
						name = "Max Rarity",
						type = "range",
						desc = "Sets the maximum rarity for gems (unless overriden by MatchRarity or MaxAvailRarity)",
						min = 1,
						max = 4,
						step = 1,
						get = getBaseOption,
						set = setBaseOption,
						width = nil,
					},
					MaxAvailRarity = {
						order = OrderNum(),
						name = "Max Avail Rarity",
						type = "range",
						desc = "Sets the maximum rarity for gems you have access to (overrides MaxRarity)",
						min = 1,
						max = 4,
						step = 1,
						get = getBaseOption,
						set = setBaseOption,
						width = nil,
					},
					
					[HeaderName()] = Header("Best colored Gem"),
					
					Blue 					 = CreateExecute("Blue", "Display best Blue gem", function() AddOn:PrintBestGem("Blue"); end),
					Red 					 = CreateExecute("Red", "Display best Red gem", function() AddOn:PrintBestGem("Red"); end),
					Yellow 				 = CreateExecute("Yellow", "Display best Yellow gem", function() AddOn:PrintBestGem("Yellow"); end),
					
					[HeaderName()] = Header("Best meta Gem"),
					
					Meta 					 = CreateExecute("Meta", "Display best Meta gem", function() AddOn:PrintBestGem("Meta"); end),
					
					[HeaderName()] = Header("Best non-meta Gem"),
					
					Any 					 = CreateExecute("Any", "Display best non-Meta gem", function() AddOn:PrintBestGem("AnyColor"); end),
				},
			},
			
			Dev = {
				order = OrderNum(),
				name = "Dev Tools",
				type = "group",
				cmdHidden = true,
				args = {
					Debug = {
						order = OrderNum(),
						name = "Debug",
						type = "toggle",
						desc = "Toggle Debugging",
						get = function() return AddOn.debug; end,
						set = function(info, value) AddOn.debug = not AddOn.debug; end,
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
	
	options.args.Values.args["Reset"] = CreateExecute("Reset", "Reset all values to zero", function() for key in pairs(self.db.profile.Values) do self.db.profile.Values[key] = 0; end end, "full")
	for key,value in self:DefaultValues():opairs() do
		if (key == "EMPTY_SOCKET_META") then -- not limited to value 10 etc
			if (self.db.profile.Values[key] and tonumber(self.db.profile.Values[key])) then
				options.args.Values.args[key]	= {
					order = OrderNum(),
					name = self:TranslateValueKey(key),
					type = "range",
					desc = "Set value for " .. self:TranslateValueKey(key),
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
					desc = "Set value for " .. self:TranslateValueKey(key),
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