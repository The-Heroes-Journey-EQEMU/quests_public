--#Guard_Helminth 
----Qeynos Badge of Honor (Qeynos badge #4)

function event_spawn(e)
	eq.set_timer("depop", 20 * 60 * 1000);  -- 20 min depop timer
end

function event_timer(e)
	if e.timer == "depop" then
		eq.depop();
	end
end

function event_say(e)
	local qglobals = eq.get_qglobals(e.self,e.other);

	if e.message:findi("hail") then
		e.self:Say("Who are you and what are you doing here? This place is not safe. You are to leave here immediately! You do not belong here!");
	elseif e.message:findi("investigator") and e.message:findi("dead") and tonumber(qglobals.qeynos_badge4) >= 2 then
		e.self:Say("So he did not make it, that is a shame. I managed to defeat all of the enemies. It was difficult but they were no match for one of my skill. Did [" .. eq.say_link("Vegalys sent me",false,"Vegalys send you") .. "]?");
	elseif e.message:findi("Vegalys sent me") and tonumber(qglobals.qeynos_badge4) >= 2 then
		e.self:Say("So Vegalys sent you to check on our progress then? I don't believe you. Prove it!");
	elseif e.message:findi("ready to complete the mission") and tonumber(qglobals.qeynos_badge4) == 3 then
		eq.spawn2(45118,0,0,-50,328,-38,0);		-- NPC: #Rotting_Sentry
		eq.spawn2(45106,0,0,-48,415,-38,254);	-- NPC: #a_necromancer
		eq.spawn2(45119,0,0,-266,441,-37,128);	-- NPC: #Azibelle_Spavin
		eq.spawn2(45130,0,0,-49,379,-38,256);	-- NPC: #Corrupt_Guard_Helminth
		eq.depop();								-- NPC: #Guard_Helminth
	end
end

function event_trade(e)
	local item_lib = require("items");

	if item_lib.check_turn_in(e.trade, {item1 = 2694}) then -- Item: Vegalys Seal
		e.self:Say("Well, well! Vegalys did send you after all. Are you [ready to complete the mission]? I am certain I know where Azibelle is hiding.");
		e.other:SummonItem(2694);					-- Item: Vegalys Seal 
		eq.set_global("qeynos_badge4","3",5,"F");	-- QGlobal: Badge Globals
	end
	item_lib.return_items(e.self, e.other, e.trade)
end
