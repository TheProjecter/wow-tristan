local L = AceLibrary("AceLocale-2.2"):new("Enhancer");
local SML = AceLibrary("SharedMedia-1.0");
SML:Register("font", "Adventure",	[[Interface\AddOns\Enhancer\fonts\Adventure.ttf]]);
SML:Register("font", "The Godfather",	[[Interface\AddOns\Enhancer\fonts\CorleoneDue.ttf]]);
SML:Register("font", "Corleone",	[[Interface\AddOns\Enhancer\fonts\Corleone.ttf]]);
SML:Register("font", "Sopranos",	[[Interface\AddOns\Enhancer\fonts\Mobsters.ttf]]);
SML:Register("font", "Friz Quadrata TT", [[Fonts\FRIZQT__.ttf]]);
SML:Register("font", "Weltron Urban", [[Interface\AddOns\Enhancer\fonts\weltu.ttf]]);
SML:Register("font", "Jokewood", [[Interface\AddOns\Enhancer\fonts\jokewood.ttf]]);
SML:Register("font", "Freshbot", [[Interface\AddOns\Enhancer\fonts\freshbot.ttf]]);
SML:Register("font", "Chick", [[Interface\AddOns\Enhancer\fonts\chick.ttf]]);
SML:Register("font", "Alba Super", [[Interface\AddOns\Enhancer\fonts\albas.ttf]]);
SML:Register("font", "Wild Ride", [[Interface\AddOns\Enhancer\fonts\WildRide.ttf]]);
local SML_fonts = SML:List("font");



--[[ Start: I LOVE THESE ]]--
local orderNum = 0;
local function OrderNum()
	orderNum = orderNum + 1;
	return orderNum;
end

local spacerNum = 0;
local function SpacerName()
	spacerNum = spacerNum + 1;
	return "Spacer"..spacerNum;
end
local function SpacerTable()
	return { type = "header", order = OrderNum(), };
end
--[[ End: I LOVE THESE ]]--

local epMin = 0;
local epMax = 5;
local epStep = (1 / 10);
local defaults = {
	locked = true,
	framesize = 35,
	
	combatinactiveAlpha = (3 / 10),
	oocinactiveAlpha = 0,
	combatAlpha = 1,
	oocombatAlpha = (7 / 10),
	specialAlpha = true,
	killYards = 150,
	yardKill = true,
	
	playSound = false,
	growingPulse = true,
	borderPulse = false,
	buffIndicator = "noindication",
	snap = true,
	roman = true,
	blizzTime = false,
	blizzSsec = true,
	warnExpire = true,
	warnDeath = true,
	warnSlain = true,
	warnTime = 7,
	
	EPZero = true,
	AEP = true,
	AEPH = true,
	HEP = false,
	DEP = false,
	DEPH = false,
	EIP = true,
	EPGems = {
		maxQuality = 3,
		maxQualityNonEpic = 0,
		metaGems = true,
	},
	EPGuesstimates = true,
	EPGemGuesstimates = false,
	
	aboveFontID = "Friz Quadrata TT",
	aboveFontName = [[Fonts\FRIZQT__.ttf]],
	aboveFontSize = 12,
	aboveFontFlags = "OUTLINE",
	
	centerFontID = "Adventure",
	centerFontName = [[Interface\AddOns\Enhancer\fonts\Adventure.ttf]],
	centerFontSize = 16,
	centerFontFlags = "OUTLINE",
	
	belowFontID = "Adventure",
	belowFontName = [[Interface\AddOns\Enhancer\fonts\Adventure.ttf]],
	belowFontSize = 12,
	belowFontFlags = "OUTLINE",
	
	AEPNumbers = {
		ATTACKPOWER = (10 / 10),
		STR = (20 / 10),
		AGI = (18 / 10),
		STA = (0 / 10),
		CR_CRIT = (20 / 10),
		CR_HIT = (14 / 10),
		CR_HASTE = (15 / 10), --(22 / 10),
		CR_EXPERTISE = (24 / 10),  -- Multiply hit rating AEP by 1.8 if you assume that the mob will never cast and never parry.
		CR_RESILIENCE = (0 / 10),
		IGNOREARMOR = (3 / 10),
		WEAPON_MIN = (0 / 10),
		WEAPON_MAX = (0 / 10),
	},
	HEPNumbers = {
		HEAL = (10 / 10),
		INT = (8 / 10),
		SPI = (0 / 10), --1
		STA = (0 / 10),
		CR_SPELLCRIT = (1 / 10),
		CR_SPELLHASTE = (0 / 10), --3
		CR_RESILIENCE = (0 / 10),
		MANAREG = (27 / 10),
	},
	DEPNumbers = {
		DMG = (10 / 10),
		INT = (1 / 10),
		SPI = (0 / 10), --1,
		STA = (0 / 10),
		CR_SPELLCRIT = (2 / 10),
		CR_SPELLHIT = (6 / 10),
		CR_SPELLHASTE = (0 / 10), --3,
		CR_RESILIENCE = (0 / 10),
		MANAREG = (15 / 10),
	},
	
	startAnnounceDisabled = false,
	
	bonus = {},
	
	nagShit = {
		WF3Sec = 0,
	},
};
Enhancer:RegisterDefaults('profile', defaults);

function Enhancer:RegisterSlashCommands()
	local consoleoptions = {
		type = "group",
		args = {
		  [L["waterfall_cmd"]] = {
				name = L["waterfall_cmd"], type = "execute",
				desc = L["waterfall_desc"],
				func = function(v)
					Enhancer:Waterfall();
				end,
				order = OrderNum(),
			},
			[L["lock_cmd"]] = {
				name = L["lock_cmd"], type = "toggle",
				desc = L["lock_desc"],
				get = function() return Enhancer.db.profile.locked end,
				set = function(v)
					Enhancer.db.profile.locked = not Enhancer.db.profile.locked;
					Enhancer:ToggleLock();
				end,
				order = OrderNum(),
			},
			[L["reset_cmd"]] = {
				name = L["reset_cmd"], type = "execute",
				desc = L["reset_desc"],
				func = function(v)
					Enhancer:ResetPos();
					if (Enhancer.db.profile.framePositions) then Enhancer.db.profile.framePositions = nil; end
				end,
				order = OrderNum(),
			},
			[L["resize_cmd"]] = {
				name = L["resize_cmd"], type = "range",
				desc = L["resize_desc"],
				min = 20,
				max = 72,
				step = 1,
				get = function() return Enhancer.db.profile.framesize; end,
				set = function(v)
					Enhancer.db.profile.framesize = v;
					Enhancer:Resize();
				end,
				order = OrderNum(),
			},
			
			[SpacerName()] = SpacerTable(),
			
			[L["yard_group_cmd"]] = {
				type = "group",
				name = L["yard_group_cmd"],
				desc = L["yard_group_desc"],
				order = OrderNum(),
				args = {
					[L["yard_range_cmd"]] = {
						name = L["yard_range_cmd"], type = "range",
						desc = L["yard_range_desc"],
						min = 90, max = 400, step = 1,
						get = function() return Enhancer.db.profile.killYards; end,
						set = function(v)
							Enhancer.db.profile.killYards = v;
						end,
						order = OrderNum(),
					},
					[L["yard_active_cmd"]] = {
						name = L["yard_active_cmd"], type = "toggle",
						desc = L["yard_active_desc"],
						get = function() return Enhancer.db.profile.yardKill; end,
						set = function()
							Enhancer.db.profile.yardKill = not Enhancer.db.profile.yardKill;
						end,
						order = OrderNum(),
					},
				},
			},
			
			[SpacerName()] = SpacerTable(),
			
			[L["element_group_cmd"]] = {
				type = "group",
				name = L["element_group_cmd"],
				desc = L["element_group_desc"],
				order = OrderNum(),
				args = {
					[L["earth_cmd"]] = {
						name = L["earth_cmd"], type = "toggle",
						desc = string.format(L["element_desc"], L["earth_cmd"]),
						get = function() return (Enhancer:HasModule("Earth") and Enhancer:IsModuleActive("Earth")); end,
						set = function()
							if (Enhancer:HasModule("Earth")) then
								Enhancer:ToggleModuleActive("Earth");
							end
						end,
						order = OrderNum(),
					},
					[L["fire_cmd"]] = {
						name = L["fire_cmd"], type = "toggle",
						desc = string.format(L["element_desc"], L["fire_cmd"]),
						get = function() return (Enhancer:HasModule("Fire") and Enhancer:IsModuleActive("Fire")); end,
						set = function()
							if (Enhancer:HasModule("Fire")) then
								Enhancer:ToggleModuleActive("Fire");
							end
						end,
						order = OrderNum(),
					},
					[L["water_cmd"]] = {
						name = L["water_cmd"], type = "toggle",
						desc = string.format(L["element_desc"], L["water_cmd"]),
						get = function() return (Enhancer:HasModule("Water") and Enhancer:IsModuleActive("Water")); end,
						set = function()
							if (Enhancer:HasModule("Water")) then
								Enhancer:ToggleModuleActive("Water");
							end
						end,
						order = OrderNum(),
					},
					[L["air_cmd"]] = {
						name = L["air_cmd"], type = "toggle",
						desc = string.format(L["element_desc"], L["air_cmd"]),
						get = function() return (Enhancer:HasModule("Air") and Enhancer:IsModuleActive("Air")); end,
						set = function()
							if (Enhancer:HasModule("Air")) then
								Enhancer:ToggleModuleActive("Air");
							end
						end,
						order = OrderNum(),
					},
				},
			},
			[L["bonus_group_cmd"]] = {
				type = "group",
				name = L["bonus_group_cmd"],
				desc = L["bonus_group_desc"],
				order = OrderNum(),
				args = {
				--[[ Creating default place ]]--
				},
			},
			[L["ep_cmd"]] = {
				name = L["ep_cmd"], type = "toggle",
				desc = L["ep_desc"],
				get = function() return Enhancer:IsModuleActive("EP"); end,
				set = function()
					Enhancer:ToggleModuleActive("EP");
				end,
				order = OrderNum(),
			},
			
			[SpacerName()] = SpacerTable(),
			
			[L["ep_group_cmd"]] = {
				type = "group",
				name = L["ep_group_cmd"],
				desc = L["ep_group_desc"],
				order = OrderNum(),
				args = {
					[L["aep_cmd"]] = {
						name = L["aep_cmd"], type = "toggle",
						desc = L["aep_desc"],
						get = function() return Enhancer.db.profile.AEP; end,
						set = function()
							Enhancer.db.profile.AEP = not Enhancer.db.profile.AEP;
						end,
						order = OrderNum(),
					},
					[L["aeph_cmd"]] = {
						name = L["aeph_cmd"], type = "toggle",
						desc = L["aeph_desc"],
						get = function() return Enhancer.db.profile.AEPH; end,
						set = function()
							Enhancer.db.profile.AEPH = not Enhancer.db.profile.AEPH;
						end,
						order = OrderNum(),
					},
					[L["hep_cmd"]] = {
						name = L["hep_cmd"], type = "toggle",
						desc = L["hep_desc"],
						get = function() return Enhancer.db.profile.HEP; end,
						set = function()
							Enhancer.db.profile.HEP = not Enhancer.db.profile.HEP;
						end,
						order = OrderNum(),
					},
					[L["dep_cmd"]] = {
						name = L["dep_cmd"], type = "toggle",
						desc = L["dep_desc"],
						get = function() return Enhancer.db.profile.DEP; end,
						set = function()
							Enhancer.db.profile.DEP = not Enhancer.db.profile.DEP;
						end,
						order = OrderNum(),
					},
					[L["deph_cmd"]] = {
						name = L["deph_cmd"], type = "toggle",
						desc = L["deph_desc"],
						get = function() return Enhancer.db.profile.DEPH; end,
						set = function()
							Enhancer.db.profile.DEPH = not Enhancer.db.profile.DEPH;
						end,
						order = OrderNum(),
					},
					
					
					[SpacerName()] = SpacerTable(),
					
					[L["epz_cmd"]] = {
						name = L["epz_cmd"], type = "toggle",
						desc = L["epz_desc"],
						get = function() return Enhancer.db.profile.EPZero; end,
						set = function()
							Enhancer.db.profile.EPZero = not Enhancer.db.profile.EPZero;
						end,
						order = OrderNum(),
					},
					
					[SpacerName()] = SpacerTable(),
					
					[L["eip_cmd"]] = {
						name = L["eip_cmd"], type = "toggle",
						desc = L["eip_desc"],
						get = function() return Enhancer.db.profile.EIP; end,
						set = function()
							Enhancer.db.profile.EIP = not Enhancer.db.profile.EIP;
						end,
						order = OrderNum(),
					},
				},
			},
			[L["ep_numbers_cmd"]] = {
				type = "group",
				name = L["ep_numbers_cmd"],
				desc = L["ep_numbers_desc"],
				order = OrderNum(),
				args = {
					[L["aep_cmd"]] = {
						type = "group",
						name = L["aep_cmd"],
						desc = L["aep_cmd"],
						order = OrderNum(),
						args = {
							[L["ATTACKPOWER"]] = {
								name = L["ATTACKPOWER"], type = "range",
								desc = L["ATTACKPOWER"] .. L["base_warn"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.AEPNumbers.ATTACKPOWER; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.ATTACKPOWER = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["STR"]] = {
								name = L["STR"], type = "range",
								desc = L["STR"] .. L["base_warn"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.AEPNumbers.STR; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.STR = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["AGI"]] = {
								name = L["AGI"], type = "range",
								desc = L["AGI"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.AEPNumbers.AGI; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.AGI = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["STA"]] = {
								name = L["STA"], type = "range",
								desc = L["STA"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.AEPNumbers.STA; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.STA = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["CR_CRIT"]] = {
								name = L["CR_CRIT"], type = "range",
								desc = L["CR_CRIT"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.AEPNumbers.CR_CRIT; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.CR_CRIT = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["CR_HIT"]] = {
								name = L["CR_HIT"], type = "range",
								desc = L["CR_HIT"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.AEPNumbers.CR_HIT; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.CR_HIT = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["CR_EXPERTISE"]] = {
								name = L["CR_EXPERTISE"], type = "range",
								desc = L["CR_EXPERTISE"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.AEPNumbers.CR_EXPERTISE; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.CR_EXPERTISE = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["CR_HASTE"]] = {
								name = L["CR_HASTE"], type = "range",
								desc = L["CR_HASTE"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.AEPNumbers.CR_HASTE; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.CR_HASTE = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["CR_RESILIENCE"]] = {
								name = L["CR_RESILIENCE"], type = "range",
								desc = L["CR_RESILIENCE"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.AEPNumbers.CR_RESILIENCE; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.CR_RESILIENCE = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["IGNOREARMOR"]] = {
								name = L["IGNOREARMOR"], type = "range",
								desc = L["IGNOREARMOR"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.AEPNumbers.IGNOREARMOR; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.IGNOREARMOR = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["WEAPON_MIN"]] = {
								name = L["WEAPON_MIN"], type = "range",
								desc = L["WEAPON_MIN"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.AEPNumbers.WEAPON_MIN; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.WEAPON_MIN = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["WEAPON_MAX"]] = {
								name = L["WEAPON_MAX"], type = "range",
								desc = L["WEAPON_MAX"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.AEPNumbers.WEAPON_MAX; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.WEAPON_MAX = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["bestgem_cmd"]] = {
								type = "group",
								name = L["bestgem_cmd"],
								desc = L["bestgem_desc"],
								order = OrderNum(),
								args = {
									[L["blue"]] = {
										type = "execute",
										name = L["blue"],
										desc = L["blue"],
										func = function()
											if (Enhancer:HasModule("EP") and Enhancer:IsModuleActive("EP")) then
												Enhancer:GetModule("EP"):BestGem(Enhancer.db.profile.AEPNumbers, "Blue");
											else
												Enhancer:Print("EP module not active\available!");
											end
										end,
										order = OrderNum(),
									},
									[L["yellow"]] = {
										type = "execute",
										name = L["yellow"],
										desc = L["yellow"],
										func = function()
											if (Enhancer:HasModule("EP") and Enhancer:IsModuleActive("EP")) then
												Enhancer:GetModule("EP"):BestGem(Enhancer.db.profile.AEPNumbers, "Yellow");
											else
												Enhancer:Print("EP module not active\available!");
											end
										end,
										order = OrderNum(),
									},
									[L["red"]] = {
										type = "execute",
										name = L["red"],
										desc = L["red"],
										func = function()
											if (Enhancer:HasModule("EP") and Enhancer:IsModuleActive("EP")) then
												Enhancer:GetModule("EP"):BestGem(Enhancer.db.profile.AEPNumbers, "Red");
											else
												Enhancer:Print("EP module not active\available!");
											end
										end,
										order = OrderNum(),
									},
									[L["any"]] = {
										type = "execute",
										name = L["any"],
										desc = L["any"],
										func = function()
											if (Enhancer:HasModule("EP") and Enhancer:IsModuleActive("EP")) then
												Enhancer:GetModule("EP"):BestGem(Enhancer.db.profile.AEPNumbers);
											else
												Enhancer:Print("EP module not active\available!");
											end
										end,
										order = OrderNum(),
									},
								},
							},
							--[L["reset_cmd"]] = {
								--type = "execute",
								--name = L["reset_cmd"],
								--desc = L["reset_cmd"],
								--func = function()
									--for key, value in pairs(defaults.AEPNumbers) do
										--Enhancer.db.profile.AEPNumbers[key] = defaults.AEPNumbers[key];
									--end
								--end,
								--order = OrderNum(),
							--},
							
							[SpacerName()] = SpacerTable(),
							
							[L["aep_import_crazyshaman_cmd"]] = {
								type = "text",
								name = L["aep_import_crazyshaman_cmd"],
								desc = L["aep_import_crazyshaman_desc"],
								usage = "<string>",
								get = function() return ""; end,
								set = function(data)
									Enhancer:CrazyShamanImport(data);
								end,
								order = OrderNum(),
							},
							[L["low_cmd"]] = { -- Default
								type = "execute",
								name = L["low_cmd"],
								desc = L["low_desc"],
								func = function(data)
									for key, value in pairs(defaults.AEPNumbers) do
										Enhancer.db.profile.AEPNumbers[key] = defaults.AEPNumbers[key];
									end
								end,
								order = OrderNum(),
							},
							[L["high_cmd"]] = {
								type = "execute",
								name = L["high_cmd"],
								desc = L["high_desc"],
								func = function(data)
									Enhancer:StandardEPSets("high");
								end,
								order = OrderNum(),
							},
						},
					},
					[L["hep_cmd"]] = {
						type = "group",
						name = L["hep_cmd"],
						desc = L["hep_cmd"],
						order = OrderNum(),
						args = {
							[L["HEAL"]] = {
								name = L["HEAL"], type = "range",
								desc = L["HEAL"] .. L["base_warn"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.HEPNumbers.HEAL; end,
								set = function(v)
									Enhancer.db.profile.HEPNumbers.HEAL = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["INT"]] = {
								name = L["INT"], type = "range",
								desc = L["INT"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.HEPNumbers.INT; end,
								set = function(v)
									Enhancer.db.profile.HEPNumbers.INT = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["SPI"]] = {
								name = L["AGI"], type = "range",
								desc = L["AGI"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.HEPNumbers.SPI; end,
								set = function(v)
									Enhancer.db.profile.HEPNumbers.SPI = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["STA"]] = {
								name = L["STA"], type = "range",
								desc = L["STA"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.HEPNumbers.STA; end,
								set = function(v)
									Enhancer.db.profile.HEPNumbers.STA = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["CR_SPELLCRIT"]] = {
								name = L["CR_SPELLCRIT"], type = "range",
								desc = L["CR_SPELLCRIT"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.HEPNumbers.CR_SPELLCRIT; end,
								set = function(v)
									Enhancer.db.profile.HEPNumbers.CR_SPELLCRIT = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["CR_SPELLHASTE"]] = {
								name = L["CR_SPELLHASTE"], type = "range",
								desc = L["CR_SPELLHASTE"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.HEPNumbers.CR_SPELLHASTE; end,
								set = function(v)
									Enhancer.db.profile.HEPNumbers.CR_SPELLHASTE = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["CR_RESILIENCE"]] = {
								name = L["CR_RESILIENCE"], type = "range",
								desc = L["CR_RESILIENCE"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.HEPNumbers.CR_RESILIENCE; end,
								set = function(v)
									Enhancer.db.profile.HEPNumbers.CR_RESILIENCE = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["MANAREG"]] = {
								name = L["MANAREG"], type = "range",
								desc = L["MANAREG"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.HEPNumbers.MANAREG; end,
								set = function(v)
									Enhancer.db.profile.HEPNumbers.MANAREG = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["bestgem_cmd"]] = {
								type = "group",
								name = L["bestgem_cmd"],
								desc = L["bestgem_desc"],
								order = OrderNum(),
								args = {
									[L["blue"]] = {
										type = "execute",
										name = L["blue"],
										desc = L["blue"],
										func = function()
											if (Enhancer:HasModule("EP") and Enhancer:IsModuleActive("EP")) then
												Enhancer:GetModule("EP"):BestGem(Enhancer.db.profile.HEPNumbers, "Blue");
											else
												Enhancer:Print("EP module not active\available!");
											end
										end,
										order = OrderNum(),
									},
									[L["yellow"]] = {
										type = "execute",
										name = L["yellow"],
										desc = L["yellow"],
										func = function()
											if (Enhancer:HasModule("EP") and Enhancer:IsModuleActive("EP")) then
												Enhancer:GetModule("EP"):BestGem(Enhancer.db.profile.HEPNumbers, "Yellow");
											else
												Enhancer:Print("EP module not active\available!");
											end
										end,
										order = OrderNum(),
									},
									[L["red"]] = {
										type = "execute",
										name = L["red"],
										desc = L["red"],
										func = function()
											if (Enhancer:HasModule("EP") and Enhancer:IsModuleActive("EP")) then
												Enhancer:GetModule("EP"):BestGem(Enhancer.db.profile.HEPNumbers, "Red");
											else
												Enhancer:Print("EP module not active\available!");
											end
										end,
										order = OrderNum(),
									},
									[L["any"]] = {
										type = "execute",
										name = L["any"],
										desc = L["any"],
										func = function()
											if (Enhancer:HasModule("EP") and Enhancer:IsModuleActive("EP")) then
												Enhancer:GetModule("EP"):BestGem(Enhancer.db.profile.HEPNumbers);
											else
												Enhancer:Print("EP module not active\available!");
											end
										end,
										order = OrderNum(),
									},
								},
							},
							[L["reset_cmd"]] = {
								type = "execute",
								name = L["reset_cmd"],
								desc = L["reset_cmd"],
								func = function()
									for key, value in pairs(defaults.HEPNumbers) do
										Enhancer.db.profile.HEPNumbers[key] = defaults.HEPNumbers[key];
									end
								end,
								order = OrderNum(),
							},
						},
					},
					[L["dep_cmd"]] = {
						type = "group",
						name = L["dep_cmd"],
						desc = L["dep_cmd"],
						order = OrderNum(),
						args = {
							[L["DMG"]] = {
								name = L["DMG"], type = "range",
								desc = L["DMG"] .. L["base_warn"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.DEPNumbers.DMG; end,
								set = function(v)
									Enhancer.db.profile.DEPNumbers.DMG = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["INT"]] = {
								name = L["INT"], type = "range",
								desc = L["INT"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.DEPNumbers.INT; end,
								set = function(v)
									Enhancer.db.profile.DEPNumbers.INT = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["SPI"]] = {
								name = L["SPI"], type = "range",
								desc = L["SPI"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.DEPNumbers.SPI; end,
								set = function(v)
									Enhancer.db.profile.DEPNumbers.SPI = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["STA"]] = {
								name = L["STA"], type = "range",
								desc = L["STA"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.DEPNumbers.STA; end,
								set = function(v)
									Enhancer.db.profile.DEPNumbers.STA = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["CR_SPELLCRIT"]] = {
								name = L["CR_SPELLCRIT"], type = "range",
								desc = L["CR_SPELLCRIT"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.DEPNumbers.CR_SPELLCRIT; end,
								set = function(v)
									Enhancer.db.profile.DEPNumbers.CR_SPELLCRIT = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["CR_SPELLHIT"]] = {
								name = L["CR_SPELLHIT"], type = "range",
								desc = L["CR_SPELLHIT"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.DEPNumbers.CR_SPELLHIT; end,
								set = function(v)
									Enhancer.db.profile.DEPNumbers.CR_SPELLHIT = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["CR_SPELLHASTE"]] = {
								name = L["CR_SPELLHASTE"], type = "range",
								desc = L["CR_SPELLHASTE"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.DEPNumbers.CR_SPELLHASTE; end,
								set = function(v)
									Enhancer.db.profile.DEPNumbers.CR_SPELLHASTE = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["CR_RESILIENCE"]] = {
								name = L["CR_RESILIENCE"], type = "range",
								desc = L["CR_RESILIENCE"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.DEPNumbers.CR_RESILIENCE; end,
								set = function(v)
									Enhancer.db.profile.DEPNumbers.CR_RESILIENCE = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["MANAREG"]] = {
								name = L["MANAREG"], type = "range",
								desc = L["MANAREG"],
								min = epMin, max = epMax, step = epStep,
								get = function() return Enhancer.db.profile.DEPNumbers.MANAREG; end,
								set = function(v)
									Enhancer.db.profile.DEPNumbers.MANAREG = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["bestgem_cmd"]] = {
								type = "group",
								name = L["bestgem_cmd"],
								desc = L["bestgem_desc"],
								order = OrderNum(),
								args = {
									[L["blue"]] = {
										type = "execute",
										name = L["blue"],
										desc = L["blue"],
										func = function()
											if (Enhancer:HasModule("EP") and Enhancer:IsModuleActive("EP")) then
												Enhancer:GetModule("EP"):BestGem(Enhancer.db.profile.DEPNumbers, "Blue");
											else
												Enhancer:Print("EP module not active\available!");
											end
										end,
										order = OrderNum(),
									},
									[L["yellow"]] = {
										type = "execute",
										name = L["yellow"],
										desc = L["yellow"],
										func = function()
											if (Enhancer:HasModule("EP") and Enhancer:IsModuleActive("EP")) then
												Enhancer:GetModule("EP"):BestGem(Enhancer.db.profile.DEPNumbers, "Yellow");
											else
												Enhancer:Print("EP module not active\available!");
											end
										end,
										order = OrderNum(),
									},
									[L["red"]] = {
										type = "execute",
										name = L["red"],
										desc = L["red"],
										func = function()
											if (Enhancer:HasModule("EP") and Enhancer:IsModuleActive("EP")) then
												Enhancer:GetModule("EP"):BestGem(Enhancer.db.profile.DEPNumbers, "Red");
											else
												Enhancer:Print("EP module not active\available!");
											end
										end,
										order = OrderNum(),
									},
									[L["any"]] = {
										type = "execute",
										name = L["any"],
										desc = L["any"],
										func = function()
											if (Enhancer:HasModule("EP") and Enhancer:IsModuleActive("EP")) then
												Enhancer:GetModule("EP"):BestGem(Enhancer.db.profile.DEPNumbers);
											else
												Enhancer:Print("EP module not active\available!");
											end
										end,
										order = OrderNum(),
									},
								},
							},
							[L["reset_cmd"]] = {
								type = "execute",
								name = L["reset_cmd"],
								desc = L["reset_cmd"],
								func = function()
									for key, value in pairs(defaults.DEPNumbers) do
										Enhancer.db.profile.DEPNumbers[key] = defaults.DEPNumbers[key];
									end
								end,
								order = OrderNum(),
							},
						},
					},
					
					[SpacerName()] = SpacerTable(),
					
					[L["ep_gemq_cmd"]] = {
						name = L["ep_gemq_cmd"], type = "range",
						desc = L["ep_gemq_desc"],
						min = 1,
						max = 4,
						step = 1,
						get = function() return Enhancer.db.profile.EPGems.maxQuality; end,
						set = function(v)
							Enhancer.db.profile.EPGems.maxQuality = v;
							--Enhancer:EPValuesChanged();
						end,
						order = OrderNum(),
					},
					[L["ep_gemqn_cmd"]] = {
						name = L["ep_gemqn_cmd"], type = "range",
						desc = L["ep_gemqn_desc"],
						min = 0,
						max = 4,
						step = 1,
						get = function() return Enhancer.db.profile.EPGems.maxQualityNonEpic; end,
						set = function(v)
							Enhancer.db.profile.EPGems.maxQualityNonEpic = v;
							--Enhancer:EPValuesChanged();
						end,
						order = OrderNum(),
					},
					[L["ep_gemm_cmd"]] = {
						name = L["ep_gemm_cmd"], type = "toggle",
						desc = L["ep_gemm_desc"],
						get = function() return Enhancer.db.profile.EPGems.metaGems; end,
						set = function()
							Enhancer.db.profile.EPGems.metaGems = not Enhancer.db.profile.EPGems.metaGems;
						end,
						order = OrderNum(),
					},
					[L["ep_guess_cmd"]] = {
						name = L["ep_guess_cmd"], type = "toggle",
						desc = L["ep_guess_desc"],
						get = function() return Enhancer.db.profile.EPGems.EPGuesstimates; end,
						set = function()
							Enhancer.db.profile.EPGems.EPGuesstimates = not Enhancer.db.profile.EPGems.EPGuesstimates;
						end,
						order = OrderNum(),
					},
					[L["ep_gguess_cmd"]] = {
						name = L["ep_gguess_cmd"], type = "toggle",
						desc = L["ep_gguess_desc"],
						get = function() return Enhancer.db.profile.EPGems.EPGemGuesstimates; end,
						set = function()
							Enhancer.db.profile.EPGems.EPGemGuesstimates = not Enhancer.db.profile.EPGems.EPGemGuesstimates;
						end,
						order = OrderNum(),
					},
					
					[SpacerName()] = SpacerTable(),
					
					[L["ep_info_cmd"]] = {
						name = L["ep_info_cmd"], type = "execute",
						desc = L["ep_info_desc"],
						func = function()
							Enhancer:Print(L["ep_info_exec"]);
						end,
						order = OrderNum(),
					},
				},
			},
			
			[SpacerName()] = SpacerTable(),
			
			[L["sound_cmd"]] = {
				name = L["sound_cmd"], type = "toggle",
				desc = L["sound_desc"],
				get = function() return Enhancer.db.profile.playSound; end,
				set = function()
					Enhancer.db.profile.playSound = not Enhancer.db.profile.playSound;
				end,
				order = OrderNum(),
			},
			[L["time_cmd"]] = {
				type = "group",
				name = L["time_cmd"],
				desc = L["time_desc"],
				order = OrderNum(),
				args = {
					[L["blizztime_cmd"]] = {
						name = L["blizztime_cmd"], type = "toggle",
						desc = L["blizztime_desc"],
						get = function() return Enhancer.db.profile.blizzTime; end,
						set = function()
							Enhancer.db.profile.blizzTime = not Enhancer.db.profile.blizzTime;
						end,
						order = OrderNum(),
					},
					[L["blizzssec_cmd"]] = {
						name = L["blizzssec_cmd"], type = "toggle",
						desc = L["blizzssec_desc"],
						get = function() return Enhancer.db.profile.blizzSsec; end,
						set = function()
							Enhancer.db.profile.blizzSsec = not Enhancer.db.profile.blizzSsec;
						end,
						order = OrderNum(),
					},
				},
			},
			[L["pulse_cmd"]] = {
				type = "group",
				name = L["pulse_cmd"],
				desc = L["pulse_desc"],
				order = OrderNum(),
				args = {
					[L["growpulse_cmd"]] = {
						name = L["growpulse_cmd"], type = "toggle",
						desc = L["growpulse_desc"],
						get = function() return Enhancer.db.profile.growingPulse; end,
						set = function()
							Enhancer.db.profile.growingPulse = not Enhancer.db.profile.growingPulse;
						end,
						order = OrderNum(),
					},
					[L["borderpulse_cmd"]] = {
						name = L["borderpulse_cmd"], type = "toggle",
						desc = L["borderpulse_desc"],
						get = function() return Enhancer.db.profile.borderPulse; end,
						set = function()
							Enhancer.db.profile.borderPulse = not Enhancer.db.profile.borderPulse;
						end,
						order = OrderNum(),
					},
				},
			},
			[L["buffIndicator_cmd"]] = {
				type = "text",
			  name = L["buffIndicator_cmd"],
				desc = L["buffIndicator_desc"],
				get = function()
					return self.db.profile.buffIndicator
				end,
				set = function(v)
					for _, framename in pairs(Enhancer.aFrames) do
						self[framename].topleft:SetTexture(1, 1, 1, 0);
						self[framename].topright:SetTexture(1, 1, 1, 0);
						self[framename].bottomleft:SetTexture(1, 1, 1, 0);
						self[framename].bottomright:SetTexture(1, 1, 1, 0);
					end
					self.db.profile.buffIndicator = v;
				end,
				validate = {
					["noindication"] = L["noindication"],
					["topleft"] = L["topleft"],
					["topright"] = L["topright"],
					["bottomleft"] = L["bottomleft"],
					["bottomright"] = L["bottomright"],
				},
	      order = OrderNum(),
			},
			[L["warning_cmd"]] = {
				type = "group",
				name = L["warning_cmd"],
				desc = L["warning_desc"],
				order = OrderNum(),
				args = {
					[L["warnExpire_cmd"]] = {
						name = L["warnExpire_cmd"], type = "toggle",
						desc = L["warnExpire_desc"],
						get = function() return Enhancer.db.profile.warnExpire; end,
						set = function()
							Enhancer.db.profile.warnExpire = not Enhancer.db.profile.warnExpire;
						end,
						order = OrderNum(),
					},
					[L["warnDeath_cmd"]] = {
						name = L["warnDeath_cmd"], type = "toggle",
						desc = L["warnDeath_desc"],
						get = function() return Enhancer.db.profile.warnDeath; end,
						set = function()
							Enhancer.db.profile.warnDeath = not Enhancer.db.profile.warnDeath;
						end,
						order = OrderNum(),
					},
					[L["warnSlain_cmd"]] = {
						name = L["warnSlain_cmd"], type = "toggle",
						desc = L["warnSlain_desc"],
						get = function() return Enhancer.db.profile.warnSlain; end,
						set = function()
							Enhancer.db.profile.warnSlain = not Enhancer.db.profile.warnSlain;
						end,
						order = OrderNum(),
					},
					[L["warnTime_cmd"]] = {
						name = L["warnTime_cmd"], type = "range",
						desc = L["warnTime_desc"],
						min = 3,
						max = 15,
						step = 1,
						get = function() return Enhancer.db.profile.warnTime; end,
						set = function(v)
							Enhancer.db.profile.warnTime = v;
						end,
						order = OrderNum(),
					},
				},
			},
			[L["snap_cmd"]] = {
				name = L["snap_cmd"], type = "toggle",
				desc = L["snap_desc"],
				get = function() return Enhancer.db.profile.snap; end,
				set = function()
					Enhancer.db.profile.snap = not Enhancer.db.profile.snap;
				end,
				order = OrderNum(),
			},
			[L["roman_cmd"]] = {
				name = L["roman_cmd"], type = "toggle",
				desc = L["roman_desc"],
				get = function() return Enhancer.db.profile.roman; end,
				set = function()
					Enhancer.db.profile.roman = not Enhancer.db.profile.roman;
				end,
				order = OrderNum(),
			},
			
			[SpacerName()] = SpacerTable(),
			
			[L["alpha_cmd"]] = {
				type = "group",
				name = L["alpha_cmd"],
				desc = L["alpha_desc"],
				order = OrderNum(),
				args = {
					[L["alpha_ic_active_cmd"]] = {
						name = L["alpha_ic_active_cmd"], type = "range",
						desc = L["alpha_ic_active_desc"],
						min = 0,
						max = 1,
						step = (1 / 10),
						get = function() return Enhancer.db.profile.combatAlpha; end,
						set = function(v)
							Enhancer.db.profile.combatAlpha = v;
							Enhancer:UpdateAlphaBegin( Enhancer.aFrames );
						end,
						order = OrderNum(),
					},
					[L["alpha_ooc_active_cmd"]] = {
						name = L["alpha_ooc_active_cmd"], type = "range",
						desc = L["alpha_ooc_active_desc"],
						min = 0,
						max = 1,
						step = (1 / 10),
						get = function() return Enhancer.db.profile.oocombatAlpha; end,
						set = function(v)
							Enhancer.db.profile.oocombatAlpha = v;
							Enhancer:UpdateAlphaBegin( Enhancer.aFrames );
						end,
						order = OrderNum(),
					},
					[L["alpha_ic_inactive_cmd"]] = {
						name = L["alpha_ic_inactive_cmd"], type = "range",
						desc = L["alpha_ic_inactive_desc"],
						min = 0,
						max = 1,
						step = (1 / 10),
						get = function() return Enhancer.db.profile.combatinactiveAlpha; end,
						set = function(v)
							Enhancer.db.profile.combatinactiveAlpha = v;
							Enhancer:UpdateAlphaBegin( Enhancer.aFrames );
						end,
						order = OrderNum(),
					},
					[L["alpha_ooc_inactive_cmd"]] = {
						name = L["alpha_ooc_inactive_cmd"], type = "range",
						desc = L["alpha_ooc_inactive_desc"],
						min = 0,
						max = 1,
						step = (1 / 10),
						get = function() return Enhancer.db.profile.oocinactiveAlpha; end,
						set = function(v)
							Enhancer.db.profile.oocinactiveAlpha = v;
							Enhancer:UpdateAlphaBegin( Enhancer.aFrames );
						end,
						order = OrderNum(),
					},
					
					[SpacerName()] = SpacerTable(),
					
					[L["specialalpha_cmd"]] = {
						name = L["specialalpha_cmd"], type = "toggle",
						desc = L["specialalpha_desc"],
						get = function() return Enhancer.db.profile.specialAlpha; end,
						set = function()
							Enhancer.db.profile.specialAlpha = not Enhancer.db.profile.specialAlpha;
							Enhancer:UpdateAlphaBegin();
						end,
						order = OrderNum(),
					},
				},
			},
			[L["font_cmd"]] = {
				type = "group",
				name = L["font_cmd"],
				desc = L["font_desc"],
				order = OrderNum(),
				args = {
					[L["fontabove_cmd"]] = {
						type = "group",
						name = L["fontabove_cmd"],
						desc = L["fontabove_desc"],
						order = OrderNum(),
						args = {
							[L["fontname_cmd"]] = {
								name = L["fontname_cmd"], type = "text",
								desc = L["fontname_desc"],
								get = function() return SML:IsValid("font", Enhancer.db.profile.aboveFontID) and Enhancer.db.profile.aboveFontID; end,
								set = function(v)
									if (v) then
										Enhancer.db.profile.aboveFontID = v;
										Enhancer.db.profile.aboveFontName = SML:Fetch("font", Enhancer.db.profile.aboveFontID);
										Enhancer:UpdateFont();
									end
								end,
								validate = SML_fonts,
								usage = "<font name>",
								order = OrderNum(),
							},
							[L["fontsize_cmd"]] = {
								name = L["fontsize_cmd"], type = "range",
								desc = L["fontsize_desc"],
								min = 5, max = 16, step = 1, isPercent = false,
								get = function() return Enhancer.db.profile.aboveFontSize; end,
								set = function(v)
									Enhancer.db.profile.aboveFontSize = v;
									Enhancer:UpdateFont();
								end,
								order = OrderNum(),
							},
							[L["fontflag_cmd"]] = {
								name = L["fontflag_cmd"], type = "text",
								desc = L["fontflag_desc"],
								get = function() return Enhancer.db.profile.aboveFontFlags; end,
								set = function(v)
									Enhancer.db.profile.aboveFontFlags = v;
									Enhancer:UpdateFont();
								end,
								validate = { "OUTLINE", "THICKOUTLINE", "NONE" },
								usage = "<OUTLINE\|THICKOUTLINE\|NONE>",
								order = OrderNum(),
							},
						},
					},
					[L["fontcenter_cmd"]] = {
						type = "group",
						name = L["fontcenter_cmd"],
						desc = L["fontcenter_desc"],
						order = OrderNum(),
						args = {
							[L["fontname_cmd"]] = {
								name = L["fontname_cmd"], type = "text",
								desc = L["fontname_desc"],
								get = function() return SML:IsValid("font", Enhancer.db.profile.centerFontID) and Enhancer.db.profile.centerFontID; end,
								set = function(v)
									if (v) then
										Enhancer.db.profile.centerFontID = v;
										Enhancer.db.profile.centerFontName = SML:Fetch("font", Enhancer.db.profile.centerFontID);
										Enhancer:UpdateFont();
									end
								end,
								validate = SML_fonts,
								usage = "<font name>",
								order = OrderNum(),
							},
							[L["fontsize_cmd"]] = {
								name = L["fontsize_cmd"], type = "range",
								desc = L["fontsize_desc"],
								min = 5, max = 25, step = 1, isPercent = false,
								get = function() return Enhancer.db.profile.centerFontSize; end,
								set = function(v)
									Enhancer.db.profile.centerFontSize = v;
									Enhancer:UpdateFont();
								end,
								order = OrderNum(),
							},
							[L["fontflag_cmd"]] = {
								name = L["fontflag_cmd"], type = "text",
								desc = L["fontflag_desc"],
								get = function() return Enhancer.db.profile.centerFontFlags; end,
								set = function(v)
									Enhancer.db.profile.centerFontFlags = v;
									Enhancer:UpdateFont();
								end,
								validate = { "OUTLINE", "THICKOUTLINE", "NONE" },
								usage = "<OUTLINE\|THICKOUTLINE\|NONE>",
								order = OrderNum(),
							},
						},
					},
					[L["fontbelow_cmd"]] = {
						type = "group",
						name = L["fontbelow_cmd"],
						desc = L["fontbelow_desc"],
						order = OrderNum(),
						args = {
							[L["fontname_cmd"]] = {
								name = L["fontname_cmd"], type = "text",
								desc = L["fontname_desc"],
								get = function() return SML:IsValid("font", Enhancer.db.profile.belowFontID) and Enhancer.db.profile.belowFontID; end,
								set = function(v)
									if (v) then
										Enhancer.db.profile.belowFontID = v;
										Enhancer.db.profile.belowFontName = SML:Fetch("font", Enhancer.db.profile.belowFontID);
										Enhancer:UpdateFont();
									end
								end,
								validate = SML_fonts,
								usage = "<font name>",
								order = OrderNum(),
							},
							[L["fontsize_cmd"]] = {
								name = L["fontsize_cmd"], type = "range",
								desc = L["fontsize_desc"],
								min = 5, max = 16, step = 1, isPercent = false,
								get = function() return Enhancer.db.profile.belowFontSize; end,
								set = function(v)
									Enhancer.db.profile.belowFontSize = v;
									Enhancer:UpdateFont();
								end,
								order = OrderNum(),
							},
							[L["fontflag_cmd"]] = {
								name = L["fontflag_cmd"], type = "text",
								desc = L["fontflag_desc"],
								get = function() return Enhancer.db.profile.belowFontFlags; end,
								set = function(v)
									Enhancer.db.profile.belowFontFlags = v;
									Enhancer:UpdateFont();
								end,
								validate = { "OUTLINE", "THICKOUTLINE", "NONE" },
								usage = "<OUTLINE\|THICKOUTLINE\|NONE>",
								order = OrderNum(),
							},
						},
					},
				},
			},
			
			["sinkorder"] = OrderNum(),
			
			[SpacerName()] = SpacerTable(),
			
			[L["Announcement_cmd"]] = {
				type = "group",
				name = L["Announcement_cmd"],
				desc = L["Announcement_desc"],
				order = OrderNum(),
				args = {
					[L["a_show_cmd"]] = {
						type = "execute",
						name = L["a_show_cmd"],
						desc = L["a_show_desc"],
						func = function()
							Enhancer:DelayAnnounce();
						end,
						order = OrderNum(),
					},
					[L["a_disable_cmd"]] = {
						name = L["a_disable_cmd"], type = "toggle",
						desc = L["a_disable_desc"],
						get = function() return Enhancer.db.profile.startAnnounceDisabled; end,
						set = function()
							Enhancer.db.profile.startAnnounceDisabled = not Enhancer.db.profile.startAnnounceDisabled;
						end,
						order = OrderNum(),
					},
					
					[SpacerName()] = SpacerTable(),
					
					[L["news_cmd"]] = {
						type = "execute",
						name = L["news_cmd"],
						desc = L["news_desc"],
						func = function()
							Enhancer:News();
						end,
						order = OrderNum(),
					},
				},
			},
			
			[SpacerName()] = SpacerTable(),
			
			["Debug"] = {
				name = "Debug", type = "toggle",
				desc = "Currently trying to find a bug in EShield module where it lose track often",
				get = function() return Enhancer.debug; end,
				set = function() Enhancer.debug = not Enhancer.debug; end,
				order = OrderNum(),
			},
		},
	};
	
	--[[ Add Modules to slashcommands ]]--
	local removeCat = true;
	for name, module in Enhancer:IterateModules() do
		if (module.GetConsoleOptions) then
			removeCat = false;
			
			local cmd, desc, ordernum = module:GetConsoleOptions();
			
			consoleoptions.args[L["bonus_group_cmd"]].args[cmd] = {
				name = cmd, type = "toggle",
				desc = desc,
				get = function() return Enhancer:IsModuleActive(name); end,
				set = function()
					Enhancer:ToggleModuleActive(name);
				end,
				order = OrderNum(),
			};
			
		end
	end
	if (removeCat) then consoleoptions.args[L["bonus_group_cmd"]] = nil; end
	
	local sinkorder = consoleoptions.args.sinkorder;
	consoleoptions.args.sinkorder = nil;
	
	self:RegisterChatCommand( { "/Enhancer", "/enh", "/ShammySpy" }, consoleoptions );
	
	--[[ Ugly thing to get the output from SinkLib where I want it to be ]]--
	local console = AceLibrary("AceConsole-2.0").registry;
	if (console and console.ENHANCER and console.ENHANCER.args and console.ENHANCER.args.output) then
		console.ENHANCER.args.output.order = sinkorder;
	end
	
	if (AceLibrary:HasInstance("Waterfall-1.0")) then
		AceLibrary("Waterfall-1.0"):Register(
			"Enhancer",
			"aceOptions", consoleoptions,
			"treeType","SECTIONS",
			"colorR", (127/255), "colorG", (255/255), "colorB", (212/255)
		)
	end
end

function Enhancer:Waterfall()
	if (AceLibrary:HasInstance("Waterfall-1.0")) then
		AceLibrary("Waterfall-1.0"):Open("Enhancer")
	else
		self:Print("Waterfall library not available!");
	end
end