EnhancerEarth = Enhancer:NewModule("Earth");
Enhancer:SetModuleDefaultState("Earth", true);
local FrameName = "earth";

function EnhancerEarth:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Totem_WardOfDraining", 170, 170);
	Enhancer[FrameName].borderColor = Enhancer.colors.earth.dec;
	Enhancer:AddFrameToList(FrameName, true, true, true) --[[ Enhancer:AddFrameToList(framename, all, totem, death) ]]--
	Enhancer[FrameName].moveName = "Earth";
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