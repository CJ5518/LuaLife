local bar10 = {}

--Does this profile force some resolution?
bar10.hasSetRes = {32,18};

--Function called with life instance, do your work here
function bar10.init(lifeInstance)
	for x=1, 10 do
		lifeInstance:setPixel(x+10,8,1);
	end
	bar10.timeout = love.timer.getTime() + 3;
	FRAMERATE_MAX = 5;
end

return bar10;
