--#Gakamenial_Fir`Disralsi
--poair


function event_combat(e)
	if e.joined then
		eq.set_timer("memblur",12 * 1000);
	end
end

function event_timer(e)
	if e.timer == "memblur"  then
		if e.self:IsEngaged() then
			if math.random(100) <= 30 then e.self:WipeHateList() end  	--30% memblur chance
		elseif not e.self:IsEngaged() then
			eq.stop_timer(e.timer);
		end
	end
end

