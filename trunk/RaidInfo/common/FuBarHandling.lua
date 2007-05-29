local L = AceLibrary("AceLocale-2.2"):new("RaidInfo")
local Tablet = AceLibrary("Tablet-2.0")
local TabletCat = nil
local PC = AceLibrary("PaintChips-2.0")

RaidInfo.hasIcon = RaidInfo.tTitleIcon
RaidInfo.hideMenuTitle = true
RaidInfo.tooltipHiddenWhenEmpty = true
RaidInfo.clickableTooltip = true
RaidInfo.cannotDetachTooltip = true
RaidInfo.independentProfile = true
RaidInfo.hideWithoutStandby = true

function RaidInfo:FuInitialize()
	self.OnMenuRequest = self.options
end

function RaidInfo:FuOnDataUpdate(...)
	--
end

function RaidInfo:ToggleUpdateTooltip()
	if (self.db.profile.updatetooltip) then
		self:ScheduleRepeatingEvent("FuTooltip", function() self:UpdateTooltip() end, 1, self)
	else
		self:CancelScheduledEvent("FuTooltip")
	end
end

function RaidInfo:OnTextUpdate(...)
	local fuText = self:FuName()
	
	self:SetText(fuText)
end

function RaidInfo:OnTooltipUpdate(...)
	Tablet:SetTitle(self:FuName())
	Tablet:SetTitleColor(163/255, 53/255, 238/255) -- Epic for the right feeling
	
	if (self:CurrentGroupType()) then
		self:NewTabletCategory('columns', 3)
	  self:TabletSetColorJustifyCheck("ItemQuality6", nil, nil)
		self:NewTabletLine(
			  L["TabletCatName"]
			, L["TabletCatSpell"]
			, L["TabletCatCD"]
		)
		
	  local addedSomething = false
	  for groupIndex = 1, self:GetNumGroupMembers() do
		  local name, rank, subgroup, level, class, fileName, zone, online, isDead = self:GetGroupRosterInfo(groupIndex)
		  self:TabletSetColorJustifyCheck(fileName, nil, nil)
		  
		  if (self.knowledgeBase[name]) then
		  	for spellName, spellInfo in pairs(self.knowledgeBase[name]) do
		  		local timeToRun = spellInfo["Done"] - GetTime()
		  		local barName = self:BarName(name, spellName)
		  		local _, _, _, running = self:CandyBarStatus(barName)
		  		
				  self:NewTabletLine(
						  name
						, spellName
						, self:GetFormattedTime(timeToRun)
						, function() self:FuRowClick(name, spellName) end
						, running
					)
					addedSomething = true
				end
			end
		end
		
		if (addedSomething) then self:TabletExtraHint(L["FuHintClick"]) end
  else
  	self:TabletSetColorJustifyCheck("ItemQuality6", "CENTER", nil)
  	self:NewTabletCategory('columns', 1)
	  self:NewTabletLine(L["Not grouped"])
  end
end

function RaidInfo:OnClick(...)
	
end

function RaidInfo:OnDoubleClick(...) -- "button"
	--
end

function RaidInfo:OnMouseDown(...) -- "button"
	--
end

function RaidInfo:OnReceiveDrag(...)
	--
end

function RaidInfo:FuRowClick(clickName, spellName)
	self:ToggleVisibility(clickName, spellName)
	self:Update()
end

function RaidInfo:TabletSetColorJustifyCheck(pcColor, justify, hasCheck)
	if (not self.tabletOptions) then self.tabletOptions = { } end
	if (type(pcColor) == "string") then self.tabletOptions.pcColor = pcColor end
	if (type(justify) == "string") then self.tabletOptions.justify = justify end
	if (type(hasCheck) == "boolean") then self.tabletOptions.hasCheck = hasCheck end
end

function RaidInfo:NewTabletCategory(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	local args = {}
	tinsert(args, arg1)
	tinsert(args, arg2)
	tinsert(args, arg3)
	tinsert(args, arg4)
	tinsert(args, arg5)
	tinsert(args, arg6)
	tinsert(args, arg7)
	tinsert(args, arg8)
	tinsert(args, arg9)
	
	local info = { }
	for _, locArg in pairs(args) do
		if (type(locArg) == "number") then
			info["columns"] = locArg
		elseif (type(locArg) == "boolean") then
			info["hideBlankLine"] = locArg
		end
	end
	
	return info
end

function RaidInfo:NewTabletCategory(...)
	TabletCat = Tablet:AddCategory(...)
end

function RaidInfo:NewTabletLine(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if (not self.tabletOptions) then self.tabletOptions = { } end
	
	local args = {}
	tinsert(args, arg1)
	tinsert(args, arg2)
	tinsert(args, arg3)
	tinsert(args, arg4)
	tinsert(args, arg5)
	tinsert(args, arg6)
	tinsert(args, arg7)
	tinsert(args, arg8)
	tinsert(args, arg9)
	
	local info = { }
	local txtCounter = 1
	local _, textR, textG, textB = PC:GetRGBPercent(self.tabletOptions.pcColor)
	
	for _, locArg in pairs(args) do
		if (type(locArg) == "function") then
			info["func"] = locArg
		elseif (type(locArg) == "boolean") then
			info["isRadio"] = locArg
			info["checked"] = locArg
		else
			local textString = "text"..txtCounter
			local justifyString = "justify"..txtCounter
			local textRString = "text"..txtCounter.."R"
			local textGString = "text"..txtCounter.."G"
			local textBString = "text"..txtCounter.."B"
			
			if (txtCounter == 1) then
				textString = "text"
				justifyString = "justify"
				textRString = "textR"
				textGString = "textG"
				textBString = "textB"
			end
			
			info[textString] = locArg
			info[justifyString] = self.tabletOptions.justify
			info[textRString] = textR
			info[textGString] = textG
			info[textBString] = textB
			
			txtCounter = txtCounter + 1
		end
	end
	info["hasCheck"] = self.tabletOptions.hasCheck

	TabletCat:AddLine(info)
end

function RaidInfo:TabletExtraHint(hint, func)
	self:TabletSetColorJustifyCheck("green", "LEFT", nil)
	self:NewTabletCategory('columns', 1, 'hideBlankLine', true)
	self:NewTabletLine("Hint: "..hint, func)
end

function RaidInfo:TabletExtraHeadline(headline, func)
	self:TabletSetColorJustifyCheck("ItemQuality6", "CENTER", nil)
	self:NewTabletCategory('columns', 1)
	self:NewTabletLine(headline, func)
end