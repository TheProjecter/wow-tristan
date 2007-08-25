EnhancerWater = Enhancer:NewModule("Water");
Enhancer:SetModuleDefaultState("Water", true);
local FrameName = "water";

function EnhancerWater:OnInitialize()
	Enhancer.water = Enhancer:CreateButton("EnhancerFrameWater", "Spell_Totem_WardOfDraining", 170, -170);
	Enhancer.water.borderColor = { ["r"] = (0/255), ["g"] = (245/255), ["b"] = (255/255), ["a"] = 1, }
	Enhancer:AddFrameToList(FrameName, true, true, true) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
end

function EnhancerWater:OnEnable()
	Enhancer:CheckRunningModules();
	Enhancer:ShowFrame(FrameName);
	Enhancer:ToggleLock(FrameName);
end

function EnhancerWater:OnDisable()
	Enhancer:CheckRunningModules();
	Enhancer:HideFrame(FrameName);
end