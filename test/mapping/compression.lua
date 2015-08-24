
--Get digits in a number
local function getDigits(number)

	local digits = 1;
   -- if (number < 0) digits = 1; -- remove this line if '-' counts as a digit
    while (number>=10) do
        number = number / 10;
        digits = digits + 1;
    end
    return digits;
end

--Map compression modes
local compressmodes = {
	"x",
	"y",
	"z",
	"mode"
}

local max = 5

local chars = {
	"!","@","#","$","%","^","&","*","(",")","_","+","a","b","c","d","e","f","g","h",
	"i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A",
	"B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S",
	"T","U","V","W","X","Y","Z","<",">","?","/",":",";","'","{","}","|","=","Ï"}--]]
	
--local chars = {"Ï","a","b"}

--String Compression


--Compress string by a power of p... the higher the power, the more likeliness of a lag spike
function compressString(str,p)

	math.randomseed(os.time())

	p = p or 1
	--print(#str)
	local compressed = {str = str, key = {}}
	local new = ""


	local new = ""
	--print(times)
	
	local checks = {}
		
	local usedchars = {}
	for v,i in ipairs(chars) do
		table.insert(usedchars,i)
	end
	
	for f = 1, p do
	
		local add = ""
		local times = math.ceil(#str/f)
		local at = 1
		local left = #str
		--print("left",left)
		local used = 0
		local skip = 0
	
		local key = {}
		local new = ""
		local on = 1
		local mult = 0
		for i = 1, times do
			local e
			if left>f then
				e = f%left
			else	
				e = left
			end
			used = used + e
			left = left - e + 1	
			
			local test = str:sub(at,at+e-1)
			
			local found = false
			--print(node[get])
			for v,i in pairs(key) do
				if i==test then
					new = new .. v
					found=true
				end
			end
			if not found then
			
				if #usedchars==0 then
					new = new .. "`"
					mult = mult + 1
					on = 1
					for v,i in ipairs(chars) do
						table.insert(usedchars,i)
					end
				end
				
				local r = math.random(1,#usedchars)
				
				local char = usedchars[r]
				--print(r, char)
				table.remove(usedchars,r)
				
				if mult > 0 then
					char = char .. mult
				end	
				
				key[char] = test
				new = new .. char
				on = on + 1
			end	
			
			at = at + e 
		end
		
		table.insert(checks,{key=key,str=new})
	
	end
	
	--Get the best keys for the job
	local newkey = {}
	local skip = 0----                                 abb abb
	local reb = ""
	
	usedchars = {}
	for v,i in ipairs(chars) do
		table.insert(usedchars,i)
	end
	
	for i = 1, #str do
		if skip>0 then
			skip = skip-1
			--continue
		else
			local add = ""
			local max = 0
			for k,l in pairs(checks) do
				for g,d in pairs(l.key) do
					local t = str:sub(i,i+#d-1)
					if t==d and #t>max then
						max = #t
						add = t
					end
				end
			end
			reb = reb .. add
			skip = skip + max - 1
			if add~="" then
				table.insert(newkey, add)
			end
		end
	
	
	end
	
	local key = {}
	
	local on = 1
	local mult = 0
	local new = ""
	
	for i = 1, #newkey do
			
		local test = newkey[i]
			
		local found = false
		for v,i in pairs(key) do
			if i==test then
				new = new .. v
				found=true
			end
		end
		if not found then
			
			if #usedchars==0 then
				new = new .. "`"
				mult = mult + 1
				on = 1
				for v,i in ipairs(chars) do
					table.insert(usedchars,i)
				end
			end
			
			
			local r = math.random(1,#usedchars)
				
			local char = usedchars[r]
			--print(char)
			table.remove(usedchars,r)
				
			if mult > 0 then
				char = char .. mult
			end	
				
			key[char] = test
			new = new .. char
			on = on + 1
		end	
	end
	
	local send = {key=key,str=new}
	
	return send

end


--Decompress string table made by "compressString"
function decompressString(tab)
	local new = ""
	local key = tab.key
	local e = tab.str
	local mult = 0
	local skip = 0
	
	--Go through string
	for i = 1,#e do
		
		if e:sub(i,i)=="`" then
			mult = mult + 1
			--continue
		else
		
			--Skip because we had a %1 or something
			if skip>0 then
				skip = skip-1
			
			else
				--are we past "the cycle"?
				local char = e:sub(i,i)
		
				for x = 1, getDigits(mult) do
					if tonumber(e:sub(i+x,i+x)) then--Do we have a number with our char?
						char=char..e:sub(i+x,i+x)
						skip = skip + 1
					end
				end
		
				local get = compressmodes[mode]
				new = new .. key[char]
			end
		end
		
	end
	
	return new
end



