function event_say(e)
	local flags = {
		["pop.alt.codecay"] = 1,
		["pop.alt.hedge"] = 1,
		["pop.alt.hohonora"] = 1,
		["pop.alt.potactics"] = 1,
		["pop.alt.solrotower"] = 1,
		["pop.flags.aerin"] = 1,
		["pop.flags.agnarr"] = 1,
		["pop.flags.adler"] = 1,
		["pop.flags.anthone"] = 1,
		["pop.flags.arbitor"] = 1,
		["pop.flags.arlyxir"] = 1,
		["pop.flags.askr"] = 4,
		["pop.flags.behemoth"] = 2,
		["pop.flags.bertox"] = 1,
		["pop.flags.codecay"] = 2,
		["pop.flags.coirnav"] = 1,
		["pop.flags.construct"] = 1,
		["pop.flags.dresolik"] = 1,
		["pop.flags.elder"] = 1,
		["pop.flags.faye"] = 1,
		["pop.flags.fennin"] = 1,
		["pop.flags.garn"] = 1,
		["pop.flags.grummus"] = 1,
		["pop.flags.hedge"] = 1,
		["pop.flags.jiva"] = 1,
		["pop.flags.karana"] = 1,
		["pop.flags.librarian"] = 1,
		["pop.flags.maelin"] = 1,
		["pop.flags.marr"] = 1,
		["pop.flags.mavuin"] = 1,
		["pop.flags.newleaf"] = 1,
		["pop.flags.poxbourne"] = 1,
		["pop.flags.rallos"] = 1,
		["pop.flags.rathe"] = 1,
		["pop.flags.saryrn"] = 2,
		["pop.flags.shadyglade"] = 1,
		["pop.flags.terris"] = 1,
		["pop.flags.tribunal"] = 1,
		["pop.flags.trell"] = 1,
		["pop.flags.valor"] = 1,
		["pop.flags.xanamech"] = 1
	}

	if e.message:findi("Hail") then
		for flag, required_value in pairs(flags) do
			local flag_value = tonumber(e.other:GetAccountBucket(flag)) or 0
			local status_message = (flag == required_value) and "Complete" or "Incomplete"
			local status_link = eq.silent_say_link(status_message)

			local type = (flag:findi("pop.flags")) and "Flag" or "Alternate Access"
			local match_string = (flag:findi("pop.flags")) and "pop.flags." or "pop.alt."
			local flag_name = string.gsub("^%1", string.gsub(flag, match_string, "").upper)

			e.other:Message(
				MT.Yellow,
				string.format(
					"%s %s | %s",
					flag_name,
					type,
					status_link
				)
			)
		end
	end
end