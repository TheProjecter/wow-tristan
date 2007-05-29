--[[ *** Localization *** ]]
local L = AceLibrary("AceLocale-2.2"):new("ChatHighlighter")

L:RegisterTranslations("enUS", function() return {
	["AuthorPrefix"] = "Author: ",
	["VersionPrefix"] = "Author: ",
	
	["add_name"] = "Add",
	["add_desc"] = "Add a string (case sensitive)",
	["delete_name"] = "Delete",
	["delete_desc"] = "Delete a string (case sensitive)",
	["list_name"] = "List",
	["list_desc"] = "List all string (watch your chat-frame die ;)",
	["color_name"] = "Color",
	["color_desc"] = "Sets a color to use for highlighting in HexFormat (e6cc80)\ne6cc80 = imba\nff0000 = red\n00ff00 = green\nEmpty set's it back to default",
	["reset_name"] = "Reset",
	["reset_desc"] = "Clears all words from DB and resets color to default!",
	
	["chatcommands"] = { "/ch", "/ChatHighlighter", "/chath" },
	
	["ColorChange"] = "Color has been changed!",
} end)

L:RegisterTranslations("koKR", function() return {
	["AuthorPrefix"] = "제작자: ",
	["VersionPrefix"] = "제작자: ",
	
	["add_name"] = "추가",
	["add_desc"] = "강조하고 싶은 글자를 입력합니다. (대소문자 주의)",
	["delete_name"] = "삭제",
	["delete_desc"] = "삭제하고 싶은 글자를 입력합니다.(대소문자 주의)",
	["list_name"] = "리스트",
	["list_desc"] = "저장한 리스트를 봅니다.",
	["color_name"] = "색깔",
	["color_desc"] = "색깔을 지정합니다.(예: e6cc80, \nff0000 = 빨강\n00ff00 = 녹색)\n(아무것도 입력하지 않으면 기본값으로 저장됩니다.)",
	
	["chatcommands"] = { "/ch", "/ChatHighlighter", "/chath" },
	
	["ColorChange"] = "색깔이 변경되었습니다.",
} end)

--[[ *** Create Ace2 AddOn *** ]]
ChatHighlighter = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceHook-2.1", "AceDB-2.0")

ChatHighlighter.imbaCol = "e6cc80"

ChatHighlighter:RegisterDB("ChatHighlighterDB")
ChatHighlighter:RegisterDefaults('profile', {
	color = ChatHighlighter.imbaCol,
	words = {},
})

--[[ *** Initialize the AddOn *** ]]
function ChatHighlighter:OnInitialize()
	self.options = {
		type = "group",
		args = {
	  	headerName = {
				type = "header",
				name = "|cff"..self.imbaCol.."ChatHighlighter|r |cff7fff7f -Ace2-|r",
				icon = "Interface\\Icons\\INV_Holiday_ToW_SpiceBandage",
				iconHeight = 16,
				iconWidth = 16,
				order = 1,
			},
			headerAuthor = {
				type = "header",
				name = "|cff"..self.imbaCol..L["AuthorPrefix"].."Tristan|r",
				order = 2,
			},
			headerVersion = {
				type = "header",
				name = "|cff"..self.imbaCol..L["VersionPrefix"].."1.0|r",
				order = 3,
			},
			headerspacer = {
				type = "header",
				order = 4,
			},
			add = {
				type = "text",
				name = L["add_name"],
				desc = L["add_desc"],
			  get = function() return "" end,
			  set = function(word)
			  	if ((string.find(word, "%%")) or (string.find(word, "%|"))) then
			  		self:Print("'"..word.."' is not valid, can't use regex nor |!")
			  	else
			  		self:AddWord(word)
			  	end
			  end,
			  usage = "<Any string>",
			  order = 5,
			},
			delete = {
				type = "text",
				name = L["delete_name"],
				desc = L["delete_desc"],
			  get = function() return "" end,
			  set = function(word) self:DeleteWord(word) end,
			  usage = "<Any string>",
			  order = 6,
			},
			list = {
				type = "execute",
				name = L["list_name"],
				desc = L["list_desc"],
			  func = function() self:ListWords() end,
			  order = 7,
			},
			color = {
				type = "text",
				name = L["color_name"],
				desc = L["color_desc"],
			  get = function() return self.db.profile.color end,
			  set = function(color) self:SwapColor(color) end,
			  usage = "<Any string>",
			  order = 8,
			},
			reset = {
				type = "execute",
				name = L["reset_name"],
				desc = L["reset_desc"],
			  func = function()
			  	self.db.profile.words = nil
			  	self.db.profile.words = {}
			  	self:Print("All words wiped!")
			  	self:SwapColor(self.imbaCol)
			  end,
			  order = 9,
			},
		},
	}
	
	self:RegisterChatCommand(L["chatcommands"], self.options)
end

function ChatHighlighter:OnEnable()
	for i=1, NUM_CHAT_WINDOWS do
		self:Hook(getglobal("ChatFrame"..i), "AddMessage", true)
	end
end

function ChatHighlighter:OnDisable()
  self:UnregisterAllEvents()
end

function ChatHighlighter:AddMessage(frame, text, ...)
	-- |cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0|h[Broken Fang]|h|r
	-- |Hplayer:Tristan|h[Tristan]|h
	for word, _ in pairs(self.db.profile.words) do
		text = string.gsub(text.." ","([%!%?%.%,%/%s%(])("..self:gsubSpecial(word)..")([%!%?%.%,%/%s%)%'])", "%1|cff"..self.db.profile.color.."%2|r%3")
		text = strtrim(text)
	end
	
	self.hooks[frame].AddMessage(frame, text, ...)
end

function ChatHighlighter:Colorize(word)
	return "|cff"..self.db.profile.color..word.."|r"
end

function ChatHighlighter:AddWord(word)
	self.db.profile.words[word] = true
end

function ChatHighlighter:DeleteWord(word)
	self.db.profile.words[word] = nil
end

function ChatHighlighter:ListWords()
	for word, _ in pairs(self.db.profile.words) do
		self:Print(word)
	end
end

function ChatHighlighter:SwapColor(color)
	if (color == "") then color = self.imbaCol end
	
	if (not string.find(color, "%x%x%x%x%x%x")) then
		self:Print("Not a valid hex-color: |cff"..self.db.profile.color..color.."|r")
	else
		if (self.db.profile.color ~= color) then
			self:Print("|cff"..color..L["ColorChange"].."|r")
		end
		self.db.profile.color = color
	end
end

function ChatHighlighter:gsubSpecial(expression)
     return string.gsub(expression, '(%a)', 
               function (v) return '['..strupper(v)..strlower(v)..']' end)
end
