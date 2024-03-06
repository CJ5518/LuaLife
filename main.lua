local life = require("life");
local readCells, writeCells;


local lifeInstance;

function love.load()
	lifeInstance = life.new(love.graphics.getPixelDimensions());
	for x=0, lifeInstance:getWidth()-1 do
		for y=0, lifeInstance:getHeight()-1 do
			if math.random() < .2 then
				lifeInstance:setPixel(x,y,1);
			end
		end
	end
end

function love.draw()
	lifeInstance:draw();
end

function love.update()
	lifeInstance:update();
end
