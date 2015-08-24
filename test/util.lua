Casting = nil
function worldRayCastCallback(fixture, x, y, xn, yn, fraction)
	Casting = fixture
	return 0 -- Continues with ray cast through all shapes.
end

function getPlayerFromFixture(fix)

	for v,i in pairs(playerhandler.players) do
		if i.fixture==fix then
			return i
		end
	end
	return nil

end

function getIpFromUserId(id)
	if id == -1 then
		return "server"
	end
	for v,i in pairs(Net.ips) do
		if i==id then
			return v
		end
	end
	return nil
end


function table.HasValue(tbl, val)
	for v,i in pairs(tbl) do
		if i==val then
			return true
		end
	end
	return false
end

function table.RemoveByValue(tbl, val)
	for v,i in pairs(tbl) do
		if i==val then
			table.remove(tbl,v)
		end
	end
end


function AccessorFunc(tbl, key, fancy)
	
	tbl["set"..fancy] = function(self, val)
		self[key] = val
	end
	
	tbl["get"..fancy] = function(self)
		return self[key]
	end
	
end

hoveredPanel = nil
function getHoveredPanel()
	if panel.scene<0 then
		hoveredPanel = nil
		return nil
	end
	local t = panel.scenes[panel.scene]
	for v,i in ripairs(t) do
		local x,y = love.mouse.getPosition()
		local x2,y2 = getPanelZeros(i,i.x,i.y)
		local hovered =
		   x > x2 and
		   y > y2 and
		   x < (x2 + i.w) and
		   y < (y2 + i.h)
		if hovered and i:getVisible() then
			hoveredPanel = i
			return i
		end
	end
	hoveredPanel = nil
	return nil
end





function drawOutlinedRect(col,x,y,w,h,r)
	local r = r or 1
	love.graphics.setColor(col)
	for i = 0, r-1 do
		local p = {}
		--[[
		p[1] = {x=x+i,y=y+i}
		p[2] = {x=x+w-i*2,y=y+i}
		p[3] = {x=x+w-i*2,y=y+h-i*2}
		p[4] = {x=x+i,y=y+h-i*2}
		love.graphics.line(p)]]
		local x2 = x + i
		local y2 = y + i
		
		local xmax = x+w-i
		local ymax = y+h-i
		
		p={x2,y2,
		xmax,y2,
		xmax,ymax,
		x2,ymax,
		x2,y2}
		love.graphics.line(p)
	end


end


function drawImg(col, img, x, y, w, h, flipx, flipy, scaled)
	love.graphics.setColor(col)
	
	local scaled = scaled or 1
	local scalex = w/img:getWidth()
	local scaley = h/img:getHeight()
	local offx = 0
	local offy = 0
	
	if flipx then
		offx = w/scaled
		scalex = -scalex
	end
	if flipy then
		offy = -h/scaled
		scaley = -scaley
	end
	
	love.graphics.draw(img, x, y, 0, scalex, scaley, offx, offy)
end





function ripairs(t)
  local function ripairs_it(t,i)
    i=i-1
    local v=t[i]
    if v==nil then return v end
    return i,v
  end
  return ripairs_it, t, #t+1
end


function math.clamp(n, low, high) 
	return math.min(math.max(low, n), high) 
end


function lerp(t,a,b) return (1-t)*a + t*b end

