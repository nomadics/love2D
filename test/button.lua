local buttons = {}

button = newClass();

local buttonmeta = {}

function button:newButton(x, y, w, h, parent)
	local b = panel.Create("Button", parent)--newClass(buttonmeta)
	b.x = x or 0
	b.y = y or 0
	b.w = w or 10
	b.h = h or 10
	
	table.insert(buttons,b)
	
	return b

end

buttonmeta.draw = function(self, x, y, w, h)
	local col = self.color or Color(255,255,255)

	
	
	love.graphics.setColor(col)
	love.graphics.rectangle("fill", x, y, w, h)
	
	if self:getMouseDown() then
		col = Color(0,0,0,100)
		love.graphics.setColor(col)
		love.graphics.rectangle("fill", x, y, w, h)
	elseif self.Hovered then
		col = Color(0,0,0,40)
		love.graphics.setColor(col)
		love.graphics.rectangle("fill", x, y, w, h)
	end
	
	
	drawOutlinedRect(Color(0,0,0,255),x,y,w,h,1)
end

function buttonmeta:update(self, dt)
	--self.x = self.x + (10 * dt)
end

buttonmeta.mousemoved = function(self,dx,dy)
	--[[if not self:getMouseDown() then
		return
	end
	self.x = self.x + dx
	self.y = self.y + dy]]
end

buttonmeta.doClick = function(self, mouse)
	--self.y = self.y + 10
end

panel.Register("Button",buttonmeta,"Panel")