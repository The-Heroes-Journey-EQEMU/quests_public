-- Churn in Ring War event in GD

local questExpToGive=100000;

function event_spawn(e)
	ready = false;
end

function event_say(e)
	if(e.message:findi("hail")) then
		e.self:Say("Hello outlander. Thank you for your help!");
	end
end

function event_trade(e)
	local item_lib = require("items");
	
	if ready and item_lib.check_turn_in(e.self, e.trade, {item1 = 1741}) then -- Shorn Head of Narandi
		e.self:Emote("pries a crown from the head of Narandi, 'The halls of Thurgadin will echo with praises to you for as long as we grace the face of this land. May this crown serve you well. Honor through battle!'");
		e.other:Faction(406, 25); --Coldain
		e.other:Faction(405, 10); --Dain
		e.other:Faction(419, -40); --Kromrif
		e.other:Faction(448, -20); --Kromzek
		e.other:SummonItem(1741); -- Shorn head
		e.other:SummonItem(1746); -- Crown of Narandi
		e.other:AddEXP(questExpToGive);
		eq.depop();
	end

	item_lib.return_items(e.self, e.other, e.trade);
end

function event_signal(e)
	if e.signal == 105 then
		ready = true;
	end
end
