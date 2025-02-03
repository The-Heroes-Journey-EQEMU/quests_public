--#Gozer_The_Gatekeeper
--Full zone instance version
--poair

function event_say(e)
    local instance_id = eq.get_zone_instance_id();
    local qglobals = eq.get_qglobals(e.other);

    if(instance_id ~= 0) then
        e.self:Say("Hail Traveler!  I am pleased to see you made it through the rift unharmed. You must return to the original plane if you wish to access the deeper areas of the instance.");
        return;
    end

    if(e.message:findi('hail')) then
        e.self:Say("Greetings Traveler, recently there has been talk of rifts in space and time. These rifts have been allowing well established groups of adventurers to explore identical instances of Norrath.");
        e.self:Say("The Planar tears seem to diverge here. Do you wish to confront the  [" .. eq.say_link("Caretakers") .. "] of the Islands? Or The [" .. eq.say_link("Queen") .. "] herself?.");
        e.self:Say("When you are [" .. eq.say_link("ready") .. "], please let me know.");
    elseif(e.message:findi('Caretakers')) then
        local rings_clear = eq.get_data("rings_clear") ~= "" and true or false
        if not rings_clear then
            eq.set_data("rings_clear", "1", "60s")
            e.other:Message(15, "The air is filled with static.");
        else
            -- live uses this as a request message throttling mechanic, creation can still occur but no conflict messages
            e.other:Message(13, "The world warps in front of you and sucks you in.");
        end

        local dz = e.other:GetExpedition()
        if not dz.valid then
            dz = e.other:CreateExpedition("poair", 0, 43200, "Leaf on the Wind", 6, 72, rings_clear)
            if dz.valid then
                dz:SetCompass("poair", 541, 902, -92.33)
                dz:SetSafeReturn("poair", 532, 884, -94.01, 256)
                dz:SetZoneInLocation(532, 884, -94.01, 256)
				dz:AddReplayLockout(1200); -- 20m Respawn cheese prevention

                if dz:GetInstanceID() == 0 then
                    e.other:Message(13, "Instance failed to be created, yell at a GM");
                end
                eq.cross_zone_message_player_by_name(5, "Trust", "Air Rings Instance Created -- Instance: [" .. dz:GetInstanceID() .."]");
            end
        end
    elseif(e.message:findi('Queen')) then -- Rathe Expedition
        local xegony_clear = eq.get_data("xegony_clear") ~= "" and true or false
        if not xegony_clear then
            eq.set_data("xegony_clear", "1", "60s")
            e.other:Message(15, "The air is filled with static.");
        else
            -- live uses this as a request message throttling mechanic, creation can still occur but no conflict messages
            e.other:Message(13, "The world warps in front of you and sucks you in.");
        end

        local dz = e.other:GetExpedition()
        if not dz.valid then
            -- zone entry gated via flag checks but expedition can be created if only requester is eligible
            dz = e.other:CreateExpedition("poair", 0, 43200, "Throne of Air", 6, 72, xegony_clear)
            if dz.valid then
                dz:SetCompass("poair", 541, 902, -92.33)
                dz:SetSafeReturn("poair", 532, 884, -94.01, 256)
                dz:SetZoneInLocation(-401.94, 934.44, 438.27, 256)
				dz:AddReplayLockout(1200); -- 20m Respawn cheese prevention

                if dz:GetInstanceID() == 0 then
                    e.other:Message(13, "Instance failed to be created, yell at a GM");
                end
                eq.cross_zone_message_player_by_name(5, "Trust", "Xegony Instance Created -- Instance: [" .. dz:GetInstanceID() .."]");
            end
        end
    elseif(e.message:findi('ready')) then
        local dz = e.other:GetExpedition()
        if dz.valid then
            e.other:MovePCDynamicZone("poair") -- only moves client if they have associated dz to target zone
        end
    end
end

--[[ Old Gozer
local player_list = nil;
local player_list_count = nil;
local entity_list = nil;
local client_e = nil;
local group = nil;
local raid = nil;

function event_say(e)
	local instance_id = eq.get_zone_instance_id();
    if(instance_id ~= 0) then
		e.self:Say("Hail, Traveler.  I am pleased to see you made it through the rift unharmed.  I wish you luck in your upcoming adventure!");
		return;
    end

    local instanceId = nil;  -- from the global
    if(e.message:findi('hail')) then
        e.self:Say("Greetings Traveler, recently there has been talk of rifts in space and time. These rifts have been allowing well established groups of adventurers to explore identical instances of Norrath.");
        e.self:Say("Are you [" .. eq.say_link("brave") .. "] enough to travel through these portals?");
    elseif(e.message:findi('brave')) then
        local qglobals = eq.get_qglobals(e.other);
        local zoneGlobal = "POEARTHB-" .. tostring(e.other:GuildID());
        instanceId = qglobals[zoneGlobal];
        if (instanceId ~= nil) then
            entity_list = eq.get_entity_list(); --get current entity list of zone
            client_e = e;
            raid = e.other:GetRaid();
            group = e.other:GetGroup();
            if (raid ~= nil and check_raid_guild(raid,e.other:GuildID())) then
                eq.assign_raid_to_instance(tonumber(instanceId));
            elseif (group ~= nil and check_group_guild(group,e.other:GuildID())) then
                eq.assign_group_to_instance(tonumber(instanceId));
            else
                eq.assign_to_instance(tonumber(instanceId));
            end
            e.other:MovePCInstance(222, tonumber(instanceId), -785,330,-55,130);
        else
            e.other:Message(13,"There is no instance available in this zone for your guild,");
        end
    end
end

function check_raid_guild(cur_raid, guildId)
    local same_guild = 0;
    player_list = nil;
    player_list_count = nil;
    if (cur_raid.valid == true) then
        player_list = cur_raid;
        player_list_count = cur_raid:RaidCount();
    end
    if (player_list ~= nil) then
        for i = 0, player_list_count - 1, 1 do --Uses a 0-n group memembers
            local client_v = player_list:GetMember(i):CastToClient();
            if (client_v.valid and client_v:GuildID() == guildId) then --valid client
                same_guild = same_guild + 1;
            end
        end
    end
    if (player_list ~= nil and same_guild == player_list_count) then
        return true;
    else
        return false;
    end
end

function check_group_guild(cur_group, guildId)
    local same_guild = 0;
    player_list = nil;
    player_list_count = nil;
    if (cur_group.valid == true) then
        player_list = cur_group;
        player_list_count = cur_group:GroupCount();
    end
    if (player_list ~= nil) then
        for i = 0, player_list_count - 1, 1 do --Uses a 0-n group memembers
            local client_v = player_list:GetMember(i):CastToClient();
            if (client_v.valid and client_v:GuildID() == guildId) then --valid client
                same_guild = same_guild + 1;
            end
        end
    end
    if (player_list ~= nil and same_guild == player_list_count) then
        return true;
    else
        return false;
    end
end

]]--

--[[ Old Gozer
local player_list = nil;
local player_list_count = nil;
local entity_list = nil;
local client_e = nil;
local group = nil;
local raid = nil;

function event_say(e)
	local instance_id = eq.get_zone_instance_id();
    if(instance_id ~= 0) then
		e.self:Say("Hail, Traveler.  I am pleased to see you made it through the rift unharmed.  I wish you luck in your upcoming adventure!");
		return;
    end

    local instanceId = nil;  -- from the global	
    if(e.message:findi('hail')) then
        e.self:Say("Greetings Traveler, recently there has been talk of rifts in space and time. These rifts have been allowing well established groups of adventurers to explore identical instances of Norrath.");
        e.self:Say("Are you [" .. eq.say_link("brave") .. "] enough to travel through these portals?");
    elseif(e.message:findi('brave')) then
        local qglobals = eq.get_qglobals(e.other);
        local zoneGlobal = "POAIR-" .. tostring(e.other:GuildID());
        instanceId = qglobals[zoneGlobal];
        if (instanceId ~= nil) then
            entity_list = eq.get_entity_list(); --get current entity list of zone
            client_e = e;
            raid = e.other:GetRaid();
            group = e.other:GetGroup();
            if (raid ~= nil and check_raid_guild(raid,e.other:GuildID())) then
                eq.assign_raid_to_instance(tonumber(instanceId));
            elseif (group ~= nil and check_group_guild(group,e.other:GuildID())) then
                eq.assign_group_to_instance(tonumber(instanceId));
            else
                eq.assign_to_instance(tonumber(instanceId));
            end
            e.other:MovePCInstance(215, tonumber(instanceId), 532,884,-90,300);
        else
            e.other:Message(13,"There is no instance available in this zone for your guild,");
        end
    end
end

function check_raid_guild(cur_raid, guildId)
    local same_guild = 0;
    player_list = nil;
    player_list_count = nil;
    if (cur_raid.valid == true) then
        player_list = cur_raid;
        player_list_count = cur_raid:RaidCount();
    end
    if (player_list ~= nil) then
        for i = 0, player_list_count - 1, 1 do --Uses a 0-n group memembers
            local client_v = player_list:GetMember(i):CastToClient();
            if (client_v.valid and client_v:GuildID() == guildId) then --valid client
                same_guild = same_guild + 1;
            end
        end
    end
    if (player_list ~= nil and same_guild == player_list_count) then
        return true;
    else
        return false;
    end
end

function check_group_guild(cur_group, guildId)
    local same_guild = 0;
    player_list = nil;
    player_list_count = nil;
    if (cur_group.valid == true) then
        player_list = cur_group;
        player_list_count = cur_group:GroupCount();
    end
    if (player_list ~= nil) then
        for i = 0, player_list_count - 1, 1 do --Uses a 0-n group memembers
            local client_v = player_list:GetMember(i):CastToClient();
            if (client_v.valid and client_v:GuildID() == guildId) then --valid client
                same_guild = same_guild + 1;
            end
        end
    end
    if (player_list ~= nil and same_guild == player_list_count) then
        return true;
    else
        return false;
    end
end

]]--
