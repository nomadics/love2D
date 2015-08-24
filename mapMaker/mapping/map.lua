rootsprites = {}

map = {}

local setting = 1

local version = "0.0.1"

function newMap()

	map = {}

	map.size = 80

	map.layout={
		{1,1,1,1},
		{1,1,1,1},
		{1,1,1,1},
		{1,1,1,1},
	}

	map.zero = {x=-(ScrW/map.size)/2+3,y=-(ScrH/map.size)/2+3}
	
	map.zero.x = math.floor(map.zero.x)
	map.zero.y = math.floor(map.zero.y)
	
	map.spawns = {}
	--map.off = {x=0,y=0}

	map.sprites = {}
	
	map.version = version
	
	for v,i in pairs(rootsprites) do
		map.sprites[v] = i
	end
	
	if editormenu then
	
		editormenu:setuptiles()
	
	end
	
	
end

function removePoint(x,y)

	local l = map.layout
	local row = l[y]
	if row then
		if row[x] then
			if setting~=-1 then
				row[x]=0--0 is air
			end
		end
	end
	
	if setting==-1 then
		removeSpawn(x,y)
	end
end

function addPoint(x, y)
	x = math.floor(x)
	y = math.floor(y)
	local l = map.layout
	local row = l[y]
	if row then
		if setting~=-1 then
			row[x]=setting
		else
			addSpawn(x,y)
		end
	else
	
		local leastx,leasty = least(l)
		local mostx,mosty = most(l)
		
		local min,max = 1,1
		if y < leasty then
			min = y
			max = leasty - 1
		elseif y > mosty then
			min = mosty + 1
			max = y
		end
		
		for i = min, max do
			l[i] = {}
		end
		
		if setting~=-1 then
			l[y][x]=setting
		else
			addSpawn(x,y)
		end
	end
end

function addSpawn(x,y)
	local found = false
	for v,i in pairs(map.spawns) do
		if i.x==x and i.y==y then
			found = true
		end
	end
	if not found then
		table.insert(map.spawns,{x=x,y=y})
	end
end

function removeSpawn(x,y)
	for v,i in pairs(map.spawns) do
		if i.x==x and i.y==y then
			table.remove(map.spawns,v)
		end
	end
end

function getSpawn(x,y)
	for v,i in pairs(map.spawns) do
		if i.x==x and i.y==y then
			return i
		end
	end
	return nil
end

function registerSprite(tbl, ind, collide, animated, img)

	local sprite = {
		collide = collide,
		animated = animated,
		}
	if img then
		sprite.imgpath = img
		sprite.img = love.graphics.newImage(img)
	end
	
	tbl[ind] = sprite
	return sprite
end

local tbl = rootsprites

registerSprite(tbl, -1, false, false, "assets/spawn.png")
registerSprite(tbl, 0, false, false)
registerSprite(tbl, 1, false, false, "assets/backgroundtest.png")
registerSprite(tbl, 2, true, false, "assets/bricks.png")
registerSprite(tbl, 3, true, false, "assets/brickstr.png")
registerSprite(tbl, 4, true, false, "assets/brickstl.png")

newMap()

function least(map)
	local x = 1
	local y = 1
	for v,i in pairs(map) do
		if i and v < y then
			y = v
		end
		for k,l in pairs(i) do
			if l and k < x then
				x = k
			end
		end
	end
	return x,y
end

function most(map)
	local x = 1
	local y = 1
	for v,i in pairs(map) do
		if i and v > y then
			y = v
		end
		for k,l in pairs(i) do
			if l and k > x then
				x = k
			end
		end
	end
	return x,y
end

function mostrow(row)
	local t = 1
	for v,i in pairs(row) do
		if i and v > t then
			t = v
		end
	end
	return t
end

function leastrow(row)
	local t = 1
	for v,i in pairs(row) do
		if i and v < t then
			t = v
		end
	end
	return t
end

function drawMap()
	local layout = map.layout
	local size = map.size

	
	local offx = (map.zero.x*size)
	local offy = (map.zero.y*size)
	
	local s = camera.scaleX
	
	local posx,posy
	posx = (camera.x + (ScrW*s)/2 + offx)
	posy = (camera.y + (ScrH*s)/2 + offy)
	
	--posx = math.floor(posx)
	
	posx = (posx / (size))
	posy = (posy / (size))
	
	local fitx = math.ceil(ScrW/(size))*s+2
	local fity = math.ceil(ScrH/(size))*s+2

	local xmin,xmax
	
	local leastx,leasty = least(layout)
	local mostx,mosty = most(layout)
	
	local ymin = math.ceil(math.clamp(math.ceil(posy-fity/2),leasty,mosty))
	local ymax = math.ceil(math.clamp(math.ceil(posy+fity/2),leasty,mosty))
	
	local draw = 0
	for y = ymin, ymax do
		
		leastx = leastrow(layout[y])
		mostx = mostrow(layout[y])
		
		xmin = math.floor(math.clamp(posx-fitx/2,leastx,mostx))
		xmax = math.ceil(math.clamp(posx+fitx/2,leastx,mostx))
		for x = xmin, xmax do
			local xp = x * size - offx
			local yp = y * size - offy

			if true then--xr>0 and yr>0 and xr<ScrW+size and yr<ScrH+size then
				local img
				local ind = layout[y][x]
				if not map.sprites[ind] then
					love.graphics.setColor(0,0,0)
				else
					ind = map.sprites[ind]
					love.graphics.setColor(255,255,255)
					img = ind.img
				end
				if not img then
					--love.graphics.rectangle("fill",xp,yp,size,size)
				else
					draw = draw + 1
					love.graphics.draw(img, xp, yp, 0, size/img:getWidth(), size/img:getHeight())
					--print(size/img:getWidth())
				end
				local spawn = getSpawn(x,y)
				if spawn then
					local img = map.sprites[-1].img
					love.graphics.setColor(255,255,255)
					love.graphics.draw(img, xp, yp, 0, size/img:getWidth(), size/img:getHeight())
					love.graphics.setColor(0,255,0,100)
					love.graphics.rectangle("fill", xp, yp, size, size)
					draw = draw + 1
				end
			else
					--print("no draw")
			end
			
			
		end
	end
	--print(draw)

end

function newMapGrid()

	local size = map.size
	
	local e = size/camera.scaleX

	mapGrid = love.graphics.newCanvas(ScrW + (e*2), ScrH + (e*2))
	love.graphics.setCanvas(mapGrid)
	--print(draw)
	--if drawGrid then
		--print(size, size / camera.scaleX)
		--size = size / camera.scaleX
		local x
		local y
		
		local w = size / camera.scaleX
		local h = size / camera.scaleX
		
		for xx = -1, math.ceil(ScrW/(size/camera.scaleX))+1 do
			x = ((size * xx) / camera.scaleX)-- - camera.x % size) / camera.scaleX
			for yy = -1, (math.ceil(ScrH/(size/camera.scaleX))+1) do
				y = ((size * yy) / camera.scaleY)-- - camera.y % size) / camera.scaleX
				--local xr,yr = camera.getRealPosition(x,y)
				love.graphics.setColor(0,0,0)
				love.graphics.rectangle("line", x, y, w, h)
			end
		end
	
	love.graphics.setCanvas()
	--end

	--local file = love.filesystem.newFile(map)
	--file:open("r")
	--setScene(0)
end

--newMapGrid()

function drawMapGrid()

	love.graphics.setColor(255,255,255)
	local size = map.size
	local x = (-camera.x % size - size) / camera.scaleX
	local y = (-camera.y % size - size) / camera.scaleX
	
	love.graphics.draw(mapGrid, x, y)

end


function saveMap(name)
	local save = {}
	save.size = map.size
	save.layout = map.layout
	save.spawns = map.spawns
	save.zero = map.zero
	save.sprites = {}
	for v,i in pairs(map.sprites) do
		save.sprites[v] = i
		save.sprites[v].img = nil
	end
	
	local json = JSON:encode(save)
	local comp = compressString(json, 4)
	local savejson = JSON:encode(comp)
	local s = love.filesystem.newFile("maps/"..name..".map")
	s:open("w")
	s:write(savejson)
	s:close()
end

function loadMap(name)

	editormenu:cleartiles()

	local mapfile = love.filesystem.newFile(name)
	mapfile:open("r")
	local json = mapfile:read()
	mapfile:close()
	local tbl = JSON:decode(json)
	local json2 = decompressString(tbl)
	local loadmap = JSON:decode(json2)

	newMap()
	
	map.layout = {}
	map.size = loadmap.size
	map.zero = loadmap.zero
	for v,i in pairs(loadmap.sprites) do
		v = tonumber(v)
		registerSprite(map.sprites, v, i.collide, i.animated, i.imgpath)
	end
	
	
	for v,i in pairs(loadmap.layout) do
		local key1 = tonumber(v)
		map.layout[key1]={}
		for k,l in pairs(loadmap.layout[v]) do
			map.layout[key1][tonumber(k)] = tonumber(l)
		end
	end
	
	map.spawns = loadmap.spawns
	
	map.zero.x = math.floor(map.zero.x)
	map.zero.y = math.floor(map.zero.y)
	
	setScene(0)
	
	editormenu:setuptiles()
end


panel.Register("EditorMenu", {
	init = function(self)
	
		self:setSize(250,ScrH)
		self:setPos(ScrW-self:getWidth(),0)
		
		self.BackgroundColor = Color(100,100,100)
		
		self.tiles = {}
		
		self.Create = panel.Create("MenuButton", self)
		self.Create:setPos(self.w/2-100,self.h-180)
		self.Create.text = "Save Map"
		self.Create.doClick = function(self)
			saveMap("save")
			setScene(-1)
		end
		
		self.selected = nil
		

	end,
	
	setuptiles = function(self)
		self:cleartiles()
		local x = 5
		local y = 5
		local maxx = 240
		local size = 30
		for v,tile in pairs(map.sprites) do
			
			if x + size > maxx then
				x = 5
				y = y + size + 5
			end
			
			local b = panel.Create("Button",self)
			b:setPos(x,y)
			b:setSize(size,size)
			b.image = tile.img or false
			if setting==v then
				self.selected =  b
			end
			--b.tile = tile
			b.doClick = function(this)
				setting = v
				self.selected = this
			end
			b.old = b.drawOver
			b.drawOver = function(this,x,y,w,h)
				this:old(x,y,w,h)
				if self.selected == this then
					love.graphics.setColor(0,255,0,100)
					love.graphics.rectangle("fill",x,y,w,h)
				end
			end
			table.insert(self.tiles,b)
			print(v)
			x = x + size + 5
		
		end
	
	end,
	
	cleartiles = function(self)
	
		for v,i in pairs(self.tiles) do
			i:remove()
		end
		self.tiles = {}
	
	end,
	
	draw = function(self,x,y,w,h)
		love.graphics.setColor(self.BackgroundColor)
		love.graphics.rectangle("fill", x, y, w, h)
		
		--drawImg(color_white, self.BackImg, x, y, w, h)
		
		drawOutlinedRect(Color(0,0,0,255),x,y,w,h,1)
		
		--love.graphics.printf(self.Title, x, y+10, w, 'center')
		
	
	end


},"Panel")
