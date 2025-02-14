function event_say(e)
	if e.message:findi("Hail") then
		local construct_bucket = tonumber(e.other:GetAccountBucket("pop.flags.construct")) or 0
		local hedge_bucket = tonumber(e.other:GetAccountBucket("pop.flags.hedge")) or 0
		local hedge_alt_bucket = tonumber(e.other:GetAccountBucket("pop.alt.hedge")) or 0
		local poxbourne_bucket = tonumber(e.other:GetAccountBucket("pop.flags.poxbourne")) or 0
		local saryrn_bucket = tonumber(e.other:GetAccountBucket("pop.flags.saryrn")) or 0
		local terris_bucket = tonumber(e.other:GetAccountBucket("pop.flags.terris")) or 0
		if saryrn_bucket == 4 then
			if hedge_alt_bucket == 0 or hedge_alt_bucket == 1 then
				if (
					construct_bucket == 0 and
					hedge_bucket == 0 and
					poxbourne_bucket == 0 and
					terris_bucket == 0
				) then
					local believe_link = eq.silent_say_link("believe")
					e.self:Say(
						string.format(
							"Excellent work %s, I hear great things of you from Odaen. I have more work for you if you wish to help. Do you [%s] that we can help another suffering soul?",
							e.other:GetCleanName(),
							believe_link
						)
					)
				end
			elseif hedge_alt_bucket == 2 then
				e.self:Say(
					string.format(
						"%s we have done it! I heard all about your adventures into the Plane of Nightmare from Kelletia. Do you believe it? I always believed that you believed that we could do it and look we have done it! Our work here is done friend.",
						e.other:GetCleanName()
					)
				)
				e.other:SetZoneFlag(221) -- Plane of Torment

				e.other:SetAccountBucket("pop.flags.terris", "1")
				e.other:Message(MT.LightBlue, "You receive a character flag!");
				e.other:SetAccountBucket("pop.flags.poxbourne", "1")
				e.other:Message(MT.LightBlue, "You receive a character flag!");
				e.other:SetAccountBucket("pop.flags.hedge", "1")
				e.other:Message(MT.LightBlue, "You receive a character flag!");
				e.other:SetAccountBucket("pop.flags.construct", "1")
				e.other:Message(MT.LightBlue, "You receive a character flag!");

				e.other:SetAccountBucket("pop.alt.hedge", "3")
			elseif hedge_alt_bucket == 3 then
				local mylik_link = eq.silent_say_link("Mylik")
				e.self:Say(
					string.format(
						"Excellent work $name, but there is no time to waste. [%s] needs our help.",
						mylik_link
					)
				)
			end
		else
			local illness_link = eq.silent_say_link("illness")
			e.self:Say(
				string.format(
					"Greetings fellow adventurer, I can see that you're interested in curing the [%s] that seeps through Norrath.",
					illness_link
				)
			)
		end
	elseif e.message:findi("believe") then
		local nightmares_link = eq.silent_say_link("nightmares")
		e.self:Say(
			string.format(
				"We will see how much you believe in my powers and your abilities. This man Thelin over here is lost in a world of Nightmares. Thelin was once a great man who opened a portal to the Plane of Nightmare is now a weak man trapped inside his own [%s].",
				nightmares_link
			)
		)
	elseif e.message:findi("nightmares") then
		local jeweled_dagger_link = eq.silent_say_link("jeweled dagger")
		e.self:Say(
			string.format(
				"Thelin had used all of his energy to open the portal to the Plane of Nightmare. He went home that day and fell asleep clutching a [%s] that was once given to him. While sleeping, he had this terrible nightmare and he started to toss and turn from the vision that was sent to him. He tossed and turned so much that he landed on the dagger and critically injured himself. The elders found him in time and were able to save him but he has slipped into a coma and is in an endless world of nightmares.",
				jeweled_dagger_link
			)
		)
	elseif e.message:findi("jeweled dagger") then
		local find_her_link = eq.silent_say_link("find her")
		e.self:Say(
			string.format(
				"Ah yes the jeweled dagger. It was precious to him and he always kept it by his side. I believe that retrieving the dagger is the key to saving him. I have a scout inside the Plane of Nightmare trying to recover it for me. Terris Thule has broken it into many pieces and scattered it inside a maze so Thelin couldn't use it to escape his nightmares. Our scout has been gone for awhile now and I'm getting worried. Can you [%s] and assist her in bringing the jeweled dagger back to me?",
				find_her_link
			)
		)
	elseif e.message:findi("find her") then
		e.self:Say("Excellent her name is Kelletia. She is one of our best scouts.")
	elseif e.message:findi("illness") then
		local you_link = eq.silent_say_link("me", "you")
		e.self:Say(
			string.format(
				"$name, look at these people. Their minds are being tormented, they are diseased and their souls are decaying more and more each day. You only see four in front of you but tomorrow it might be eight and the day after it could be hundreds. Who knows, it might even be [%s] on your sick bed.",
				you_link
			)
		)
	elseif e.message:findi("me") then
		local help_me_link = eq.silent_say_link("help you", "help me")
		e.self:Say(
			string.format(
				"Yes $name even you. You have to believe that I can help these people. You need to believe that I can help you. You need to believe that you can help me. I believe you can help me. Will you [%s] save these people?",
				help_me_link
			)
		)
	elseif e.message:findi("help you") then
		e.self:Say("Then let's get started! This man Tylis suffers from mental torment. Look at him $name he is in pain. His illness is no ordinary illness. Someone is controlling his mind and we need to stop the source ofthis torment. You can find the one who controls his mind inside the Plane of Torment. We want to learn more about how his brain works. Destroy the source and bring me back his brain so we can set those under his spell free.")
	elseif e.message:findi("Mylik") then
		local understand_link = eq.silent_say_link("understand")
		e.self:Say(
			string.format(
				"Excellent! Let me tell you about Mylik. Much like Thelin, Mylik was a strong brave man too. Mylik stood in these lands and focused his energy and mana and opened the portal to the Plane of Disease. Bertoxxulous set a curse on those who dared open a portal to his plane and he defiled Mylik's soul with a potent toxin that has left him lying there slowly decaying away. Do you [%s] the amount of death that Bertoxxulous can spread over Norrath?",
				understand_link
			)
		)
	elseif e.message:findi("understand") then
		e.self:Say("Ok then pay attention $name. I have already sent in an old friend of mine to handle what needs to be done inside the Plane of Disease. What he doesn't know is that Bertoxxulous is aware that he has breached the portal and is planning on sending four guardians to eliminate him. Enter the Crypt of Decay and destroy the guardians. Bring me back proof of their death and I'll give you further instructions. Hurry $name, this task is vital to saving Milyk.")
	end
end

function event_trade(e)
	local item_lib = require("items")
	if item_lib.check_turn_in(e.trade, {item1 = 51614}) then -- Brains of the Tormentor
		local saryrn_bucket = tonumber(e.other:GetAccountBucket("pop.flags.saryrn")) or 0
		if saryrn_bucket == 4 then
			e.self:Say(
				string.format(
					"A fine step towards curing this illness, %s. I thank you.",
					e.other:GetCleanName()
				)
			)
			e.other:SetAccountBucket("pop.flags.newleaf", "1")
			e.other:Message(MT.MT.LightBlue, "You receive a character flag!")
		else
			e.other:SummonItem(51614)
		end
	elseif item_lib.check_turn_in(e.trade, {item1 = 51618, item2 = 51619, item3 = 51620, item4 = 51621}) then
		local construct_bucket = tonumber(e.other:GetAccountBucket("pop.flags.construct")) or 0
		local hedge_bucket = tonumber(e.other:GetAccountBucket("pop.flags.hedge")) or 0
		local newleaf_bucket = tonumber(e.other:GetAccountBucket("pop.flags.newleaf")) or 0
		local poxbourne_bucket = tonumber(e.other:GetAccountBucket("pop.flags.poxbourne")) or 0
		local saryrn_bucket = tonumber(e.other:GetAccountBucket("pop.flags.saryrn")) or 0
		local terris_bucket = tonumber(e.other:GetAccountBucket("pop.flags.terris")) or 0
		if (
			construct_bucket == 1 and
			hedge_bucket == 1 and
			newleaf_bucket == 1 and
			poxbourne_bucket == 1 and
			saryrn_bucket == 1 and
			terris_bucket == 1
		) then
			e.self:Say(
				string.format(
					"Go forth to the Crypt of Decay, %s.",
					e.other:GetCleanName()
				)
			)
			e.other:SetAccountBucket("pop.flags.adler", "1")
			e.other:Message(MT.LightBlue, "You receive a character flag!")
			e.other:SetAccountBucket("pop.flags.elder", "1")
			e.other:Message(MT.LightBlue, "You receive a character flag!")
			e.other:SetAccountBucket("pop.flags.grummus", "1")
			e.other:Message(MT.LightBlue, "You receive a character flag!")
			e.other:SetZoneFlag(200) -- Crypt of Decay
			e.other:Message(MT.LightBlue, "You receive a character flag!")
		else
			e.other:SummonItem(51618)
			e.other:SummonItem(51619)
			e.other:SummonItem(51620)
			e.other:SummonItem(51621)
		end
	end
end