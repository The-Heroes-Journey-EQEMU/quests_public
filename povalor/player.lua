function event_click_door(e)
	local door_id = e.door:GetDoorID()
	if door_id == 3 then
		local aerin_bucket = tonumber(e.self:GetAccountBucket("pop.flags.aerin")) or 0
		local alt_access_hohonora_bucket = tonumber(e.self:GetAccountBucket("pop.alt.hohonora")) or 0
		local mavuin_bucket = tonumber(e.self:GetAccountBucket("pop.flags.mavuin")) or 0
		local tribunal_bucket = tonumber(e.self:GetAccountBucket("pop.flags.tribunal")) or 0
		local valor_bucket = tonumber(e.self:GetAccountBucket("pop.flags.valor")) or 0
		if (
			e.self:GetLevel() >= 62 or
			alt_access_hohonora_bucket == 1 or
			(
				aerin_bucket == 1 and
				mavuin_bucket == 1 and
				tribunal_bucket == 1 and
				valor_bucket == 1
			)
		) then
			if not e.self:HasZoneFlag(Zone.hohonora) then
				e.self:SetZoneFlag(Zone.hohonora)
				e.self:Message(MT.LightBlue, "You receive a character flag!")
			end
		end
	end
end