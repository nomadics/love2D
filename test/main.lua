Net = require("lib/Net")

require("lib.json")
require("util")
require("color")
require("class")
require("panel")
require("button")
require("connections")

require("mapping.compression")

require("textbox")
require("menu")

require("player")
require("ammo/bullet")
require("camera")

ScrW = love.graphics.getWidth()
ScrH = love.graphics.getHeight()

local canvas
local menu
font = nil

sceneId = 1
scene = nil
scenes = {
}


tickrate = 16

function setScene(id)
	if sceneId~=id then
		panel.focus = nil
	end

	if not scenes[id] then
		scenes[id] = {}
	end
	panel:setScene(id)
	sceneId = id
	scene = scenes[id]
	
end


function beginCallback(fixture1, fixture2, contact)
	print(fixture1, fixture2)
end

function love.load()

	math.randomseed(os.time())


	love.filesystem.createDirectory("customlevels")
	
	gr = love.graphics
	font = love.graphics.newFont( "AcademyBlah.ttf", 40 )
	arial = love.graphics.newFont( "arial.ttf", 16)
	love.graphics.setFont(font)
	local cursor = love.mouse.newCursor("assets/cursor.png",0,0)
	love.mouse.setCursor(cursor)
	love.graphics.setBackgroundColor(Color(38,134,166))
	
	setScene(1)
	
	menu = panel.Create("Menu")
	
	love.keyboard.setKeyRepeat(0.1, 1)
	require("mapping.map")
	
	
end

function love.update(dt)
	panel:update(dt)
	getHoveredPanel()
	playerhandler.update(dt)
	updateBullets(dt)
	
	Net:update(dt)
	netThink(dt)
	--updateMap()
	--print(sceneId)
end

function love.draw()

	camera:set()

	
	
	--Everything else
	love.graphics.setColor(Color(255,255,255))
	--love.graphics.draw(canvas)
	
	
		
		
	gr.setColor( 0, 0, 0)
	gr.point(ScrW/2,ScrH/2)
	
	drawMap()
	
	drawBullets()
	
	
	playerhandler.draw()
	
	camera:unset()
	--draw all panels
	
	
	panel:draw()
	
	love.graphics.setColor(Color(0,0,0))
	love.graphics.print("FPS."..love.timer.getFPS(), 5, 5)
	
	
	
end

function love.mousepressed(x, y, mouse)

	panel:mousepressed(mouse)
	
end

function love.mousemoved( x, y, dx, dy )

	panel:mousemoved(dx,dy)

end


function love.textinput( key )

	panel:keypressed(key)

end

function love.keypressed(key)
	if key=="backspace" then
		panel:keypressed(key)
	end
end

function startRound()
	setScene(2)
	playerhandler.create(-1, true)
end