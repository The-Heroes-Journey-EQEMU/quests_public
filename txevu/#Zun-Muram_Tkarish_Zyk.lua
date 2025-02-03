-- Zun`Muram Tkarish Zyk NPCID 297150

local init_engage	= false
local banished_pc	= nil
local banish_chance = 54; -- 54% chance to banish in testing

function event_spawn(e)
	init_engage = false
	banished_pc = nil
	spawn_event()
end

function event_combat(e)
	if e.joined then
		-- eq.set_timer("banishHateTop", 25 * 1000); -- Attempt to banish every 25s
		eq.set_timer("ritualist_adds_1", 30 * 1000); -- 30s initial start
		eq.set_timer("ritualist_adds_2", 60 * 1000); -- 60s initial start
		eq.set_timer("ritualist_adds_3", 90 * 1000); -- 90s initial start
		eq.set_timer("ritualist_adds_4", 120 * 1000); -- 120s initial start
		-- Wanton Destruction, scripted AE
		eq.set_timer("wanton",15000);
		eq.set_timer("OOBcheck", 3000);
		--eq.stop_timer("fail_check");
		eq.set_timer("aggrolink", 3 * 1000);
		if not eq.is_paused_timer("fail_check") then
			eq.pause_timer("fail_check");
		end
	else
		-- wipe or tether
		eq.stop_timer("banishHateTop");
		eq.stop_timer("ritualist_adds_1");
		eq.stop_timer("ritualist_adds_2");
		eq.stop_timer("ritualist_adds_3");
		eq.stop_timer("ritualist_adds_4");
		eq.stop_timer("wanton");
		eq.signal(297147, 297150); -- Tell Ritualists I lost agro
		eq.signal(297075, 297150); -- Tell Ritualists I lost agro
		eq.signal(297076, 297150); -- Tell Ritualists I lost agro
		eq.signal(297077, 297150); -- Tell Ritualists I lost agro
		banished_pc = 0
		eq.stop_timer("OOBcheck");
		--eq.set_timer("fail_check", 20 * 60 * 1000); --20 min reset
		eq.stop_timer("aggrolink");
		if not init_engage then
			--30 minutes cumulative to finish or the entire event resets
			eq.set_timer("fail_check", 1800000)
			init_engage = true
		else
			eq.resume_timer("fail_check");
		end
	end
end

function event_timer(e)
	if e.timer == "ghost_check" then
		if banished_pc ~= nil then
			if banished_pc:GetX() >= 1410 and banished_pc:GetX() <= 1501 and banished_pc:GetY() >= 178 and banished_pc:GetY() <= 237 then
				-- Spawn north jail ghosts, a_vengeful_apparition
				banished_pc:Message(MT.LightGray,"Angered by your presence here, apparitions step through the nearby walls.  A bone chilling cold fills the room as they reach for your throat.")
				eq.spawn2(297152,0,0,1500, 180, -328, 396)
				eq.spawn2(297152,0,0,1500, 234, -328, 308)
				eq.spawn2(297152,0,0,1469, 236, -328, 260)
				eq.spawn2(297152,0,0,1449, 235, -328, 236)
				eq.spawn2(297152,0,0,1413, 234, -328, 200)
				eq.spawn2(297152,0,0,1412, 207, -328, 138)
			elseif banished_pc:GetX() >= 1410 and banished_pc:GetX() <= 1501 and banished_pc:GetY() >= -237 and banished_pc:GetY() <= -178 then
				-- Spawn south jail ghosts, a_vengeful_apparition
				banished_pc:Message(MT.LightGray,"Angered by your presence here, apparitions step through the nearby walls.  A bone chilling cold fills the room as they reach for your throat.")
				eq.spawn2(297152,0,0,1500, -180, -328, 396)
				eq.spawn2(297152,0,0,1500, -234, -328, 460)
				eq.spawn2(297152,0,0,1469, -236, -328, 510)
				eq.spawn2(297152,0,0,1449, -235, -328, 510)
				eq.spawn2(297152,0,0,1413, -234, -328, 72)
				eq.spawn2(297152,0,0,1412, -207, -328, 134)
			end
		end
		eq.stop_timer("ghost_check")
	elseif e.timer == "banishHateTop" then
		if math.random(100) <= banish_chance then
			banished_pc = e.self:GetHateTop()
			if banished_pc ~= nil then
				banished_pc:Message(MT.LightGray,"Zun`Muram Tkarish Zyk tells you, 'I grow tired of your insolence.  Rot in your new home!")
				e.self:SetHate(banished_pc,1,1)
				-- Randomly north or south jail
				if banished_pc:IsClient() then
					local banished_pc_v = banished_pc:CastToClient()
					if banished_pc_v.valid then
						local instance_id = eq.get_zone_instance_id();
						local rand = math.random(1,2);
						if rand == 1 then
							banished_pc_v:MovePCInstance(297, instance_id, 1475, 205, -327, 255); -- Location: North Jail
							eq.spawn2(297144,0,0, 1475, 205, -327, 0)
							--spawn north jailer npc a_jailer (297144)
						elseif rand == 2 then
							banished_pc_v:MovePCInstance(297, instance_id, 1475, -205, -327, 0); -- Location: South Jail
							eq.spawn2(297143,0,0, 1475, -205, -327, 0)
							--spawn south jailer npc a_jailer (297143)
						end
					end
				end
				-- If they don't open the door and get out within 20 seconds, the ghosts spawn2
				-- eq.set_timer("ghost_check", 20000) jailer npc will handle this
				-- live emotes from jail room. Not Implemented yet.
				-- An unearthly moan echoes through the small room.
				-- Faint whispers can be heard all around you
			end
		end
	-- Ritualist Add Handling
	elseif e.timer == "ritualist_adds_1" then -- North
		eq.stop_timer(e.timer);
		if eq.get_entity_list():IsMobSpawnedByNpcTypeID(297075) then
			eq.spawn2(eq.ChooseRandom(297159, 297161, 297161, 297222, 297222, 297223, 297134),0,0,1305, 27, -304, 0):AddToHateList(e.self:GetHateTop(),1) -- North
			eq.set_timer("ritualist_adds_1", 2 * 60 * 1000); -- 2 minute timer
		end
	elseif e.timer == "ritualist_adds_2" then -- East
		eq.stop_timer(e.timer);
		if eq.get_entity_list():IsMobSpawnedByNpcTypeID(297077) then
			eq.spawn2(eq.ChooseRandom(297159, 297161, 297161, 297222, 297222, 297223, 297134),0,0,1276, 0, -304, 384):AddToHateList(e.self:GetHateTop(),1) -- East
			eq.set_timer("ritualist_adds_2", 2 * 60 * 1000); -- 2 minute timer
		end
	elseif e.timer == "ritualist_adds_3" then -- South
		eq.stop_timer(e.timer);
		if eq.get_entity_list():IsMobSpawnedByNpcTypeID(297076) then
			eq.spawn2(eq.ChooseRandom(297159, 297161, 297161, 297222, 297222, 297223, 297134),0,0,1305, -27, -304, 256):AddToHateList(e.self:GetHateTop(),1) -- South
			eq.set_timer("ritualist_adds_3", 2 * 60 * 1000); -- 2 minute timer
		end	
	elseif e.timer == "ritualist_adds_4" then -- West
		eq.stop_timer(e.timer);
		if eq.get_entity_list():IsMobSpawnedByNpcTypeID(297147) then
			eq.spawn2(eq.ChooseRandom(297159, 297161, 297161, 297222, 297222, 297223, 297134),0,0,1330, 0, -304, 128):AddToHateList(e.self:GetHateTop(),1) -- West
			eq.set_timer("ritualist_adds_4", 2 * 60 * 1000); -- 2 minute timer
		end
	elseif e.timer == "fail_check" then
		-- respawn the whole event
		eq.depop_all(297147); -- West
		eq.depop_all(297075); -- North
		eq.depop_all(297076); -- South
		eq.depop_all(297077); -- East
		eq.depop_all(297148);
		eq.depop_all(297149);
		eq.depop_all(297159);
		eq.depop_all(297161);
		eq.depop_all(297222);
		eq.depop_all(297223);
		eq.depop_all(297134);
		init_engage = false
		banished_pc = nil
		--init_engage = false
		eq.stop_all_timers()
		--eq.spawn2(297150,0,0,1506,2,-285,374) -- myself, which also will trigger Spawn_Event()
		--eq.depop()
		spawn_event()
	elseif e.timer == "wanton" then
		e.self:CastSpell(1250,e.self:GetID())
		eq.set_timer("wanton", eq.ChooseRandom(100,120) * 1000)
	elseif e.timer=="OOBcheck" then
		eq.stop_timer("OOBcheck");
			if e.self:GetX() < 1215 or e.self:GetY() > 106 or e.self:GetY() < -106 then
				e.self:CastSpell(3791,e.self:GetID()); -- Spell: Ocean's Cleansing
				e.self:GotoBind();
				e.self:WipeHateList();
			else
				eq.set_timer("OOBcheck", 3 * 1000);
			end
	elseif e.timer == "aggrolink" then
		local npc_list =  eq.get_entity_list():GetNPCList();
		for npc in npc_list.entries do
			if npc.valid and not npc:IsEngaged() and (npc:GetNPCTypeID() == 297148 or npc:GetNPCTypeID() == 297149 or npc:GetNPCTypeID() == 297147 or npc:GetNPCTypeID() == 297075 or npc:GetNPCTypeID() == 297076 or npc:GetNPCTypeID() == 297077) then
				npc:AddToHateList(e.self:GetHateRandom(),1); -- add ritualists and inquisitor goats to aggro list if alive
			end
		end
	end
end

function spawn_event()
	-- 4 Ikaav Ritualist and the two Inquisitor goats.
	eq.spawn2(297147,0,0,1353, 0, -305, 384);	-- West
	eq.spawn2(297075,0,0,1305, 45, -305, 256);	-- North
	eq.spawn2(297076,0,0,1305, -45, -305, 0);	-- South
	eq.spawn2(297077,0,0,1260, 0, -305, 128);	-- East
	eq.spawn2(297148,0,0,1528, 30, -285, 384);
	eq.spawn2(297149,0,0,1528, -30, -285, 384);
end

function event_death_complete(e)
	eq.signal(297140,297150); -- Add Lockout
end
