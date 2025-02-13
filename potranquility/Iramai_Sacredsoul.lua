function event_say(e)
	if e.message:findi("Hail") then
		local phanti_link = eq.silent_say_link("Phanti")
		e.self:Say(
			string.format(
				"Oh, hello. I am sorry, I did not see you approach. I have been giving all of my attention to poor [%s] here.",
				phanti_link
			)
		)
	elseif e.message:findi("Phanti") then
		local suspicions_link = eq.silent_say_link("suspicions")
		e.self:Say(
			string.format(
				"A few days ago Phanti started to get very ill, while she was preparing herself for another trip into [Saryrn's domain]. We are not sure exactly was caused her to fall into this malaise, although we do have our [%s].",
				suspicions_link
			)
		)
	elseif e.message:findi("suspicions") then
		local help_link = eq.silent_say_link("Plane of Torment")
		e.self:Say(
			string.format(
				"Torment, the Plane of Pain. She was doing some research on the denizens there, should you [%s] us, I could grant you and your companions entry. The key will not do Phanti any good for quite some time.",
				help_link
			)
		)
	elseif e.message:findi("help") then
		e.self:Say("Recently, the portal from the Plane of Disease has been unusually active. People have been reporting strange sounds from around the portal at night, and a few of our trackers have seen strange, almost rodent like, footprints. Our best guess is that one of the denizens of the Plane of Disease managed to make its way into our plane. If this is true, it may explain the unnaturally quick manifestation of the disease. Perhaps, the bile from one of the rodents will help us learn of the cause, and hopefully a cure.")
	end
end

function event_trade(e)
	local item_lib = require("items")
	if item_lib.check_turn_in(e.trade, {item1 = 29295, item2 = 29302}) then
		e.self:Say("Hmm, it looks like I will need both the cure and the purified bile in order to heal Phanti.")
		e.self:Say("You've done it! Praise the Tranquil! I can already see Phanti's condition improving. Take these, Phanti is not going to be doing any planar exploration any time soon. She was planning on using them to bring her research party into Torment, make good use of them, and stay safe. Thank you again for your help.")

		if e.other:IsGrouped() then
			local group = e.other:GetGroup()
			local member_count = group:GroupCount()
			for i = 0, member_count - 1 do
				local member = group:GetMember(i)
				if member ~= nil then
					if not member:CastToClient():KeyRingCheck(29213) then
						member:CastToClient():KeyRingAdd(29213)
						member:SummonItem(29213)
						member:SetAccountBucket("pop.alt.potorment", "1")
						member:Message(MT.LightBlue, "You receive a character flag!")
					end
				end
			end
		else
			if not e.other:KeyRingCheck(29213) then
				e.other:KeyRingAdd(29213)
				e.other:SummonItem(29213)
				e.other:SetAccountBucket("pop.alt.potorment", "1")
				e.other:Message(MT.LightBlue, "You receive a character flag!")
			end
		end

		e.other:AddEXP(6250)
	elseif item_lib.check_turn_in(e.trade, {item1 = 29315}) then -- Bubonian Bile
		e.self:Emote("pours the bile into a small flask, there is a puff of green smoke, which turns white as it floats into the sky. 'This is good news. It appears that this is the cause for her disease, but I have neither the tools, nor the knowledge to create a cure. There is rumor of an indigo orc who may prove useful to us in this area, but he is imprisoned in the Plane of Justice. Ask him about rare diseases. He was known to have cured many, prior to his imprisonment.")
		e.other:SummonItem(29302) -- Purified Bubonian Bile
		e.other:AddEXP(50000)
	end

	item_lib.return_items(e.self, e.other, e.trade)
end