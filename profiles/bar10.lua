local bar10 = {}

--Does this profile force some resolution?
bar10.hasSetRes = {80,45};

--Function called with life instance, do your work here
function bar10.init(lifeInstance)
	for x=1, 10 do
		lifeInstance:setPixel(x+34,20,1);
	end
end

return bar10;
