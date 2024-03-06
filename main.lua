local ffi = require("ffi")
local readCells, writeCells;

ffi.cdef[[
void tickLifeOnBoard(void* boardRead, void* boardWrite, int width, int height)
]]

local testLib = ffi.load("LuaLifeC")


function love.load()
	
	readCells = love.image.newImageData(love.graphics.getPixelDimensions());
	for x=0, readCells:getWidth()-1 do
		for y=0, readCells:getHeight()-1 do
			if math.random() < .3 then
				readCells:setPixel(x,y,1,1,1,1);
			end
		end
	end

	
	writeCells = love.image.newImageData(love.graphics.getPixelDimensions());
	img = love.graphics.newImage(readCells)
	img:setFilter("nearest", "nearest");
end

function love.draw()
	img:replacePixels(readCells)
	love.graphics.draw(img,0,0,0,1,1);
end

function love.update()
	testLib.tickLifeOnBoard(readCells:getFFIPointer(), writeCells:getFFIPointer(), readCells:getWidth(), readCells:getHeight());

	local tmp = readCells;
	readCells = writeCells;
	writeCells = tmp;
end
