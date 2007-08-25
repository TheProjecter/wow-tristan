EnhancerAir = Enhancer:NewModule("Air");
Enhancer:SetModuleDefaultState("Air", true);
local FrameName = "air";

function EnhancerAir:OnInitialize()
	Enhancer.air = Enhancer:CreateButton("EnhancerFrameAir", "Spell_Totem_WardOfDraining", -170, -170);
	Enhancer.air.borderColor = { ["r"] = (127/255), ["g"] = (255/255), ["b"] = (212/255), ["a"] = 1, }
	Enhancer:AddFrameToList(FrameName, true, true, true) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
end

function EnhancerAir:OnEnable()
	Enhancer:CheckRunningModules();
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
end

function EnhancerAir:OnDisable()
	Enhancer:CheckRunningModules();
	Enhancer:HideFrame(FrameName);
end