--[[
-- PoAir Zone_Status (215438)
-- Control the Player Lockouts
--]]

local instance_id = 0;
local charid_list;
local entity_list;
local PoAir_Lockouts = {};

--Named/unique mob controls to despawn within instance
local disable_instance = {}
local static_named = {215424, 215034, 215024, 215054, 215003, 215039, 215011};	--disable these spawnpoints since they don't share other trash NPCS (also are included above in disabled instance)

local function seconds(duration)
	local w = duration:match("(%d+)w") or 0
	local d = duration:match("(%d+)d") or 0
	local h = duration:match("(%d+)h") or 0
	local m = duration:match("(%d+)m") or 0
	local s = duration:match("(%d+)s") or 0
	return s + (m * 60) + (h * 3600) + (d * 86400) + (w * 604800)
end

-- Minis
local STORM_EVENT		= 'Stormriders Event'
local AOW_EVENT			= 'Avatar of Wind'
local ELEMENTALS_EVENT	= 'Elementals Event'
local AOS_EVENT			= 'Avatar of Smoke'
local PHOENIXES_EVENT	= 'Phoenix Event'
local AOM_EVENT			= 'Avatar of Mist'
local SPIDERS_EVENT		= 'Spider Event'
local AOD_EVENT			= 'Avatar of Dust'

-- Xegony
local XEGONY_EVENT	= 'Xegony the Queen of Air'

function setup_rings()
	PoAir_Lockouts = {
		[215425] = {STORM_EVENT,		seconds('3d'), Spawn_Storm},
		[215407] = {AOW_EVENT,    		seconds('3d'), Spawn_AOW},
		[215426] = {ELEMENTALS_EVENT,	seconds('3d'), Spawn_Elementals},
		[215406] = {AOS_EVENT,			seconds('3d'), Spawn_AOS},
		[215427] = {PHOENIXES_EVENT,	seconds('3d'), Spawn_Phoenixes},
		[215405] = {AOM_EVENT,			seconds('3d'), Spawn_AOM},
		[215428] = {SPIDERS_EVENT,		seconds('3d'), Spawn_Spider},
		[215404] = {AOD_EVENT,			seconds('3d'), Spawn_AOD}
	};
end

function setup_xegony()
	PoAir_Lockouts = {
		[215056] = {XEGONY_EVENT,    seconds('3d'), Spawn_Xegony}
	};
end

function event_spawn(e)
	zone_id = eq.get_zone_id();
	instance_id = eq.get_zone_instance_id();
	charid_list = eq.get_characters_in_instance(instance_id);
	entity_list = eq.get_entity_list();


	-- Cleanup Globals From Previous Events

	eq.delete_global(instance_id .. "_AoDust_PoAir");
	eq.delete_global(instance_id .. "_AoMist_PoAir");
	eq.delete_global(instance_id .. "_AoSmoke_PoAir");
	eq.delete_global(instance_id .. "_AoWind_PoAir");

	local expedition = eq.get_expedition_by_zone_instance(zone_id,instance_id);
	if expedition.valid then
		if(expedition:GetName() == "Leaf on the Wind") then
			setup_rings();
		elseif(expedition:GetName() == "Throne of Air") then
			setup_xegony();
		end

		for k,v in pairs(PoAir_Lockouts) do
			if v[3] and not expedition:HasLockout(v[1]) then
				v[3]() -- boss spawning function
			end
		end
	end

	if(instance_id ~= 0) then
		local mysql = require("luasql_ext");
		for id,name in mysql.rows(con,"SELECT id from npc_types WHERE id >= 215000 and id < 216000 and disable_instance = 1") do
			disable_instance[id] = tonumber(id);
		end
		eq.set_timer("scan", 5 * 1000);
	end
end

-- Rings
function Spawn_Storm()
	eq.unique_spawn(215425,0,0,-370,-625,106,0); -- NPC: #isle_two_controller (215425)
end

function Spawn_AOW() -- #Avatar_of_Wind (215407)
	-- Nothing to Spawn, Lockout Tracking Only
end

function Spawn_Elementals()
	eq.unique_spawn(215426,0,0,-440,-1275,320,0); -- NPC: #isle_three_controller (215426)
end

function Spawn_AOS() -- #Avatar_of_Smoke (215406)
	-- Nothing to Spawn, Lockout Tracking Only
end

function Spawn_Phoenixes()
	eq.unique_spawn(215427,0,0,330,-715,443,0); -- NPC: #isle_four_controller (215427)
end

function Spawn_AOM() -- #Avatar_of_Mist (215405)
	-- Nothing to Spawn, Lockout Tracking Only
end

function Spawn_Spider()
	eq.unique_spawn(215428,0,0,-440,640,435,0); -- NPC: #isle_five_controller (215428)
end

function Spawn_AOD() -- #Avatar_of_Dust (215404)
	-- Nothing to Spawn, Lockout Tracking Only
end

-- Xegony
function Spawn_Xegony()
	eq.unique_spawn(215056,0,0,79,20,1467.19,385.49); -- NPC: #Xegony_the_Queen_of_Air (215056)
end

function AddLockout(lockout)
	local lockout_name = lockout[1];
	local lockout_duration = lockout[2];

	local expedition = eq.get_expedition()
	if expedition.valid then
		-- this should add the lockout to:
		-- 1) the expedition internally, so anyone that gets added after and zones in will receive it
		-- 2) all current members of the expedition, even if they're in another zone
		-- 3) all clients currently inside the dz instance in case members were removed but haven't been teleported out yet
		expedition:AddLockout(lockout_name, lockout_duration)
	end
end

function event_signal(e)
	eq.debug("signal: " .. e.signal);
	if ( PoAir_Lockouts[e.signal] ~= nil ) then
		AddLockout(PoAir_Lockouts[e.signal]);
	end
end

function event_timer(e)
	if e.timer == "scan" then
		local npc_list = eq.get_entity_list():GetNPCList();
		if npc_list ~= nil then
			for npc in npc_list.entries do
				for k,npc_id in pairs(disable_instance) do
					if npc:CastToMob():GetNPCTypeID() == npc_id then
						local spawn = eq.get_entity_list():GetSpawnByID(npc:GetSpawnPointID());
						spawn:ForceDespawn();
						if DisableCheck(npc_id) then
							spawn:Disable();
						else
							spawn:Repop(1);
						end
					end
				end
			end
		end
	end
end

function DisableCheck(npc)
	for k,v in pairs(static_named) do
		if npc == v then
			return true;
		end
	end
	return false;
end
