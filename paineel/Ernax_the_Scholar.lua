--Quest:Azraxs' Legacy

function event_say(e)
	if e.message:findi("hail") then
		e.self:Say("Hello. Please leave me be. I am studying several interesting essays on mana storage devices.");
	elseif e.message:findi("matter of the soul") then
		e.self:Say("hmmm. That's a phrase I have not heard for some time, and one I thought I would not hear again, any time soon. So another fool seeks Azrax's legacy, eh? Well, so be it. Take this and follow its instructions. When you are finished reading and scribing, give it back to me.");
		if not e.other:HasItem(18956) then
			e.other:SummonItem(18956); -- Item: Tattered Book
		end
	elseif e.message:findi("crystal of capturing") then
		e.self:Say("Jalen Goldsinger has the required skills to craft the crystal.  He often spends his time in the Toxullia Forest.");
	end
end

function event_trade(e)
	local item_lib = require("items");

	if item_lib.check_turn_in(e.trade, {item1 = 18956}) then -- Item: Tattered Book
		e.self:Say("For your sake, I wish you a quick and painless death. For mine, I wish you a slow and painful one, as a warning to any fool who wishes to follow in your path.");
		e.other:SummonItem(17803); -- Item: Soul Trap
	end
	item_lib.return_items(e.self, e.other, e.trade)
end
