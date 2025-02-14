function event_click_door(e)
	local door_id = e.door:GetDoorID()
	if (
		door_id == 44 or
		door_id == 45 or
		door_id == 47 or
		door_id == 48
	) then
		local flags = {
			"pop.flags.arlyxir",
			"pop.flags.dresolik",
			"pop.flags.jiva",
			"pop.flags.rallos",
			"pop.flags.rizlona",
			"pop.flags.xuzl"
		}

		for _, flag in ipairs(flags) do
			local current_flag = tonumber(e.self:GetAccountBucket(flag)) or 0
			if current_flag ~= 1 then
				e.self:Message(MT.Red, "You lack the will to use this object!")
				return
			end
		end

		e.self:MovePCInstance(Zone.solrotower, eq.get_zone_instance_id(), 0, -847, 244)
	end
end