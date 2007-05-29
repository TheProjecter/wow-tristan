local L = AceLibrary("AceLocale-2.2"):new("RaidHelper")

--[[ Build Options ]]
function RaidHelper:BuildOptions()
	local DB = self.db.profile
	
	local rVal = {
		type = "group",
	  args = {
	  	headerName = {
				type = "header",
				name = self:NameHeading(),
				icon = self.tTitleIcon,
				iconHeight = 16,
				iconWidth = 16,
				order = 1,
			},
			headerAuthor = {
				type = "header",
				name = "|cff".."e6cc80"..string.gsub(L["AuthorPrefixed"], "{$}", self.author).."|r",
				order = 2,
			}, -- ["AuthorPrefixed"]
			headerVersion = {
				type = "header",
				name = "|cff".."e6cc80"..string.gsub(L["VersionPrefixed"], "{$}", self.version).."|r",
				order = 3,
			},
			headerspacer = {
				type = "header",
				order = 4,
			},
			leadership = {
				type = "toggle",
				name = L["leadership_name"],
				desc = L["leadership_desc"],
			  get = function() return self.db.profile.leadership end,
			  set = function() self.db.profile.leadership = not self.db.profile.leadership end,
				order = 5,
			},
			quietready = {
				type = "toggle",
				name = L["quietready_name"],
				desc = L["quietready_desc"],
			  get = function() return self.db.profile.quietready end,
			  set = function() self.db.profile.quietready = not self.db.profile.quietready end,
				order = 6,
			},
			opassword = {
				type = "text",
				name = L["opassword_name"],
				desc = L["opassword_desc"],
			  get = function() return self.db.char.opassword or "" end,
			  set = function(newPass) if (string.len(self:Trim(newPass)) > 0) then self.db.char.opassword = self:Trim(newPass) else self.db.char.opassword = nil end end,
			  usage = "<Any string>",
				order = 7,
			},--[[
			ipassword = {
				type = "text",
				name = L["ipassword_name"],
				desc = L["ipassword_desc"],
			  get = function() return self.db.char.ipassword or "" end,
			  set = function(newPass) if (string.len(self:Trim(newPass)) > 0) then self.db.char.ipassword = self:Trim(newPass) else self.db.char.ipassword = nil end end,
			  usage = "<Any string>",
				order = 8,
			},]]
			helpspacer = {
				type = "header",
				order = 97,
			},
			help = {
				type = "execute",
				name = L["help_name"],
				desc = L["help_desc"],
			  func = function() self:Shorthands() end,
				order = 98,
			},
			lastupdatespacer = {
				type = "header",
				order = 99,
			},
			headerLastUpdate = {
				type = "header",
				name = "|cff".."e6cc80"..string.gsub(L["LastUpdatePrefixed"], "{$}", self.lastUpdateDate).."|r",
				order = 100,
			},
		},
	}
	
	if (not self.tAuthorInDD) then rVal.args.headerAuthor = nil end
	if (not self.tVersionInDD) then rVal.args.headerVersion = nil end
	
	return rVal
end

function RaidHelper:NameHeading()
	local retVal = ""
	
	local Title = GetAddOnMetadata(self.addonFolder, "Title"); Title = string.gsub(string.gsub(Title, "%|cff7fff7f %-Ace2%-%|r$", ""), "^%s*(.-)%s*$", "%1")
	local Author = GetAddOnMetadata(self.addonFolder, "Author"); if (string.find(string.lower(Author), "s", -1)) then Author = Author.."'" else Author = Author.."'s" end; Author = "|cff".."e6cc80"..Author.."|r"
	local Ace = "|cff7fff7f -Ace2-|r"
	
	if (self.tAuthorInDD) then Author = "" end
	
	retVal = string.gsub(L["NameHeading"], "{Author}", Author)
	retVal = string.gsub(retVal, "{Title}", Title)
	retVal = string.gsub(retVal, "{Ace}", Ace)
	return retVal
end