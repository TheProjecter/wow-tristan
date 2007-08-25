EnhancerFire = Enhancer:NewModule("Fire");
Enhancer:SetModuleDefaultState("Fire", true);
local FrameName = "fire";

function EnhancerFire:OnInitialize()
	Enhancer.fire = Enhancer:CreateButton("EnhancerFrameFire", "Spell_Totem_WardOfDraining", -170, 170);
	Enhancer.fire.borderColor = { ["r"] = (178/255), ["g"] = (34/255), ["b"] = (34/255), ["a"] = 1, }
	Enhancer:AddFrameToList(FrameName, true, true, true) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
end

function EnhancerFire:OnEnable()
	Enhancer:CheckRunningModules();
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
end

function EnhancerFire:OnDisable()
	Enhancer:CheckRunningModules();
	Enhancer:HideFrame(FrameName);
end