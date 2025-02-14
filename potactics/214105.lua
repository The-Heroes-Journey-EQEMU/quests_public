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
		e.self:Emote("Maelin Starpyre's thoughts enter into your own. 'The singed parchment of Rallos lies in his dead hand. Bring it back to me I will translate them using the Cipher of Druzzil.'")
		e.other:SetAccountBucket("pop.flags.rallos", "1")
		e.other:Message(MT.LightBlue, "You receive a character flag!")
	end
end