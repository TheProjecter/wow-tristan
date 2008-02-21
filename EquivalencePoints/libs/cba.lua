local ident, current, version = nil, nil, nil;
local _G = getfenv(0);

-- Global print function!
ident, current = "GLOBAL_PRINT_FUNCTION!", 1;
version = _G[ident];
if (not version or version < current) then
	_G[ident] = current;
	local header_color = "7fffd4"; -- "33ff99"
		
	local function output(header, msg)
		header = tostring(header);
		msg = tostring(msg);
		
		if (string.sub(string.lower(header), 1, 4) == "|cff" and (string.sub(string.lower(header), -3) == "|r:" or string.sub(string.lower(header), -3) == ":|r")) then -- Allready colorized
			DEFAULT_CHAT_FRAME:AddMessage(header .." "..msg, 1, 1, 1, nil, 5);
		else -- Default color
			if (string.sub(header, -1) == ":") then -- Scale away the semi-colon if it exists
				header = string.sub(header, 1, -2);
			end
			DEFAULT_CHAT_FRAME:AddMessage("|cff".. header_color .. header .."|r: "..msg, 1, 1, 1, nil, 5);
		end
	end
	
	local function arg_as_string(arg, ...)
		if select("#", ...) > 0 then
			return tostring(arg), arg_as_string(...);
		else
			return tostring(arg);
		end
	end
	
	local function print_args_sorted(header, msg, ...)
		msg = tostring(msg);
		
		if msg:find("%%") and select('#', ...) >= 1 then
			local success, text = pcall(string.format, arg_as_string(msg, ...));
			
			if success then
				msg = text;
			end
		elseif (select("#", ...) > 0) then
			local success, text = pcall(string.join, " ", arg_as_string(msg, ...));
			
			if success then
				msg = text;
			end
		end
		
		output(header, msg);
	end
	
	-- Create a global print function
	_G["print"] = function (msg, ...)
		msg = tostring(msg);
		
		if (string.sub(msg, -1) == ":" or string.sub(string.lower(msg), -3) == ":|r") then
			print_args_sorted(msg, ...)
		else
			print_args_sorted("Output", msg, ...)
		end
	end
end -- print("AddOn:", "Hi mate!");, I like having a print() function as I can easily test my stuff in a lua workbench this way :)
-- I'd like this function to be able to take a frame and colors etc aswell but cba working on it more atm, for now it's enough!

-- Returns 1 if version a is outdated, 2 if version b is outdated and 0 if equal Credz to ClosetGnome
_G["VersionCompare"] = function(a, b)
  if type(a) == "string" then a = a:trim() end
  if type(b) == "string" then b = b:trim() end
  if a == b then
    return 0
  elseif tonumber(a) and tonumber(b) then
    if tonumber(a) == tonumber(b) then
      return 0
    else
      return tonumber(b) > tonumber(a) and 1 or 2
    end
  else
    a = tostring(a):trim()
    b = tostring(b):trim()
    local numA = a:gsub("%D", "")
    local numB = b:gsub("%D", "")
    numA = tonumber(numA)
    numB = tonumber(numB)
    if type(numA) == "number" and type(numB) == "number" then
      if numA == numB then
        return 0
      else
        return numB > numA and 1 or 2
      end
    else
      if numB and not numA then
        return 1
      else
        return 2
      end
    end
  end
end -- VersionCompare("2.2", "2.1"); == 2

ident, current = "GLOBAL_ROUND_FUNCTION!", 1;
version = _G[ident];
if (not version or version < current) then
	_G[ident] = current;
	
	_G["math"]["round"] = function (number, decimals)
	  local multiplier = (10^(decimals or 0));
	  return math.floor(number * multiplier + 0.5) / multiplier;
	end
end -- math.round(number, decimals);

if (not _G["convert"]) then _G["convert"] = {}; end -- table for convert functions
ident, current = "GLOBAL_RGB2HEX_FUNCTION!", 1;
version = _G[ident];
if (not version or version < current) then
	_G[ident] = current;
	
	local multiplier = 1; -- 255 based values 255, 225, 124
	if (r and r <= 1 and g and g <= 1 and b and b <= 1) then
		-- Assume decimal version (ie 1.0, 0.5, 0.2)
		multiplier = 255;
	end
	
	-- Converts 255, 225, 124 into a hex string
	_G["convert"]["rgb2hex"] = function(r, g, b)
		return string.format("%.2x%.2x%.2x", (r * multiplier), (g * multiplier), (b * multiplier));
	end
end -- convert.rgb2hex(r, g, b);

ident, current = "GLOBAL_TABLESAFECOUNT_FUNCTION!", 1;
version = _G[ident];
if (not version or version < current) then
	_G[ident] = current;
	
	-- Counts all elements in a table using pairs and not ipairs to surely get the "real" count
	_G["table"]["safecount"] = function(tbl)
		local num = 0;
		
		for _, _ in pairs(tbl or {}) do
			num = num + 1;
		end
		
		return num;
	end
end -- local items = table.safecount(tbl);

-- Creds to Mikk, http://www.wowwiki.com/Tcount
ident, current = "GLOBAL_TABLECOPY_FUNCTION!", 1;
version = _G[ident];
if (not version or version < current) then
	_G[ident] = current;
	
	-- Copies a table entirely except functions
	_G["table"]["copy"] = function(from, to)
		to = to or {};
		
		for key, value in pairs(from) do
			if (type(value) == "table") then
				to[key] = table.copy(value);
			else
				to[key] = value;
			end
		end
		
		setmetatable(to, getmetatable(from))
		return to;
	end
end -- local newTable = table.copy(aTbl); or table.copy(originalTbl, destinationTbl);