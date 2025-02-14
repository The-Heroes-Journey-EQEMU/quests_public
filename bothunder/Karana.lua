function event_spawn(e)
	eq.set_Timer("Depop", 900)
end

function event_timer(e)
	if e.timer == "Depop" then
		eq.stop_timer("Depop")
		eq.depop()
	end
end

function event_say(e)
	local agnarr_bucket = tonumber(e.other:GetAccountBucket("pop.flags.agnarr")) or 0
	if agnarr_bucket == 1 then
		if e.message:findi("Hail") then
			local follow_path_link = eq.silent_say_link("follow the path of the Fallen")
			e.self:Emote(
				string.format(
					"looks down at %s's face. He seems so insignificant next to the massive stature of the Rainkeeper. 'Don't worry mortal, Askr is unharmed, I have set him on a journey that will take him to all corners of this reality. He will either find the balance of the Fallen or he will die trying. And what of you champions? Do you wish to [%s]? A more dangerous path has never existed. Defy the will of the Pantheon at your peril.",
					e.other:GetCleanName(),
					follow_path_link
				)
			)
		elseif e.message:findi("follow the path of the fallen") then
			e.self:Emote("begins to laugh quietly. You seem to notice a great storm cloud brewing once more above him. A sudden arching bolt hits you, but you are unharmed. Instead a tome written in the language of the gods appears in your hands. 'Then let what I know be yours to know as well. Your path leads you onward $name. The path to power or ruin, the choice is up to you. Speak the words and I will send you on your way.")
			e.other:SetAccountBucket("pop.flags.karana", "1")
			e.other:Message(MT.LightBlue, "You receive a character flag!")
		elseif e.message:findi("send me on my path") then
			e.self:CastSpell(797, e.other:GetID()) -- Spell: GM Gate
		end
	end
end