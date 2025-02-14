function event_say(e)
	if e.message:findi("Hail") then
		local done_link = eq.silent_say_link("done")
		e.self:Emote(
			string.format(
				"grumbles under his breath, 'Yes, yes, I see you there. No need for you to shout I can see you just fine! Now, what was I saying? Yes that's right... let me know when you are [%s].",
				done_link
			)
		)
	elseif e.message:findi("done") then
		local key_link = eq.silent_say_link("done")
		e.self:Say(
			string.format(
				"Yes done! Weren't you paying attention? Once you've gathered all the pieces of the [%s] bring it to me and I'll put them back together for you.",
				key_link
			)
		)
	elseif e.message:findi("key") then
		local agree_to_help_link = eq.silent_say_link("agree to help")
		e.self:Say(
			string.format(
				"THE Key, you really are as thick skulled as you look. You [%s] me and you aren't even paying attention.",
				agree_to_help_link
			)
		)
	elseif e.message:findi("agree to help") then
		local done_link = eq.silent_say_link("done")
		e.self:Say(
			string.format(
				"grumbles under his breath, 'Yes, yes, I see you there. No need for you to shout I can see you just fine! Now, what was I saying? Yes that's right... let me know when you are [%s].",
				done_link
			)
		)
	elseif e.message:findi("tied to the mast") then
		local diaku_link = eq.silent_say_link("Diaku")
		e.self:Say(
			string.format(
				"The Diaku Raiders, filthy sort if you ask me. I was out on a shipping run, when Diaku attacked, they pillaged all of my goods, then tied me to the mast and left me floating a sea. Then the storm came and ate my ship, and I woke up here, I swear that I saw some [%s] washed up on the shore with me.",
				diaku_link
			)
		)
	elseif e.message:findi("Diaku") then
		local drunder_link = eq.silent_say_link("Drunder")
		e.self:Say(
			string.format(
				"The Diaku that attacked me! Pay attention for Karana's sake! You appear to be the fighting sort. You can help me kill the Diaku at their source in [%s].",
				drunder_link
			)
		)
	elseif e.message:findi("Drunder") then
		e.self:Say("Drunder! The Fortress of Zek, the Zeks don't trust any one mortal to have free access to the fortress. The Diaku come and go in fours, and four parts are needed for entry. Of course they won't part with them easily. If you find four, and bring me four, I can make the four into one, and with one, you can get into Drunder without three more. Then, with your one, you can kill all of them. I would do it myself, but with my bad knee and all. . .")
	end
end

function event_trade(e)
	local item_lib = require("items")
	if item_lib.check_turn_in(e.trade, {item1 = 29216, item2 = 29217, item3 = 29218, item4 = 29219}) then
		e.self:Say("What's this? Four pieces of a Diaku Emblem? Why ever would you give these to me? Well I think I can get them to fit back together. You know, while you have this, I would be quite happy if you would avenge the loss of my dear ship and kill every Diaku you find? Yes that would be very good indeed. Here is your key, and a key for all your companions as well.")

		if e.other:IsGrouped() then
			local group = e.other:GetGroup()
			local member_count = group:GroupCount()
			for i = 0, member_count - 1 do
				local member = group:GetMember(i):CastToClient()
				if member ~= nil then
					if not member:KeyRingCheck(29215) then
						member:KeyRingAdd(29215)
						member:SummonItem(29215)
						member:SetAccountBucket("pop.alt.potactics", "1")
						member:Message(MT.LightBlue, "You receive a character flag!")
					end
				end
			end
		else
			if not e.other:KeyRingCheck(29215) then
				e.other:KeyRingAdd(29215)
				e.other:SummonItem(29215)
				e.other:SetAccountBucket("pop.alt.potactics", "1")
				e.other:Message(MT.LightBlue, "You receive a character flag!")
			end
		end

		e.other:SetFactionLevel2(e.other:CharacterID(), 1609, e.other:GetBaseClass(), e.other:GetBaseRace(), e.other:GetDeity(), 10, 0)
		e.other:SetFactionLevel2(e.other:CharacterID(), 1618, e.other:GetBaseClass(), e.other:GetBaseRace(), e.other:GetDeity(), 10, 0)
		e.other:AddEXP(150000)
	end

	item_lib.return_items(e.self, e.other, e.trade)
end