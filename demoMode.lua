--Runs a 'demo' mode, used largely by the screensaver, but available to the main program
--Default behavior is to switch between a number of different 'profiles'
--Examples of profiles can be found in the profiles folder

local life = require("life")

local demoMode = {}

--Full immutable list of profiles
local profiles = {};

--Mutable list of profiles, used in the shuffle process so we don't get repeats
local profilesRemover = {};

local currentInstance;
local oldInstance;

local function loadRandomProfile()
	if #profilesRemover == 0 then
		for i, v in pairs(profiles) do
			profilesRemover[i] = v;
		end
	end

	local index = math.random(#profilesRemover);
	local profileName = profilesRemover[index];
	table.remove(profilesRemover, index);

	local profileData = require("profiles." .. profileName);

	local res;
	if not profileData.hasSetRes then
		--Make up a resolution
		res = {love.graphics.getPixelDimensions()};
	else
		--Profile has set res
		res = profileData.hasSetRes;
	end

	currentInstance = life.new(unpack(res));
	profileData.init(currentInstance);
end

local function load()
	--Get list of the available profiles
	files = love.filesystem.getDirectoryItems("profiles");
	for i,v in pairs(files) do
		if v:sub(v:len()-3) == ".lua" then
			profiles[#profiles + 1] = v:sub(0,v:len()-4);
		end
	end

	loadRandomProfile();
end

local function update(dt)
	currentInstance:update()
end

local function draw()
	currentInstance:refreshImage();
	local x,y = love.graphics.getPixelDimensions();
	love.graphics.draw(currentInstance.image,0,0,0,x / currentInstance:getWidth(), y / currentInstance:getHeight());
end


function demoMode.init()
	love.update = update;
	love.draw = draw;

	load();
end

return demoMode;
