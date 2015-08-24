


panel.Register("Menu", {
	init = function(self)
	
		self:setSize(400,500)
		self:setPos(ScrW/2-self:getWidth()/2,ScrH/2-self:getHeight()/2)
		
		self.BackgroundColor = Color(100,100,100)
		
		--self.BackImg = love.graphics.newImage("assets/wtflol.png")
		
		self.Title = "Map Maker"
		
		
		self.Exit = panel.Create("MenuButton", self)
		self.Exit:setPos(self.w/2-100,self.h-60)
		self.Exit.text = "Exit"
		self.Exit.doClick = function(self)
			love.event.quit()
		end
		
		
		self.Load = panel.Create("MenuButton", self)
		self.Load:setPos(self.w/2-100,self.h-120)
		self.Load.text = "Load"
		self.Load.doClick = function(self)
			setScene(1)
			loadmenu:findfiles()
		end
		
		self.Create = panel.Create("MenuButton", self)
		self.Create:setPos(self.w/2-100,self.h-180)
		self.Create.text = "Create New"
		self.Create.doClick = function(self)
			setScene(0)
			newMap()
		end
		

	end,
	
	draw = function(self,x,y,w,h)
		love.graphics.setColor(self.BackgroundColor)
		love.graphics.rectangle("fill", x, y, w, h)
		
		--drawImg(color_white, self.BackImg, x, y, w, h)
		
		drawOutlinedRect(Color(0,0,0,255),x,y,w,h,1)
		
		love.graphics.printf(self.Title, x, y+10, w, 'center')
		
	
	end


},"Panel")



panel.Register("MenuButton", {
	init = function(self)
	
		self:setSize(200,50)
		self.text = "Button"
		self.font = ariallarge

	end,
	
	drawOver = function(self,x,y,w,h)
		love.graphics.setFont(self.font)
		love.graphics.printf(self.text, x, y+5, w, 'center')
	end,
	
	doClick = function(self)
	end,


},"Button")





panel.Register("LoadMenu", {
	init = function(self)
	
		self:setSize(400,500)
		self:setPos(ScrW/2-self:getWidth()/2,ScrH/2-self:getHeight()/2)
		
		self.BackgroundColor = Color(100,100,100)
		
		--self.BackImg = love.graphics.newImage("assets/wtflol.png")
		
		self.Title = "Load Map"
		self.files = {}
		
		
		self.Exit = panel.Create("MenuButton", self)
		self.Exit:setPos(self.w/2-100,self.h-60)
		self.Exit.text = "Close"
		self.Exit.doClick = function(this)
			self:clearfiles()
			setScene(-1)
		end
		

	end,
	
	findfiles = function(self)
	
		for v,i in pairs(love.filesystem.getDirectoryItems("maps")) do
			file = panel.Create("TextLabel", self)
			file:setSize(self:getWidth()-40,20)
			file:setPos(20,20+20*v)
			file.text = i
			file.map = i
			file.doClick = function(this)
			
				loadMap("maps/"..this.map)
				self:clearfiles()
			
			end
			table.insert(self.files,file)
		end
	
	end,
	
	clearfiles = function(self)
		for v,i in pairs(self.files) do
			i:remove()
		end
		
		self.files = {}
	end,
	
	draw = function(self,x,y,w,h)
		love.graphics.setColor(self.BackgroundColor)
		love.graphics.rectangle("fill", x, y, w, h)
		
		--drawImg(color_white, self.BackImg, x, y, w, h)
		
		drawOutlinedRect(Color(0,0,0,255),x,y,w,h,1)
		
		love.graphics.printf(self.Title, x, y+10, w, 'center')
		
	
	end


},"Panel")