local L = AceLibrary("AceLocale-2.2"):new("Enhancer");

local defaults = {
	locked = true,
	framesize = 46,
	
	combatinactiveAlpha = (3 / 10),
	oocinactiveAlpha = 0,
	combatAlpha = 1,
	oocombatAlpha = (7 / 10),
	
	playSound = false,
	growingPulse = true,
	borderPulse = false,
	
	Windfury = true,
	Reincarnation = true,
	Invigorated = false,
	EP = true,
	EPZero = true,
	AEP = true,
	AEPH = true,
	HEP = false,
	DEP = false,
	EIL = true,
	EPGems = {
		maxQuality = 3,
		metaGems = true,
	},
	
	centerFontName = "Fonts\\FRIZQT__.TTF",
	centerFontSize = (46 / 3),
	centerFontFlags = "OUTLINE",
	centerFont = CreateFont("EnhancerCenterFont"),

	belowFontName = "Fonts\\FRIZQT__.TTF",
	belowFontSize = (46 / 4),
	belowFontFlags = "OUTLINE",
	belowFont = CreateFont("EnhancerBelowFont"),
	
	debugframe = {
		lock = true,
	},
}

defaults.centerFont:SetFont(defaults.centerFontName, defaults.centerFontSize, defaults.centerFontFlags);
defaults.belowFont:SetFont(defaults.belowFontName, defaults.belowFontSize, defaults.belowFontFlags);

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
			order = 1,
		},
		[L["reset_cmd"]] = {
			name = L["reset_cmd"], type = "execute",
			desc = L["reset_desc"],
			func = function(v)
				Enhancer:DefaultPos();
				if (Enhancer.db.profile.framePositions) then Enhancer.db.profile.framePositions = nil; end
			end,
			order = 2,
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
			order = 3,
		},
		firstSpacer = {
			type = "header",
			order = 4,
		},
		[L["windfury_cmd"]] = {
			name = L["windfury_cmd"], type = "toggle",
			desc = L["windfury_desc"],
			get = function() return EnhancerWindfury:Active(); end,
			set = function()
				EnhancerWindfury:Toggle();
			end,
			order = 5,
		},
		[L["reincarnation_cmd"]] = {
			name = L["reincarnation_cmd"], type = "toggle",
			desc = L["reincarnation_desc"],
			get = function() return EnhancerReincarnation:Active(); end,
			set = function()
				EnhancerReincarnation:Toggle();
			end,
			order = 6,
		},
		[L["invigorated_cmd"]] = {
			name = L["invigorated_cmd"], type = "toggle",
			desc = L["invigorated_desc"],
			get = function() return EnhancerInvigorated:Active(); end,
			set = function()
				EnhancerInvigorated:Toggle();
			end,
			order = 7,
		},
		[L["ep_cmd"]] = {
			name = L["ep_cmd"], type = "toggle",
			desc = L["ep_desc"],
			get = function() return EnhancerEP:Active(); end,
			set = function()
				EnhancerEP:Toggle();
			end,
			order = 8,
		},
		[L["ep_group_cmd"]] = {
  		type = "group",
  		name = L["ep_group_cmd"],
  		desc = L["ep_group_desc"],
  		order = 9,
  		args = {
				[L["ep_gemq_cmd"]] = {
					name = L["ep_gemq_cmd"], type = "range",
					desc = L["ep_gemq_desc"],
					min = 1,
					max = 3,
					step = 1,
					get = function() return Enhancer.db.profile.EPGems.maxQuality; end,
					set = function(v)
						Enhancer.db.profile.EPGems.maxQuality = v;
					end,
					order = 1,
				},
				[L["ep_gemm_cmd"]] = {
					name = L["ep_gemm_cmd"], type = "toggle",
					desc = L["ep_gemm_desc"],
					get = function() return Enhancer.db.profile.EPGems.metaGems; end,
					set = function()
						Enhancer.db.profile.EPGems.metaGems = not Enhancer.db.profile.EPGems.metaGems;
					end,
					order = 2,
				},
  			[L["epz_cmd"]] = {
					name = L["epz_cmd"], type = "toggle",
					desc = L["epz_desc"],
					get = function() return Enhancer.db.profile.EPZero; end,
					set = function()
						Enhancer.db.profile.EPZero = not Enhancer.db.profile.EPZero;
					end,
					order = 3,
				},
				firstSpacer = {
					type = "header",
					order = 4,
				},
				[L["aep_group_cmd"]] = {
		  		type = "group",
		  		name = L["aep_group_cmd"],
		  		desc = L["aep_group_desc"],
		  		order = 5,
		  		args = {
		  			[L["aep_cmd"]] = {
							name = L["aep_cmd"], type = "toggle",
							desc = L["aep_desc"],
							get = function() return Enhancer.db.profile.AEP; end,
							set = function()
								Enhancer.db.profile.AEP = not Enhancer.db.profile.AEP;
							end,
							order = 1,
						},
						[L["aeph_cmd"]] = {
							name = L["aeph_cmd"], type = "toggle",
							desc = L["aeph_desc"],
							get = function() return Enhancer.db.profile.AEPH; end,
							set = function()
								Enhancer.db.profile.AEPH = not Enhancer.db.profile.AEPH;
							end,
							order = 2,
						},
					},
				},
				[L["hep_cmd"]] = {
					name = L["hep_cmd"], type = "toggle",
					desc = L["hep_desc"],
					get = function() return Enhancer.db.profile.HEP; end,
					set = function()
						Enhancer.db.profile.HEP = not Enhancer.db.profile.HEP;
					end,
					order = 6,
				},
				[L["dep_cmd"]] = {
					name = L["dep_cmd"], type = "toggle",
					desc = L["dep_desc"],
					get = function() return Enhancer.db.profile.DEP; end,
					set = function()
						Enhancer.db.profile.DEP = not Enhancer.db.profile.DEP;
					end,
					order = 7,
				},
				[L["eil_cmd"]] = {
					name = L["eil_cmd"], type = "toggle",
					desc = L["eil_desc"],
					get = function() return Enhancer.db.profile.EIL; end,
					set = function()
						Enhancer.db.profile.EIL = not Enhancer.db.profile.EIL;
					end,
					order = 7,
				},
			},
		},
		secondSpacer = {
			type = "header",
			order = 10,
		},
		[L["sound_cmd"]] = {
			name = L["sound_cmd"], type = "toggle",
			desc = L["sound_desc"],
			get = function() return Enhancer.db.profile.playSound; end,
			set = function()
				Enhancer.db.profile.playSound = not Enhancer.db.profile.playSound;
			end,
			order = 11,
		},
		[L["growpulse_cmd"]] = {
			name = L["growpulse_cmd"], type = "toggle",
			desc = L["growpulse_desc"],
			get = function() return Enhancer.db.profile.growingPulse; end,
			set = function()
				Enhancer.db.profile.growingPulse = not Enhancer.db.profile.growingPulse;
			end,
			order = 12,
		},
		[L["borderpulse_cmd"]] = {
			name = L["borderpulse_cmd"], type = "toggle",
			desc = L["borderpulse_desc"],
			get = function() return Enhancer.db.profile.borderPulse; end,
			set = function()
				Enhancer.db.profile.borderPulse = not Enhancer.db.profile.borderPulse;
			end,
			order = 13,
		},
		thirdSpacer = {
			type = "header",
			order = 14,
		},
		[L["alpha_cmd"]] = {
  		type = "group",
  		name = L["alpha_cmd"],
  		desc = L["alpha_desc"],
  		order = 15,
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
						Enhancer:UpdateAlphaBegin( Enhancer.allframes );
					end,
					order = 1,
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
						Enhancer:UpdateAlphaBegin( Enhancer.allframes );
					end,
					order = 2,
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
						Enhancer:UpdateAlphaBegin( Enhancer.allframes );
					end,
					order = 3,
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
						Enhancer:UpdateAlphaBegin( Enhancer.allframes );
					end,
					order = 4,
				},
	  	},
	  },
	  [L["debug_cmd"]] = {
			name = L["debug_cmd"], type = "toggle",
			desc = L["debug_desc"],
			get = function() return Enhancer.isDebugging; end,
			set = function()
				if (Enhancer.DebugFrames) then
					Enhancer.isDebugging = not Enhancer.isDebugging;
					Enhancer:DebugFrames()
				end
			end,
			order = 16,
		},
		[L["debug_lock_cmd"]] = {
			name = L["debug_lock_cmd"], type = "toggle",
			desc = L["debug_lock_desc"],
			get = function() return Enhancer.db.profile.debugframe.lock; end,
			set = function()
				Enhancer.db.profile.debugframe.lock = not Enhancer.db.profile.debugframe.lock;
				Enhancer:DebugLock();
			end,
			order = 16,
		},
	},
}

Enhancer:RegisterDefaults('profile', defaults)
Enhancer:RegisterChatCommand( { "/Enhancer", "/enh", "/ShammySpy" }, consoleoptions )

-- Enhancer.db.profile.EIL