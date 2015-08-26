--[[
Copyright (c) 2015 Hunter Esler

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

gr = love.graphics

animations = {}

--Run update function on all animations
function updateAnimations(dt)

	for v,i in pairs(animations) do
		i:update(dt)
	end
	
end

--Pre-defined values and functions
local animmeta = {}
animmeta.quad = gr.newQuad(0,0,0,0,0,0)
animmeta.rows = 1
animmeta.columns = 1
animmeta.t = 1
animmeta.timeLeft = 0
animmeta.currentRow = 0
animmeta.currentColumn = 0

function newAnimation(obj, img, rows, columns, offset, t)
	--These are the "rows and colums of our animation to scroll through"
	rows = rows or 1
	columns = columns or 1
	--offset is the line width between each frame
	offset = offset or 0
	
	--How fast should we loop through our animation (in milliseconds)?
	t = t or 1000
	
	--Make a new class with the pre-defined functions/parameters animmeta
	local a = newClass(animmeta)
	--set a custom image
	a.img = img
	--make the quad for rendering
	a.quad = gr.newQuad(0, 0, 0, 0, img:getDimensions())
	--rows and columns
	a.rows = rows
	a.columns = columns
	--time and offset
	a.t = t
	a.offset = offset
	--timeLeft is the time we have left until we update the animation!
	a.timeLeft = 0
	--reset some values
	a.currentRow = 0
	a.currentColumn = 0
	--make sure we set our object to know where to draw!
	a.obj = obj
	
	a.w = img:getWidth()/columns
	a.h = img:getHeight()/rows
	--Return our animation
	return a
end

--Function: Clones an animation
function cloneAnimation(obj, anim)
	local a = newClass(anim)
	a.obj = obj
	table.insert(animations,a)
	return a
end

--Function: Draws quad at specified location at scale 0-1 and w/h scale 0-1
animmeta.drawquad = function(self, x1, y1, x2, y2, w, h, r)
	r = r or 0
	local rw,rh = self.img:getDimensions()
	self.quad:setViewport(rw*x2, rh*y2, rw*w, rh*h)
	gr.draw(self.img, self.quad, x1, y1, r)
end

--update the time and see if we should update the viewPort
animmeta.update = function(self,dt)
	self.timeLeft = self.timeLeft - dt
	if (self.timeLeft < 0) then--Has enough time passed to change the frame?
		self.timeLeft = self.t/1000--It is in milleseconds, convert to seconds
		--Update our row/column position
		self.currentColumn = self.currentColumn + 1
		
		if self.currentColumn > self.columns then
			self.currentColumn = 1
			self.currentRow = self.currentRow + 1
		end
		if self.currentRow > self.rows then
			self.currentRow = 1
		end
		
		--Figure out where we are on the sprite sheet!
		local rw,rh = self.img:getDimensions()
		
		local w = (rw/self.columns)
		local h = (rh/self.rows)
		
		local x = w*(self.currentColumn-1)
		local y = h*(self.currentRow-1)
		
		local off = self.offset
		
		w = math.floor(w-off*2)
		h = math.floor(h-off*2)
		
		--Update ourselves accordingly
		self.quad:setViewport(x+off, y+off, w, h)
		
	end
end

animmeta.draw = function(self)
	if self.obj then
		--Our "real" x,y
		local x = self.obj.x
		local y = self.obj.y
	
		--Object's width and height
		local w = self.obj.w
		local h = self.obj.h
	
		--spritesheet's tile width and height and width height ratio
		local sx = w/self.w
		local sy = h/self.h
		
		gr.draw(self.img, self.quad, x, y, 0, sx, sy)
	end

end

--Remove our animation from updating.
animmeta.remove = function(self)
	for v,i in pairs(animations) do
		if i==self then
			animations[v] = nil
		end
	end
end