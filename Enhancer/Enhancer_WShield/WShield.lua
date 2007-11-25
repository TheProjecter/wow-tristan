EnhancerWShield = Enhancer:NewModule("WShield", "AceEvent-2.0");
Enhancer:SetModuleDefaultState("WShield", false);
local FrameName = "wshield";

local SEA = AceLibrary("SpecialEvents-Aura-2.0");

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerWShield:GetConsoleOptions()
	return L["wshield_cmd"], L["wshield_desc"];
end

function EnhancerWShield:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Ability_Shaman_WaterShield", 0, 125);
	Enhancer[FrameName].borderColor = Enhancer.colors.water.dec;
	Enhancer:AddFrameToList(FrameName, true, false, false); --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer:AddFrameToOnOffList(FrameName);
	Enhancer[FrameName].moveName = "WShield";
end

function EnhancerWShield:OnEnable()
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "OutOfCombat");
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "EnterCombat");
end

function EnhancerWShield:OnDisable()
	Enhancer:HideFrame(FrameName);
	
	self:UnregisterAllEvents();
	self:CancelAllScheduledEvents();
end

function EnhancerWShield:EnterCombat()
	self:ScheduleRepeatingEvent("CheckShield", self.CheckShield, 1, self);
end

function EnhancerWShield:OutOfCombat()
	self:CancelScheduledEvent("CheckShield");
	
	Enhancer[FrameName].active = false;
	Enhancer:UpdateAlphaBegin(FrameName);
end

function EnhancerWShield:CheckShield()
	local buffIndex, _, _, _ = SEA:UnitHasBuff("player", Enhancer.BS["Water Shield"]);
	-- return unitBuffs.index[buffIndex], unitBuffs.count[buffIndex], unitBuffs.icon[buffIndex], unitBuffs.rank[buffIndex]
	
	if (not buffIndex) then
		Enhancer[FrameName].active = true;
		Enhancer:UpdateAlphaBegin(FrameName);
	else
		Enhancer[FrameName].active = false;
		Enhancer:UpdateAlphaBegin(FrameName);
	end
end