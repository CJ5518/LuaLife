--Runs a 'demo' mode, used largely by the screensaver, but available to the main program
--Default behavior is to switch between a number of different 'profiles'
--Examples of profiles can be found in the profiles folder

local life = require("life");
local profiles = require("profiles");

local demoMode = {}

local currentInstance;

--Not the best implementation but don't worry about it
local fadeAmount = 1;
local fadeOut = false;
local fadeIn = false;

local currProfile;

local function loadRandomProfile()
	currentInstance, currProfile = profiles.loadRandom();
	currProfile.timeoutFramesEdit = currProfile.timeoutFrames;
	collectgarbage();
end

local function load()
	profiles.loadProfileList();
	loadRandomProfile();
end

local function update(dt)
	currentInstance:update();

	local switchInstances = false;

	if not fadeOut then
		--Check if we need to switch instances
		if currProfile.timeoutFrames then
			currProfile.timeoutFramesEdit = currProfile.timeoutFramesEdit - 1;
			switchInstances = currProfile.timeoutFramesEdit <= 0;
		end
		if currProfile.timeout then
			switchInstances = love.timer.getTime() >= currProfile.timeout;
		end

		if switchInstances then
			fadeAmount = 1;
			fadeOut = true;
		end
	else
		if not fadeIn then
			fadeAmount = fadeAmount - (dt / 1);
			if fadeAmount <= -1 then
				fadeIn = true;
				fadeAmount = 0;
				loadRandomProfile();
			end
		else
			fadeAmount = fadeAmount + (dt / 1.5);
			if fadeAmount >= 1 then
				fadeAmount = 1;
				fadeIn = false;
				fadeOut = false;
			end
		end
	end
end

local function draw()
	currentInstance:refreshImage();
	local x,y = love.graphics.getPixelDimensions();

	love.graphics.setColor(1,1,1,fadeAmount);

	love.graphics.draw(currentInstance.image,0,0,0,x / currentInstance:getWidth(), y / currentInstance:getHeight());
end


function demoMode.init(arg)
	love.update = update;
	love.draw = draw;

	load(arg);
end

return demoMode;
