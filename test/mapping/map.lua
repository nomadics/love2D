local size = 50
rootsprites = {}

map = {}

map.layout={
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1},
{1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1},
{1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1},
{1,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1},
{1,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1},
{1,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1},
{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
}

map.zero = {x=1,y=-1}
map.off = {x=map.zero.x*size,y=map.zero.y*size}

map.sprites = {}
map.saves = {}

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



function loadMap(name)

	--love.filesystem.
	local mapfile = love.filesystem.newFile(name)
	mapfile:open("r")
	local json = mapfile:read()
	mapfile:close()
	local tbl = JSON:decode(json)
	local json2 = decompressString(tbl)
	local loadmap = JSON:decode(json2)
	
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

end

loadMap("customlevels/save.map")

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

function getRandomSpawn()
	if #map.spawns>0 then
		return map.spawns[math.random(1,#map.spawns)]
	else
		return nil
	end
end

function drawMap()

	local size = map.size
	local layout = map.layout
	
	local offx = (map.zero.x*size)
	local offy = (map.zero.y*size)
	
	local posx,posy
	local player
	if not localplayer then
		return
	else
		player = localplayer
		posx = player.x + offx
		posy = player.y + offy
	end
	
	posx = math.floor(posx / size)
	posy = math.floor(posy / size)
	
	local fitx = math.ceil(ScrW/size)+2
	local fity = math.ceil(ScrH/size)+2
	
	local xmin,xmax
	
	local leastx,leasty = least(layout)
	local mostx,mosty = most(layout)
	
	--print(posx,posy)
	local ymin = math.floor(math.clamp(posy-fity/2,leasty,mosty))
	local ymax = math.ceil(math.clamp(posy+fity/2,leasty,mosty))
	--print(ymin,ymax)
	local draw = 0
	for y = ymin, ymax do
		
		leastx = leastrow(layout[y])
		mostx = mostrow(layout[y])
		
		local xmin = math.floor(math.clamp(posx-fitx/2,leastx,mostx))
		local xmax = math.ceil(math.clamp(posx+fitx/2,leastx,mostx))
		for x = xmin, xmax do
			draw = draw + 1
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
					love.graphics.draw(img, xp, yp, 0, size/img:getWidth(), size/img:getHeight())
					--print(size/img:getWidth())
				end
			else
					--print("no draw")
			end
			
			
		end
	end


end

function boundingCheck(x1,y1,w1,h1,x2,y2,w2,h2)
	return x1 <= x2 + w2 and 
           x1+w1 >= x2 and
           y1 <= y2+h2 and
		   y1+h1 >= y2
end


function collisionCheck(x, y, w, h, player)-- x and y being movement

	local size = map.size
	local layout = map.layout
	
	local offx = (map.zero.x*size)
	local offy = (map.zero.y*size)
	
	local posx,posy
	
	posx = x + offx
	posy = y + offy
	
	posx = math.floor(posx / size)
	posy = math.floor(posy / size)
	
	local fitx = math.ceil(w*2/size)
	local fity = math.ceil(h*2/size)
	
	--print(posx,posy)
	local xmin,xmax
	--print(ymin,ymax)
	local draw = 0
	
	local px = x - w/2
	local py = y
	
	local points = {}
	table.insert(points,{x=px,y=py})
	table.insert(points,{x=px+w,y=py})
	table.insert(points,{x=px+w,y=py+h})
	table.insert(points,{x=px,y=py+h})
	
	
	local leastx,leasty = least(layout)
	local mostx,mosty = most(layout)
	
	local ymin = math.floor(math.clamp(posy-fity/2,leasty,mosty))
	local ymax = math.ceil(math.clamp(posy+fity/2,leasty,mosty))
	
	for y = ymin, ymax do
		
		leastx = leastrow(layout[y])
		mostx = mostrow(layout[y])
		
		local xmin = math.floor(math.clamp(posx-fitx/2,leastx,mostx))
		local xmax = math.ceil(math.clamp(posx+fitx/2,leastx,mostx))
		for x = xmin, xmax do
			draw = draw + 1
			local xp = x * size - offx
			local yp = y * size - offy
			local xr, yr = camera.getRealPosition(xp,yp)
			xr = xr + size
			yr = yr + size
			
			local ind = layout[y][x]
			local sprite = map.sprites[ind]
			
			if sprite and sprite.collide then
				--sprint("swag")
				
				if boundingCheck(px, py, w, h, xp, yp, size, size) then
					return true
				end
			
			end
		end
	end
	
	if player then
		for v,i in pairs(playerhandler.players) do
			if i~=player then
				if boundingCheck(px,py,w,h,i.x-i.w/2,i.y,i.w,i.h) then
					return true, i
				end
			end
		end
	end
end
