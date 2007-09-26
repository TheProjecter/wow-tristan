EnhancerFire = Enhancer:NewModule("Fire");
Enhancer:SetModuleDefaultState("Fire", true);
local FrameName = "fire";

function EnhancerFire:OnInitialize()
	Enhancer[FrameName] = Enhancer:CreateButton("EnhancerFrame" .. FrameName, "Spell_Totem_WardOfDraining", -170, 170);
	Enhancer[FrameName].borderColor = Enhancer.colors.fire.dec;
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