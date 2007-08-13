local L = AceLibrary("AceLocale-2.2"):new("Enhancer");

local defaults = {
	locked = true,
	framesize = 46,
	combatinactiveAlpha = (3 / 10),
	oocinactiveAlpha = 0,
	combatAlpha = 1,
	oocombatAlpha = (7 / 10),
	
	Windfury = true,
	Reincarnation = true,
	Invigorated = true,
	AEP = true,
	
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
			order = 5,
		},
		[L["aep_cmd"]] = {
			name = L["aep_cmd"], type = "toggle",
			desc = L["aep_desc"],
			get = function() return EnhancerAEP:Active(); end,
			set = function()
				EnhancerAEP:Toggle();
			end,
			order = 5,
		},
	},
}


Enhancer:RegisterDefaults('profile', defaults)
Enhancer:RegisterChatCommand( { "/Enhancer", "/enh", "/ShammySpy" }, consoleoptions )

-- Enhancer.db.profile.Invigorated