local L = AceLibrary("AceLocale-2.2"):new("ShammySpy")

local defaults = {
	lock = true,
	chatframe = false,
	oldpulse = false,
	ShammySpyEarthFrame = {
		x = nil,
		y = nil,
	},
	ShammySpyFireFrame = {
		x = nil,
		y = nil,
	},
	ShammySpyWaterFrame = {
		x = nil,
		y = nil,
	},
	ShammySpyAirFrame = {
		x = nil,
		y = nil,
	},
	ShammySpyReincarnationFrame = {
		x = nil,
		y = nil,
	},
}

local consoleoptions = {
	type = "group",
	args = {
		[L["Lock"]] = {
			name = L["Lock"], type = "toggle",
			desc = L["Lock"],
			get = function() return ShammySpy.db.profile.lock end,
			set = function(v)
				ShammySpy.db.profile.lock = v
				ShammySpy:UpdateLock()
			end,
			order = 1,
		},
		[L["Reset"]] = {
			name = L["Reset"], type = "execute",
			desc = L["Reset"],
			func = function(v)
				ShammySpy.db.profile.ShammySpyEarthFrame.x = nil
				ShammySpy.db.profile.ShammySpyEarthFrame.y = nil
				ShammySpy.db.profile.ShammySpyFireFrame.x = nil
				ShammySpy.db.profile.ShammySpyFireFrame.y = nil
				ShammySpy.db.profile.ShammySpyWaterFrame.x = nil
				ShammySpy.db.profile.ShammySpyWaterFrame.y = nil
				ShammySpy.db.profile.ShammySpyAirFrame.x = nil
				ShammySpy.db.profile.ShammySpyAirFrame.y = nil
				ShammySpy.db.profile.ShammySpyReincarnationFrame.x = nil
				ShammySpy.db.profile.ShammySpyReincarnationFrame.y = nil
				ShammySpy:MoveFrames()
			end,
			order = 2,
		},
		[L["Chatframe"]] = {
			name = L["Chatframe"], type = "toggle",
			desc = L["Send messages to Chatframe aswell"],
			get = function() return ShammySpy.db.profile.chatframe; end,
			set = function(v)
				ShammySpy.db.profile.chatframe = v;
			end,
			order = 3,
		},
		[L["Old Pulse"]] = {
			name = L["Old Pulse"], type = "toggle",
			desc = L["Old style Pulse"],
			get = function() return ShammySpy.db.profile.oldpulse; end,
			set = function(v)
				for _, element in ipairs({"Earth","Fire","Water","Air"}) do
					local frame = getglobal("ShammySpy"..element.."Frame");
					frame:SetBackdropBorderColor(1,1,1,0);
					ShammySpy:RemPulse(element);
				end
				ShammySpy.db.profile.oldpulse = v;
			end,
			order = 4,
		},
	},
}

ShammySpy = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0")
ShammySpy:RegisterDB("ShammySpyDB")
ShammySpy:RegisterDefaults('profile', defaults)
ShammySpy:RegisterChatCommand( { "/ss", "/shs", "/ShammySpy" }, consoleoptions )