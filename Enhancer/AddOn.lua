--[[
Left to do:
	Windfury calculation and display! (FontString midscreen that grows on crit?)
]]--
--[[ http://www.wowace.com/wiki/Joker ]]--
--[[ http://www.wowace.com/wiki/Rock ]]--
Enhancer = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0", "AceModuleCore-2.0", "Parser-3.0", "Sink-1.0");
Enhancer:RegisterDB("EnhancerDB", nil, "class");


local L = AceLibrary("AceLocale-2.2"):new("Enhancer");
Enhancer.deformat = AceLibrary("Deformat-2.0");
Enhancer.BS = AceLibrary("Babble-Spell-2.2");
--local Aura = AceLibrary("SpecialEvents-Aura-2.0")
Enhancer.LR = LibStub:GetLibrary("LibRoman-1.0");

_, Enhancer.englishClass = UnitClass("player");

Enhancer.aFrames = {}; -- All Frames
Enhancer.tFrames = {}; -- Totem Frames
Enhancer.dFrames = {}; -- Death Frames
Enhancer.oFrames = {}; -- On/Off Frames
Enhancer.combatLog = {}; -- List of all "unit"s we are intressted in for the combatlog :)

Enhancer.colors = {
	earth = {
		hex = "7fffd4",
		dec = {
			r = 127,
			g = 255,
			b = 212,
			a = 255,
		},
	},
	fire = {
		hex = "ff8c00",
		dec = {
			r = 255,
			g = 140,
			b = 0,
			a = 255,
		},
	},
	water = {
		hex = "87ceeb",
		dec = {
			r = 135,
			g = 206,
			b = 235,
			a = 255,
		},
	},
	air = {
		hex = "1e90ff",
		dec = {
			r = 30,
			g = 144,
			b = 255,
			a = 255,
		},
	},
};
--[[ Totem Colors
	aquamarine	aquamarine	#7FFFD4	127	255	212
	darkorange	darkorange	#FF8C00	255	140	  0
	skyblue			skyblue			#87CEEB	135	206	235
	dodgerblue	dodgerblue	#1E90FF	 30	144	255
]]--

function Enhancer:OnInitialize()
	self:RegisterSlashCommands();
	self:InspectEPValues(); -- Check so not using old values

	if (not self.db.profile.startAnnounceDisabled) then
		self:ScheduleEvent("DelayAnnounce", self.DelayAnnounce, 7, self)
	end
	self:ScheduleEvent("SnapPos", self.SnapPos, 2, self)
	
	if ((EnhancerNews or 0) < Enhancer.news) then
		self:News();
	end
end

function Enhancer:OnEnable()
	self.PlayerLevel = UnitLevel("player");
	self:Zoning();

	-- Register our events :>
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "OutOfCombat");
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "EnterCombat");
	self:RegisterEvent("PLAYER_LEVEL_UP", "Ding");
	if (Enhancer.englishClass == "SHAMAN") then
		self:RegisterEvent("PLAYER_DEAD", "PlayerDead");
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "CastingTotem");
		-- self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "TotemWasDestroyed");
		self:RegisterEvent("ZONE_CHANGED", "Zoning"); -- PLAYER_LEAVING_WORLD
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Zoning"); -- PLAYER_LEAVING_WORLD

		self:RegisterParserEvent({
			eventType = 'Damage',
		}, "ParserDamage");
		self:RegisterParserEvent({
			eventType = 'Miss',
			sourceID = "player",
		}, "ParserMiss");
	end
end

function Enhancer:OnDisable()
	self:UnregisterAllEvents();
	self:UnregisterAllParserEvents();
	self:CancelAllScheduledEvents();
end

function Enhancer:OnProfileDisable()

end
function Enhancer:OnProfileEnable(oldProfileName, oldProfileData)
	self:InspectEPValues();
	self:Resize();
	self:UpdateFont();
	self:ToggleLock();

	for name, module in self:IterateModules() do
		if (self:IsModuleActive(name) and module.OnEnable) then
			module:OnEnable();
		elseif (module.OnDisable) then
			module:OnDisable();
		end
	end
end

function Enhancer:SnapPos()
	-- Must do it all in the right order so we position frames without parents first etc ;)

	if (Enhancer.db.profile.framePositions) then
		-- We have some saved positions so let's get started;

		Enhancer.process = {};
		for framename, _ in pairs(Enhancer.db.profile.framePositions) do
			-- These frames need loading
			local Parent = Enhancer.db.profile.framePositions[framename]["Parent"];
			local ParentName = Enhancer.db.profile.framePositions[framename]["relativeTo"];
			if (not getglobal(ParentName)) then Parent = nil; end

			if (Parent) then
				Enhancer.process[framename] = { ["Parent"] = Parent, ["ParentGlobalName"] = ParentName };
			else
				Enhancer.process[framename] = { ["ParentGlobalName"] = ParentName };
			end
		end

		local next = self:GetNext();
		while (next) do
			local framename = self:FindParent(next);
			self:LoadPos(framename);
			Enhancer.process[framename] = nil;
			next = self:GetNext();
		end

		Enhancer.process = nil;
	end
end

function Enhancer:GetNext()
	if (not Enhancer.process) then return nil; end

	for framename, frameinfo in pairs(Enhancer.process) do
		return framename;
	end

	return nil;
end

function Enhancer:FindParent(framename)
	while (Enhancer.process[framename].Parent) do
		if (not getglobal(Enhancer.process[framename].ParentGlobalName)) then
			-- Could not find parent loaded so skip snapping this
			return framename;
		end

		local oldname = framename;
		framename = Enhancer.process[framename].Parent;
		if (not Enhancer.process[framename]) then
			return oldname;
		end
	end

	return framename;
end

function Enhancer:DelayAnnounce()
	if (self.noannounce) then return; end
	self:Print(L["Announcement"]);
end

function Enhancer:InspectEPValues()
	local resetNeeded = false;

	for _, value in pairs(Enhancer.db.profile.AEPNumbers) do
		if (value > 5) then
			resetNeeded = true;
		end
	end
	for _, value in pairs(Enhancer.db.profile.HEPNumbers) do
		if (value > 5) then
			resetNeeded = true;
		end
	end
	for _, value in pairs(Enhancer.db.profile.DEPNumbers) do
		if (value > 5) then
			resetNeeded = true;
		end
	end

	if (resetNeeded) then
		for key, value in pairs(defaults.AEPNumbers) do
			Enhancer.db.profile.AEPNumbers[key] = defaults.AEPNumbers[key];
		end
		for key, value in pairs(defaults.HEPNumbers) do
			Enhancer.db.profile.HEPNumbers[key] = defaults.HEPNumbers[key];
		end
		for key, value in pairs(defaults.DEPNumbers) do
			Enhancer.db.profile.DEPNumbers[key] = defaults.DEPNumbers[key];
		end

		self:Print("Your AEP values have been reset due to a major change, there was sadly no alternative!");
	end
end