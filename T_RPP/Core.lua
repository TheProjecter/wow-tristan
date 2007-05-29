T_RPP = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceHook-2.1", "AceEvent-2.0", "AceDB-2.0")
local L = AceLibrary("AceLocale-2.2"):new("T_RPP")

T_RPP:RegisterDB("T_RPPDB")
T_RPP:RegisterDefaults("profile", {
	titleRPP = true
})
T_RPP:RegisterDefaults('char', {
	Items = { }
})

function T_RPP:OnInitialize()
  self.opts = {
	  type = "group",
	  args = {
	    tooltips = {
	      type = "toggle",
	      name = L["Title RPP"],
	      desc = L["Toggles the display of RPP Values in title(/end of tooltip)"],
	      get = function()
	        return self.db.profile.titleRPP
	      end,
	      set = function()
	        self.db.profile.titleRPP = not self.db.profile.titleRPP
	      end
	    },
	    update = {
				name = L["Update"],
				type = "text",
			  desc = L["Update value for an item (Usage: /trpp update [Item Link] #)"],
				get = false,
			  set = function(text) self:UpdateItem(text) end,
				usage = L["[Item Link] <value>"],
				guiHidden = true
			},
			purge = {
				name = L["Purge"],
				type = "execute",
			  desc = L["Clear collected data (joining a new guild?)"],
			  func = function() self.db.char.Items = { } self:Print(L["Database has been purged!"]) end,
			},
	  },
  }
  self:RegisterChatCommand({"/trpp"}, self.opts)
  self.crayon = AceLibrary("Crayon-2.0")
  self.plugins = { }
  
	self:SecureHook(GameTooltip, "SetBagItem", function(this, bag, slot)
			T_RPP:EditTooltip(GameTooltip, GetContainerItemLink(bag, slot))
    end
  )

  self:SecureHook(GameTooltip, "SetLootItem", function(this, slot)
			T_RPP:EditTooltip(GameTooltip, GetLootSlotLink(slot))
    end
  )

  self:SecureHook(GameTooltip, "SetQuestItem", function(this, unit, slot)
			T_RPP:EditTooltip(GameTooltip, GetQuestItemLink(unit, slot))
    end
  )

  self:SecureHook(GameTooltip, "SetQuestLogItem", function(this, sOpt, slot)
			T_RPP:EditTooltip(GameTooltip, GetQuestLogItemLink(sOpt, slot))
    end
  )

  self:SecureHook(GameTooltip, "SetTradeSkillItem", function(this, skill, slot)
			local link = (slot) and GetTradeSkillReagentItemLink(skill, slot) or GetTradeSkillItemLink(skill)
			T_RPP:EditTooltip(GameTooltip, link)
    end
  )

  self:SecureHook(GameTooltip, "SetMerchantItem", function(this, slot)
			T_RPP:EditTooltip(GameTooltip, GetMerchantItemLink(slot))
    end
  )

  self:SecureHook(GameTooltip, "SetAuctionItem", function(this, unit, slot)
			T_RPP:EditTooltip(GameTooltip, GetAuctionItemLink(unit, slot))
    end
  )

  self:SecureHook(GameTooltip, "SetLootRollItem", function(this, id)
			T_RPP:EditTooltip(GameTooltip, GetLootRollItemLink(id))
    end
  )

  self:SecureHook(GameTooltip, "SetInventoryItem", function(this, unit, slot)
			T_RPP:EditTooltip(GameTooltip, GetInventoryItemLink(unit, slot))
    end
  )

  self:SecureHook("SetItemRef", function(link, name, button)
			if(link and name and ItemRefTooltip) then 
        T_RPP:EditTooltip(ItemRefTooltip, link)
      end
    end
  )
  
  self:Print(L["translator"])
end

function T_RPP:OnEnable()
  --
end

function T_RPP:OnDisable()
	--
end

function T_RPP:EditTooltip(frame, link)
	--local _, _, id = string.find(link or "", "item:(%d+):%d+:%d+:%d+")
	--id = id and tonumber(id)
	local itemID = self:ExtractItemID(link)
	
	if (tonumber(self.db.char.Items[itemID])) then
		if (self.db.profile.titleRPP) then
			frame:AppendText(" ["..self.crayon:Green(tonumber(self.db.char.Items[itemID])).."]")
		else
			frame:AddLine(L["* RPP/DKP: "]..self.crayon:Green(tonumber(self.db.char.Items[itemID])))
		end
		frame:Show()
	end
end

function T_RPP:UpdateItem(msg)
	local _, _, link, num = string.find(msg, "(.+)%s(%d+)")
	local itemID = self:ExtractItemID(link)
	
	num = tonumber(num)
	if ((itemID) and (num)) then
		self.db.char.Items[itemID] = num
		self:Print(string.format(L["Added Item: %s - Value:%d"], link, num))
	end
end

function T_RPP:ExtractItemID(linkstring)
	if linkstring ~= nil then
		local _, _, itemID = string.find(linkstring,"-*:(%d+):.*")
		return itemID
	end
end

function T_RPP:ModuleMsg(msg)
	self:print(msg)
end