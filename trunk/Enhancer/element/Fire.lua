EnhancerFire = Enhancer:NewModule("Fire");
EnhancerFire.DefaultState = (Enhancer.englishClass == "SHAMAN");
Enhancer:SetModuleDefaultState("Fire", EnhancerFire.DefaultState);
local FrameName = "fire";

function EnhancerFire:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Totem_WardOfDraining", -170, 170);
	Enhancer[FrameName].borderColor = { ["r"] = (178/255), ["g"] = (34/255), ["b"] = (34/255), ["a"] = 1, }
	Enhancer:AddFrameToList(FrameName, true, true, true) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer[FrameName].moveName = "Fire";
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