function event_spawn(e)
	eq.set_timer("Depop", 1200)
end

function event_timer(e)
	if e.timer == "Depop" then
		eq.stop_timer("Depop")
		eq.depop()
	end
end

function event_say(e)
	if e.message:findi("Hail") then
		e.other:SetAccountBucket("pop.flags.vallon", "1")
		e.other:Message(MT.LightBlue, "You receive a character flag!")
	end
end