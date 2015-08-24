


panel.Register("Menu", {
	init = function(self)
	
		self:setSize(400,500)
		self:setPos(ScrW/2-self:getWidth()/2,ScrH/2-self:getHeight()/2)
		
		self.BackgroundColor = Color(100,100,100)
		
		--self.BackImg = love.graphics.newImage("assets/wtflol.png")
		
		self.Title = "Shooting game"
		
		
		self.Exit = panel.Create("MenuButton", self)
		self.Exit:setPos(self.w/2-100,self.h-60)
		self.Exit.text = "Exit"
		self.Exit.doClick = function(self)
			love.event.quit()
		end
		
		
		self.Play = panel.Create("MenuButton", self)
		self.Play:setPos(self.w/2-100,self.h-120)
		self.Play.text = "Play"
		self.Play.doClick = function(self)
			startRound()
		end
		
		self.Join = panel.Create("MenuButton", self)
		self.Join:setPos(self.w/2-100,self.h-180)
		self.Join.text = "Join"
		self.Join.doClick = function(this)
			self.conf.confing = this
			self.TextBox.text = "IP"
			self.box.text = "25.167.192.43"
			self.conf.text = "Join"
			self.TextBox:setVisible(true)
			self:setVisible(false)
		end
		self.Join.cClick = function(self, ip)
			startClient(ip)
		end
		
		
		self.Host = panel.Create("MenuButton", self)
		self.Host:setPos(self.w/2-100,self.h-240)
		self.Host.text = "Host"
		self.Host.doClick = function(self)
			startHost(true)
		end
		
		self.TextBox = panel.Create("Panel")
		self.TextBox:setSize(390,100)
		self.TextBox:setVisible(false)
		self.TextBox:setPos(self.x + self:getWidth()/2-self.TextBox:getWidth()/2,self.y + self:getHeight()/2-self.TextBox:getHeight()/2)
		self.TextBox.text = ""
		self.TextBox.drawOver = function(this, x, y, w, h)
		
			love.graphics.setColor(0, 0, 0)
			love.graphics.setFont(font)
			love.graphics.printf(this.text, x + 5, y, w, 'center')
		
		end
		self.box = panel.Create("TextBox", self.TextBox)
		self.box:setSize(self.TextBox:getWidth() - 20,20)
		self.box:setPos(self.TextBox:getWidth()/2 - self.box:getWidth()/2,self.TextBox:getHeight()/2 - self.box:getHeight()/2)
		self.conf = panel.Create("MenuButton", self.TextBox)
		self.conf:setSize(self.TextBox:getWidth()-40, 30)
		self.conf:setPos(self.TextBox:getWidth()/2 - self.conf:getWidth()/2, self.TextBox:getHeight() - self.conf:getHeight() - 5)
		self.conf.text = "Confirm"
		self.conf.confing = nil
		self.conf.font = arial
		self.conf.doClick = function(this)
			this.confing:cClick(self.box.text)
			self:setVisible(true)
			self.TextBox:setVisible(false)
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
		self.font = font

	end,
	
	drawOver = function(self,x,y,w,h)
		love.graphics.setFont(self.font)
		love.graphics.printf(self.text, x, y+5, w, 'center')
	end,
	
	doClick = function(self)
	end,


},"Button")