--Handles the profiles

local life = require("life")
local profileModule = {};

local profiles = {};

function profileModule.loadProfileList()
	--Get list of the available profiles
	local files = love.filesystem.getDirectoryItems("profiles");
	for i,v in pairs(files) do
		if v:sub(v:len()-3) == ".lua" then
			profiles[#profiles + 1] = v:sub(0,v:len()-4);
			if v:sub(0,v:len()-4) == arg[1] then
				argIsProfile = true;
			end
		end
	end

	files = love.filesystem.getDirectoryItems("profiles/cells");
	profiles.cells = {};
	for i,v in pairs(files) do
		profiles.cells[#profiles.cells+1] = v;
	end
end

function profileModule.isProfile(name)
	for i,v in ipairs(profiles) do
		if v == name then return i,profiles end
	end

	for i,v in ipairs(profiles.cells) do
		if v == name then return i, profiles.cells end
	end
end

--Loads a profile, returns a life instance and a table of some data
--Can randomize the resolution or not, bool
function profileModule.loadProfile(name, randomRes)
	local idx,tab = profileModule.isProfile(name);
	local profile;

	--Lua file
	if tab == profiles then
		profile = require("profiles." .. name)

	end

	--cells file
	if tab == profiles.cells then
		
	end

	local res;
	if profile.hasSetRes then
		res = profile.hasSetRes;
	elseif randomRes then
		res = {love.graphics.getDimensions()}
	else
		res = {love.graphics.getDimensions()}
	end

	local lifeInstance = life.new(unpack(res));
	profile.init(lifeInstance);
	return lifeInstance, profile;
end

function profileModule.loadRandom()
	return profileModule.loadProfile("random", false);
end

return profileModule;
