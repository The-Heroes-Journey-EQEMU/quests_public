function event_say(e)
	if e.message:findi("Hail") then
		local they_link = eq.silent_say_link("they")
		e.self:Say(
			string.format(
				"Shhh $name, [%s] can hear and see every move that you make.",
				they_link
			)
		)
	elseif e.message:findi("they") then
		local work_link = eq.silent_say_link("work")
		e.self:Say(
			string.format(
				"Terris Thule and her henchman are after me. I thought I had completed my [%s] without being noticed but something went wrong.",
				work_link
			)
		)
	elseif e.message:findi("work") then
		local nightmares_link = eq.silent_say_link("nightmares")
		e.self:Say(
			string.format(
				"I came here to find the pieces of the dagger for Variok. Terris did a good job at scattering them across her maze but I was able to sneak around and find each of them without being noticed. I crafted the dagger back together and I made my escape out of the maze to here. I was going to take a night's rest then leave this plane and return the dagger to Variok but that's when the [%s] started.",
				nightmares_link
			)
		)
	elseif e.message:findi("nightmares") then
		local can_help_link = eq.silent_say_link("can help")
		e.self:Say(
			string.format(
				"I fell asleep here that night and in my dreams I saw Terris Thule ordering her henchman to kill me at all costs because I have the dagger in my possession. I try and fight the urge to sleep but eventually I find myself running from them, fighting to stay alive. My only hope of surviving is to assassinate her henchman before he assassinates me. I have scouted the area and I know my point of attack but with the many sleepless nights I don't think I have the power to assassinate him myself. Do you think you [%s] me?",
				can_help_link
			)
		)
	elseif e.message:findi("can help") then
		e.self:Say("Ok every night he appears just south east of the maze. He has two guardsmen with him when he is around. If he were alone I could assassinate him but his two guards pose a problem for me. Kill him and bring his heart back to me.")
	elseif e.message:findi("three items") then
		local hedge_alt_bucket = tonumber(e.other:GetAccountBucket("pops.alt.hedge")) or 0
		if hedge_alt_bucket == 1 then
			e.self:Say("I need a secured wooden case and two pieces of silky cloth. If you can bring them back to me I'll be able to return this to Veriok.")
		end
	end
end

function event_trade(e)
	local item_lib = require("items")

	if item_lib.check_turn_in(e.trade {item1 = 51615}) then -- Heart of the Tyrant
		local three_items_link = eq.silent_say_link("three items")
		e.self:Say(
			string.format(
				"You made fast work of him. I need to clean this dagger before returning it to Variok. With Terris and her henchman chasing me I couldn't collect the pieces that I needed. Could you collect [%s] for me?",
				three_items_link
			)
		)
		e.other:SetAccountBucket("pop.alt.hedge", "1")
	elseif item_lib.check_turn_in(e.trade {item1 = 51616, item2 = 51617, item3 = 51617}) then -- Secured Wooden Case, 2x Silky Cloth
		local hedge_alt_bucket = tonumber(e.other:GetAccountBucket("pops.alt.hedge")) or 0
		if hedge_alt_bucket == 1 then
			e.self:Say("Perfect I can clean this dagger up and return it to Veriok. You were a great help to me. I'll be sure to report that to Veriok when I get back.")
			e.other:SetAccountBucket("pop.alt.hedge", "2")
			e.other:AddEXP(10000)
		end
	end

	item_lib.return_items(e.self, e.other, e.trade)
end