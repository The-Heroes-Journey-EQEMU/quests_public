--#Avatar_of_Dust (215404)
--Triggered by Isle #5 Sigismond_Windwalker Event
--poair

function event_spawn(e)
	eq.set_timer("depop", 45 * 60 * 1000);	--45 min depop
end

function event_combat(e)
	if e.joined then
		eq.set_timer("memblur",12 * 1000);
	end
end

function event_timer(e)
	if e.timer == "depop" then
		SetGlobal();	--this is a blowable spawn.  Setting the global even if failure
		eq.depop();
	elseif e.timer == "memblur" then
		if e.self:IsEngaged() then
			if math.random(100) <= 30 then e.self:WipeHateList() end  	--30% memblur chance
		elseif not e.self:IsEngaged() then
			eq.stop_timer(e.timer);
		end
	end
end

function event_death_complete(e)
	eq.signal(215438 , 215404); -- NPC: zone_status npc, originating npc
	SetGlobal();
	e.self:DeathNotification(e);
end

function SetGlobal()
	local instance_id = eq.get_zone_instance_id();
	eq.set_global(instance_id .. "_AoDust_PoAir", "1",3,"H6");
end

