--Handles the actual screensaver portion of things
--For the settings menu please see screensaverSettingsMenu.lua

local screensaverSettingsMenu = {}

local function load()

end

local function update(dt)

end

local function draw()

end

local function closeProgram()

end

function screensaverSettingsMenu.init()
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

return screensaverSettingsMenu;
