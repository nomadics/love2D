local buttons = {}

button = newClass();

local panelmeta = {}

panelmeta.init = function(self)

	self.color = Color(255,255,255)
	self.font = arialsmall
	self.text = "TextLabel"


end

panelmeta.draw = function(self, x, y, w, h)
	local col = self.color or Color(255,255,255)
	
	love.graphics.setColor(col)
	love.graphics.rectangle("fill", x, y, w, h)
	
	drawOutlinedRect(Color(0,0,0,255),x,y,w,h,1)
end

panelmeta.drawOver = function(self, x, y, w, h)

	local height = self.font:getHeight()

	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(self.font)
	love.graphics.printf(self.text, x + 5, y+h/2-height/2, w, 'center')
	
end

function panelmeta:update(self, dt)

end

panelmeta.mousemoved = function(self,dx,dy)
	--[[if not self:getMouseDown() then
		return
	end
	self.x = self.x + dx
	self.y = self.y + dy]]
end

panelmeta.doClick = function(self, mouse)
	--self.y = self.y + 10
end

panel.Register("TextLabel",panelmeta,"Panel")