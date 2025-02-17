function event_spawn(e)
	eq.set_timer("Depop", 600)
end

function event_timer(e)
	if e.timer == "Depop" then
		eq.spawn_condition(eq.get_zone_short_name(), eq.get_zone_instance_id(), 2, 0)
		eq.stop_timer("Depop")
		eq.depop()
	end
end

function event_say(e)
	if e.message:findi("Hail") then
		e.other:SummonItem(29147) -- Item: Globe of Dancing Flame
		e.other:SetAccountBucket("pop.flags.fennin")
		e.other:Message(MT.LightBlue, "You receive a character flag!")
	end
end