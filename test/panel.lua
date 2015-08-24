paneltypes = {}

panel = {}
panel.scenes = {}
panel.scene = -1
panel.focus = nil
panel.changedfocus = false

function panel:setScene(sceneId)
	if not panel.scenes[sceneId] then
		panel.scenes[sceneId] = {}
	end
	panel.scene = sceneId
end

local panelmeta = {}

panelmeta.children = {}
panelmeta.parent = nil

AccessorFunc(panelmeta, "x", "X")
AccessorFunc(panelmeta, "y", "Y")
AccessorFunc(panelmeta, "w", "Width")
AccessorFunc(panelmeta, "h", "Height")
AccessorFunc(panelmeta, "mouseDown", "MouseDown")

panelmeta.visible = true

panelmeta.setVisible = function(self, vis)
	print(self._class)
	self.visible = vis
	for v,i in pairs(self:getChildren()) do
		i:setVisible(vis)
	end
end

panelmeta.getVisible = function(self)
	return self.visible
end

panelmeta.init = function(self)
	self.x = 0
	self.y = 0
	self.w = 5
	self.h = 5
	--self:printChildren(1)
	--print(eee)
	--eee = eee + 1
end
eee = 0
panelmeta.printChildren = function(self, int)

	print(int, self)
	int = int + 1
	for v,i in pairs(self.children) do
		i:printChildren(int)
	end

end

panelmeta.draw = function(self, x, y, w, h)
	love.graphics.setColor(Color(255,255,255))
	love.graphics.rectangle("fill", x, y, w, h)
	drawOutlinedRect(Color(0,0,0,255),x,y,w,h,1)
end
panelmeta.drawOver = function(self,x,y,w,h)
end

panelmeta.getChildren = function(self)
	return self.children
end

panelmeta.addChild = function(self, child)
	if not table.HasValue(self.children, child) and child~=self then
		--table.insert(self.children, child)
		child:setParent(self)
	end
end

--Let's set a parent!
panelmeta.setParent = function(self,parent)
	--Dont set parent to self... we're not asexual
	if parent==self then--lol
		return
	end
	
	--Is our old parent not our new parent?
	local old = self:getParent()
	if old ~= parent then
		--Remove us from old parent if exists
		if old then
			table.RemoveByValue(old.children, self)
		end
		table.insert(parent.children, self)
		self.parent = parent
	end
end

panelmeta.getParent = function(self)
	return self.parent
end

function panel:update(dt)
	for v,i in ipairs(panel.scenes[panel.scene]) do
		i:update(i, dt)
		i:think(i)
	end
	
end

--do i need this
local function getFirstParent(panel)
	local parent = panel:getParent()
	if parent then
		return getFirstParent(parent)
	end
	return nil
end

function getPanelZeros(panel, x, y, z)
	local x = x or panel.x
	local y = y or panel.y
	local z = z and (z+1) or 1
	local parent = panel:getParent()
	if parent then
		--print("parnet")
		x = x + parent.x
		y = y + parent.y
		--print(z)
		return getPanelZeros(parent, x, y)
	end
	--print(z)
	return x,y
end

function panel:draw()

	for v,i in ipairs(panel.scenes[panel.scene]) do
		local x = 0
		local y = 0
		x,y = getPanelZeros(i)
		--Make sure our panel is on the screen!
		if x < ScrW and y < ScrH and x+i.w>0 and y+i.h>0 and i:getVisible() then
			i:draw(x, y, i.w, i.h)
			i:drawOver(x, y, i.w, i.h)
		else
			--print("nodraw")
		end
	end
end

function panel:mousepressed(mouse)
	panel.changedfocus = false

	for v,i in ipairs(panel.scenes[panel.scene]) do
		if i.mousepressed then
			i:rootmousepressed(mouse)
			i:mousepressed(mouse)
		end
	end
	
	if panel.focus~=nil and not panel.changedfocus then
	
		panel.focus = nil
	
	end
end

function panel:keypressed(key)

	if panel.focus and panel.focus.keyPressed then

		panel.focus:keyPressed(key)
	
	end

end

function panel:mousemoved(dx,dy)
	for v,i in ipairs(panel.scenes[panel.scene]) do
		if i.mousemoved then
			i:mousemoved(dx,dy)	
		end
	end
end

local function getPanelType(name)
	for v,i in pairs(paneltypes) do
		if v==name then
			return i
		end
	end
	return nil
end

function panel.Register(key, meta, base)
	local c
	local b = getPanelType(base)
	local oldinit
	if base then
		c = newClass(b);
		oldinit = b.class_init
	else
		c = newClass(panelmeta)
	end
	c._base = b
	
	for v,i in pairs(meta) do
		c[v] = i
	end
	
	local init = c.init
	
	c.class_init = function(self,...)
		if oldinit then
			oldinit(self)
		end
		init(self)
	end
	
	--c.__type = key
	
	paneltypes[key]=c

end


function panel.Create(key, parent)
	local b = newClass(getPanelType(key));
	b.children = {}
	table.insert(panel.scenes[panel.scene], b)
	b.class_init(b)
	b._class = key
	if parent then
		parent:addChild(b)
		b:setVisible(parent:getVisible())
	end
	
	return b
end

panelmeta.getHovered = function(self)

	--[[local x,y = love.mouse.getPosition()
	local x2,y2 = getPanelZeros(self)
	
	return x > x2 and
		   y > y2 and
		   x < (x2 + self.w) and
		   y < (y2 + self.h)]]
	return hoveredPanel==self
	
end

panelmeta.isMouseDown = function(self, mouse)
	
	return self:getHovered() and love.mouse.isDown(mouse)

end

panelmeta.think = function(self)

	self.Hovered = self:getHovered()
	
	if self:getMouseDown() and not self.Hovered then
		self:setMouseDown(false)
	end
	
	if self.Hovered then
		if not love.mouse.isDown("l","r","m") then
			self:setMouseDown(false)
		end
	end

end

panelmeta.rootmousepressed = function(self, mouse)
	if self.Hovered then
		if (mouse=="l" or mouse=="r" or mouse=="m") and not self:getMouseDown() then
			local onLoseFocus 
			if panel.focus and panel.focus.onLoseFocus then
				onLoseFocus = panel.focus
			end
			panel.focus = self
			panel.changedfocus = true
			if onLoseFocus then
				onLoseFocus:onLoseFocus()
			end
		end
	end
end

panelmeta.mousepressed = function(self, mouse)
	if self.Hovered then
		if (mouse=="l" or mouse=="r" or mouse=="m") and not self:getMouseDown() then
			self:setMouseDown(mouse)
			if self.doClick then
				self:doClick(mouse)
			end
		else
			self:setMouseDown(false)
		end
	end
end

panelmeta.mousemoved = function(self,dx,dy)
end

panelmeta.setPos = function(self,x,y)
	self.x = x
	self.y = y
end

panelmeta.getPos = function(self)
	return {x=self.x,y=self.y}
end

panelmeta.setSize = function(self,x,y)
	self.w = x
	self.h = y
end

panel.Register("Panel", panelmeta)