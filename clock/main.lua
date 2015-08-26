
require("clock")
gr = love.graphics

function love.load()
	gr.setBackgroundColor(100,200,100)

	c = newClock(100,100,200,200,CLOCK_TYPE_CIRCLE,"gfx/circle.png")
	cc = newClock(300,300,50,50,CLOCK_TYPE_CIRCLE,"gfx/circle.png")

end

function love.draw()
	drawClocks()

end

function love.update(dt)

end