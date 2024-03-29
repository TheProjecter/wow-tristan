--[[ $Id: AceConsole-3.0.lua 56939 2007-12-13 20:03:55Z nevcairiel $ ]]
local MAJOR,MINOR = "AceConsole-3.0", 0

local AceConsole, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not AceConsole then return end -- No upgrade needed

AceConsole.embeds = AceConsole.embeds or {} -- table containing objects AceConsole is embedded in.
AceConsole.commands = AceConsole.commands or {} -- table containing commands registered
AceConsole.weakcommands = AceConsole.weakcommands or {} -- table containing self, command => func references for weak commands that don't persist through enable/disable

-- AceConsole:Print( [chatframe,] ... )
--
-- Print to DEFAULT_CHAT_FRAME or given chatframe (anything with an .AddMessage member)
function AceConsole:Print(...)
	local text = ""
	if self ~= AceConsole then
		text = tostring( self )..": "
	end

	local frame = select(1, ...)
	if not ( type(frame) == "table" and frame.AddMessage ) then	-- Is first argument something with an .AddMessage member?
		frame=nil
	end
	
	for i=(frame and 2 or 1), select("#", ...) do
		text = text .. tostring( select( i, ...) ) .." "
	end
	(frame or DEFAULT_CHAT_FRAME):AddMessage( text )
end


-- AceConsole:RegisterChatCommand(. command, func, persist )
--
-- command (string) - chat command to be registered WITHOUT leading "/"
-- func (function|membername) - function to call, or self[membername](self, ...) call
-- persist (boolean) - false: the command will be soft disabled/enabled when aceconsole is used as a mixin (default: true)
-- silent (boolean) - don't whine if command already exists, silently fail
--
-- Register a simple chat command
function AceConsole:RegisterChatCommand( command, func, persist, silent )
	if type(command)~="string" then error([[Usage: AceConsole:RegisterChatCommand( "command", func[, persist[, silent] ]): 'command' - expected a string]], 2) end
	
	if persist==nil then persist=true end	-- I'd rather have my addon's "/addon enable" around if the author screws up. Having some extra slash regged when it shouldnt be isn't as destructive. True is a better default. /Mikk
	
	local name = "ACECONSOLE_"..command:upper()
	if SlashCmdList[name] then
		if not silent then
			geterrorhandler()(tostring(self)..": Chat Command '"..command.."' already exists, will not overwrite.")
		end
		return
	end
	if type( func ) == "string" then
		SlashCmdList[name] = function(input)
			self[func](self, input)
		end
	else
		SlashCmdList[name] = func
	end
	_G["SLASH_"..name.."1"] = "/"..command:lower()
	AceConsole.commands[command] = name
	-- non-persisting commands are registered for enabling disabling
	if not persist then
		AceConsole.weakcommands[self][command] = func
	end
end


-- AceConsole:UnregisterChatCommand( command )
-- 
-- Unregister a chatcommand
function AceConsole:UnregisterChatCommand( command )
	local name = AceConsole.commands[command]
	if name then
		SlashCmdList[name] = nil
		setglobal("SLASH_"..name.."1", nil)
		hash_SlashCmdList["/" .. command:upper()] = nil
		AceConsole.commands[command] = nil
	end
end


local function nils(n, ...)
	if n>1 then
		return nil, nils(n-1, ...)
	elseif n==1 then
		return nil, ...
	else
		return ...
	end
end
	

-- AceConsole:GetArgs(string, numargs, startpos)
--
-- Retreive one or more space-separated arguments from a string. 
-- Treats quoted strings and itemlinks as non-spaced.
--
--   string   - The raw argument string
--   numargs  - How many arguments to get (default 1)
--   startpos - Where in the string to start scanning (default  1)
--
-- Returns arg1, arg2, ..., nextposition
-- Missing arguments will be returned as nils. 'nextposition' is returned as 1e9 at the end of the string.

function AceConsole:GetArgs(str, numargs, startpos)
	numargs = numargs or 1
	startpos = max(startpos or 1, 1)
	
	local pos=startpos

	-- find start of new arg
	pos = strfind(str, "[^ ]", pos)
	if not pos then	-- whoops, end of string
		return nils(numargs, 1e9)
	end

	if numargs<1 then
		return pos
	end

	-- quoted or space separated? find out which pattern to use
	local delim_or_pipe
	local ch = strsub(str, pos, pos)
	if ch=='"' then
		pos = pos + 1
		delim_or_pipe='([|"])'
	elseif ch=="'" then
		pos = pos + 1
		delim_or_pipe="([|'])"
	else
		delim_or_pipe="([| ])"
	end
	
	startpos = pos
	
	while true do
		-- find delimiter or hyperlink
		local ch,_
		pos,_,ch = strfind(str, delim_or_pipe, pos)
		
		if not pos then break end
		
		if ch=="|" then
			-- some kind of escape
			
			if strsub(str,pos,pos+1)=="|H" then
				-- It's a |H....|hhyper link!|h
				pos=strfind(str, "|h", pos+2)	-- first |h
				if not pos then break end
				
				pos=strfind(str, "|h", pos+2)	-- second |h
				if not pos then break end
			end
			
			pos=pos+2 -- skip past this escape (last |h if it was a hyperlink)
		
		else
			-- found delimiter, done with this arg
			return strsub(str, startpos, pos-1), AceConsole:GetArgs(str, numargs-1, pos+1)
		end
		
	end
	
	-- search aborted, we hit end of string. return it all as one argument. (yes, even if it's an unterminated quote or hyperlink)
	return strsub(str, startpos), nils(numargs-1, 1e9)
end


--- embedding and embed handling

local mixins = {
	"Print",
	"RegisterChatCommand", 
	"UnregisterChatCommand",
	"GetArgs",
} 

-- AceConsole:Embed( target )
-- target (object) - target object to embed AceBucket in
--
-- Embeds AceConsole into the target object making the functions from the mixins list available on target:..
function AceConsole:Embed( target )
	for k, v in pairs( mixins ) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	return target
end

function AceConsole:OnEmbedEnable( target )
	if AceConsole.weakcommands[target] then
		for command, func in pairs( AceConsole.weakcommands[target] ) do
			target:RegisterChatCommand( command, func, false, true ) -- nonpersisting and silent registry
		end
	end
end

function AceConsole:OnEmbedDisable( target )
	if AceConsole.weakcommands[target] then
		for command, func in pairs( AceConsole.weakcommands[target] ) do
			target:UnregisterChatCommand( command ) -- TODO: this could potentially unregister a command from another application in case of command conflicts. Do we care?
		end
	end
end

for addon in pairs(AceConsole.embeds) do
	AceConsole:Embed(addon)
end
