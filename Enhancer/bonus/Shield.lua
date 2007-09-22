EnhancerShield = Enhancer:NewModule("Shield", "AceEvent-2.0");
EnhancerShield.DefaultState = false;
Enhancer:SetModuleDefaultState("Shield", EnhancerShield.DefaultState);
local FrameName = "shield";

local SEA = AceLibrary("SpecialEvents-Aura-2.0");

local L = AceLibrary("AceLocale-2.2"):new("Enhancer")
function EnhancerShield:GetConsoleOptions()
	return L["shield_cmd"], L["shield_desc"];
end

function EnhancerShield:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Ability_Mage_MoltenArmor", 0, -95);
	Enhancer[FrameName].mainframe.bgFileDefault  = "Interface/Icons/Ability_Mage_MoltenArmor";
	Enhancer[FrameName].fullicon = true;
	Enhancer[FrameName].borderColor = { ["r"] = (0/255), ["g"] = (245/255), ["b"] = (255/255), ["a"] = 1, }
	Enhancer:AddFrameToList(FrameName, true, false, true) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer[FrameName].moveName = "Shield";
end

function EnhancerShield:OnEnable()
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
	
	self:RegisterEvent("UNIT_SPELLCAST_SENT", "SpellCastSent");
	self:RegisterEvent("SpecialEvents_PlayerBuffGained", "PlayerBuffGained")
	self:RegisterEvent("SpecialEvents_PlayerBuffLost", "PlayerBuffLost")
	
	self:CheckOnEnable();
end

function EnhancerShield:OnDisable()
	Enhancer:HideFrame(FrameName);
	
	self:UnregisterAllEvents();
	self:CancelAllScheduledEvents();
end

function EnhancerShield:CheckOnEnable()
	local buffIndex, applications, texture, rank = SEA:UnitHasBuff("player", Enhancer.BS["Lightning Shield"]);
	local buffName = Enhancer.BS["Lightning Shield"];
	if (not buffIndex) then
		buffIndex, applications, texture, rank = SEA:UnitHasBuff("player", Enhancer.BS["Water Shield"]);
		buffName = Enhancer.BS["Water Shield"];
	end
	
	if (buffIndex) then
		self:PlayerBuffGained(buffName, buffIndex, applications, texture, rank)
	end
end

function EnhancerShield:PlayerBuffGained(buffName, buffIndex, applications, texture, rank, index)
	if (buffName == Enhancer.BS["Lightning Shield"] or buffName == Enhancer.BS["Water Shield"]) then
		Enhancer[FrameName].active = true;
		Enhancer[FrameName].current = buffName;
		Enhancer[FrameName].textbelow:SetText( Enhancer:FormatTime( GetPlayerBuffTimeLeft(buffIndex) ) );
		Enhancer[FrameName].textcenter:SetText( Enhancer.LR:R(applications) );
		Enhancer:ChangeIcon(FrameName, texture);
		Enhancer:UpdateAlphaBegin(FrameName);
		self:ScheduleRepeatingEvent("UpdateShield", self.UpdateShield, 1, self);
	end
end

function EnhancerShield:PlayerBuffLost(buffName, applications, texture, rank)
	if (buffName == Enhancer.BS["Lightning Shield"] or buffName == Enhancer.BS["Water Shield"]) then
		if (not (SEA:UnitHasBuff("player", Enhancer.BS["Lightning Shield"])) and not (SEA:UnitHasBuff("player", Enhancer.BS["Water Shield"])) ) then
			Enhancer:FrameDeathPreBegin(FrameName);
			self:CancelScheduledEvent("UpdateShield");
		end
	end
end

function EnhancerShield:SpellCastSent(unit, spell, rank, target)
	if (unit ~= "player") then return; end
	
	if (spell == Enhancer.BS["Earth Shield"]) then self:Debug(target); end
end

function EnhancerShield:UpdateShield()
	local buffIndex, applications = SEA:UnitHasBuff("player", Enhancer[FrameName].current);
	-- return unitBuffs.index[buffIndex], unitBuffs.count[buffIndex], unitBuffs.icon[buffIndex], unitBuffs.rank[buffIndex]
	
	if (buffIndex) then
		Enhancer[FrameName].textbelow:SetText( Enhancer:FormatTime( GetPlayerBuffTimeLeft(buffIndex) ) );
		Enhancer[FrameName].textcenter:SetText( Enhancer.LR:R(applications) );
	end
end

function EnhancerShield:Debug(...)
	if (EnhancerShield.debug) then
		Enhancer:Print("Shield-Debug:", ...);
	end
end