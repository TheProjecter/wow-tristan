local L = AceLibrary("AceLocale-2.2"):new("Enhancer");

Enhancer.news = 2; -- Can only ever increase
function Enhancer:News()
	Enhancer.noannounce = true;
	
	self:CreateNewsFrame();
	
	self.newsFrame:Clear();
	self.newsFrame.title:SetText(L["news_1"]);
	self.newsFrame.disclaimer:SetText(L["news_2"]);
	
	self.newsFrame:AddLine("Modules", "Broke everything out to modules if you are");
	self.newsFrame:AddLine("", "using WAU it should unpack itself otherwise");
	self.newsFrame:AddLine("", "you can just drag all folders starting with");
	self.newsFrame:AddLine("", "Enhancer_* out of the Enhancer folder an into");
	self.newsFrame:AddLine("", "the main AddOns folder of wow. This means any")
	self.newsFrame:AddLine("", "modules you don't want wont even be loaded!");
	self.newsFrame:AddLine("", "Happy enabling/disabling");
	self.newsFrame:AddLine("", "");
	
	self.newsFrame:AddLine("", "It's entirely possible this has brought on some new bugs.");
	self.newsFrame:AddLine("", "If it scares you revert to previous versions for a while.");
	self.newsFrame:AddLine("", "If it doesn't then try ahead and remember to email me");
	self.newsFrame:AddLine("", "should you encounter bugs or oddities!");
	
	self.newsFrame:AddLine("", "");
	self.newsFrame:AddLine("", "");
	self.newsFrame:AddLine(L["news_4"], L["news_7"]);
	self.newsFrame:AddLine(L["news_5"], L["news_7"]);
	self.newsFrame:AddLine(L["news_6"], L["news_7"]);
	
	self.newsFrame:Show();
	EnhancerNews = Enhancer.news;
end

function Enhancer:CreateNewsFrame()
	Enhancer.newsFrame = CreateFrame("Frame", "EnhancerNewsFrame", UIParent, "DialogBoxFrame")
	Enhancer.newsFrame:SetWidth(500)
	Enhancer.newsFrame:SetHeight(400)
	Enhancer.newsFrame:SetPoint("CENTER")
	Enhancer.newsFrame:SetBackdrop({
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
	    edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
	    tile = true, tileSize = 16, edgeSize = 16,
	    insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	Enhancer.newsFrame:SetBackdropColor(0,0,0,1)

	local text = Enhancer.newsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	Enhancer.newsFrame.title = text
	text:SetPoint("TOP", 0, -5)

	Enhancer.newsFrame:Hide()

	Enhancer.newsFrame.lefts = {}
	Enhancer.newsFrame.rights = {}
	Enhancer.newsFrame.textLefts = {}
	Enhancer.newsFrame.textRights = {}
	function Enhancer.newsFrame:Clear()
		self.title:SetText("")
		self.disclaimer:SetText("")
		for i = 1, #self.lefts do
			self.lefts[i] = nil
			self.rights[i] = nil
		end
	end

	function Enhancer.newsFrame:AddLine(left, right)
		Enhancer.newsFrame.lefts[#Enhancer.newsFrame.lefts+1] = left
		Enhancer.newsFrame.rights[#Enhancer.newsFrame.rights+1] = right
	end

	local newsFrame_Show = Enhancer.newsFrame.Show
	function Enhancer.newsFrame:Show(...)
		local maxLeftWidth = 0
		local maxRightWidth = 0
		local textHeight = 0
		for i = 1, #self.lefts do
			if not self.textLefts[i] then
				local left = Enhancer.newsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				self.textLefts[i] = left
				local right = Enhancer.newsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				self.textRights[i] = right
				if i == 1 then
					left:SetPoint("TOPRIGHT", Enhancer.newsFrame, "TOPLEFT", 75, -35)
				else
					left:SetPoint("TOPRIGHT", self.textLefts[i-1], "BOTTOMRIGHT", 0, -1)
				end
				right:SetPoint("LEFT", left, "RIGHT", 5, 0)
			end
			self.textLefts[i]:SetText(self.lefts[i] .. ((string.len(self.lefts[i]) > 0 and ":") or " "))
			self.textRights[i]:SetText(self.rights[i])
			local leftWidth = self.textLefts[i]:GetWidth()
			local rightWidth = self.textRights[i]:GetWidth()
			textHeight = self.textLefts[i]:GetHeight()
			if maxLeftWidth < leftWidth then
				maxLeftWidth = leftWidth
			end
			if maxRightWidth < rightWidth then
				maxRightWidth = rightWidth
			end
		end
		for i = #self.lefts+1, #self.textLefts do
			self.textLefts[i]:SetText('')
			self.textRights[i]:SetText('')
		end
		local finalWidth = 85 + maxRightWidth + 20 + 30;
		if (finalWidth < 360) then finalWidth = 360; end
		Enhancer.newsFrame:SetWidth(finalWidth)
		Enhancer.newsFrame:SetHeight(#self.lefts * (textHeight + 1) + 100)

		newsFrame_Show(self, ...)
	end
	Enhancer.newsFrame:Hide()
	
	local disclaimer = Enhancer.newsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	Enhancer.newsFrame.disclaimer = disclaimer
	disclaimer:SetPoint("BOTTOMRIGHT", Enhancer.newsFrame:GetName(), "BOTTOMRIGHT", -5, 5)
	
	--[[if (getglobal("EnhancerNewsFrameButton")) then
		getglobal("EnhancerNewsFrameButton"):SetScript("OnClick", function()
			Enhancer.newsFrame:Hide();
			Enhancer:Print(L["news_3"]);
		end);
	end]]
	
	Enhancer.CreateNewsFrame = function() return; end;
end