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
		e.other:Message(MT.DarkGray, "The Planar Projection seems to flicker in and out of existence. It seems to be impressed and grateful for the death of Saryrn.")
		e.other:SetAccountBucket("pop.flags.saryrn", "1")
		e.other:Message(MT.LightBlue, "You receive a character flag!")
		-- plugin::SetSubFlag($client, 'GoD', 'Saryrn', 1); -- Needs a Lua equivalent?
	end
end