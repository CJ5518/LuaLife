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
		demoMode.init(arg);
	end
end

function love.draw()
end

function love.update()
end

FRAMERATE_MAX = 40000;

--Override love.run because I am gigachad
function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		local startTime = love.timer.getTime();

		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		local frameTime = (love.timer.getTime() - startTime);
		
		love.timer.sleep((1/FRAMERATE_MAX) - frameTime);
	end
end

