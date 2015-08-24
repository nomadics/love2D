require("lib.json")
ScrW = love.graphics.getWidth()
ScrH = love.graphics.getHeight()

require("util")
require("color")
require("class")
require("panel")
require("button")

require("camera")
require("mapping.compression")
require("mapping.map")

require("textbox")
require("textlabel")
require("menu")

local canvas
local menu
font = nil

sceneId = 1
scene = nil
scenes = {
}

drawGrid = true

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


function love.load()

	math.randomseed(os.time())

	gr = love.graphics
	arialsmall = love.graphics.newFont( "arial.ttf", 16)
	arialnormal = love.graphics.newFont( "arial.ttf", 24)
	ariallarge = love.graphics.newFont( "arial.ttf", 32)
	
	love.graphics.setBackgroundColor(Color(200,200,200))
	
	setScene(0)--Map Editor
	
	editormenu = panel.Create("EditorMenu")
	
	setScene(1)--Load
	
	loadmenu = panel.Create("LoadMenu")
	
	setScene(-1)--Menu
	
	menu = panel.Create("Menu")
	
	love.keyboard.setKeyRepeat(0.1, 1)
	
	love.filesystem.createDirectory("maps")
	
	newMapGrid()
	print("?")
	
end

function love.update(dt)
	panel:update(dt)
	getHoveredPanel()
	
	if love.mouse.isDown("m") then
		if not hoveredPanel then
			movingScreen = true
		end
	else
		movingScreen = false
	end
end

function love.draw()
	camera:set()
	
	
		
		
		--gr.setColor( 0, 0, 0)
		--gr.point(ScrW/2,ScrH/2)
	
		if sceneId==0 then
			drawMap()
		end
	
	camera:unset()
	
	if sceneId==0 then
		drawMapGrid()
	end
	--draw all panels
	panel:draw()
	
	
	love.graphics.setFont(arialnormal)
	love.graphics.setColor(Color(0,0,0))
	love.graphics.print("FPS."..love.timer.getFPS(), 5, 5)
	
	
	
end

movingScreen = false

local drawing = false

function love.mousereleased(x, y, mouse)

	if mouse=="l" or mouse=="r" then
		drawing = false
	end

end


function getGridPos(x,y)
	local s = camera.scaleX
	
	local d = map.size
	
	local x, y = love.mouse.getPosition()
	x = math.floor(x / d)+map.zero.x
	y = math.floor(y / d)+map.zero.y

	return x,y
end

function drawPoint(x,y,mouse)
	x,y = getGridPos(x,y)
	--print(x,y)
		
	if mouse=="l" then
		addPoint(x, y)
		drawing = "l"
	elseif mouse=="r" then
		removePoint(x,y)
		drawing = "r"
	end
end

function love.mousepressed(x, y, mouse)
	
	local old = camera.scaleX
	
	if mouse=="wd" then
		--print("swag")
		
		camera:scale(2)
		
		camera.scaleX = math.clamp(camera.scaleX,1,32)
		camera.scaleY = camera.scaleX
		
		--local x = (camera.x + ScrW) * camera.scaleX 
		--local y = (camera.y + ScrH) * camera.scaleY
		
		if old~=camera.scaleX then
			camera.x = camera.x - (ScrW*camera.scaleX)/4
			camera.y = camera.y - (ScrH*camera.scaleY)/4
		end
		
		newMapGrid()
	end
	
	if mouse=="wu" then
	
		camera:scale(.5)
		camera.scaleX = math.clamp(camera.scaleX,1,32)
		camera.scaleY = camera.scaleX
		
		if old~=camera.scaleX then
			local x = love.mouse.getX() * camera.scaleX
			local y = love.mouse.getY() * camera.scaleX
		
			camera.x = camera.x + x
			camera.y = camera.y + y
		end
		
		newMapGrid()
	end
	
	if (mouse=="l" or mouse=="r") and not hoveredPanel then
		
		drawPoint(x,y,mouse)
		--print(x+map.zero.x,y+map.zero.y)
	end
	
	panel:mousepressed(mouse)
	
end

function love.mousemoved( x, y, dx, dy )

	if movingScreen then
		camera.x = camera.x - dx * camera.scaleX
		camera.y = camera.y - dy * camera.scaleX
	
		--love.mouse.setPosition(x - dx, y - dy)
	
	end
	
	if drawing then
	
		drawPoint(x,y,drawing)
	
	end

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