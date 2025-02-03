--[[
--  Ancient Cragbeast Matriarch
--  NPCs involved:
--      #Ancient_Cragbeast_Matriarch (297056)
--      #Bearer_of_Absorption (297173)
--      #Bearer_of_Anger (297055)
--      #Bearer_of_Haste (297190)
--      #Bearer_of_Intensification (297051)
--      #Bearer_of_Mending (297054)
--      #Bearer_of_Nascency (297050)
--      #Bearer_of_Projection (297208)
--      #Bearer_of_Quickening (297142)
--      #Bearer_of_Rage (297053)
--      #Bearer_of_Reflection (297052)
--      #Bearer_of_Resistance (297141)
--      #Bearer_of_Shielding (297191)
--  http://everquest.allakhazam.com/db/quest.html?quest=7691
--]]

local ae			= false
local adds			= false
local combat		= false
local instance_id	= eq.get_zone_instance_id();
local bearer_list	= {297173,297055,297190,297051,297054,297050,297208,297142,297053,297052,297141,297191};

function ACMSpawn(e)
	local entity_list = eq.get_entity_list()
	ae = false
	adds = false
	combat = false
	-- due to the way spawn conditions work, if on boot up the condition is
	-- enabled the mob spawn order is not guaranteed
	-- This isn't as clean as I would like, but it's better than checking them all on a timer

	for i = 1, #bearer_list do
		if entity_list:IsMobSpawnedByNpcTypeID(bearer_list[i]) then
			eq.signal(297056, bearer_list[i]);
		end
	end
	eq.set_timer("spawnevent", 3000)
	
end

function ACMDeath(e)
	eq.spawn_condition("txevu", instance_id, 3, 0) -- bearers and Mastruqs
	ae = false
	adds = false
	combat = false
	eq.signal(297140,297056); -- Add Lockout
end

function ACMTimer(e)
	if e.timer == "hatchling" then
		local x,y,z,h = e.self:GetX(), e.self:GetY(), e.self:GetZ(), e.self:GetHeading();
		eq.zone_emote(MT.Yellow, "In search of food, cragbeast hatchlings scurry out from beneath the Ancient Cragbeast Matriarch")
		eq.spawn2(297210, 0, 0, x, y + 5, z, h) -- a_cragbeast_hatchling
		eq.spawn2(297210, 0, 0, x + 5, y, z, h) -- a_cragbeast_hatchling
		eq.spawn2(297210, 0, 0, x - 5, y, z, h) -- a_cragbeast_hatchling
	elseif e.timer == "ae" then
		eq.stop_timer(e.timer)
		local target = e.self:GetTarget()
		if target.valid then
			e.self:CastSpell(1239, target:GetID()) -- Devouring Conflagration
		end
		eq.set_timer(e.timer, math.random(5, 60) * 1000)
	elseif e.timer == "spawnevent" then
		eq.stop_timer("spawnevent")
		eq.spawn_condition("txevu", instance_id, 3, 1) -- bearers and Mastruqs
	end
end

function ACMCombat(e)
	if e.joined then
		combat = true
		if adds then
			eq.set_timer("hatchling", 35 * 1000)
		end
		if ae then
			eq.set_timer("ae", math.random(5, 60) * 1000)
		end
	else
		combat = false
		eq.stop_timer("hatchling")
		eq.stop_timer("ae")
	end
end

-- This is less than ideal IMO, but since we can't keep around a pointer that
-- gets cleared in every case (#repop) we gotta rely on signals
function ACMSignal(e)
	if e.signal == 297173 then
		e.self:ModSkillDmgTaken(0, -75) -- 1h blunt
		e.self:ModSkillDmgTaken(1, -75) -- 1h slashing
		e.self:ModSkillDmgTaken(2, -75) -- 2h blunt
		e.self:ModSkillDmgTaken(3, -75) -- 2h slashing
		e.self:ModSkillDmgTaken(7, -75) -- archery
		e.self:ModSkillDmgTaken(8, -75) -- backstab
		e.self:ModSkillDmgTaken(10, -75) -- bash
		e.self:ModSkillDmgTaken(21, -75) -- dragon punch
		e.self:ModSkillDmgTaken(23, -75) -- eagle strike
		e.self:ModSkillDmgTaken(26, -75) -- flying kick
		e.self:ModSkillDmgTaken(28, -75) -- hand to hand
		e.self:ModSkillDmgTaken(30, -75) -- kick
		e.self:ModSkillDmgTaken(36, -75) -- piercing
		e.self:ModSkillDmgTaken(38, -75) -- round kick
		e.self:ModSkillDmgTaken(52, -75) -- tiger claw
		e.self:ModSkillDmgTaken(74, -75) -- frenzy
	elseif e.signal == 9297173 then
		e.self:ModSkillDmgTaken(0, 0) -- 1h blunt
		e.self:ModSkillDmgTaken(1, 0) -- 1h slashing
		e.self:ModSkillDmgTaken(2, 0) -- 2h blunt
		e.self:ModSkillDmgTaken(3, 0) -- 2h slashing
		e.self:ModSkillDmgTaken(7, 0) -- archery
		e.self:ModSkillDmgTaken(8, 0) -- backstab
		e.self:ModSkillDmgTaken(10, 0) -- bash
		e.self:ModSkillDmgTaken(21, 0) -- dragon punch
		e.self:ModSkillDmgTaken(23, 0) -- eagle strike
		e.self:ModSkillDmgTaken(26, 0) -- flying kick
		e.self:ModSkillDmgTaken(28, 0) -- hand to hand
		e.self:ModSkillDmgTaken(30, 0) -- kick
		e.self:ModSkillDmgTaken(36, 0) -- piercing
		e.self:ModSkillDmgTaken(38, 0) -- round kick
		e.self:ModSkillDmgTaken(52, 0) -- tiger claw
		e.self:ModSkillDmgTaken(74, 0) -- frenzy
	elseif e.signal == 297055 then
		e.self:SetSpecialAbility(SpecialAbility.rampage, 1)
		e.self:SetSpecialAbilityParam(SpecialAbility.rampage, 0, 27)
	elseif e.signal == 9297055 then
		e.self:SetSpecialAbility(SpecialAbility.rampage, 0)
	elseif e.signal == 297190 then
		e.self:SetSpecialAbility(SpecialAbility.flurry, 1)
		e.self:SetSpecialAbilityParam(SpecialAbility.flurry, 0, 50)
	elseif e.signal == 9297190 then
		e.self:SetSpecialAbility(SpecialAbility.flurry, 0)
	elseif e.signal == 297051 then
		e.self:ModifyNPCStat("min_hit", "1150")
		e.self:ModifyNPCStat("max_hit", "4000")
	elseif e.signal == 9297051 then
		e.self:ModifyNPCStat("min_hit", "850")
		e.self:ModifyNPCStat("max_hit", "2750")
	elseif e.signal == 297054 then
		e.self:ModifyNPCStat("combat_hp_regen", "6000")
	elseif e.signal == 9297054 then
		e.self:ModifyNPCStat("combat_hp_regen", "100")
	elseif e.signal == 297050 then
		adds = true
		if combat then
			eq.set_timer("hatchling", 35000)
		end
	elseif e.signal == 9297050 then
		adds = false
		eq.stop_timer("hatchling")
	elseif e.signal == 297208 then
		ae = true
		if combat then
			eq.set_timer("ae", math.random(5, 60) * 1000)
		end
	elseif e.signal == 9297208 then
		ae = false
		eq.stop_timer("ae")
	elseif e.signal == 297142 then
		e.self:ModifyNPCStat("attack_delay", "12")
	elseif e.signal == 9297142 then
		e.self:ModifyNPCStat("attack_delay", "17")
	elseif e.signal == 297053 then
		e.self:SetSpecialAbility(SpecialAbility.area_rampage, 1)
		e.self:SetSpecialAbilityParam(SpecialAbility.area_rampage, 0, 17)
	elseif e.signal == 9297053 then
		e.self:SetSpecialAbility(SpecialAbility.area_rampage, 0)
	elseif e.signal == 297052 then
		e.self:AddAISpell(0, 1248, 1024, -1, 30, -1) -- Spiritual Echo, in combat buff
	elseif e.signal == 9297052 then
		e.self:RemoveAISpell(1248) -- Spiritual Echo
	elseif e.signal == 297141 then
		e.self:ModifyNPCStat("mr", "236")
		e.self:ModifyNPCStat("fr", "236")
		e.self:ModifyNPCStat("cr", "236")
		e.self:ModifyNPCStat("pr", "236")
		e.self:ModifyNPCStat("dr", "236")
	elseif e.signal == 9297141 then
		e.self:ModifyNPCStat("mr", "136")
		e.self:ModifyNPCStat("fr", "136")
		e.self:ModifyNPCStat("cr", "136")
		e.self:ModifyNPCStat("pr", "136")
		e.self:ModifyNPCStat("dr", "136")
	elseif e.signal == 297191 then
		e.self:AddAISpell(0, 1249, 1024, -1, 30, -1) -- Bristling Armament, in combat buff
	elseif e.signal == 9297191 then
		e.self:RemoveAISpell(1249) -- Bristling Armament
	end
end

function bearer_spawn(e)
	eq.signal(297056, e.self:GetNPCTypeID());
end

function bearer_death(e)
	eq.signal(297056, tonumber("9"..e.self:GetNPCTypeID()));
end

function ACHSpawn(e)
	eq.set_timer("leash", 3 * 1000);
end

function ACHDeath(e)
	eq.stop_timer('leash');
end

function ACHTimer(e)
	if e.timer == "leash" then
		if e.self:GetX() >= 700 then
			e.self:GotoBind();
			e.self:WipeHateList();
		end
	end
end

function event_encounter_load(e)
	eq.register_npc_event("acm", Event.spawn,				297056, ACMSpawn)
	eq.register_npc_event("acm", Event.death_complete,		297056, ACMDeath)
	eq.register_npc_event("acm", Event.timer,				297056, ACMTimer)
	eq.register_npc_event("acm", Event.combat,				297056, ACMCombat)
	eq.register_npc_event("acm", Event.signal,				297056, ACMSignal)

	for i = 1, #bearer_list do
		eq.register_npc_event("acm", Event.spawn,			bearer_list[i], bearer_spawn)
		eq.register_npc_event("acm", Event.death_complete,	bearer_list[i], bearer_death)
	end

	eq.register_npc_event("acm", Event.spawn,				297210, ACHSpawn)
	eq.register_npc_event("acm", Event.timer,				297210, ACHTimer)
	eq.register_npc_event("acm", Event.death_complete,		297210, ACHDeath)
end
