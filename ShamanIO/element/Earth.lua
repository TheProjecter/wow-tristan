EnhancerEarth = Enhancer:NewModule("Earth");
Enhancer:SetModuleDefaultState("Earth", true);

function EnhancerEarth:OnInitialize()
	
end

function EnhancerEarth:OnEnable()
	Enhancer:CheckRunningModules();
	Enhancer:ShowFrame("earth");
end

function EnhancerEarth:OnDisable()
	Enhancer:CheckRunningModules();
	Enhancer:HideFrame("earth");
end