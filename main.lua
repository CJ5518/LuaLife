local life = require("life");
local screensaver = require("screensaver");
local screensaverSettingsMenu = require("screensaverSettingsMenu");

local readCells, writeCells;


local lifeInstance;

function love.load(arg)
	if arg[1] == "/s" then
		screensaver.init();
	elseif arg[1] == "/c" then
		screensaverSettingsMenu.init();
	else
		lifeInstance = life.new(love.graphics.getPixelDimensions());
		for x=0, lifeInstance:getWidth()-1 do
			for y=0, lifeInstance:getHeight()-1 do
				if math.random() < .2 then
					lifeInstance:setPixel(x,y,1);
				end
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
