--Clock type enums
CLOCK_TYPE_CIRCLE = 0
gr = love.graphics
hand = gr.newImage("gfx/hand.png")

local clocks = {}
--X position, Y position, Width, Height, Clock Type, Image
function newClock(x,y,w,h,typ,img)
	
	local c = {}
	--Setting values
	c.x = x
	c.y = y
	c.w = w
	c.h = h
	c.typ = typ
	c.img = gr.newImage(img)
	c.off = (18/200)*w
	c.font = gr.newFont("arial.ttf", math.floor(w/10))
	
	table.insert(clocks,c)
	
	return c

end

function updateClocks(dt)

	for v,i in pairs(clocks) do
		i.t = os.time()
	end

end

function drawClocks()
	local t = os.time()
	local hour = os.date("%I", t)
	local m = os.date("%M", t)
	local s = os.date("%S", t)
	for v,i in pairs(clocks) do
		gr.setColor(0,0,0)
		local iw,ih = i.img:getDimensions()
		local w = i.w/iw
		local h = i.h/ih
		
		if i.typ==CLOCK_TYPE_CIRCLE then
			gr.draw(i.img, i.x, i.y, 0, w, h)
			local ang12 = -(math.pi/6)*2
			local ang = ang12
			local x = i.x + i.w/2
			local y = i.y + i.h/2
			--print(w,h)
			for hour = 1, 12 do
				gr.setFont(i.font)
				gr.printf(hour, x + math.cos(ang) * (i.w/2 - i.off), (y + math.sin(ang) * (i.h/2 - i.off))-i.font:getHeight()/2, w, "center")
				ang = ang + (math.pi/6)
			end
			
			local w = (2/200)*i.w
			local h = (i.h/3)
			local ww = w/hand:getWidth()
			local hh = h/hand:getHeight()
			local xx = x + w/2
			--hh = 0
			ang = ang12 + (math.pi/30)*(s-5)
			gr.draw(hand, (xx + math.cos(ang) * (i.w/3)), (y + math.sin(ang) * (i.h/3)), ang+math.pi/2, ww, hh)
			
			
			local w = (3.5/200)*i.w
			local h = (i.h/2.5)
			local ww = w/hand:getWidth()
			local hh = h/hand:getHeight()
			local xx = x + w/2
			--hh = 0
			ang = ang12 + (math.pi/30)*(m-5)
			gr.draw(hand, (xx + math.cos(ang) * (i.w/2.5)), (y + math.sin(ang) * (i.h/2.5)), ang+math.pi/2, ww, hh)
			
			local w = (5/200)*i.w
			local h = (i.h/4)
			local ww = w/hand:getWidth()
			local hh = h/hand:getHeight()
			local xx = x + w/2
			--hh = 0
			ang = ang12 + (math.pi/6)*(hour-1)
			gr.draw(hand, (xx + math.cos(ang) * (i.w/4)), (y + math.sin(ang) * (i.h/4)), ang+math.pi/2, ww, hh)
			
			
			gr.setColor(255,0,0)
			gr.point(x,y)
			
		end
	
	end


end