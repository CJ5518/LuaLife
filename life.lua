--Holds a game of life

local ffi = require("ffi");

ffi.cdef[[
void tickLifeOnBoard(void* boardRead, void* boardWrite, int width, int height)
]];

local lifeCLib = ffi.load("LuaLifeC")

local life = {}
life.__index = life


function life.new(x,y)
	if type(x) ~= "number" or type(y) ~= "number" then
		error("Bad args to life.new, need 2 numbers width and height");
	end

	local o = {};
	o.readCells = love.image.newImageData(x,y);
	o.writeCells = love.image.newImageData(x,y);
	o.image = love.graphics.newImage(o.readCells);
	o.image:setFilter("nearest", "nearest");
	setmetatable(o, life)

	return o;
end

function life.getWidth(self)
	return self.readCells:getWidth();
end

function life.getHeight(self)
	return self.readCells:getHeight();
end

--Where on is 1 or 0
function life.setPixel(self, x, y, on)
	return self.readCells:setPixel(x,y,on,on,on,on);
end

function life.refreshImage(self)
	self.image:replacePixels(self.readCells);
end

function life.draw(self)
	self:refreshImage();
	love.graphics.draw(self.image,0,0,0,1,1);
end

function life.update(self)
	lifeCLib.tickLifeOnBoard(
		self.readCells:getFFIPointer(),
		self.writeCells:getFFIPointer(),
		self.readCells:getWidth(),
		self.readCells:getHeight()
	);

	local tmp = self.readCells;
	self.readCells = self.writeCells;
	self.writeCells = tmp;
end

return life;
