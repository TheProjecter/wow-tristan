local L = AceLibrary("AceLocale-2.2"):new("Enhancer");

Enhancer.Modules = {};

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

local defaults = {
	locked = true,
	framesize = 46,
	
	combatinactiveAlpha = (3 / 10),
	oocinactiveAlpha = 0,
	combatAlpha = 1,
	oocombatAlpha = (7 / 10),
	specialAlpha = true,
	
	playSound = false,
	growingPulse = true,
	borderPulse = false,
	
	EPZero = true,
	AEP = true,
	AEPH = true,
	HEP = false,
	DEP = false,
	DEPH = false,
	EIP = true,
	EPGems = {
		maxQuality = 3,
		metaGems = true,
	},
	EPGuesstimates = false,
	
	centerFontName = "Fonts\\FRIZQT__.TTF",
	centerFontSize = (46 / 3),
	centerFontFlags = "OUTLINE",
	centerFont = CreateFont("EnhancerCenterFont"),

	belowFontName = "Fonts\\FRIZQT__.TTF",
	belowFontSize = (46 / 4),
	belowFontFlags = "OUTLINE",
	belowFont = CreateFont("EnhancerBelowFont"),
	
	AEPNumbers = {
		ATTACKPOWER = (10 / 10),
		STR = (20 / 10),
		AGI = (18 / 10),
		STA = (0 / 10),
		CR_CRIT = (20 / 10),
		CR_HIT = (14 / 10),
		CR_HASTE = (15 / 10), --(22 / 10),
		CR_RESILIENCE = (0 / 10),
		IGNOREARMOR = (0 / 10), -- 10-20
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
};
defaults.centerFont:SetFont(defaults.centerFontName, defaults.centerFontSize, defaults.centerFontFlags);
defaults.belowFont:SetFont(defaults.belowFontName, defaults.belowFontSize, defaults.belowFontFlags);
Enhancer:RegisterDefaults('profile', defaults);

function Enhancer:RegisterSlashCommands()
	local consoleoptions = {
		type = "group",
		args = {
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
			
			[L["element_group_cmd"]] = {
				type = "group",
				name = L["element_group_cmd"],
				desc = L["element_group_desc"],
				order = OrderNum(),
				args = {
					[L["earth_cmd"]] = {
						name = L["earth_cmd"], type = "toggle",
						desc = string.format(L["element_desc"], L["earth_cmd"]),
						get = function() return Enhancer:IsModuleActive("Earth"); end,
						set = function()
							Enhancer:ToggleModuleActive("Earth");
						end,
						order = OrderNum(),
					},
					[L["fire_cmd"]] = {
						name = L["fire_cmd"], type = "toggle",
						desc = string.format(L["element_desc"], L["fire_cmd"]),
						get = function() return Enhancer:IsModuleActive("Fire"); end,
						set = function()
							Enhancer:ToggleModuleActive("Fire");
						end,
						order = OrderNum(),
					},
					[L["water_cmd"]] = {
						name = L["water_cmd"], type = "toggle",
						desc = string.format(L["element_desc"], L["water_cmd"]),
						get = function() return Enhancer:IsModuleActive("Water"); end,
						set = function()
							Enhancer:ToggleModuleActive("Water");
						end,
						order = OrderNum(),
					},
					[L["air_cmd"]] = {
						name = L["air_cmd"], type = "toggle",
						desc = string.format(L["element_desc"], L["air_cmd"]),
						get = function() return Enhancer:IsModuleActive("Air"); end,
						set = function()
							Enhancer:ToggleModuleActive("Air");
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
					[L["windfury_cmd"]] = {
						name = L["windfury_cmd"], type = "toggle",
						desc = L["windfury_desc"],
						get = function() return Enhancer:IsModuleActive("Windfury"); end,
						set = function()
							Enhancer:ToggleModuleActive("Windfury");
						end,
						order = OrderNum(),
					},
					[L["reincarnation_cmd"]] = {
						name = L["reincarnation_cmd"], type = "toggle",
						desc = L["reincarnation_desc"],
						get = function() return Enhancer:IsModuleActive("Reincarnation"); end,
						set = function()
							Enhancer:ToggleModuleActive("Reincarnation");
						end,
						order = OrderNum(),
					},
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
								desc = L["ATTACKPOWER"],
								min = 0, max = 5, step = (1 / 10),
								get = function() return Enhancer.db.profile.AEPNumbers.ATTACKPOWER; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.ATTACKPOWER = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							
							[SpacerName()] = SpacerTable(),
							
							[L["STR"]] = {
								name = L["STR"], type = "range",
								desc = L["STR"],
								min = 0, max = 5, step = (1 / 10),
								get = function() return Enhancer.db.profile.AEPNumbers.STR; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.STR = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["AGI"]] = {
								name = L["AGI"], type = "range",
								desc = L["AGI"],
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
								get = function() return Enhancer.db.profile.AEPNumbers.CR_HIT; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.CR_HIT = v;
									Enhancer:EPValuesChanged();
								end,
								order = OrderNum(),
							},
							[L["CR_HASTE"]] = {
								name = L["CR_HASTE"], type = "range",
								desc = L["CR_HASTE"],
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
								get = function() return Enhancer.db.profile.AEPNumbers.IGNOREARMOR; end,
								set = function(v)
									Enhancer.db.profile.AEPNumbers.IGNOREARMOR = v;
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
							[L["reset_cmd"]] = {
								type = "execute",
								name = L["reset_cmd"],
								desc = L["reset_cmd"],
								func = function()
									for key, value in pairs(defaults.AEPNumbers) do
										Enhancer.db.profile.AEPNumbers[key] = defaults.AEPNumbers[key];
									end
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
								desc = L["HEAL"],
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								desc = L["DMG"],
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
								min = 0, max = 5, step = (1 / 10),
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
							Enhancer:EPValuesChanged();
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
				},
			},
		},
	};
	
	--[[ Add Modules to slashcommands ]]--
	local doSeparator = true;
	for name, module in Enhancer:IterateModules() do
		if (module.GetConsoleOptions) then
			
			if (doSeparator) then
				--Add a separator for external modules
				consoleoptions.args[L["bonus_group_cmd"]].args[SpacerName()] = SpacerTable();
				doSeparator = false;
			end
			
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
	
	self:RegisterChatCommand( { "/Enhancer", "/enh", "/ShammySpy" }, consoleoptions );
end
-- AceLibrary("AceConsole-2.0"):InjectAceOptionsTable(self, Bartender3.options.args.fubar)