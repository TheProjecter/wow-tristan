EnhancerWater = Enhancer:NewModule("Water");
Enhancer:SetModuleDefaultState("Water", true);

function EnhancerWater:OnInitialize()
	
end

function EnhancerWater:OnEnable()
	Enhancer:CheckRunningModules();
	Enhancer:ShowFrame("water");
end

function EnhancerWater:OnDisable()
	Enhancer:CheckRunningModules();
	Enhancer:HideFrame("water");
end