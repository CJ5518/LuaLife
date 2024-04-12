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

	files = love.filesystem.getDirectoryItems("profiles/rle");
	profiles.rle = {};
	for i,v in pairs(files) do
		profiles.rle[#profiles.rle+1] = v;
	end
end

function profileModule.isProfile(name)
	for i,v in ipairs(profiles) do
		if v == name then return i,profiles end
	end

	for i,v in ipairs(profiles.cells) do
		if v == name then return i, profiles.cells end
	end

	for i,v in ipairs(profiles.rle) do
		if v == name then return i, profiles.rle end
	end
end

--Loads a profile, returns a life instance and a table of some data
--Can randomize the resolution or not, bool
function profileModule.loadProfile(name, randomRes)
	local idx,tab = profileModule.isProfile(name);
	if not idx then error("Not a profile :("); end
	local profile;

	--Lua file
	if tab == profiles then
		profile = require("profiles." .. name)

	end

	--cells file
	if tab == profiles.cells then
		profile = {};
		local file = io.open("profiles/cells/" .. name, "r");
		local lineCount, lineSize = 0,0;
		for line in file:lines() do
			if line:sub(1,1) == "!" then
			else
				lineCount = lineCount + 1;
				lineSize = math.max(lineSize, line:len());
			end
		end
		file:close();
		profile.minRes = {lineSize, lineCount};
		profile.init = function (lifeInstance)
			local fil = io.open("profiles/cells/" .. name, "r");
			local lifeStartX = math.floor(((lifeInstance:getWidth() / 2) - (lineSize / 2)) + .5);
			local lifeStartY = math.floor(((lifeInstance:getHeight() / 2) - (lineCount / 2)) + .5);
			local count = 0;
			for line in fil:lines() do
				if line:sub(1,1) == "!" then
				else
					for x = 1, line:len() do
						local char = x
						lifeInstance:setPixel(x+lifeStartX-1,count+lifeStartY,line:sub(char,char) == "O" and 1 or 0)
					end
					count = count + 1;
				end
			end
			fil:close();
		end
	end

	--rle file
	if tab == profiles.rle then
		profile = {};
		local file = io.open("profiles/rle/" .. name, "r");
		for line in file:lines() do
			if line:sub(1,1) == "#" then
			else
				local xRes, yRes = line:match("x = (%d+), y = (%d+)");
				xRes = tonumber(xRes);
				yRes = tonumber(yRes);
				profile.minRes = {xRes, yRes};
				break;
			end
		end
		profile.init = function(lifeInstance)
			local fil = io.open("profiles/rle/" .. name, "r");
			local lifeStartX = math.floor(((lifeInstance:getWidth() / 2) - (profile.minRes[1] / 2)) + .5);
			local lifeStartY = math.floor(((lifeInstance:getHeight() / 2) - (profile.minRes[2] / 2)) + .5);
			local count = 0;
			local numberStack = "";
			local pos = 0;
			for line in fil:lines() do
				if line:sub(1,1) == "#" or line:sub(1,1) == "x" then
				else
					for q = 1, line:len() do
						local char = line:sub(q,q);
						if char == "$" then count = count + (tonumber(numberStack) and tonumber(numberStack) or 1) ; pos = 0; numberStack = ""; end
						if tonumber(char) then
							numberStack = numberStack .. char;
						end
						if char == "b" then
							pos = pos + (tonumber(numberStack) and tonumber(numberStack) or 1);
							numberStack = "";
						end
						if char == "o" then
							for x = 1, (tonumber(numberStack) and tonumber(numberStack) or 1) do
								lifeInstance:setPixel(pos + lifeStartX, count + lifeStartY, 1);
								pos = pos + 1;
							end
							numberStack = "";
						end
						if char == "!" then break end

						--lifeInstance:setPixel(x+lifeStartX,count+lifeStartY,line:sub(char,char) == "O" and 1 or 0)

					end
				end
			end
			fil:close();
		end
	end

	local res;
	if profile.hasSetRes then
		res = profile.hasSetRes;
	elseif randomRes then
		res = {love.graphics.getDimensions()};
		

		local maxFactor, minFactor;
		local maxFactorDividerX = 1;
		local maxFactorDividerY = 1;
		if profile.minRes then
			maxFactorDividerX = profile.minRes[1];
			maxFactorDividerY = profile.minRes[2];
		end
		--Unreadable and uncommented math, taking a page out Landon's book
		maxFactor = math.floor(math.min(math.logBase(res[1] / maxFactorDividerX, 2), math.logBase(res[2] / maxFactorDividerY, 2))) - 1;
		maxFactor = math.min(9,maxFactor);

		if profile.minRes then
			minFactor = (maxFactor >= 3) and (maxFactor - 3) or 0;
		else
			minFactor = 0;
		end

		if maxFactor >= 1 then
			local factor = math.pow(2, math.random(minFactor, maxFactor));
			res[1] = res[1] / factor;
			res[2] = res[2] / factor;
		end
	else
		res = {love.graphics.getDimensions()}
	end

	local lifeInstance = life.new(unpack(res));
	profile.init(lifeInstance);
	return lifeInstance, profile;
end

function profileModule.loadRandom()

	--The # operator seems to only count numerical indices, in order (as an array)
	local numProfiles = #profiles + #profiles.cells + #profiles.rle;
	local profilePick = math.random(1, numProfiles);
	local name = "error";
	if profilePick <= #profiles then
		name = profiles[profilePick];
	elseif profilePick <= #profiles + #profiles.cells then
		profilePick = profilePick - #profiles;
		name = profiles.cells[profilePick];
	else
		profilePick = profilePick - #profiles;
		profilePick = profilePick - #profiles.cells;
		name = profiles.rle[profilePick];
	end
	FRAMERATE_MAX = math.random(2,30) * 5;
	return profileModule.loadProfile(name, true);

end

return profileModule;
