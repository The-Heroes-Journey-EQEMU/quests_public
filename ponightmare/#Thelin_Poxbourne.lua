function event_signal(e)
	if e.signal == 5 then
		eq.stop_timer("Reset")
		e.self:DeleteEntityVariable("Entries")
	end
end

function event_timer(e)
	if e.timer == "Reset" then
		eq.stop_timer("Reset")
		e.self:DeleteEntityVariable("Entries")
		e.self:Shout("Hedge trial is now open.")
	elseif e.timer == "Reset Trigger" then
		eq.stop_timer("Reset Trigger")
		eq.set_timer("Reset", 7200)
	end
end

function event_say(e)
	local hedge_bucket = tonumber(e.other:GetAccountBucket("pop.flags.hedge")) or 0
	local entries_variable = tonumber(e.self:GetEntityVariable("Entries")) or 0
	if e.message:findi("Hail") then
		if hedge_bucket == 0 then
			e.self:Emote("screams loudly, and then falls asleep once again.")
		elseif hedge_bucket == 1 and
			if entries_variable >= 1 and entries_variable <= 18 then
				local ready_link = eq.silent_say_link("ready")
				e.self:Say(
					string.format(
						"You there! You have talked to Adroha Jezith? Then I assume you are here to help me! ... Tell me when you are [%s] to begin, I will lead you through the maze and we, together, will end this endless torment!",
						ready_link
					)
				)
			elseif entries_variable >= 19 then
				e.self:Say("I do not have time for this.")
			end
		end
	elseif e.message:findi("ready") then
		if hedge_bucket == 1 then
			e.self:Emote("closes his eyes and falls asleep immediately.  He looks peaceful for a moment and then screams in agony!")
			e.other:MovePCInstance(Zone.ponightmare, eq.get_zone_instance_id(), -4774, 5198, 4)
			e.self:SetEntityVariable("Entries", entries_variable + 1)
			if entries_variable == 0 then
				eq.signal(204058, 5, 300) -- NPC: Hedge_Trigger
				eq.set_timer("Ready Trigger", 600)
			end
		end
	end
end