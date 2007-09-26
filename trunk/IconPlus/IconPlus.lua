IconPlus = Rock:NewAddon("IconPlus", "LibRockDB-1.0", "LibRockConsole-1.0", "LibRockEvent-1.0", "LibRockConfig-1.0")

local IconPlus, self, Self = IconPlus, IconPlus, IconPlus;
IconPlus.revision = tonumber(("$Revision$"):match("%d+"));
IconPlus.version = "1.0." .. IconPlus.revision;
IconPlus.date = ("$Date$"):match("%d%d%d%d%-%d%d%-%d%d");

IconPlus.prefix = "IconPlus";

local L = Rock("LibRockLocale-1.0"):GetTranslationNamespace("IconPlus");
IconPlus.L = L;
L:AddTranslations("enUS", function() return {
	[1] = "Star",
	[2] = "Circle",
	[3] = "Diamond",
	[4] = "Triangle",
	[5] = "Moon",
	[6] = "Square",
	[7] = "Cross",
	[8] = "Skull", -- Make this not assignable?
	
	["new_assign"] = "Your icon for groups lead by %s is now set to %s",
} end);

IconPlus:SetDatabase("IconPlusDB", "IconPlusCharDB");
IconPlus:SetDefaultProfile("char");
IconPlus:SetDatabaseDefaults('profile', {
	icons = {}, -- [GroupLeaderName] = icon#
	default = 4, -- Default Icon to set when not assigned an icon
	assigned = {}, -- [GroupMemberName] = icon#
});

IconPlus.options = {
	type = 'group',
	name = "IconPlus",
	desc = "Addon to assing raid icons.",
	icon = [[Interface\AddOns\IconPlus\icons\Diamond]],
	args = {
		type = 'execute',
		name = "Mark",
		desc = "Assign icon to target (one way or another).",
		func = function()
			IconPlus:Mark()
		end,
		order = 1,
	},
}

function IconPlus:OnInitialize()
	self:SetConfigTable(self.options)
	self:SetConfigSlashCommand("/IconPlus", "/IP", "/IconP");
end

function IconPlus:OnEnable()
	self:AddEventListener("CHAT_MSG_ADDON");
end

function IconPlus:OnDisable()
	self:RemoveEventListener("CHAT_MSG_ADDON");
end

function IconPlus:CHAT_MSG_ADDON(prefix, message, type, sender)
  --[[ Updates IconPlus.db.profile.icons["Leion"] --]]
  if (prefix ~= self.prefix) then return; end
  
  if (type == self:CurrentGroup()) then
  	local target, icon = string.match(message, "^(%s%s*) (%d)$");
  	icon = tonumber(icon)
  	
  	if (target and icon and target == UnitName("player") and sender == self:GroupLeaderName()) then
  		if (icon < 1 or icon > 8) then return; end
  		
  		self.db.profile.icons[sender] = icon;
  		self:Print(string.format(L["new_assign"], sender, L[icon]));
  	elseif (message == "set") then
  		-- Assign senders icon to his target
  		local sIcon = self.db.profile.assigned[sender];
  		local unit = self:GetUnitFromName(sender);
  		
  		if (self:CanSetIcon() and sIcon and unit) then
  			self:Mark(unit, sIcon);
  		end
  	elseif (message == "get" and self:IsLeader()) then
  		local sIcon = self.db.profile.assigned[sender];
  		self:SendAssign(sender, sIcon);
  	end
  end
end

function IconPlus:Assign(playername, icon)
	local assigned = tonumber(icon);
	if (assigned) then
		self.db.profile.assigned[playername] = assigned;
		
		self:SendAssign(playername, icon);
	end
end

function IconPlus:SendAssign(playername, icon)
	self:SendAddonMessage(string.format("%s %d", playername, assigned));
end

function IconPlus:SendAddonMessage(message)
	local cg = self:CurrentGroup();
	if (cg) then
		SendAddonMessage(self.prefix, message, cg);
	end
end

function IconPlus:IsLeader()
	local cg = self:CurrentGroup();
	
	return ((cg == "PARTY" and IsPartyLeader()) or (cg == "RAID" and IsRaidLeader()));
end

function IconPlus:CanSetIcon()
	local cg = self:CurrentGroup();
	
	return ((cg == "PARTY" and IsPartyLeader()) or (cg == "RAID" and (IsRaidLeader() or IsRaidOfficer())));
end

function IconPlus:CurrentGroup()
	if (MiniMapBattlefieldFrame.status == "active") then return; end
	
	if (GetNumRaidMembers() > 0) then return "RAID"; end
	if (GetNumPartyMembers() > 0) then return "PARTY"; end
end

function IconPlus:GetUnitFromName(name)
	local cg = self:CurrentGroup();
	
	if (cg == "RAID") then
		for i = 1, 40 do
			local token = "raid" .. i;
			if (UnitExists(token) and name == UnitName(token)) then
				return token;
			end
		end
	elseif (cg == "PARTY") then
		for i = 1, 5 do
			local token = "party" .. i;
			if (UnitExists(token) and name == UnitName(token)) then
				return token;
			end
		end
	end
end

function IconPlus:GroupLeaderName()
	local cg = self:CurrentGroup();
	
	if (cg == "RAID") then
		for i = 1, 40 do
			local name, rank = GetRaidRosterInfo(i);
			if (name and rank == 2) then
				return name;
			end
		end
	elseif (cg == "PARTY") then
		for i = 1, 5 do
			local token = "party" .. i;
			if (UnitExists(token) and UnitIsPartyLeader(token)) then
				return (UnitName(token));
			end
		end
	end
end

function IconPlus:Mark(who, icon) --[[ This should be a keybinding --]]
	local cg = self:CurrentGroup();
	local csi = self:CanSetIcon();
	
	if (who and icon and csi and cg) then
		self:SetRaidTarget(who .. "target", icon, who);
	elseif (csi and cg) then
		self:SetRaidTarget("target", self.db.profile.icons[self:GroupLeaderName()] or self.db.profile.default);
	elseif (cg) then
		self:SendAddonMessage("set");
	end
end

function IconPlus:SetRaidTarget(unit, icon, who)
	if (not UnitExists(unit)) then
		if (who) then
			self:Print("Can't assign icon to <No Target> of " .. (UnitName(who)) .. ", are you in range of the target?");
		else
			self:Print("Can't assign icon to <No Target>");
		end
		return;
	end
	
	cIcon = GetRaidTargetIndex(unit);
	if (cIcon ~= icon) then
		SetRaidTarget(unit, icon);
	end
end

--[[-----------------------------------------------------
SetRaidTarget("target", 1);  -- Star
SetRaidTarget("target", 2);  -- Circle
SetRaidTarget("target", 3);  -- Diamond
SetRaidTarget("target", 4);  -- Triangle
SetRaidTarget("target", 5);  -- Moon
SetRaidTarget("target", 6);  -- Square
SetRaidTarget("target", 7);  -- Cross
SetRaidTarget("target", 8);  -- Skull
SetRaidTarget("target", 0);  -- Remove RaidIcon
-----------------------------------------------------]]--