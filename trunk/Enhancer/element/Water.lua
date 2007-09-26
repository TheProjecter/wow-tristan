EnhancerWater = Enhancer:NewModule("Water");
Enhancer:SetModuleDefaultState("Water", true);
local FrameName = "water";

function EnhancerWater:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Totem_WardOfDraining", 170, -170);
	Enhancer[FrameName].borderColor = Enhancer.colors.water.dec;
	Enhancer:AddFrameToList(FrameName, true, true, true) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer[FrameName].moveName = "Water";
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