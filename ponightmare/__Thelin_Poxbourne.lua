function event_spawn(e)
	eq.set_timer("Depop", 600)
	eq.set_timer("Emote 1", 6)
	eq.set_timer("Emote 2", 12)
	eq.set_timer("Emote 3", 18)
end

function event_timer(e)
	if e.timer == "Depop" then
		eq.stop_timer("Depop")
		eq.depop()
	elseif e.timer == "Emote 1" then
		eq.stop_timer("Emote 1")
		e.self:Say("Terris, hear me now!  I have done as you asked.  My beloved dagger is whole once again!  Now keep up your part of the bargain.")
		eq.signal(204065, 1, 0) -- #Terris_Thule
	elseif e.timer == "Emote 2" then
		eq.stop_timer("Emote 2")
		e.self:Say("Vile wench, I knew in the end it would come to this.  You shall pay dearly for your injustice here.")
		eq.signal(204065, 2, 0) -- #Terris_Thule
	elseif e.timer == "Emote 3" then
		eq.stop_timer("Emote 3")
		e.self:Say("So then my hope is nearly lost.  Take my dagger with you and plunge it deep into her soulless heart.  If I cannot escape from this forsaken plane under her rules, I shall make my own!")
	end
end

function event_say(e)
	if e.message:findi("Hail") then
		e.other:Message(MT.White, "Thelin Poxbourne tells you, 'Please destroy her for subjecting me to her hideous visions.'  Thelin closes his eyes and is swept away from his nightmare.  The land of pure thought begins to vanish from around you.")
		e.other:SetAccountBucket("pop.flags.construct", "1")
		e.other:Message(MT.LightBlue, "You receive a character flag!")
	elseif e.message:findi("return") then
		e.other:MovePCInstance(204, eq.get_zone_instance_id(), -1520, 1104, 125)
	end
end