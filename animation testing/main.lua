require("class")
require("animation")
gr = love.graphics

function love.load()
	gr.setBackgroundColor(255,255,255)
	img = gr.newImage("assets/sprite.png")
	
	--Example animation
	anim = newAnimation(nil, img, 1, 16, 0, 100)--Static, not applied
	
	--Make an object
	obj = {
		x=100,
		y=100,
		w=32,
		h=32,
	}
	--Apply our animation to our object
	obj.anim = cloneAnimation(obj, anim)
	--obj.anim:remove()

end


function love.draw()
	--Draw our new animation!
	gr.setColor(0,0,0,100)
	obj.anim:draw()

end

function love.update(dt)
	--Update all of our animations!
	updateAnimations(dt)
end

	
	
	
	
	
	
	
	
	