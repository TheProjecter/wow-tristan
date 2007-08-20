EnhancerAir = Enhancer:NewModule("Air");
Enhancer:SetModuleDefaultState("Air", true);

function EnhancerAir:OnInitialize()
	
end

function EnhancerAir:OnEnable()
	Enhancer:CheckRunningModules();
	Enhancer:ShowFrame("air");
end

function EnhancerAir:OnDisable()
	Enhancer:CheckRunningModules();
	Enhancer:HideFrame("air");
end