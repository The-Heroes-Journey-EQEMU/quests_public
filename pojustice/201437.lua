-- 201435 The Tribunal
-- Trial of Stoning
--
-- items: 31599

local trial_group_id = 0;
local client_id = 0; -- character ID, not entity ID
local trial_x = -133;
local trial_y = -1107;
local trial_z = 73;
local trial_h = 126;
local trial_mobs = { 201451, 201493, 21494, 201495, 201496, 201497, 201498, 201499 };

local cooldown_timer = 1800000;
local eject_timer = 900000;
local fail_timer = 360000;


function event_say(e)
	local mavuin_bucket = tonumber(e.other:GetAccountBucket("pop.flags.mavuin")) or 0
	if (mavuin_bucket == 1) then
		if (e.message:findi("hail")) then
			local prepared_link = eq.silent_say_link("prepared")
			e.self:Emote(
				string.format(
					" fixes you with a dark, peircing gaze. 'What do you want, mortal? Are you [%s]?",
					prepared_link
				)
			);
		elseif (e.message:findi("prepared")) then
			local begin_the_trial_of_stoning_link = eq.silent_say_link("begin the trial of stoning");
			e.self:Say(
				string.format(
					"Very well. When you are ready, you may [%s]. You must protect the victims from their tormentors. Be wary of the scourge of honor - you cannot fight it directly. You must find and destroy its life force to defeat it. We shall judge the mark of your success.",
					begin_the_trial_of_stoning_link
				)
			)
		elseif (e.message:findi("rbegin the trial of stoning")) then
			local active_variable = tonumber(e.self:GetEntityVariable("Active")) or 0
			if active_variable == 0 then 
				e.self:Say("Then begin.");

				-- Move the Player and their Group tot he trial room.
				local trial_group = e.other:GetGroup();
				if (trial_group ~= nil and trial_group.valid) then
					MoveGroup( trial_group, e.self:GetX(), e.self:GetY(), e.self:GetZ(), 75, trial_x, trial_y, trial_z, trial_h); 
					trial_group_id = trial_group:GetID();
				else
					client_id = e.other:CharacterID();
					e.other:MovePCInstance(201, eq.get_zone_instance_id(), trial_x, trial_y, trial_z, trial_h); -- Zone: pojustice
				end

				-- Spawn the Controller
				eq.spawn2(201451, 0, 0, trial_x, trial_y, trial_z, trial_h); -- NPC: #Event_Stoning_Control

				-- Set the Proximity Check Timer; if everyone has left the trial (wipe); then reset things
				eq.set_timer("proximitycheck", 60000);

				-- Set a variable to indicate the Trial is unavailable.
				e.self:SetEntityVariable("Active", "1")
			else
				e.self:Say("I'm sorry, the Trial of Stoning is currently unavilable to you.");
			end
		elseif (e.message:findi("what evidence of mavuin") ) then
		 	if e.other:HasItem(31845) then
				e.other:SetAccountBucket("pop.flags.tribunal", "1");
				e.other:SetAccountBucket("pop.flags.stoning", "1");
				e.other:Message(4, "You receive a character flag!");
			end
		elseif (e.message:findi("i seek knowledge") ) then
			local marks = { 31796, 31842, 31844, 31845, 31846 , 31960 }
			local has_six = 1;
			for k,v in pairs(marks) do
				if (not e.other:HasItem(v)) then
					has_six = 0;
				end
			end

			if (has_six == 1) then 
				if (not e.other:HasItem(31599)) then 
					-- give 31599 to e.other
					e.other:SummonItem(31599); -- Item: The Mark of Justice
				end
			elseif (has_six == 0) then
				e.self:Say("You have done well, mortal, but there are more trials yet for you to complete.");
			end
		end
	end
end

function event_timer(e)
	 if (e.timer == "ejecttimer") then
		eq.stop_timer(e.timer);
		despawn_trial_mobs()

		local trial_group = eq.get_entity_list():GetGroupByID(trial_group_id);
		if (trial_group ~= nil and trial_group.valid) then
		 MoveGroup( trial_group, trial_x, trial_y, trial_z, 250, 456, 825, 9, 180, "A mysterious force translocates you."); 
		else
			local client_e = eq.get_entity_list():GetClientByCharID(client_id);
			if (client_e ~= nil and client_e.valid) then
				client_e.other:MovePCInstance(201, eq.get_zone_instance_id(), 456, 825, 9, 360 ); -- Zone: pojustice
				client_e.other:Message(3, "A mysterious force translocates you.");
			end
		end
		HandleCorpses(trial_x, trial_y, trial_z, 200);

		eq.stop_timer("proximitycheck");

	 elseif (e.timer == "cooldown") then
		eq.stop_timer(e.timer);

		e.self:DeleteEntityVariable("Active")
		client_id		= 0;
		trial_group_id = 0;

		despawn_trial_mobs();

		eq.stop_timer("proximitycheck");
		e.self:Shout("The Trial of Stoning is now Available.");

	 elseif (e.timer == "proximitycheck") then
		-- The proximitycheck timer is primarily for when a trial has failed
		-- This check will allow the trial to be re-attempted as soon as
		-- everyone has left the trial room (or they are kicked out after
		-- 15minutes by the ejecttimer).

		-- Check to see if all the PCs have left the Trial area; if so
		-- Clean Corpses up and release thoe hold and stop the timer.
		if ( ProximityCheck(trial_x, trial_y, trial_z, 250) == false) then 
		 eq.stop_timer(e.timer);

		 eq.stop_timer("cooldown");
		 eq.stop_timer("ejecttimer");
		 eq.set_timer("ejecttimer", 100);
		 eq.set_timer("cooldown", 200);
		end
	end
end

function event_signal(e)
	 if (e.signal == 0) then

	 elseif (e.signal == 1) then
		-- Trial was successful
		-- 30min till next Trial can start
		-- 15min Eject Timer to kick any PC out of the Trial Room
		eq.set_timer("ejecttimer", eject_timer);
		eq.set_timer("cooldown"	, cooldown_timer);

		eq.stop_timer("proximitycheck");

	 elseif (e.signal == 2) then
		-- Trial Failed
		eq.set_timer("ejecttimer", fail_timer);
		eq.set_timer("cooldown"	, fail_timer);

		eq.stop_timer("proximitycheck");
		eq.set_timer("proximitycheck", 10000);

	end

end

function MoveGroup(trial_group, src_x, src_y, src_z, distance, tgt_x, tgt_y, tgt_z, tgt_h, msg)
	 if ( trial_group ~= nil) then
		local trial_count = trial_group:GroupCount();

		for i = 0, trial_count - 1, 1 do
		 local mob_v = trial_group:GetMember(i);

		 if (mob_v ~= nil and mob_v.valid and mob_v:IsClient()) then
			local client_v = mob_v:CastToClient();

			if (client_v.valid) then
				 -- check the distance and port them up if close enough
				 if (client_v:CalculateDistance(src_x, src_y, src_z) <= distance) then
					-- port the player up
					client_v:MovePCInstance(201, eq.get_zone_instance_id(), tgt_x, tgt_y, tgt_z, tgt_h); -- Zone: pojustice
					
					if (msg) then
					 client_v:Message(3, msg);
					end
				end
			end
		end
		end
	end
end

function HandleCorpses(src_x, src_y, src_z, dist)

	 -- Move Player Corpses from the Trial Area to the Grave Yard
	 local clist = eq.get_entity_list():GetCorpseList();
	 if ( clist ~= nil ) then
		for corpse in clist.entries do
		 if ( corpse:IsPlayerCorpse() ) then
			 if (corpse:CalculateDistance(src_x, src_y, src_z) < dist) then
				 corpse:GMMove(58, -47, 2);		
			end
		 elseif ( corpse:IsNPCCorpse() ) then
			if (corpse:CalculateDistance(src_x, src_y, src_z) < dist) then
				 corpse:Delete();
			end
			end
		end
	end
end

function ProximityCheck(chk_x, chk_y, chk_z, dist)

	 local players_in_prox = false;
	 local clist = eq.get_entity_list():GetClientList();

	 if ( clist ~= nil ) then
		for client in clist.entries do
		 if (client:CalculateDistance(chk_x, chk_y, chk_z) < dist) then
			players_in_prox = true;
		end
		end
	end

	 return players_in_prox;
end

function despawn_trial_mobs()
	 for k,v in pairs(trial_mobs) do
		eq.depop_all(v);
	end
end
