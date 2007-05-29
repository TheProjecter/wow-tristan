TinyPadFu = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "FuBarPlugin-2.0")
TinyPadFu:RegisterDB("TinyPadFuDB")
TinyPadFu.hasIcon = "Interface\\Icons\\INV_Misc_Note_01"
TinyPadFu.hideMenuTitle = true
-- TinyPadFu.hasNoColor = true
TinyPadFu.tAuthorInDD = true
TinyPadFu.clickableTooltip = true
TinyPadFu:RegisterDefaults('char', {
	noteIconNum = 1,
})

local Tablet = AceLibrary("Tablet-2.0")
local L = AceLibrary("AceLocale-2.2"):new("FuBar_TinyPadFu")

function TinyPadFu:OnInitialize()
	self.iconNums = {
		["1"] = "Icon number 01",
		["2"] = "Icon number 02",
		["3"] = "Icon number 03",
		["4"] = "Icon number 04",
		["5"] = "Icon number 05",
		["6"] = "Icon number 06",
	}
	
	self.OnMenuRequest = {
		type = 'group',
		args = {
			headerName = {
				type = "header",
				name = self:FancyName(),
				icon = self.hasIcon,
				iconHeight = 16,
				iconWidth = 16,
				order = 1,
			},
			headerAuthor = {
				type = "header",
				name = self:SetHexColor("Tristan", self:GoFigure(L["AuthorPrefixed"], self.author)),
				order = 2,
			},
			headerVersion = {
				type = "header",
				name = self:SetHexColor("Tristan", self:GoFigure(L["VersionPrefixed"], self.version)),
				order = 3,
			},
				headerspacer = {
				type = "header",
				order = 4,
			},
			iconNum = {
				type = "text",
			  name = L["Icon"],
				desc = L["Select Icon For FuBar"],
				get = function()
					return self.db.char.noteIconNum or "1"
				end,
				set = "SwapIcon",
				validate = self.iconNums,
	      order = 5,
			},
		},
	}
end

function TinyPadFu:OnEnable()
	self:Print(L["translator"])
	self:SwapIcon(self.db.char.noteIconNum)
end

function TinyPadFu:SwapIcon(arg1)
	local iMax = 0
	for k,v in pairs(TinyPadFu.iconNums) do iMax = iMax + 1 end
	if (tonumber(arg1) < 1) then arg1 = "1" end
	if (tonumber(arg1) > iMax) then arg1 = "1" end
	
	self.db.char.noteIconNum = arg1
	self:SetIcon("Interface\\Icons\\INV_Misc_Note_0"..self.db.char.noteIconNum)
	self.OnMenuRequest.args.headerName.icon = self:GetIcon()
end

function TinyPadFu:OnClick()
	TinyPad:Toggle()
end

function TinyPadFu:OnTextUpdate()
	self:SetText(L["addonnameFu"])
end

function TinyPadFu:OnTooltipUpdate()
	cat = Tablet:AddCategory(
  	'columns', 2
  )
    
  for i=1, getn(TinyPadPages) do
  local TinyPadPageName = self:ShortenPage(TinyPadPages[i])
  TinyPadPageName = self:CheckSpecialTitle(TinyPadPageName)
  
  cat:AddLine(
    'text', (string.gsub(L["TabletPageNum"], "{i}", i)),
    'text2', TinyPadPageName,
    'func', "OnPageClick",
		'arg1', self,
		'arg2', i,
		'arg3', "TinyPad"
  )
  end
    
  Tablet:SetHint(L["FuBarHint"])
  Tablet:SetTitle(L["TinyPad Pages"]) 
end

function TinyPadFu:CheckSpecialTitle(title)
	local _, _, newTitle = string.find(title, "%-%-%[%[(.*)%]%]")
	if (newTitle) then
		return (string.gsub(L["Script"], "{t}", self:Trim(newTitle)))
	else
		return title
	end
end

function TinyPadFu:ShortenPage(page)
	if (not page) then
		return L["<Empty>"]
	else
		page = string.gsub(page, "\r", "")
		page = self:Trim(page)
		if (strlen(page) == 0) then
			return L["<Empty>"]
		elseif (string.find(page, "\n")) then
			return self:Partial(self:strSplit("\n", page)[1])
		else
			return self:Partial(page)
		end
	end
end

function TinyPadFu:Trim(s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function TinyPadFu:Partial(s)
	if (strlen(s) > 33) then
		return string.sub(s, 1 , 30).."..."
	else
		return s
	end
end

function TinyPadFu:strSplit(delimiter, text)
  local list = {}
  local pos = 1
  if strfind("", delimiter, 1) then -- this would result in endless loops
    error(L["SplitError"])
  end
  while 1 do
    local first, last = strfind(text, delimiter, pos)
    if first then -- found?
      tinsert(list, strsub(text, pos, first-1))
      pos = last+1
    else
      tinsert(list, strsub(text, pos))
      break
    end
  end
  return list
end

function TinyPadFu:OnPageClick(pagenum, type)
	if (type == "TinyPad") then
		if TinyPadPages[pagenum] then
			if (IsAltKeyDown()) then -- Delete
				local bHide = true
				if TinyPadFrame:IsVisible() then
					bHide = false
				end
				TinyPad.current_page = pagenum
				TinyPad.DeletePage()
				if (bHide) then TinyPadFrame:Hide() end
			elseif (IsShiftKeyDown()) then -- Run
				RunScript(TinyPadPages[pagenum])
			else -- Edit
				TinyPad.first_use = nil
				TinyPad.current_page = pagenum
				TinyPad.ShowPage()
			end
		else
			self:Print((string.gsub(L["TinyPadError"], "{i}", pagenum)))
		end
	elseif (type == "ReloadUI") then
		ReloadUI()
	end
end

function TinyPadFu:Trim(expression)
	return string.gsub(expression, "^%s*(.-)%s*$", "%1")
end

function TinyPadFu:FancyName()
	-- ["fancyname"] = "{author} {addon} {ace}",
	local Title = GetAddOnMetadata("FuBar_TinyPadFu", "Title")
	local Author = self:SetHexColor("Tristan", self:AuthorOwner())
	local Ace = "|cff7fff7f -Ace2-|r"
	Title = self:Trim(string.gsub(Title, "^FuBar %- ", ""))
	Title = self:Trim(string.gsub(Title, "%|cff7fff7f %-Ace2%-%|r$", ""))
	Title = self:SetHexColor("Tristan", self:StripColors(Title))
	
	if (self.tAuthorInDD) then Author = "" end
	
	return self:Trim(self:GoFigure(L["fancyname"], { ["Author"] = Author, ["Title"] = Title, ["Ace"] = Ace}))
end

function TinyPadFu:GoFigure(expression, insert)
	if (type(insert) == "table") then
		for key, value in pairs(insert) do
			expression = ( gsub(expression, "{"..key.."}", value) )
		end
		return expression
	else
		return ( gsub(expression, "{$}", insert) )
	end
end

function TinyPadFu:StripColors(expression)
	expression = string.gsub(expression, "%|c%x%x%x%x%x%x%x%x", "")
	expression = string.gsub(expression, "%|r", "")
	return expression
end

function TinyPadFu:SetHexColor(color, expression)
	if (not string.find(color, "%x%x%x%x%x%x")) then
		return "|cffe6cc80"..expression.."|r"
	else
		return "|cff"..color..expression.."|r"
	end
end

function TinyPadFu:AuthorOwner()
	return self:DoOwnage(GetAddOnMetadata("FuBar_TinyPadFu", "Author"))
end

function TinyPadFu:DoOwnage(expression)
	local rVal = expression
	if (string.find(string.lower(self.author), "s", -1)) then rVal = rVal.."'" else rVal = rVal.."'s" end
	return rVal
end