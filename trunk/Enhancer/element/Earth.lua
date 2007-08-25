EnhancerEarth = Enhancer:NewModule("Earth");
Enhancer:SetModuleDefaultState("Earth", true);
local FrameName = "earth";

function EnhancerEarth:OnInitialize()
	Enhancer.earth = Enhancer:CreateButton("EnhancerFrameEarth", "Spell_Totem_WardOfDraining", 170, 170);
	Enhancer.earth.borderColor = { ["r"] = (139/255), ["g"] = (69/255), ["b"] = (19/255), ["a"] = 1, }
	Enhancer:AddFrameToList(FrameName, true, true, true) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
end

function EnhancerEarth:OnEnable()
	Enhancer:CheckRunningModules();
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
end

function EnhancerEarth:OnDisable()
	Enhancer:CheckRunningModules();
	Enhancer:HideFrame(FrameName);
end