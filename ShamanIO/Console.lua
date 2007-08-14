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
	AEP = true,
	HEP = true,
	
	centerFontName = "Fonts\\FRIZQT__.TTF",
	centerFontSize = (46 / 3),
	centerFontFlags = "OUTLINE",
	centerFont = CreateFont("EnhancerCenterFont"),

	belowFontName = "Fonts\\FRIZQT__.TTF",
	belowFontSize = (46 / 4),
	belowFontFlags = "OUTLINE",
	belowFont = CreateFont("EnhancerBelowFont"),
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
		secondSpacer = {
			type = "header",
			order = 9,
		},
		[L["sound_cmd"]] = {
			name = L["sound_cmd"], type = "toggle",
			desc = L["sound_desc"],
			get = function() return Enhancer.db.profile.playSound; end,
			set = function()
				Enhancer.db.profile.playSound = not Enhancer.db.profile.playSound;
			end,
			order = 10,
		},
		[L["growpulse_cmd"]] = {
			name = L["growpulse_cmd"], type = "toggle",
			desc = L["growpulse_desc"],
			get = function() return Enhancer.db.profile.growingPulse; end,
			set = function()
				Enhancer.db.profile.growingPulse = not Enhancer.db.profile.growingPulse;
			end,
			order = 11,
		},
		[L["borderpulse_cmd"]] = {
			name = L["borderpulse_cmd"], type = "toggle",
			desc = L["borderpulse_desc"],
			get = function() return Enhancer.db.profile.borderPulse; end,
			set = function()
				Enhancer.db.profile.borderPulse = not Enhancer.db.profile.borderPulse;
			end,
			order = 12,
		},
		thirdSpacer = {
			type = "header",
			order = 13,
		},
		[L["alpha_cmd"]] = {
  		type = "group",
  		order = 14,
  		name = L["alpha_cmd"],
  		desc = L["alpha_desc"],
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
	},
}

Enhancer:RegisterDefaults('profile', defaults)
Enhancer:RegisterChatCommand( { "/Enhancer", "/enh", "/ShammySpy" }, consoleoptions )