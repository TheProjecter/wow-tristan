EnhancerFire = Enhancer:NewModule("Fire");
Enhancer:SetModuleDefaultState("Fire", true);

function EnhancerFire:OnInitialize()
	
end

function EnhancerFire:OnEnable()
	Enhancer:CheckRunningModules();
	Enhancer:ShowFrame("fire");
end

function EnhancerFire:OnDisable()
	Enhancer:CheckRunningModules();
	Enhancer:HideFrame("fire");
end