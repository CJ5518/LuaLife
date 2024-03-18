local randProfile = {}

--Does this profile force some resolution?
randProfile.hasSetRes = false;

--Function called with life instance, do your work here
function randProfile.init(lifeInstance)
	for x=0, lifeInstance:getWidth()-1 do
		for y=0, lifeInstance:getHeight()-1 do
			if math.random() < .2 then
				lifeInstance:setPixel(x,y,1);
			end
		end
	end
end

return randProfile;
