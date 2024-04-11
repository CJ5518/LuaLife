
local screensaverSettingsMenu = {}

local function load()

end

local function update(dt)

end

local function draw()

end


function screensaverSettingsMenu.init()
	love.update = update;
	love.draw = draw;

	load();
end

return screensaverSettingsMenu;
