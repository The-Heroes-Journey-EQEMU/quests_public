function event_say(e)
	local alder_bucket = tonumber(e.other:GetAccountBucket("pop.flags.adler")) or 0
	local elder_bucket = tonumber(e.other:GetAccountBucket("pop.flags.elder")) or 0
	local grummus_bucket = tonumber(e.other:GetAccountBucket("pop.flags.grummus")) or 0
	if (
		alder_bucket == 1 and
		elder_bucket == 1 and
		grummus_bucket == 1
	) then
		e.self:Message(MT.LightBlue, "Elder Fuirstel slowly turns towards you. You can feel the heat radiating from his face. The warding that envelopes your body reaches out and begins to surround him. You immediately see improvement in his condition. The pus filled sores covering his face and his burning fever start to vanish.")
		e.other:SetAccountBucket("pop.flags.elder", "1")
		e.other:Message(MT.LightBlue, "You receive a character flag!")
	else
		local bertox_bucket = tonumber(e.other:GetAccountBucket("pop.flags.bertox")) or 0
		if bertox_bucket == 1 then
			e.self:Emote("Elder Fuirstel looks surprisingly better than when you last saw him. Elder Fuirstel says 'You actually did it! You defeated Bertoxxulous! I could feel it the moment he fell. Thank you very much, $name. You have done this world a great service.'")
			e.other:SetAccountBucket("pop.flags.codecay", "2")
			e.other:Message(MT.LightBlue, "You receive a character flag!")
		end
	end
end