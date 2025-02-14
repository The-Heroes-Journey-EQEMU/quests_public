function event_scale_calc(e)
	local flags = {
		["pop.flags.aerin"] = 1,
		["pop.flags.askr"] = 4,
		["pop.flags.behemoth"] = 2,
		["pop.flags.codecay"] = 2,
		["pop.flags.elder"] = 1,
		["pop.flags.librarian"] = 1,
		["pop.flags.maelin"] = 1,
		["pop.flags.marr"] = 1,
		["pop.flags.solusek"] = 1,
		["pop.flags.valor"] = 1
	}

	local flag_count = 0
	for flag, required_value in pairs(flags) do
		local current_bucket = tonumber(e.other:GetAccountBucket(flag)) or 0
		if current_bucket == required_value then
			flag_count = flag_count + 1
			break
		end
	end

	e.self:SetScale(flag_count / 10);
end