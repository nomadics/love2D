require("class")
require("animation")
gr = love.graphics

function love.load()
	gr.setBackgroundColor(255,255,255)
	img = gr.newImage("assets/sprite.png")
	
	anim = newAnimation(nil, img, 1, 16, 0, 100)
	
	obj = {
		x=100,
		y=100,
		w=32,
		h=32,
	}
	obj.anim = cloneAnimation(obj, anim)
	--obj.anim:remove()

end


function love.draw()

	gr.setColor(0,0,0,100)
	obj.anim:draw()

end

function love.update(dt)

	updateAnimations(dt)

end

	
	
	
	
	
	
	
	
	