--Handles the actual screensaver portion of things
--For the settings menu please see screensaverSettingsMenu.lua
local life = require("life")

local screensaver = {}

local lifeInstance;

local function load()
    lifeInstance = life.new(love.graphics.getPixelDimensions());
    for x=0, lifeInstance:getWidth()-1 do
        for y=0, lifeInstance:getHeight()-1 do
            if math.random() < .2 then
                lifeInstance:setPixel(x,y,1);
            end
        end
    end
end

local function update(dt)
    lifeInstance:update();
end

local function draw()
	lifeInstance:draw();
end

local timesCloseProgramCalled = 0;
local function closeProgram()
	--Mouse moved is called instantly no matter what, need to avoid that happening
	if timesCloseProgramCalled > 0 then
		love.event.quit();
	end
	timesCloseProgramCalled = timesCloseProgramCalled + 1;
end

function screensaver.init()
	love.update = update;
	love.draw = draw;
	love.textinput = closeProgram;
	love.keypressed = closeProgram;
	love.keyreleased = closeProgram;
	love.mousemoved = closeProgram;
	love.mousepressed = closeProgram;
	love.mousereleased = closeProgram;
	love.wheelmoved = closeProgram;

	load();
end

return screensaver;
