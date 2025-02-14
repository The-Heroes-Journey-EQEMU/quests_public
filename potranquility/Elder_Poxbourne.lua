function event_say(e)
	local poxbourne_bucket = tonumber(e.other:GetAccountBucket("pop.flags.poxbourne")) or 0
	local terris_bucket = tonumber(e.other:GetAccountBucket("pop.flags.terris")) or 0
	if poxbourner_bucket == 1 and terris_bucket == 1 then
		if e.message:findi("Hail") then
			e.self:Say("Finally, after all this time, my mind is at peace... thank you, $name, Subduer of Torment.")
			e.other:SetAccountBucket("pop.flags.poxbourne", "1")
			e.other:Message(MT.LightBlue, "You receive a character flag!")
		end
	end
end