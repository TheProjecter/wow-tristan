EnhancerAir = Enhancer:NewModule("Air");
EnhancerAir.DefaultState = true;
Enhancer:SetModuleDefaultState("Air", EnhancerAir.DefaultState);
local FrameName = "air";

function EnhancerAir:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Totem_WardOfDraining", -170, -170);
	Enhancer[FrameName].borderColor = { ["r"] = (127/255), ["g"] = (255/255), ["b"] = (212/255), ["a"] = 1, }
	Enhancer:AddFrameToList(FrameName, true, true, true) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer[FrameName].moveName = "Air";
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