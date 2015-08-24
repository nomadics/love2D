

local bullettypes = {}
local bullets = {}


function updateBullets(dt)
	for v,i in pairs(bullets) do
		--print(#bullets)
		--print("woop", v)
		local oldx,oldy = i.x, i.y
		i.x = i.x - math.sin(i.ang) * i.speed * dt
		i.y = i.y - math.cos(i.ang) * i.speed * dt
		i.alive = i.alive + dt
		local collide, player = collisionCheck(i.x, i.y, i.w, i.w, i.owner)
		if i.alive>=i.life or collide then
			
			if player then
				if (Net.SERVER or not Net.connected) then
					player:takeDamage(i.damage)
					broadcast({_type=TYPE_HEALTH, health=player.health, id = player.id})
				end
			end
			
			i.removed = true
			table.remove(bullets,v)
			
		end
	end
end

function drawBullets()
	for v,i in ipairs(bullets) do
		gr.push()
			gr.setColor(color_white)
			gr.translate(i.x,i.y)
			gr.rotate(-i.ang)
			drawImg(color_white, i.img, -i.w/2, -i.h/2, i.w, i.h)
			gr.pop()
			
		

			
			
	end
end

function newBullet(name,damage,w,h,speed,life,img,f)--f being movement function... for fun stuff later :)

	local b = {}
	b.speed = speed
	b.w = w
	b.h = h
	b.img = love.graphics.newImage(img)
	b.life = life
	b.damage = damage

	bullettypes[name] = b

end

newBullet("missile",10,16,35, 600,10, "assets/missile.png")


function makeBullet(name, owner, x, y, ang, off)
	--print("makebullet")
	local off = off or 0
	local bullet = bullettypes[name]
	
	local b = {}
	b.x = x - math.sin(ang) * off
	b.y = y - math.cos(ang) * off
	b.w = bullet.w
	b.h = bullet.h
	b.ang = ang
	b.speed = bullet.speed
	b.img = bullet.img
	b.life = bullet.life
	b.alive = 0
	b.damage = bullet.damage
	b.owner = owner
	
	
	
	table.insert(bullets, b)

end

