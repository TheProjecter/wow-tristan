EnhancerTench = Enhancer:NewModule("Tench", "AceEvent-2.0");
EnhancerTench.DefaultState = false;
Enhancer:SetModuleDefaultState("Tench", EnhancerTench.DefaultState);
local FrameNameM = "mhtench";
local FrameNameO = "ohtench";
local FrameList = { FrameNameO, FrameNameM };

local SEA = AceLibrary("SpecialEvents-Aura-2.0")

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerTench:GetConsoleOptions()
	return L["tench_cmd"], L["tench_desc"];
end

function EnhancerTench:OnInitialize()
	Enhancer[FrameNameM] = Enhancer:CreateButton("EnhancerFrame" .. FrameNameM, "INV_Mace_39", -120, 0);
	Enhancer:AddFrameToList(FrameNameM, true, false, false) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer[FrameNameM].fullicon = true;
	_, Enhancer[FrameNameM].mainframe.bgFileDefault = GetInventorySlotInfo("MainHandSlot");
	Enhancer[FrameNameM].moveName = "MainH";
	
	Enhancer[FrameNameO] = Enhancer:CreateButton("EnhancerFrame" .. FrameNameO, "INV_Mace_39", 120, 0);
	Enhancer:AddFrameToList(FrameNameO, true, false, false) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer[FrameNameO].fullicon = true;
	_, Enhancer[FrameNameO].mainframe.bgFileDefault = GetInventorySlotInfo("SecondaryHandSlot");
	Enhancer[FrameNameO].moveName = "OffH";
end

function EnhancerTench:OnEnable()
	SEA:PlayerItemBuffScan();
	
	Enhancer:ShowFrame(FrameList);
	Enhancer:ToggleLock(FrameList);
	self:GearChange("player")
	
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "SpellCast");
	
	self:RegisterEvent("UNIT_INVENTORY_CHANGED", "GearChange");
end

function EnhancerTench:OnDisable()
	Enhancer:HideFrame(FrameList);
	
	self:UnregisterAllEvents();
	self:CancelAllScheduledEvents();
end

function EnhancerTench:GearChange(unit)
	if (unit ~= "player") then return; end
	local MHID, OHID;
	
	MHID, Enhancer[FrameNameM].mainframe.bgFileDefault = GetInventorySlotInfo("MainHandSlot");
	if (GetInventoryItemLink(unit, MHID)) then
		Enhancer[FrameNameM].mainframe.bgFileDefault = GetInventoryItemTexture(unit, MHID);
		Enhancer[FrameNameM].empty = nil;
	else
		Enhancer[FrameNameM].empty = true;
	end
	Enhancer:ChangeIcon(FrameNameM, Enhancer[FrameNameM].mainframe.bgFileDefault);
	
	OHID, Enhancer[FrameNameO].mainframe.bgFileDefault = GetInventorySlotInfo("SecondaryHandSlot");
	if (GetInventoryItemLink(unit, OHID)) then
		Enhancer[FrameNameO].mainframe.bgFileDefault = GetInventoryItemTexture(unit, OHID);
		Enhancer[FrameNameO].empty = nil;
	else
		Enhancer[FrameNameO].empty = true;
	end
	Enhancer:ChangeIcon(FrameNameO, Enhancer[FrameNameO].mainframe.bgFileDefault);
	
	self:AuraChanged();
end

function EnhancerTench:SpellCast(unit, spell, rank)
	if (unit ~= "player") then return; end
	
	if (spell == Enhancer.BS["Windfury Weapon"]) then self:AuraChanged(); end
	if (spell == Enhancer.BS["Flametongue Weapon"]) then self:AuraChanged(); end
	if (spell == Enhancer.BS["Frostbrand Weapon"]) then self:AuraChanged(); end
end

function EnhancerTench:AuraChanged()
	local hasMainHandEnchant, _, _, hasOffHandEnchant, _, _ = GetWeaponEnchantInfo()
	
	if (hasMainHandEnchant) then
		SEA:PlayerItemBuffScan();
		local MHName = SEA:GetPlayerMainHandItemBuff();
		if (not MHName) then self:ScheduleEvent("AuraChanged", self.AuraChanged, 1, self); return; end
		local texture = Enhancer.BS:GetSpellIcon(MHName) or Enhancer.BS:GetSpellIcon(string.format("%s Weapon", MHName))
		
		Enhancer[FrameNameM].active = true;
		Enhancer[FrameNameM].textcenter:SetText("MH");
		Enhancer:ChangeIcon(FrameNameM, texture);
		self:ScheduleRepeatingEvent("MHUpdate", self.MHUpdate, 1, self);
	else
		Enhancer:FrameDeathPreBegin(FrameNameM);
	end
	
	if (hasOffHandEnchant) then
		SEA:PlayerItemBuffScan();
		local OHName = SEA:GetPlayerOffHandItemBuff();
		if (not OHName) then self:ScheduleEvent("AuraChanged", self.AuraChanged, 1, self); return; end
		local texture = Enhancer.BS:GetSpellIcon(OHName) or Enhancer.BS:GetSpellIcon(string.format("%s Weapon", OHName))
		
		Enhancer[FrameNameO].active = true;
		Enhancer[FrameNameO].textcenter:SetText("OH");
		Enhancer:ChangeIcon(FrameNameO, texture);
		self:ScheduleRepeatingEvent("OHUpdate", self.OHUpdate, 1, self);
	else
		Enhancer:FrameDeathPreBegin(FrameNameO);
	end
end

function EnhancerTench:MHUpdate()
	local hasEnchant, Expiration, Charges = GetWeaponEnchantInfo();
	
	if (hasEnchant) then
		Enhancer[FrameNameM].textbelow:SetText( Enhancer:FormatTime( (Expiration / 1000) ) );
	else
		self:CancelScheduledEvent("MHUpdate");
		Enhancer:FrameDeathPreBegin(FrameNameM);
	end
end

function EnhancerTench:OHUpdate()
	local _, _, _, hasEnchant, Expiration, Charges = GetWeaponEnchantInfo()
	
	if (hasEnchant) then
		Enhancer[FrameNameO].textbelow:SetText( Enhancer:FormatTime( (Expiration / 1000) ) );
	else
		self:CancelScheduledEvent("OHUpdate");
		Enhancer:FrameDeathPreBegin(FrameNameO);
	end
end