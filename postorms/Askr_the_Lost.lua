function event_say(e)
	local valor_bucket = tonumber(e.other:GetAccountBucket("pop.flags.valor")) or 0
	if valor_bucket == 1 then
		if e.message:findi("Hail") then
			local problem_link = eq.silent_say_link("what problem", "problem")
			e.self:Emote(
				string.format(
					"looks up at you, and when he does, you take note of the scraggly beard on his weather-worn face; the scent of ale permeates your senses and pushes you to look away slightly. In an apparent drunken stupor, Askr begins to speak with surprising clarity. 'Here to wash the windows and clean the flooring, are you? No? Well, you can't be much help then. And the likes of you obviously wouldn't be able to get rid of the massive [%s] we're having. Bah, says I. You can help me no more than any of these other vagrants. Leave me alone to my ale and my misery.'"
				)
			)
		elseif e.message:findi("what problem") then
			e.self:Say("Askr points drunkenly towards the exit of the cave. 'Have you not seen the foul denizens of destruction outside? Hrmph! Going everywhere they please, pillaging, plundering. . . I'm lucky to have survived this long. Bah, it doesn't matter, there's nothing that anyone can do to stop them, and that is why I'm still stuck here with my *hic* potions.'")
		elseif e.message:findi("continue") then
			local askr_bucket = tonumber(e.other:GetAccountBucket("pop.flags.askr")) or 0
			if askr_bucket == 1 then
				local continue_link = eq.silent_say_link("continue")
				e.self:Say(
					string.format(
						"To the south of Grenidor lay Srerendi, Shores of the Lost and the Srerendi storm giants. Born of the ocean and the cool air, they lay claim to the shores and the plains inland as their own. To the west of Grenidor lay Krendic, Sands of Chaos and the Krendic storm giants. They have skin that is thick as dirt and blend in well with their surroundings. To the north of the great mount lay Kelek`Vor, the Forest of Tears and the Kelek`Vor storm giants. They are born of the wood and take great pleasure in seeing it used to their own purposes.' [%s]",
						continue_link
					)
				)
				e.other:SetAccountBucket("pop.flags.askr", "2")
			elseif askr_bucket == 2 then
				e.self:Say("I must know if you are truly capable of defeating the storm giants that abound here. To do this, you must slay one of each of the three factions and return to me something specific to each tribe: from the Srerendi storm giants, return their shorn beard; from the Krendic storm giants, a piece of their rocky carcass; from the Kelek`Vor storm giants, the crest from their warrior garments. These three items will ensure that you indeed do have the ability to defeat the foul denizens that have seized control of these lands. When you have acquired the three of these items, seal them in this bag and return them to me, so that I know that you are indeed capable of fulfilling a hero's destiny.")
				e.other:SummonItem(17192) -- Askr's Bag of Verity
			end
		elseif e.message:findi("It was me") then
			local askr_bucket = tonumber(e.other:GetAccountBucket("pop.flags.askr")) or 0
			if askr_bucket == 1 then
				local paying_attention_link = eq.silent_say_link("I am paying attention", "paying attention")
				e.self:Say(
					string.format(
						"Truly, I am amazed that someone of your caliber was able to do what I could not. I have been stuck in these desolate caves for so long, I had almost lost hope that I would ever find a way to get rid of those accursed giants. But you. . . you have been able to best at least one of them. It is reasonable to suggest that if you are able to dispatch one, you may be able to dispatch others. I need to know for sure if you are as capable an individual as it appears you are. This is very important, so are you [%s]?",
						paying_attention_link
					)
				)
			end
		elseif e.message:findi("I am paying attention") then
			local askr_bucket = tonumber(e.other:GetAccountBucket("pop.flags.askr")) or 0
			if askr_bucket == 1 then
				local continue_link = eq.silent_say_link("continue")
				e.self:Say(
					string.format(
						"This place was once beautiful and serene, with the great Karana's showers falling day and night soothing the lands and the creatures that inhabit it. Alas, there was an invasion of a superior force -- the storm giants which you have encountered. They laid waste to the lands, burned down trees, and have caused so much havoc I don't even know what is to become of it. Originally, they came as one group and crossed the breadth of the land pillaging and plundering all that they could find. Over time, though, they grew apart and distinct factions grew around Mount Grenidor.' [%s]",
						continue_link
					)
				)
			end
		elseif e.message:findi("Bastion of Thunder") then
			local askr_bucket = tonumber(e.other:GetAccountBucket("pop.flags.askr")) or 0
			if askr_bucket == 3 then
				e.self:Say("To be honest, I cannot say that it is entirely possible, what with the ferocity of the giants and their reluctance to leave the lands they now inhabit. From what I do know, each of the Leaders of each tribe has one piece to allow entrance into the Bastion of Thunder. When two of these pieces are combined, they form an esoteric medallion that allows instant passage to the thunderous plains beyond. If you can find and seal two pieces of the medallion in this bag, I will be able to forge them into the medallion that will help you on your journey.")
				e.other:SummonItem(17192) -- Askr's Bag of Verity
			end
		end
	end
end

function event_trade(e)
	local item_lib = require("items")
	local valor_bucket = tonumber(e.other:GetAccountBucket("pop.flags.valor")) or 0
	if valor_bucket == 2 then
		local askr_bucket = tonumber(e.other:GetAccountBucket("pop.flags.askr")) or 0
		if askr_bucket == 0 then
			if (
				item_lib.check_turn_in(e.trade, {item1 = 11486}) or
				item_lib.check_turn_in(e.trade, {item1 = 28749}) or
				item_lib.check_turn_in(e.trade, {item1 = 28781}) or
				item_lib.check_turn_in(e.trade, {item1 = 28782}) or
			) then
				e.self:Say("The drunken stupor that Askr had been in earlier appears to vanish in an instant; a glimmer of hope now flashes in the depths of his eyes. 'This is the head of a giant. . . a storm giant from outside the caves.' Askr ponders what this revelation could mean. He mutters to himself, 'If it is possible that someone has indeed bested a giant here in the planes, then perhaps it is possible. . .' He looks back at you very sternly and asks, 'Tell me now and be truthful, was it you who severed the head of this giant from his body?'")
				e.other:SetAccountBucket("pop.flags.askr", "1")
			end
		elseif askr_bucket == 2 then
			if item_lib.check_turn_in(e.trade, {item1 = 11487}) then
				e.self:Emote("looks over the remnants of the storm giants in his hands then looks up at you with a glimmer of hope in his eyes. 'Then it's true! You have the means to push back the scourge of giants. . . you must go forth to the Bastion of Thunder and finish there what you have started here. It is imperative that you clear the forces of giants from the Bastion so that order can be restored to the thunderous reaches beyond.'")
				e.other:SetAccountBucket("pop.flags.askr", "3")
			end
		elseif askr_bucket == 3 then
			if item_lib.check_turn_in(e.trade, {item1 = 11488}) then
				e.self:Emote("The mystical medallion given to you by Askr settles around your neck and then disappears into nothingness. There is no call for alarm, for the medallion is now a part of your soul. Askr the Lost says 'You have retrieved the pieces! You are well on your way to pushing forth on your quest to return balance to the plains of thunder. The most difficult part lies before you. . . deep in the heart of Mount Grenidor, there is a tempest that rages on eternally. It is there that you must present your medallion to the skies above to be transported to the citadel of thunderous might. Take the medallion and go forth, then deliver these storm giants to their creator!'")
				e.other:SetAccountBucket("pop.flags.askr", "4")
				e.other:Message(MT.LightBlue, "You receive a character flag!")
			end
		end
	end

	item_lib.return_items(e.self, e.other, e.trade)
end