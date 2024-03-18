local life = require("life");
local screensaver = require("screensaver");
local screensaverSettingsMenu = require("screensaverSettingsMenu");
local demoMode = require("demoMode");

local readCells, writeCells;


local lifeInstance;

function love.load(arg)
	math.randomseed(os.time())
	
	if arg[1] == "/s" then
		screensaver.init();
	elseif arg[1] == "/c" then
		screensaverSettingsMenu.init();
	else
		demoMode.init();
	end
end

function love.draw()
end

function love.update()
end
