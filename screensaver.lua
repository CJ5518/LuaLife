--Handles the actual screensaver portion of things
--For the settings menu please see screensaverSettingsMenu.lua
local life = require("life")
local demoMode = require("demoMode");

local screensaver = {}

local lifeInstance;

local function load()
	demoMode.init()
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
