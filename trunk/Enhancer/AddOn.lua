--[[
Left to do:
	Windfury calculation and display! (FontString midscreen that grows on crit?)
]]--
Enhancer = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "AceConsole-2.0", "AceModuleCore-2.0", "Parser-3.0", "Sink-1.0");
Enhancer:RegisterDB("EnhancerDB", nil, "class");


local L = AceLibrary("AceLocale-2.2"):new("Enhancer");
Enhancer.deformat = AceLibrary("Deformat-2.0");
Enhancer.BS = AceLibrary("Babble-Spell-2.2");
--local Aura = AceLibrary("SpecialEvents-Aura-2.0")
Enhancer.LR = LibStub:GetLibrary("LibRoman-1.0");

_, Enhancer.englishClass = UnitClass("player");

-- {"Damage", "Miss", "Parry", "Dodge", "Resist", "Absorb", "Block", "Evade", "Immune"}
Enhancer.wfParserTypes = { "Damage", "Miss", "Extra Attack" }; -- "Unknown" ???
--[[
local EVENTTYPE_DAMAGE = "Damage"
local EVENTTYPE_HEAL = "Heal"
local EVENTTYPE_ENVIRONMENTAL = "Environmental"
local EVENTTYPE_MISS = "Miss"
local EVENTTYPE_DEATH = "Death"
local EVENTTYPE_CAST = "Cast"
local EVENTTYPE_DRAIN = "Drain"
local EVENTTYPE_DURABILITY = "Durability"
local EVENTTYPE_EXTRAATTACK = "Extra Attack"
local EVENTTYPE_INTERRUPT = "Interrupt"
local EVENTTYPE_DISPEL = "Dispel"
local EVENTTYPE_LEECH = "Leech"
local EVENTTYPE_FAIL = "Fail"
local EVENTTYPE_ENCHANT = "Enchant"
local EVENTTYPE_REPUTATION = "Reputation"
local EVENTTYPE_HONOR = "Honor"
local EVENTTYPE_EXPERIENCE = "Experience"
local EVENTTYPE_FADE = "Fade"
local EVENTTYPE_GAIN = "Gain"
local EVENTTYPE_AURA = "Aura"
local EVENTTYPE_FEEDPET = "Feed Pet"
local EVENTTYPE_CREATE = "Create"
local EVENTTYPE_SKILL = "Skill"
local EVENTTYPE_UNKNOWN = "Unknown"

local MISSTYPE_MISS = "Miss"
local MISSTYPE_PARRY = "Parry"
local MISSTYPE_DODGE = "Dodge"
local MISSTYPE_REFLECT = "Reflect"
local MISSTYPE_DEFLECT = "Deflect"
local MISSTYPE_RESIST = "Resist"
local MISSTYPE_ABSORB = "Absorb"
local MISSTYPE_BLOCK = "Block"
local MISSTYPE_EVADE = "Evade"
local MISSTYPE_IMMUNE = "Immune"

]]--

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
	self:LoadModules();
	self:RegisterSlashCommands();

	--[[ No more announce
	if (not self.db.profile.startAnnounceDisabled) then
		self:ScheduleEvent("DelayAnnounce", self.DelayAnnounce, 7, self)
	end
	]]--
	self:ScheduleEvent("SnapPos", self.SnapPos, 2, self)
	
	if ((EnhancerNews or 0) < Enhancer.news) then
		self:News();
	end
	
	Enhancer:RegisterSlashCommand("/EnhDev", function(param) self:InDevelopment(param) end)
end

function Enhancer:OnEnable()
	self:CleanUp();
	
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

--[[ Stolen from AuldLangSyne ]]--
local del, newSet
do
	local list = setmetatable({}, {__mode='k'})
	function del(t)
		for k in pairs(t) do
			t[k] = nil
		end
		t[''] = true
		t[''] = nil
		list[t] = true
		return nil
	end
	function newSet(...)
		local t = next(list)
		if t then
			list[t] = nil
		else
			t = {}
		end
		for i = 1, select('#', ...) do
			t[select(i, ...)] = true
		end
		return t
	end
end
function Enhancer:LoadModules()
	for i = 1, GetNumAddOns() do
		local deps = newSet(GetAddOnDependencies(i))
		if deps["Enhancer"] and IsAddOnLoadOnDemand(i) and not IsAddOnLoaded(i) then
			local name = GetAddOnInfo(i)
			if name:find("^Enhancer_") then
				local _,_,_,_,loadable = GetAddOnInfo(i)
				if loadable then
					LoadAddOn(i)
				end
			end
		end
		deps = del(deps)
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
	-- if (self.noannounce) then return; end
	self:Print(L["Announcement"]);
end

function Enhancer:CleanUp()
	--Cleanup stuff that seemed smart at some point and now just linger in the SV
	if (Enhancer and Enhancer.db and Enhancer.db.profile and Enhancer.db.profile.AEPNumbers) then
		Enhancer.db.profile.AEPNumbers.WEAPON_MIN = nil;
		Enhancer.db.profile.AEPNumbers.WEAPON_MAX = nil;
	end
end