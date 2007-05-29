T_ItemInfo = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceHook-2.1", "AceEvent-2.0", "AceDB-2.0")
local L = AceLibrary("AceLocale-2.2"):new("T_ItemInfo")

T_ItemInfo.ColorR = (230 / 255)
T_ItemInfo.ColorG = (204 / 255)
T_ItemInfo.ColorB = (128 / 255)

function T_ItemInfo:OnInitialize()
  self:SecureHook(GameTooltip, "SetBagItem", function(this, bag, slot)
			T_ItemInfo:EditTooltip(GameTooltip, GetContainerItemLink(bag, slot))
    end
  )

  self:SecureHook(GameTooltip, "SetLootItem", function(this, slot)
			T_ItemInfo:EditTooltip(GameTooltip, GetLootSlotLink(slot))
    end
  )

  self:SecureHook(GameTooltip, "SetQuestItem", function(this, unit, slot)
			T_ItemInfo:EditTooltip(GameTooltip, GetQuestItemLink(unit, slot))
    end
  )

  self:SecureHook(GameTooltip, "SetQuestLogItem", function(this, sOpt, slot)
			T_ItemInfo:EditTooltip(GameTooltip, GetQuestLogItemLink(sOpt, slot))
    end
  )

  self:SecureHook(GameTooltip, "SetTradeSkillItem", function(this, skill, slot)
			local link = (slot) and GetTradeSkillReagentItemLink(skill, slot) or GetTradeSkillItemLink(skill)
			T_ItemInfo:EditTooltip(GameTooltip, link)
    end
  )

  self:SecureHook(GameTooltip, "SetMerchantItem", function(this, slot)
			T_ItemInfo:EditTooltip(GameTooltip, GetMerchantItemLink(slot))
    end
  )

  self:SecureHook(GameTooltip, "SetAuctionItem", function(this, unit, slot)
			T_ItemInfo:EditTooltip(GameTooltip, GetAuctionItemLink(unit, slot))
    end
  )

  self:SecureHook(GameTooltip, "SetLootRollItem", function(this, id)
			T_ItemInfo:EditTooltip(GameTooltip, GetLootRollItemLink(id))
    end
  )

  self:SecureHook(GameTooltip, "SetInventoryItem", function(this, unit, slot)
			T_ItemInfo:EditTooltip(GameTooltip, GetInventoryItemLink(unit, slot))
    end
  )

  self:SecureHook("SetItemRef", function(link, name, button)
			if(link and name and ItemRefTooltip) then 
        T_ItemInfo:EditTooltip(ItemRefTooltip, link)
      end
    end
  )
  
  --[[
  if (EQCompare) then
	  EQCompareTooltip1
	  EQCompareTooltip2
  end
  ]]
  
  --[[ Register a DB for saving ]]
	self:RegisterDB("T_ItemInfoDB")
	self:RegisterDefaults('char', {
		stackInfo = true,
		itemID = true,
		preLoaded = true,
		itemLevel = true,
	})
	self.opts = {
	  type = "group",
	  args = {
	  	header = {
				type = "header",
				name = L["addonname"],
				icon = "Interface\\Icons\\INV_Box_02",
				iconHeight = 16,
				iconWidth = 16,
				order = 1
			},
			headerspacer = {
				type = "header",
				order = 2
			},
	  	stackInfo = {
	      type = "toggle",
	      name = L["stackInfo"],
	      desc = L["stackInfo_desc"],
	      get = function()
	        return self.db.char.stackInfo
	      end,
	      set = function()
	        self.db.char.stackInfo = not self.db.char.stackInfo
	      end,
	      order = 3,
	    },
	    itemID = {
	      type = "toggle",
	      name = L["itemID"],
	      desc = L["itemID_desc"],
	      get = function()
	        return self.db.char.itemID
	      end,
	      set = function()
	        self.db.char.itemID = not self.db.char.itemID
	      end,
	      order = 3,
	    },
	    itemLevel = {
	      type = "toggle",
	      name = L["itemLevel"],
	      desc = L["itemLevel_desc"],
	      get = function()
	        return self.db.char.itemLevel
	      end,
	      set = function()
	        self.db.char.itemLevel = not self.db.char.itemLevel
	      end,
	      order = 4,
	    },
	    preLoaded = {
	      type = "toggle",
	      name = L["preLoaded"],
	      desc = L["preLoaded_desc"],
	      get = function()
	        return self.db.char.preLoaded
	      end,
	      set = function()
	        self.db.char.preLoaded = not self.db.char.preLoaded
	      end,
	      order = 5,
	    },
	  },
	}
	self:RegisterChatCommand(L["consolecommands"], self.opts)
  
  self:Print(L["translator"])
end

function T_ItemInfo:OnEnable()
	--
end

function T_ItemInfo:OnDisable()
	--
end

function T_ItemInfo:EditTooltip(frame, link)
	local itemID = self:ExtractItemID(link)
	if (itemID) then
		local localeID = GetLocale()
		local itemName, _, _, itemLevel, _, _, _, itemStackCount = GetItemInfo(itemID) -- itemName, itemString, itemQuality, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture
		local addSpacer = true
		if ((self.Info[localeID]) and (self.db.char.preLoaded)) then
			if (tonumber(itemID)) then
				itemID = tonumber(itemID)
				if (self.Info[localeID][itemID]) then
					if (self.Info[localeID][itemID]["ItemName"] == itemName) then
						local _, playerclass = UnitClass("player")
						
						if (self.Info[localeID][itemID][playerclass]) then
							if (addSpacer) then frame:AddLine(" ") addSpacer = false end
							if (type(self.Info[localeID][itemID][playerclass]) ~= "table") then
								--[[ Not a table *phew* ]]
								frame:AddLine("|cffffcc7f"..self.Info[localeID][itemID][playerclass].."|r", self.ColorR, self.ColorG, self.ColorB)
							else
								--[[ Zomg, a table ]]
								local itemLine = 1
								while (self.Info[localeID][itemID][playerclass][itemLine]) do
									frame:AddLine("|cffffcc7f"..self.Info[localeID][itemID][playerclass][itemLine].."|r", self.ColorR, self.ColorG, self.ColorB)
									itemLine = itemLine + 1
									if (not self.Info[localeID][itemID][playerclass][itemLine]) then break end
								end
							end
						end
						
						--[[ Eko, Crystals, Librams, etc ]]
						if (self.Info[localeID][itemID]["ItemInfo"]) then
							if (addSpacer) then frame:AddLine(" ") addSpacer = false end
							frame:AddLine("|cffffcc7f"..self.Info[localeID][itemID]["ItemInfo"].."|r", self.ColorR, self.ColorG, self.ColorB)
						end
					end
				end
			end
		end
		
		if ((tonumber(itemStackCount)) and (self.db.char.stackInfo)) then
			if (tonumber(itemStackCount) > 1) then
				if (addSpacer) then frame:AddLine(" ") addSpacer = false end
				frame:AddLine("Stacks in lots of "..itemStackCount, self.ColorR, self.ColorG, self.ColorB)
			end
		end
		
		if (self.db.char.itemID) then
			if (addSpacer) then frame:AddLine(" ") addSpacer = false end
			frame:AddLine("ID: "..itemID, self.ColorR, self.ColorG, self.ColorB)
		end
		
		if (self.db.char.itemLevel and itemLevel) then
			if (addSpacer) then frame:AddLine(" ") addSpacer = false end
			frame:AddLine("ItemLevel: "..itemLevel, self.ColorR, self.ColorG, self.ColorB)
		end
		
		frame:Show()
	end
end

function T_ItemInfo:ExtractItemID(linkstring)
	if linkstring ~= nil then
		local _, _, itemID = string.find(linkstring,"-*:(%d+):.*")
		return itemID
	end
end

--[[
function T_ItemInfo:FactionInfo()
	for factionIndex = 1, GetNumFactions() do
  name, description, standingId, bottomValue, topValue, earnedValue, atWarWith,
    canToggleAtWar, isHeader, isCollapsed, isWatched = GetFactionInfo(factionIndex)
  if isHeader == nil then
  	local standingName = getglobal("FACTION_STANDING_LABEL"..standingId)
  	DEFAULT_CHAT_FRAME:AddMessage("Faction: " .. name .. " - " .. standingName,0,0.86,0.73 )
  end
  
  -- /script message("HEJSAN\n\n\\o/ Tristan")
  end

end
]]