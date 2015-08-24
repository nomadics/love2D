

playerhandler = {}
playerhandler.players = {}
localplayer = nil

local instant = false

local pfuncs = {}
pfuncs.takeDamage = function(self, dmg)
	self.health = math.clamp(self.health - dmg, 0, self.maxhealth)
	print("take damage")
end

function playerhandler.create(id, isLocal)
	print("mke", id)

	local player = newClass(pfuncs)
	player.x = ScrW/2-300
	player.y = ScrH/2-150
	
	player.xvel = 0
	player.yvel = 0
	
	player.name = "John Doe"
	player.health = 100
	player.maxhealth = 100
	
	player.nextX = nil
	player.nextY = nil
	
	player.isLocal = isLocal
	player.scale = 1--broken so hard lol
	
	player.w = 40*player.scale
	player.h = 148*player.scale
	player.offy = 17*player.scale
	
	local spawn = getRandomSpawn()
	if spawn then
	
		local offx = (map.zero.x*map.size)
		local offy = (map.zero.y*map.size)
	
		player.x = (spawn.x) * map.size - offx + map.size/2-- / map.size
		player.y = (spawn.y) * map.size - offy - player.h-- / map.size
		print("spawn", offx, offy)
	end
	
	player.parts = {}
	player.nextShoot = 0
	player.mouseX = 0
	player.mouseY = 0
	
	player.nextmouseX = nil
	player.nextmouseY = nil
	
	player.flipped = false
	
	--player.drawBoxes = true
	
	local torsoimg = "assets/player/torso.png"
	local headimg = "assets/player/head.png"
	local armimg = "assets/player/arm.png"
	local cannonimg = "assets/player/cannon.png"
	local llegimg = "assets/player/lleg.png"
	local rlegimg = "assets/player/rleg.png"
	
	local torso = newPart(torsoimg, 30,   70,   ScrW/2,  ScrH/2,  0,          player.parts,    "torso",   Color(255,0,0))
	local head =  newPart(headimg,  30,   30,   0,       70,      0,          torso.children,  "head",    Color(0,255,0))
	local larm =  newPart(armimg,   20,   40,   10,      60,      0,          torso.children,  "larm",    Color(0,255,0))
	local rarm =  newPart(armimg,   20,   40,   -10,     60,      math.pi,    torso.children,  "rarm",    Color(0,255,0))
	local cannon = newPart(cannonimg,30,   40,   0,       15,      0,          larm.children,   "cannon",  Color(0,0,255))
	local lleg =  newPart(llegimg,  16,   -50,  -10,      3,      0,          torso.children,  "lleg",    Color(0,255,0), true)
	local rleg =  newPart(rlegimg,  16,   -50,  10,       3,      0,          torso.children,  "rleg",    Color(0,255,0), true)
	
	local t = isLocal and "dynamic" or "kinematic"
	
	--player.body = love.physics.newBody(world, player.x, player.y, t) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
	--player.shape = love.physics.newRectangleShape(player.w, player.h) --make a rectangle with a width of 650 and a height of 50
	--player.fixture = love.physics.newFixture(player.body, player.shape)
	--player.body:setFixedRotation(0)
	player.id = id
	 --player.fixture:setFriction(0)
	local key = id
	playerhandler.players[key] = player
	
	if isLocal then
		localplayer = player
	end
	
	print("MADE PLAYER", id, isLocal)
	
	return player
end

function playerhandler.remove(player)

	--player.body:destroy()
	table.remove(playerhandler.players,player.id)

end

--w,h,rotx, roty, rot, fixed
function newPart(img, w, h, rotx, roty, ang, parent, name, col, flipy)

	local t = {
	img = (img and love.graphics.newImage(img) or nil),
	rotx = rotx,--Where the part rotates!
	roty = roty,
	ang = ang,
	w = w,
	h = h,
	col = (col or Color(0,0,0)),
	children = {},
	realang = ang,
	x = rotx,
	y = roty,---Don't ever change these.. these are the real position of the "origin"
	flipy = flipy,--just for modelling convenience
	}
	
	if parent then
		parent[name] = t
	end
	return t
end

function playerhandler.draw()

	for v,player in pairs(playerhandler.players) do
	
		drawPart(player, player.parts.torso, player.x, player.y+player.h-48, 0)
		--[[local self = player
		love.graphics.setColor(0,0,0)
		love.graphics.line(self.x-self.w/2,self.y+self.offy+55,self.x+self.w/2,self.y+self.offy+55)]]
		love.graphics.setColor(0,0,0)
		love.graphics.setFont(arial)
		--love.graphics.printf(self.Title, x, y+10, w, 'center')
		local width = arial:getWidth(player.name)
		love.graphics.print(player.name, player.x - width/2, player.y - player.h - 50, 0)
		
		--love.graphics.rectangle("line", player.x-2, player.y - 2, 4, 4)
		
		local w = player.w
		local h = 10
		
		local x = player.x - w/2
		local y = player.y - player.h - 20
		
		local health = player.health
		local maxhealth = player.maxhealth
		
		local d = (health/maxhealth)*w
		
		love.graphics.setColor(255,0,0)
		love.graphics.rectangle("fill", x, y, w, h)
		
		love.graphics.setColor(0,255,0)
		love.graphics.rectangle("fill", x, y, d, h)
		
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("line", x, y, w, h)
		
		--love.graphics.rectangle("line", player.x-2, player.y - 2, 4, 4)
		
		local ent = player
		local px = ent.x - ent.w/2
		local py = ent.y
				
		local w = ent.w
		local h = ent.h
	
		local points = {px,py,px+w,py,px+w,py+h,px,py+h,px,py}
		
		--for v,i in pairs(points) do
			love.graphics.line(points)
		--end
		
	end
	
			
		
end

local speed = 256

function checkKeys(player, dt)
	local xvel = player.xvel
	local yvel = player.yvel
	
	local s = dt * 10
	
	if love.keyboard.isDown("d","right") then
		xvel = lerp(s,xvel,speed)
	elseif love.keyboard.isDown("a","left") then
		xvel = lerp(s,xvel,-speed)
	else
		xvel = lerp(s*5,xvel,0)
	end
	--if love.keyboard.isDown("s","down") then
		--yvel = lerp(s,yvel,speed)
	if love.keyboard.isDown("w","up") and collisionCheck(player.x, player.y+1, player.w, player.h) then
		yvel = -768
	end
	--else
		--yvel = lerp(s*5,yvel,0)
	--end
	yvel = yvel + 9.8*64 * dt
	
	local x = xvel * dt
	local y = yvel * dt
	
	player.xvel = xvel
	player.yvel = yvel
	
	player.x = player.x + x
	local collide = collisionCheck(player.x, player.y, player.w, player.h)
	if collide then
		player.xvel = 0
		player.x = player.x - x
	end
	
	
	player.y = player.y + y
	local collide = collisionCheck(player.x, player.y, player.w, player.h)
	if collide then
		player.yvel = 0
		player.y = player.y - y
	end
	

end

local nextsend = 0
function playerhandler.update(dt)
	for v, player in pairs(playerhandler.players) do
	
		if player then
			--player.x, player.y = player.body:getPosition()
	
			if player.nextShoot>0 then
				player.nextShoot = player.nextShoot - dt
			end
		
			local torso = player.parts.torso
			local head = torso.children.head
			local larm = torso.children.larm
			local rarm = torso.children.rarm
		
			--torso.ang = torso.ang + dt
			calcHead(player, head)
			calcArms(player, larm, rarm)
		
			if love.mouse.isDown("l") and player.isLocal then
				playerhandler.shoot(player, larm)
			end
		
			if player.isLocal then
			
				checkKeys(player, dt)
			
				camera:setPosition(player.x - ScrW/2,player.y - ScrH/2)
		
				player.mouseX, player.mouseY = love.mouse.getPosition()
				if Net.connected then
					if nextsend<=0 then
						nextsend = 1/tickrate
						playerhandler.sendPlayer(player)
					else
						nextsend = nextsend - dt
					end
				end
			else
		
				if player.nextmouseX and player.nextmouseY then
			
					player.mouseX = lerp(dt*tickrate, player.mouseX, player.nextmouseX)
					player.mouseY = lerp(dt*tickrate, player.mouseY, player.nextmouseY)
			
				end
			
				if player.nextX and player.nextY then
					player.x = lerp(dt*tickrate, player.x, player.nextX)
					player.y = lerp(dt*tickrate, player.y, player.nextY)
					--player.body:setPosition(player.x, player.y)
				end
			end
		
		end
		
	end
end

function playerhandler.sendPlayer(player, ip)
	local t = {
		mouseX = player.mouseX,
		mouseY = player.mouseY,
		x = player.x,
		y = player.y,
		--health = player.health,
		_type=TYPE_PLAYER,
		}
	if ip then
		t.id = player.id
		--t.health = player.health
		--print("should print health")
		--print(player.health)
		Net:send(t, nil, nil, ip)
	else
		send(t)
	end
end

function playerhandler.shoot(player, larm)
	
	--for v,i in pairs(playerhandler.players) do
		if player.nextShoot <= 0 or instant then
			--print("shoot")
			player.nextShoot = player.nextShoot + .1
		
			local ang = larm.ang
			if Net.CLIENT or not Net.connected then
				makeBullet("missile", player, larm.x, larm.y, ang, (larm.h/3)*2)
			end
		
			if Net.connected then
				local t = {}
				t._type = TYPE_BULLET
				t.name = "missile"
				if Net.HostType==HOST_BOTH then
					--t.id = "server"
				end
			
				send(t)
			end
		
		end
		
	--end
	
	

end

function calcHead(player, head)
	local x,y = player.mouseX, player.mouseY
	local x2,y2 = head.x, head.y
	x2 = x2 - math.sin(head.realang) * head.h/2
	y2 = y2 - math.cos(head.realang) * head.h/2
		
	local ang = math.atan2(x2-x,y2-y)+math.pi/2
	--print(ang)
	local newang = ang-head.realang
	if newang > math.pi/2 then
		newang = newang - math.pi
		newang = newang / 2
		player.flipped = true
		head.ang = math.clamp(newang, (-math.pi/5), (math.pi/5)*1.5)
	else
		player.flipped = false
		newang = newang / 2
		head.ang = math.clamp(newang, (-math.pi/5)*1.5, math.pi/5)
	end
end

function calcArms(player, larm, rarm)
	local x,y = player.mouseX, player.mouseY
	local x2,y2 = larm.x, larm.y
	local ang = math.atan2(x2-x,y2-y)

	local newang = ang-larm.realang
	larm.ang = newang
	
	if player.flipped then
		local ang = (math.pi/5)*6
		local newang = ang - rarm.realang
		rarm.ang = newang
	else
		local ang = (math.pi/5)*4
		local newang = ang - rarm.realang
		rarm.ang = newang
	end
	
end

function drawPart(player, part, x, y, curang)

	local scale = player.scale
	
	part.x = x
	part.y = y

	local x2,y2 = x, y
	local w = part.w * scale
	local h = part.h * scale
	
	part.realang = curang
	local ang = part.ang + curang
	
	
	x = x - math.sin(ang) * (h/2)
	y = y - math.cos(ang) * (h/2)
	
	
	
	gr.push()
		gr.setColor(part.col)
		gr.translate(x,y)
		gr.rotate(-ang)
		if not part.img or player.drawBoxes then
			gr.rectangle('fill', -w/2, -h/2, w, h)
		end
		if part.img then
			drawImg(color_white, part.img, -w/2, -h/2, w, h, player.flipped, part.flipy, scale)
		end
		gr.pop()
	
	gr.setColor(0,0,0)
	--gr.rectangle( 'fill', x2+part.rotx-1,x2+part.roty-1, 2, 2)
	
	for v,i in pairs(part.children) do
	
		local x = x2 - math.sin(ang) * scale * i.roty
		local y = y2 - math.cos(ang) * scale * i.roty
		
		x = x - math.sin(-math.pi/2+ang) * scale * i.rotx * (player.flipped and -1 or 1)
		y = y - math.cos(-math.pi/2+ang) * scale * i.rotx * (player.flipped and -1 or 1)
		
		drawPart(player, i, x, y, ang)
	
	end
		
end

Filter = {}
function worldRayCastCallbackFilter(fixture, x, y, xn, yn, fraction)
	if not table.HasValue(Filter, fixture) then
		Casting = nil
		return 0 -- Continues with ray cast through all shapes.
	else
		return 1
	end
end

function isTouchingGround(self)

	Casting = self
	Filter = {}
	for v,i in pairs(playerhandler.players) do
		table.insert(Filter, i.fixture)
	end
	world:rayCast(self.x-self.w/2,self.y+self.offy+45,self.x-self.w/2,self.y+self.offy+50,worldRayCastCallbackFilter)
	world:rayCast(self.x,self.y+self.offy+45,self.x,self.y+self.offy+50,worldRayCastCallbackFilter)
	world:rayCast(self.x+self.w/2,self.y+self.offy+45,self.x+self.w/2,self.y+self.offy+50,worldRayCastCallbackFilter)
	if Casting ~= self then
		--print("true")
		return true
	else
		--print("false")
		return false
	end


end

























