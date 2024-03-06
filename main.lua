
local readCells, writeCells;

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
	for x=0, readCells:getWidth()-1 do
		for y=0, readCells:getHeight()-1 do
			--Get neighbors, no wrapping
			local neighborCount = 0;
			do
				--To the left
				if x - 1 >= 0 then
					if y - 1 >= 0 then
						neighborCount = neighborCount + readCells:getPixel(x-1,y-1);
					end
					if y + 1 < readCells:getHeight() then
						neighborCount = neighborCount + readCells:getPixel(x-1,y+1);
					end
					neighborCount = neighborCount + readCells:getPixel(x-1,y);
				end
				--To the right
				if x + 1 < readCells:getWidth() then
					if y - 1 >= 0 then
						neighborCount = neighborCount + readCells:getPixel(x+1,y-1);
					end
					if y + 1 < readCells:getHeight() then
						neighborCount = neighborCount + readCells:getPixel(x+1,y+1);
					end
					neighborCount = neighborCount + readCells:getPixel(x+1,y);
				end

				--In the middle
				if y - 1 >= 0 then
					neighborCount = neighborCount + readCells:getPixel(x,y-1);
				end
				if y + 1 < readCells:getHeight() then
					neighborCount = neighborCount + readCells:getPixel(x,y+1);
				end
			end

			--If we're alive
			if readCells:getPixel(x,y) == 1 then
				if neighborCount == 3 or neighborCount == 2 then
					--Live on, otherwise dies
					writeCells:setPixel(x,y,1,1,1,1);
				else
					writeCells:setPixel(x,y,0,0,0,0);
				end
			else
				if neighborCount == 3 then
					--Live new, otherwise stay died
					writeCells:setPixel(x,y,1,1,1,1);
				else
					writeCells:setPixel(x,y,0,0,0,0);
				end
			end
		end
	end

	--Swap things
	local tmp = readCells;
	readCells = writeCells;
	writeCells = tmp;
end
