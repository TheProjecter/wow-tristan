local L = AceLibrary("AceLocale-2.2"):new("ShamanIOAEP")
ShamanIOAEP = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0");

local ibl = AceLibrary("ItemBonusLib-1.0");
local TipHooker = AceLibrary("TipHooker-1.0");

function ShamanIOAEP:OnInitialize()
	
end

function ShamanIOAEP:OnEnable()
	self.enabled = true;
	TipHooker:Hook(self.ProcessTooltip, "item");
	
	--[[ For some reason I can't get TipHooker to work without enabling RatingBuster wich sux so I hacked a bit here ]]--
	self:ScheduleEvent("Tooltip", self.Tooltip, 1, self);
end

function ShamanIOAEP:OnDisable()
	self.enabled = true;
	TipHooker:Unhook(self.ProcessTooltip, "item");
end

function ShamanIOAEP:Tooltip()
	--[[ For some reason I can't get TipHooker to work without enabling RatingBuster wich sux so I hacked a bit here ]]--
	local FunctionThatNeverExecutes = TipHooker.OnEventFrame:GetScript("OnEvent");
	pcall( FunctionThatNeverExecutes );
end

function ShamanIOAEP:Toggle()
	if (self.enabled) then
		self:OnDisable();
	else
		self:OnEnable();
	end
end

function ShamanIOAEP:Active()
	return self.enabled;
end

ShamanIOAEP.ProcessTypes = { [L["Armor"]] = true, [L["Gem"]] = true, [L["Weapon"]] = true, } -- [L["Projectile"]] = true, [L["Quiver"]] = true, 
ShamanIOAEP.NotProcessSubTypes = { [L["Plate"]] = true, [L["Idols"]] = true, [L["Librams"]] = true, [L["Fishing Pole"]] = true, [L["One-Handed Swords"]] = true, [L["Polearms"]] = true, [L["Two-Handed Swords"]] = true, [L["Bows"]] = true, [L["Crossbows"]] = true, [L["Guns"]] = true, [L["Thrown"]] = true, [L["Wands"]] = true, }
function ShamanIOAEP.ProcessTooltip(tooltip, name, link)
	
	if (link) then
		
		--[[ Check if we care about this item ]]--
		local _, _, _, _, _, ItemType, ItemSubType = GetItemInfo(link)
		if (not ShamanIOAEP.ProcessTypes[ItemType]) then return; end
		if (ShamanIOAEP.NotProcessSubTypes[ItemSubType]) then return; end
		
		bonuses = ibl:ScanItem(link, true, false);
		
		local AEP, AEPK = 0, 0;
		
		AEP = AEP + (bonuses.CR_HASTE or 0) * (22 / 10);
		AEP = AEP + (bonuses.STR or 0) * 2;
		AEP = AEP + (bonuses.CR_CRIT or 0) * 2;
		AEP = AEP + (bonuses.AGI or 0) * (18 / 10);
		AEP = AEP + (bonuses.CR_HIT or 0) * (14 / 10);
		AEP = AEP + (bonuses.ATTACKPOWER or 0) * 1;
		
		AEPK = AEPK + (bonuses.CR_HASTE or 0) * (22 / 10);
		AEPK = AEPK + (bonuses.STR or 0) * (22 / 10);
		AEPK = AEPK + (bonuses.CR_CRIT or 0) * 2;
		AEPK = AEPK + (bonuses.AGI or 0) * 2;
		AEPK = AEPK + (bonuses.CR_HIT or 0) * (14 / 10);
		AEPK = AEPK + (bonuses.ATTACKPOWER or 0) * 1;

--[[
		Haste Rating = 2.2
		Strength = 2 (2.2 w/Kings)
		Crit Rating = 2
		Agility = 1.8 (2 w/Kings)
		Hit Rating = 1.4
		Attack Power = 1
		
		Bonuses for: [Swiftsteel Bludgeon]
		WEAPON_MAX = 196
		WEAPON_SPEED = 1.5
		ATTACKPOWER = 40
		CR_HASTE = 27
		CR_HIT = 19
		WEAPON_MIN = 105
]]--
		
		if (AEP > 0 or AEPK > 0 or true) then
			tooltip:AddLine(" ");
			tooltip:AddLine( string.format(L["Enhancement AEP (inc BoK): %d (%d)"], AEP, AEPK) );
			tooltip:Show();
		end
	end
end