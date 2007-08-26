EnhancerTench = Enhancer:NewModule("Tench", "AceEvent-2.0");
Enhancer:SetModuleDefaultState("Tench", false);
local FrameNameM = "mhtench";
local FrameNameO = "ohtench";
local FrameList = { FrameNameO, FrameNameM };


local SEA = AceLibrary("SpecialEvents-Aura-2.0")

function EnhancerTench:OnInitialize()
	-- type(Enhancer.windfury)
	Enhancer.mhtench = Enhancer:CreateButton("EnhancerFrameMHTench", "INV_Mace_39", -120, 0);
	Enhancer:AddFrameToList(FrameNameM, true, false, false) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer.mhtench.fullicon = true;
	_, Enhancer.mhtench.mainframe.bgFileDefault = GetInventorySlotInfo("MainHandSlot");
	
	Enhancer.ohtench = Enhancer:CreateButton("EnhancerFrameOHTench", "INV_Mace_39", 120, 0);
	Enhancer:AddFrameToList(FrameNameO, true, false, false) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer.ohtench.fullicon = true;
	_, Enhancer.ohtench.mainframe.bgFileDefault = GetInventorySlotInfo("SecondaryHandSlot");
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
	self:UnregisterAllEvents();
	Enhancer:HideFrame(FrameList);
end

function EnhancerTench:GearChange(unit)
	if (unit ~= "player") then return; end
	local MHID, OHID;
	
	MHID, Enhancer.mhtench.mainframe.bgFileDefault = GetInventorySlotInfo("MainHandSlot");
	if (GetInventoryItemLink(unit, MHID)) then
		Enhancer.mhtench.mainframe.bgFileDefault = GetInventoryItemTexture(unit, MHID);
		Enhancer.mhtench.empty = nil;
	else
		Enhancer.mhtench.empty = true;
	end
	Enhancer:ChangeIcon(FrameNameM, Enhancer.mhtench.mainframe.bgFileDefault);
	
	OHID, Enhancer.ohtench.mainframe.bgFileDefault = GetInventorySlotInfo("SecondaryHandSlot");
	if (GetInventoryItemLink(unit, OHID)) then
		Enhancer.ohtench.mainframe.bgFileDefault = GetInventoryItemTexture(unit, OHID);
		Enhancer.ohtench.empty = nil;
	else
		Enhancer.ohtench.empty = true;
	end
	Enhancer:ChangeIcon(FrameNameO, Enhancer.ohtench.mainframe.bgFileDefault);
	
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
		
		Enhancer.mhtench.active = true;
		Enhancer.mhtench.textcenter:SetText("MH");
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
		
		Enhancer.ohtench.active = true;
		Enhancer.ohtench.textcenter:SetText("OH");
		Enhancer:ChangeIcon(FrameNameO, texture);
		self:ScheduleRepeatingEvent("OHUpdate", self.OHUpdate, 1, self);
	else
		Enhancer:FrameDeathPreBegin(FrameNameO);
	end
end

function EnhancerTench:MHUpdate()
	local hasEnchant, Expiration, Charges = GetWeaponEnchantInfo();
	
	if (hasEnchant) then
		Enhancer.mhtench.textbelow:SetText( Enhancer:FormatTime( (Expiration / 1000) ) );
	else
		self:CancelScheduledEvent("MHUpdate");
		Enhancer:FrameDeathPreBegin(FrameNameM);
	end
end

function EnhancerTench:OHUpdate()
	local _, _, _, hasEnchant, Expiration, Charges = GetWeaponEnchantInfo()
	
	if (hasEnchant) then
		Enhancer.ohtench.textbelow:SetText( Enhancer:FormatTime( (Expiration / 1000) ) );
	else
		self:CancelScheduledEvent("OHUpdate");
		Enhancer:FrameDeathPreBegin(FrameNameO);
	end
end