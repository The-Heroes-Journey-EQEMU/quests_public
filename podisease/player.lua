function event_zone(e)
	eq.debug("from_zone_id " .. e.from_zone_id);
	eq.debug("from_instance_id " .. e.from_instance_id);
	eq.debug("from_instance_version " .. e.from_instance_version);
	eq.debug("zone_id " .. e.zone_id);
	eq.debug("instance_id " .. e.instance_id);
	eq.debug("instance_version " .. e.instance_version);

	if e.zone_id == Zone.codecay then
		local alder_bucket = tonumber(e.self:GetAccountBucket("pop.flags.adler")) or 0
		local alt_codecay_bucket = tonumber(e.self:GetAccountBucket("pop.alt.codecay")) or 0
		local grummus_bucket = tonumber(e.self:GetAccountBucket("pop.flags.grummus")) or 0
		if (
			not e.self:HasZoneFlag(Zone.codecay) and
			(
				e.self:GetLevel() >= 55 or
				alt_codecay_bucket == 1 or
				(
					alder_bucket == 1 and
					grummus_bucket == 1
				)
			)
		) then
			e.self:SetZoneFlag(Zone.codecay)
		end
	end
end