
local classmeta = {}

function newClass(meta) 
	
	local class = {}
	setmetatable(class,classmeta)
	classmeta.__index = classmeta
	
	if type(meta)=="table" then
		
		for v,i in pairs(meta) do
			--print("v", v)
			class[v] = i
			
		end
		
	end
	
	return class

end


function classmeta.update(self)
end