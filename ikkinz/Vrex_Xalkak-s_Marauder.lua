-- Vrex_Xalkak`s_Marauder (294594)

local class_arch_required = nil;

function event_spawn(e)
	local instance_id = eq.get_zone_instance_id();
	local data_bucket = ("Ikky3_Marauder-".. instance_id);

	eq.set_timer("change", 75 * 1000); -- Change Weakness

	if eq.get_data(data_bucket) == "" then
		class_arch_required = math.random(1,4);
		eq.set_data(data_bucket, tostring(class_arch_required),tostring(eq.seconds("6h")));
	else
		class_arch_required = tonumber(eq.get_data(data_bucket));
	end

	eq.set_next_hp_event(10);
end

function event_combat(e)
	if e.joined then
		eq.set_timer("OOBcheck", 3 * 1000);
	else
		eq.stop_timer("OOBcheck");
	end
end

function event_hp(e)
	local instance_id = eq.get_zone_instance_id();
	local data_bucket = ("Ikky3_Marauder-".. instance_id);
	class_arch_required = tonumber(eq.get_data(data_bucket));

	if e.hp_event == 10 then
		if class_arch_required == 1 then
			eq.zone_emote(MT.Yellow,"The creature will perish under the strength of intelligent magic");
		elseif class_arch_required == 2 then
			eq.zone_emote(MT.Yellow,"The creature appears weak to the combined effort of might and magic!");
		elseif class_arch_required == 3 then
			eq.zone_emote(MT.Yellow,"The creature appears weak to the combined effort of strength and cunning!");
		elseif class_arch_required == 4 then
			eq.zone_emote(MT.Yellow,"The creature cannot stand up to the power of healers");
		end
	end
end

function event_timer(e)
	local instance_id = eq.get_zone_instance_id();
	local data_bucket = ("Ikky3_Marauder-".. instance_id);
	class_arch_required = tonumber(eq.get_data(data_bucket));

	if e.timer == "OOBcheck" then
		eq.stop_timer("OOBcheck");
		if e.self:GetX() > 720 or e.self:GetX() < 500 or e.self:GetY() < -300 or e.self:GetY() > -120 then
			e.self:CastSpell(3791,e.self:GetID()); -- Spell: Ocean's Cleansing
			e.self:GotoBind();
			e.self:WipeHateList();
			e.self:SetHP(e.self:GetMaxHP());
		else
			eq.set_timer("OOBcheck", 3 * 1000);
		end
	elseif e.timer == "change" then
		eq.zone_emote(MT.Yellow,"Vrex Xalkaks Marauder shudders momentarily as though it were somehow changing");
		if class_arch_required == 1 then
			class_arch_required = 2;
			eq.zone_emote(MT.Yellow,"The creature will perish under the strength of intelligent magic!");
		elseif class_arch_required == 2 then
			class_arch_required = 3;
			eq.zone_emote(MT.Yellow,"The creature appears weak to the combined effort of might and magic!");
		elseif class_arch_required == 3 then
			class_arch_required = 4;
			eq.zone_emote(MT.Yellow,"The creature appears weak to the combined effort of strength and cunning!");
		elseif class_arch_required == 4 then
			class_arch_required = 1;
			eq.zone_emote(MT.Yellow,"The creature cannot stand up to the power of healers!");
		end
		eq.set_data(data_bucket, tostring(class_arch_required),tostring(eq.seconds("6h")));
	end
end

function event_death_complete(e)
	local is_gm = (e.other:CastToClient():Admin() > 80 and e.other:CastToClient():GetGM())
	local instance_id = eq.get_zone_instance_id();
	local data_bucket = ("Ikky3_Marauder-".. instance_id);
	local class = e.other:GetClass();
	local x,y,z,h = e.self:GetX(), e.self:GetY(), e.self:GetZ(), e.self:GetHeading();
	class_arch_required = tonumber(eq.get_data(data_bucket));

	if is_gm then
		eq.signal(294595,2);
		eq.delete_data(data_bucket);
		eq.zone_emote(MT.Yellow,"The marauder's remains crash to the ground. It is no more.");
	elseif class_arch_required == 2 and (e.other:HasClass(Class.BARD) or e.other:HasClass(Class.BEASTLORD) or e.other:HasClass(Class.PALADIN) or e.other:HasClass(Class.RANGER) or e.other:HasClass(Class.SHADOWKNIGHT)) then
		eq.signal(294595,2);
		eq.delete_data(data_bucket);
		eq.zone_emote(MT.Yellow,"The marauder's remains crash to the ground. It is no more.");
	elseif class_arch_required == 3 and (class == e.other:HasClass(Class.BERSERKER) or class == e.other:HasClass(Class.MONK) or e.other:HasClass(Class.ROGUE) or e.other:HasClass(Class.WARRIOR)) then
		eq.signal(294595,2);
		eq.delete_data(data_bucket);
		eq.zone_emote(MT.Yellow,"The marauder's remains crash to the ground. It is no more.");
	elseif class_arch_required == 4 and (e.other:HasClass(Class.CLERIC) or e.other:HasClass(Class.DRUID) or e.other:HasClass(Class.SHAMAN)) then
		eq.signal(294595,2);
		eq.delete_data(data_bucket);
		eq.zone_emote(MT.Yellow,"The marauder's remains crash to the ground. It is no more.");
	elseif class_arch_required == 1 and (e.other:HasClass(Class.ENCHANTER) or e.other:HasClass(Class.MAGICIAN) or e.other:HasClass(Class.NECROMANCER) or e.other:HasClass(Class.WIZARD)) then
		eq.signal(294595,2);
		eq.delete_data(data_bucket);
		eq.zone_emote(MT.Yellow,"The marauder's remains crash to the ground. It is no more.");
	else
		eq.zone_emote(MT.Yellow,"Your energy didn't match that required to kill the stone worker.");
		if class_arch_required == 1 then
			eq.zone_emote(MT.Yellow,"The creature will perish under the strength of intelligent magic");
		elseif class_arch_required == 2 then
			eq.zone_emote(MT.Yellow,"The creature appears weak to the combined effort of might and magic!");
		elseif class_arch_required == 3 then
			eq.zone_emote(MT.Yellow,"The creature appears weak to the combined effort of strength and cunning!");
		elseif class_arch_required == 4 then
			eq.zone_emote(MT.Yellow,"The creature cannot stand up to the power of healers");
		end
		eq.zone_emote(MT.Yellow,"It reforms instantly!");
		eq.spawn2(294594 ,0,0,x,y,z,h); -- NPC: Vrex_Xalkak`s_Marauder
	end
end
