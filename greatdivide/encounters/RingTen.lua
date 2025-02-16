-- RINGWAR
-- TODO thurg depop/giants at entrance

-- TODO TESTING

local ThreadManager = require("thread_manager");

local aldikarNPCID = 118166;
local zrelikNPCID = 118167;
local narandiNPCID = 118145;
local badainNPCID = 118067;
local churnNPCID = 118169;
local corbinNPCID = 118171;
local karginNPCID = 118172;
local garadainNPCID = 118168;
local dobbinNPCID = 118170;
local gRecruitNPCID = 118160;
local gCaptainNPCID = 118130;
local gWarriorNPCID = 118150;
local zekPriestNPCID = 118155;
local gGeneralNPCID = 118120;
local gVeteranNPCID = 118156;
local zekHighPriestNPCID = 118132;
local gWarlordNPCID = 118158;
local gSpearmanNPCID = 118138;
local dSoldierNPCID = 118134;
local dClericNPCID = 118135;
local dAxemanNPCID = 118152;
local dArcherNPCID = 118141;
local controllerNPCID = 118173;

local narandiGridNum = 62;
-- paths for giants
local PathInfo = {};
local Giants = { gRecruitNPCID, gCaptainNPCID, gWarriorNPCID, zekPriestNPCID, gGeneralNPCID, gVeteranNPCID, zekHighPriestNPCID, gWarlordNPCID };
local Dwarves = { dSoldierNPCID, dClericNPCID, dAxemanNPCID, zrelikNPCID };
local Heroes = { aldikarNPCID, dobbinNPCID, garadainNPCID, churnNPCID, corbinNPCID, karginNPCID };
local Statics = { gSpearmanNPCID, dArcherNPCID, karginNPCID };
local Narandi = { narandiNPCID };
-- stages: -1 is pre-war conversation, 0 is war trigger, 1 is first siege, 2 is second siege, 3 is third siege, 4 is Narandi, 5 is loot
local stage = -1;

-- tracks entity specific data (e.g. which path is this giant on? What group does this dwarf belong to? What waypoint are we at?)
local entity_data = {};

-- tracks specific entities
local Aldikar;

-- tracks data for next spawn round
local next_spawn = {};
local boss_count = 0;
local miss_count = 0;

function event_encounter_load(e)
	-- spawn event trigger (decision points in function)
	eq.register_npc_event("RingTen", Event.spawn, -1, AllSpawn);
	-- signal 99 is for move-only events, other signals set specific paths
	eq.register_npc_event("RingTen", Event.signal, -1, AllSignal);
	-- recalculates waypoint every time mob loses aggro - e.g. if it has been kited closer to the end of its path, it'll pick a later waypoint rathen than walk all the way back
	eq.register_npc_event("RingTen", Event.combat, -1, AllCombat);
	-- waypoint arrive sets next waypoint in entity data for the triggering entity
	eq.register_npc_event("RingTen", Event.waypoint_arrive, -1, AllWaypoint);
	
	-- triggers for the NPC coordinating the event
	eq.register_npc_event("RingTen", Event.timer, aldikarNPCID, WarTimers);
	eq.register_npc_event("RingTen", Event.death_complete, aldikarNPCID, WarDeath);
	
	-- Zrelik the Scout coordination
	eq.register_npc_event("RingTen", Event.say, zrelikNPCID, ScoutMove);
	
	-- Conversation coordination
	eq.register_npc_event("RingTen", Event.waypoint_arrive, badainNPCID, Badain_Waypoint_Arrive);
	eq.register_npc_event("RingTen", Event.waypoint_arrive, aldikarNPCID, ConversationStart);
	
	-- War win monitor
	eq.register_npc_event("RingTen", Event.death_complete, narandiNPCID, FinalStage);
	eq.register_npc_event("RingTen", Event.waypoint_arrive, narandiNPCID, NarandiEscape);
	
	-- GM control of event
	eq.register_player_event("RingTen", Event.say, GMControl);
	
	-- reset all variables
	stage = -1;
	entity_data = {};
	Aldikar = nil;
	next_spawn = {};
	boss_count = 0;
	miss_count = 0;
	first = true;
	
	-- set up paths as soon as encounter loads
	PathInfo = load_paths();
	-- spawns circle of dwarves to start war
	depop_except({ badainNPCID });
	PreSetup();	

	-- note that NPCs that require a path need to be created by a trigger (timer, say, etc)
end

function NarandiEscape(e)
	--checks Narandi is set to run at each waypoint check.  Did not always seem to trigger on wp 0/1
	if e.wp < 3 then  
		e.self:SetRunning(true);
	--Narandi depops and event is failed if he escapes to Eastern Wastes
	elseif e.wp == 3 then
		if not e.self:IsEngaged() then
			eq.stop_timer("NarDepop");
			eq.set_timer("NarDepop",1000,Aldikar);
		end
	end
end

function FinalStage(e)
	Aldikar:Shout("Outlander! You've done it! The Kromrif invasion has been frustrated! Bring me the head of Narandi and your Hero's ring.");
	eq.set_timer("WarEnd", 1200000, Aldikar);
	eq.signal(aldikarNPCID, 105);
	
	local ent_list = eq.get_entity_list()
	if ent_list:IsMobSpawnedByNpcTypeID(churnNPCID) then
		eq.signal(churnNPCID, 105);
	end
	if ent_list:IsMobSpawnedByNpcTypeID(corbinNPCID) then
		eq.signal(corbinNPCID, 105);
	end
	if ent_list:IsMobSpawnedByNpcTypeID(dobbinNPCID) then
		eq.signal(dobbinNPCID, 105);
	end
	if ent_list:IsMobSpawnedByNpcTypeID(garadainNPCID) then
		eq.signal(garadainNPCID, 105);
	end
	if ent_list:IsMobSpawnedByNpcTypeID(karginNPCID) then
		eq.signal(karginNPCID, 105);
	end
end

function ConversationStart()
	if stage == -1 then
		ThreadManager:Create("Conversation", Conversation);
	elseif stage == 1 then
		ThreadManager:Create("Conversation", ShoutingMatch1);
	elseif stage == 2 then
		ThreadManager:Create("Conversation", ShoutingMatch2);
	elseif stage == 3 then
		ThreadManager:Create("Conversation", ShoutingMatch3);
	end
	
end

function Conversation()
	local Badain = eq.get_entity_list():GetMobByNpcTypeID(badainNPCID):CastToNPC();
	local Garadain = eq.get_entity_list():GetMobByNpcTypeID(garadainNPCID):CastToNPC();
	local Dobbin = eq.get_entity_list():GetMobByNpcTypeID(dobbinNPCID):CastToNPC();
	local Kargin = eq.get_entity_list():GetMobByNpcTypeID(karginNPCID):CastToNPC();
	local Churn = eq.get_entity_list():GetMobByNpcTypeID(churnNPCID):CastToNPC();
	local Corbin = eq.get_entity_list():GetMobByNpcTypeID(corbinNPCID):CastToNPC();
	Kargin:Emote("'s stomach growls loudly.");
	ThreadManager:Wait(5);
	Garadain:Say("With all due respect, Seneschal, I feel my men are best suited for the eastern post. If the outlander has rounded up enough soldiers to hold 'em off from the south then they'll definitely test us in the gorge. We'll be needin' a solid defense there.");
	ThreadManager:Wait(10);
	Aldikar:Say("Very well, Garadain, the eastern post is yours. I'll place Kargin and his bowmen on the hill to the west, and Churn, you'll station your troops up near the caves just past them.");
	ThreadManager:Wait(3);
	Garadain:Emote("bows and departs to the east.");
	Garadain:Depop();
	ThreadManager:Wait(3);
	Churn:Say("Understood sir.");
	Churn:Emote("turns to walk west.");
	Churn:Depop();
	ThreadManager:Wait(3);
	Kargin:Emote("nods quietly and slinks away.");
	Kargin:Depop();
	ThreadManager:Wait(5);
	Badain:Say("Excuse me, Seneschal Aldikar, you instructed me to report to you when the outlander returned.");
	ThreadManager:Wait(5);
	Aldikar:Say("Perfect timing outlander, please be seated and listen carefully. Badain, yer dismissed.");
	ThreadManager:Wait(3);
	Badain:Say("Sir, yessir!");
	ThreadManager:Wait(1);
	Badain:Depop(true);
	ThreadManager:Wait(2);
	Aldikar:Say("We knew the day might come when the Kromrif would discover the location of our beloved city. It was only prudent for there to be a plan for such a circumstance. In light of recent developments, however, our plans have been adjusted. Outlander, the Dain has appointed you to lead our armies in defense of Thurgadin.");
	ThreadManager:Wait(10);
	Aldikar:Say("I will stand here with a handful of men as a final line of defense. Should I fall, all will be lost. You will have these men and their soldiers to command. Use them wisely, you will be richly rewarded if your forces are able to keep them alive.");
	ThreadManager:Wait(10);
	Aldikar:Say("Garadain will post his men in the gorge to the east. Churn and his men will await your command in the caves to the west. Dobbin will have his forces at the ready in the clearing directly south of here near the towers. If any Kromrif make it to his vicinity he and his men will attack with or without your command.");
	ThreadManager:Wait(10);
	Dobbin:Emote("salutes and marches southward.");
	Dobbin:Depop();
	ThreadManager:Wait(3);
	Aldikar:Say("Lastly, Corbin will hide his men in the worm caves to the south, call on him for a surprise attack. Remember where these men are stationed, outlander. Should they call out for help you may wish to send some of your people to aid them.");
	ThreadManager:Wait(5);
	Corbin:Emote("runs off unceremoniously.");
	Corbin:Depop();
	ThreadManager:Wait(10);
	Aldikar:Say("The leader of this invasion is a powerful Kromrif named Narandi. Rumor has it that he is more powerful than any ten of his peers. He must fall. When he is slain you must show his head and your ring to me.");
	ThreadManager:Wait(10);
	Aldikar:Say("Scout Zrelik here will follow you and serve as your herald. He will relay your orders to the troops. Show me your ring now to verify your identity and I will give you the orders to memorize.");
	eq.unique_spawn(zrelikNPCID, 0, 0, -110, -545, 77, 446);
	eq.signal(zrelikNPCID, 100);
	eq.signal(aldikarNPCID, 100);
	eq.set_timer("handin1", 600000, Aldikar);
end

function ShoutingMatch1()
	eq.unique_spawn(narandiNPCID, 0, 0, -5000, -5000, 0, 0);
	local Narandi = eq.get_entity_list():GetMobByNpcTypeID(narandiNPCID):CastToNPC();
	Narandi:SetInvul(true);
	Aldikar:Shout("Good citizens of Thurgadin, hear me! Our city, our people, our very lives are in danger this day. The Kromrif are at this very moment marching towards us in an offensive they hope will bring about our demise... ");
	ThreadManager:Wait(10);
	Aldikar:Shout("I hereby command, by authority of Dain Frostreaver the Fourth, that all able bodied Coldain fight to the death in defense of our land. Children, disabled citzens, and unseasoned travellers are advised to evacuate immediately!");
	ThreadManager:Wait(10);
	Aldikar:Shout("My fellow soldiers, take heart! For we are not alone in this endeavor. One among us, an outlander, has earned the title Hero of the Dain for valiant service to our people. This newcomer has brought with him allies that will fight alongside you to help bring about our victory.");
	ThreadManager:Wait(10);
	Aldikar:Shout("My friends... Brell did not place us here so many centuries ago to be slaughtered by these heathens. Nor did our forefather, Colin Dain, sacrifice himself simply to have us fail here now. Through these events we were brought to this day to test our strength and our faith.");
	ThreadManager:Wait(10);
	Aldikar:Shout("Will we be shackled together to slave away in Kromrif mines or will we stand united and feed these beasts Coldain blades? By Brell I promise you, 'It is better to die on our feet than to live on our knees!'");
	ThreadManager:Wait(10);
	Aldikar:Shout("TROOPS, TAKE YOUR POSITIONS!!");
	for i = 56, 60 do
		eq.signal(aldikarNPCID, i, 1000);
	end
	ThreadManager:Wait(10);
	Narandi:Shout("No need to pray to your little God stumpymen, you'll be meeting him in person soon enough!");
	ThreadManager:Wait(10);
	Aldikar:Shout("You'll be begging Brell for forgiveness by the day's end, vile beast!");
	ThreadManager:Wait(10);
	Narandi:Shout("Kromrif! Form up! Dispatch these tiny fools and destroy Thurgadin. Theres a keg of ice mead waiting for every man back at home.");
	Narandi:Depop();
	eq.signal(aldikarNPCID, 50, 1000);
	GiantSpawn();
end

function ShoutingMatch2()
	eq.unique_spawn(narandiNPCID, 0, 0, -5000, -5000, 0, 0);
	local Narandi = eq.get_entity_list():GetMobByNpcTypeID(narandiNPCID):CastToNPC();
	Narandi:SetInvul(true);
	
	Aldikar:Shout("Outlander, our scouts report no more Kromrif units on the way - for the time being. Resurrect your fallen and heal your wounded. I have a feeling we haven't seen the last of them. ");
	ThreadManager:Wait(10);
	Narandi:Shout("Interlopers! You've chosen the wrong side in this war. My warriors will succeed where the young recruits have failed. You shall suffer the same fate as the pathetic vermin you serve. Your heads shall be perched upon our spears along with those of your Coldain friends!");
	ThreadManager:Wait(10);
	Aldikar:Shout("Pay no attention to his babbling, outlander. It is our destiny to emerge victorious. Prepare your army for glorious battle!");
	ThreadManager:Wait(10);
	Narandi:Shout("My warriors approach, I offer you one final opportunity to bow before the might of Rallos Zek. Throw down your weapons and surrender. You will live out your lives in relative peace, rightfully serving your Kromrif masters.");
	ThreadManager:Wait(10);
	Aldikar:Shout("Enough! Show yourself coward! Your blasphemous words shall be etched upon your spacious brow. All will mock you for generations to come. Your own god will forsake you when he witnesses your defeat here today!");
	ThreadManager:Wait(20);
	Narandi:Shout("Warriors! Charge through these pompous fools. Any you manage to capture shall become your personal slaves. The outlanders and the Seneschal must die! Bring me their heads!");
	Narandi:Depop();
end

function ShoutingMatch3()
	eq.unique_spawn(narandiNPCID, 0, 0, -5000, -5000, 0, 0);
	local Narandi = eq.get_entity_list():GetMobByNpcTypeID(narandiNPCID):CastToNPC();
	Narandi:SetInvul(true);
	
	Aldikar:Shout("Well fought, friends! May the piles of Kromrif corpses strike fear in the hearts of our overgrown enemies.");
	ThreadManager:Wait(10);
	Narandi:Shout("Silence fool! Speak not of our fallen. They who die honorably in combat earn an eternal rest in the company of our greatest heroes... even Rallos Zek himself!");
	ThreadManager:Wait(10);
	Aldikar:Shout("It is your misguided beliefs that made this war necessary. Now you feel the sting of your errors. Return to Kael and preach the doctrine of Brell Serilis in hopes that your people may someday be spared.");
	ThreadManager:Wait(10);
	Narandi:Shout("Enough chatter. Our veterans approach now to finish you. You have been tested and your weaknesses have been assessed. Bid farewell to your dear Thurgadin, those of you who are fortunate enough to survive the slaughter shall make a new home in the Kromrif slave pens!");
	ThreadManager:Wait(20);
	Narandi:Shout("Veterans! Be sure that this time we allow none of the stumpymen to escape to create yet another city. This shall be our final war with these unworthy beings.");
	Narandi:Depop();
end

function PreSetup()
	local Badain = eq.get_entity_list():GetMobByNpcTypeID(badainNPCID):CastToNPC();
	Badain:Say("Excellent! All of your commanders have reported to the Dain, and none too soon mind you. We are getting reports of Kromrif troop movement in the area and final preparations must be made. Follow me and the Seneschal will brief you.");
	Badain:MoveTo(-110, -545, 77, 223, true);
	-- Seneschal Aldikar pop
	eq.unique_spawn(aldikarNPCID, 0, 0, -125, -530, 77, 180);
	Aldikar = eq.get_entity_list():GetMobByNpcTypeID(aldikarNPCID):CastToNPC();
	-- 5 dwarf hero spawns
	eq.signal(aldikarNPCID, 51);
	eq.signal(aldikarNPCID, 52);
	eq.signal(aldikarNPCID, 53);
	eq.signal(aldikarNPCID, 54);
	eq.signal(aldikarNPCID, 55);
end

function PostSetup()
	Aldikar:MoveTo(-125, -530, 77, 90, true);
	
	-- repop surviving heroes at thurg valley
	if eq.get_entity_list():IsMobSpawnedByNpcTypeID(garadainNPCID) then
		eq.depop(garadainNPCID);
		eq.signal(aldikarNPCID, 51);
	end	
	if eq.get_entity_list():IsMobSpawnedByNpcTypeID(dobbinNPCID) then
		eq.depop(dobbinNPCID);
		eq.signal(aldikarNPCID, 52);
	end	
	if eq.get_entity_list():IsMobSpawnedByNpcTypeID(corbinNPCID) then
		eq.depop(corbinNPCID);
		eq.signal(aldikarNPCID, 53);
	end	
	if eq.get_entity_list():IsMobSpawnedByNpcTypeID(karginNPCID) then
		eq.depop(karginNPCID);
		eq.signal(aldikarNPCID, 54);
	end	
	if eq.get_entity_list():IsMobSpawnedByNpcTypeID(churnNPCID) then
		eq.depop(churnNPCID);
		eq.signal(aldikarNPCID, 55);
	end
end

function GiantSpawn()
        local spawn_time = 120000 -- hard set this to 2 minutes

	if first then -- checks for first execution
		spawn_time = 1000; -- shorter time for first wave
		first = false;
	end
	
	if boss_count == 4 then
		for i = 1, 5 do
			eq.stop_timer("Spawn" .. i, Aldikar);
		end
		if stage < 3 then
			spawn_time = 180000; -- longer pause before new stage
			boss_count = 0;
			miss_count = 0;
			stage = stage + 1;
			ConversationStart();
		elseif stage == 3 then
			stage = 4;
			next_spawn = { [0] = 0 };
			eq.set_timer("Narandi", 120000, Aldikar);
			return
		end
	end
	
	local boss;
	local prc = 25; -- pseudorandom constant (25 is ~50% chance)
	local boss_chance = math.random(100);
	if boss_chance <= prc * (miss_count + 1) then
		boss = 1;
		miss_count = 0;
		boss_count = boss_count + 1;
	else
		boss = 0;
		miss_count = miss_count + 1;
	end
	
	if stage == 1 then
		next_spawn = { [gRecruitNPCID] = 10, [gCaptainNPCID] = boss };
	elseif stage == 2 then
		next_spawn = { [gWarriorNPCID] = 8, [zekPriestNPCID] = 2, [gGeneralNPCID] = boss };
	elseif stage == 3 then
		next_spawn = { [gVeteranNPCID] = 8, [zekHighPriestNPCID] = 2, [gWarlordNPCID] = boss };
	end
	
	local spawn_loc = eq.ChooseRandom(1,2,3,4,5);
	eq.set_timer("Spawn" .. spawn_loc, spawn_time, Aldikar);
	
end

function ScoutMove(e)
	local pos = { e.other:GetX(), e.other:GetY(), e.other:GetZ(), 0.5 };
	if stage > 0 and not first then
		if(e.message:findi("Dobbin assist me")) then
			call_dwarves(pos, 6);
			e.self:Say("Dobbin is on his way!");
		elseif(e.message:findi("Garadain to my side")) then
			call_dwarves(pos, 7);
			e.self:Say("Garadain is on his way!");
		elseif(e.message:findi("Churn protect me")) then
			call_dwarves(pos, 8);
			e.self:Say("Churn is on his way");	
		elseif(e.message:findi("Corbin, attack!")) then
			call_dwarves(pos, 9);
			e.self:Say("Corbin is on his way!");
		elseif(e.message:findi("For the Dain, attack")) then
			call_dwarves({ pos[1], pos[2], pos[3], pos[4] }, 6);
			call_dwarves({ pos[1] - 22.5, pos[2] + 20, pos[3], pos[4] }, 7);
			call_dwarves({ pos[1] + 22.5, pos[2] + 20, pos[3], pos[4] }, 8);
			call_dwarves({ pos[1], pos[2] - 20, pos[3], pos[4] }, 9);
			e.self:Say("The commanders are on their way!");
		end
	else
		e.self:Say("Our troops are not yet ready! Please wait for the battle to be joined to give your orders!");
	end
end

function call_dwarves(position, group)
	-- grab the entity list
	local entity_list = eq.get_entity_list();
	local npc_list = entity_list:GetNPCList();
	if (npc_list ~= nil) then
		for npc in npc_list.entries do
			local status, groupID = pcall(get_group_ID, entity_data[npc:GetID()]) -- can probabaly be anonymous function
			if status then
				if (npc.valid and groupID == group) then
					table.insert(entity_data[npc:GetID()]['path'], position);
				end
			end
		end
	end
end

function get_group_ID(entity_entry)
	return entity_entry['groupID']
end

function GroupSpawn(num)
	local npcs = {};
	
	if num == 0 then
		-- west spears
		--spawn_Mobs(118341, 569, -2447, -86.4, 841, -1776, -33, 194, 12, 0);  old locs - needed to adjust zlocs for spearmen
		spawn_Mobs(gSpearmanNPCID, 569, -2447, -76.4, 841, -1776, -23, 388, 12, 0); 
		
		-- east spears
		spawn_Mobs(gSpearmanNPCID, -668, -2062, -60, -775, -2347, -75,  118,  6, 0);
		-- assign static 'path'
		eq.signal(gSpearmanNPCID, 0);
	elseif num == 1 then
		-- Garadain
		eq.unique_spawn(garadainNPCID, 0, 0, -125, -563, 75, 10);
	elseif num == 2 then
		-- Dobbin
		eq.unique_spawn(dobbinNPCID, 0, 0, -110, -558, 75, 480);
	elseif num == 3 then
		-- Corbin
		eq.unique_spawn(corbinNPCID, 0, 0, -98, -545, 75, 430);
	elseif num == 4 then
		-- Kargin
		eq.unique_spawn(karginNPCID, 0, 0, -90, -530, 75, 386);
	elseif num == 5 then
		-- Churn
		eq.unique_spawn(churnNPCID, 0, 0, -90, -515, 75, 340);
	elseif num == 6 then
		-- Dobbin soldiers by towers
		npcs = { [dSoldierNPCID] = 12 };
		spawn_helper(npcs, 6, 1, 12, 15, 256);
		-- archers on top of towers
		spawn_Mobs(dArcherNPCID, -155, -1080, 70, -195, -1080, 70, 256, 3, 0);
		spawn_Mobs(dArcherNPCID, 120, -1080, 70, 160, -1080, 70, 256, 3, 0);
		eq.signal(dArcherNPCID, 0);
		-- Dobbin - REPLACE WITH WALK TO POSITION!!!
		eq.unique_spawn(dobbinNPCID, 0, 0, -10, -1070, 25, 256);
		eq.signal(dobbinNPCID, 6);
	elseif num == 7 then
		-- Garadain soldiers by spire
		npcs = { [dSoldierNPCID] = 6, [dClericNPCID] = 6 };
		spawn_helper(npcs, 7, 2, 6, 15, 256);
		-- archers behind Garadain's troops
		spawn_Mobs(dArcherNPCID, -1770, -525, 80, -1845, -525, 80, 256, 6, 0);
		eq.signal(dArcherNPCID, 0);
		-- Garadain - REPLACE WITH WALK TO POSITION!!!
		eq.unique_spawn(garadainNPCID, 0, 0, -1800, -570, 75, 256);
		eq.signal(garadainNPCID, 7);
	elseif num == 8 then
		-- Churns troops by tizmak cave
		npcs = { [dAxemanNPCID] = 12 };
		spawn_helper(npcs, 8, 2, 6, 15, 256);
		-- Churn - REPLACE WITH WALK TO POSITION!!!
		eq.unique_spawn(churnNPCID, 0, 0, 1600, -1030, 330, 256);
		eq.signal(churnNPCID, 8);
	elseif num == 9 then
		-- Corbin troops near wurms
		npcs = { [dSoldierNPCID] = 6, [dClericNPCID] = 6 };
		spawn_helper(npcs, 9, 2, 6, 15, 0);
		-- Corbin - REPLACE WITH WALK TO POSITION!!!
		eq.unique_spawn(corbinNPCID, 0, 0, 200, -2885, -150, 0);
		eq.signal(corbinNPCID, 9);
	elseif num == 10 then
		-- Archers with Kargin
		spawn_Mobs(dArcherNPCID, 950, -1250, 170, 950, -1450, 170, 380, 12, 0);
		-- Kargin
		eq.unique_spawn(karginNPCID, 0, 0, 935, -1350, 160, 380);
		-- assign static 'path'
		eq.signal(karginNPCID, 0);
		eq.signal(dArcherNPCID, 0);
	elseif num == 11 then
		-- Seneschal Aldikar move
		eq.move_to(-113, 0, 100, 128, true);
		-- eq.unique_spawn(118351, 0, 0, -113, 0, 100, 256);
		-- Aldikar archers
		spawn_Mobs(dArcherNPCID, -156, -34, 95, -156, -115, 95, 160, 6, 0);
		spawn_Mobs(dArcherNPCID, -56, -34, 95, -56, -115, 95, 320, 6, 0);
		-- assign static 'path'
		eq.signal(dArcherNPCID, 0);
		eq.signal(aldikarNPCID, 0);
	end
end

function WarDeath(e)
	e.self:Shout("I have fallen brothers! Retreat!");
	if stage > 4 then
		WarEnd(1)
	else
		WarEnd(0)
	end
end

function WarEnd(end_type)
	-- endtypes: 0 - Loss (thurg dies, giants pop), 1 - Win (simple zone repop)
	eq.repop_zone(false);
	-- npc ID for controller was 118361 on p2002
	local controller = eq.unique_spawn(controllerNPCID, 0, 0, -5000, -5000, 0, 0);
	if end_type < 1 then
		local defeat_mobs = {};
		table.insert(defeat_mobs, eq.spawn2(gVeteranNPCID, 0, 0, -130, -250, 100, 100));
		table.insert(defeat_mobs, eq.spawn2(gVeteranNPCID, 0, 0, -130, -212, 100, 100));
		table.insert(defeat_mobs, eq.spawn2(gVeteranNPCID, 0, 0, -130, -174, 100, 100));
		table.insert(defeat_mobs, eq.spawn2(gVeteranNPCID, 0, 0, -130, -136, 100, 100));
		table.insert(defeat_mobs, eq.spawn2(gVeteranNPCID, 0, 0, -130, -98, 100, 100));
		table.insert(defeat_mobs, eq.spawn2(gVeteranNPCID, 0, 0, -130, -60, 100, 100));
		table.insert(defeat_mobs, eq.spawn2(gVeteranNPCID, 0, 0, -70, -250, 100, 160));
		table.insert(defeat_mobs, eq.spawn2(gVeteranNPCID, 0, 0, -72, -212, 100, 160));
		table.insert(defeat_mobs, eq.spawn2(gVeteranNPCID, 0, 0, -74, -174, 100, 160));
		table.insert(defeat_mobs, eq.spawn2(gVeteranNPCID, 0, 0, -76, -136, 100, 160));
		table.insert(defeat_mobs, eq.spawn2(gVeteranNPCID, 0, 0, -78, -98, 100, 160));
		table.insert(defeat_mobs, eq.spawn2(gVeteranNPCID, 0, 0, -80, -60, 100, 160));
		table.insert(defeat_mobs, eq.spawn2(gWarlordNPCID, 0, 0, -90, 5, 98, 192));
		table.insert(defeat_mobs, eq.spawn2(gWarlordNPCID, 0, 0, -135, 5, 98, 64));

		for _, v in ipairs(defeat_mobs) do
			eq.set_timer("depop", 86400000, v);
		end
		
		--eq.set_global("RingTen","FAIL",7,"H24");
	end
	
	eq.set_timer("depop", 1000, controller);
end

function WarTimers(e)
	if e.timer == "TMHB" then
		ThreadManager:GarbageCollect();
		ThreadManager:Resume("Conversation");
	elseif e.timer == "RingTenHB" then
		for _,v in pairs(Giants) do
			eq.signal(v, 99)
		end
		for _,v in pairs(Dwarves) do
			eq.signal(v, 99)
		end
		for _,v in pairs(Heroes) do
			eq.signal(v, 99)
		end
	elseif e.timer == "Spawn1" then
		eq.stop_timer("Spawn1");
		spawn_helper(next_spawn, 1, 1, 12, 40, 0);
		GiantSpawn()
	elseif e.timer == "Spawn2" then
		eq.stop_timer("Spawn2");
		spawn_helper(next_spawn, 2, 6, 2, 20, 0);
		GiantSpawn()
	elseif e.timer == "Spawn3" then
		eq.stop_timer("Spawn3");
		spawn_helper(next_spawn, 3, 6, 2, 15, 128);
		GiantSpawn()
	elseif e.timer == "Spawn4" then
		eq.stop_timer("Spawn4");
		spawn_helper(next_spawn, 4, 6, 2, 20, 0);
		GiantSpawn()
	elseif e.timer == "Spawn5" then
		eq.stop_timer("Spawn5");
		spawn_helper(next_spawn, 5, 6, 2, 20, 384);
		GiantSpawn()
	elseif e.timer == "Narandi" then
		eq.stop_timer("Narandi");
		local combo = table_concat(Heroes, Giants);
		table.insert(combo, narandiNPCID);
		depop_except(combo);
		PostSetup();
		eq.unique_spawn(narandiNPCID, narandiGridNum, 0, 250, -2300, -80, 0);
		e.self:Shout("Outlander! Narandi is plotting his retreat! Don't let him escape alive!");
		local Narandi = eq.get_entity_list():GetMobByNpcTypeID(narandiNPCID);
		Narandi:SetRunning(true);
		eq.set_timer("NarDepop", 1800000);
	elseif e.timer == "handin1" then
		eq.stop_timer("handin1");
		if stage < 1 then
			e.self:Say("Outlander, the enemy approaches. Proceed or we will have to carry on without your help! You have one minute remaining.");
			eq.set_timer("handin2", 60000);
		end
	elseif e.timer == "handin2" then
		eq.stop_timer("handin2");
		if stage < 1 then
			e.self:Say("We've waited too long! To your posts!");
			eq.depop(zrelikNPCID);
			eq.signal(aldikarNPCID, 61, 1000);
			stage = 1;
		end
	elseif e.timer == "NarDepop" then
		eq.stop_timer("NarDepop");
		if stage < 5 then
			local Narandi = eq.get_entity_list():GetMobByNpcTypeID(narandiNPCID):CastToNPC();
			Narandi:Shout("Fools! I shall return and your pitiful city will fall!");
			WarEnd(1);
		end
	elseif e.timer == "WarEnd" then
		eq.stop_timer("WarEnd");
		WarEnd(1);
	else
		eq.depop(tonumber(e.timer));
	end
end

function AllSpawn(e)
	
	local NpcID = e.self:GetNPCTypeID();
	
	if NpcID == aldikarNPCID then
		eq.set_timer("TMHB", 100);
		eq.set_timer("RingTenHB", 5000);
	end
	
	-- check for NPCs that match list of giants and set their runspeed to SoW
	if is_in(NpcID, Giants) or NpcID == narandiNPCID then
		e.self:ModifyNPCStat("runspeed","1.875");
		
	-- permaroot the permarooted mobs
	elseif is_in(NpcID, Statics) then
		e.self:ModifyNPCStat("runspeed","0");
		if NpcID ~= gSpearmanNPCID then
			e.self:AddItem(30149, 0, true)
		end

	-- check for NPCs that match list of Dwarves and heroes and set them to run
	elseif is_in(NpcID, table_concat(Dwarves, Heroes)) then
		e.self:SetRunning(true);
	
	end
end

function AllSignal(e)
	if e.signal >= 0 and e.signal <= 20 and not entity_data[e.self:GetID()] then
		-- sets paths for any naive NPCs (NPCs with set paths are unaffected)
		entity_data[e.self:GetID()] = load_entity_data(PathInfo[e.signal], e.self:GetX(), e.self:GetY(), e.signal);
	elseif e.self:GetNPCTypeID() == aldikarNPCID and e.signal >= 50 and e.signal <= 70 then
		group_num = e.signal - 50;
		GroupSpawn(group_num);
	elseif e.self:GetNPCTypeID() == aldikarNPCID and e.signal > 100 and e.signal <= 105 then
		stage = e.signal - 100;
	elseif e.self:GetNPCTypeID() == aldikarNPCID and e.signal == 999 and stage == -1 then
		ConversationStart();
	end
	
	issue_move(e.self:GetID(), e.self:GetNPCTypeID());
end

function AllCombat(e)
	if not e.joined then
		if not e.self:GetNPCTypeID() == zrelikNPCID then
			local min_dist = 100000;  -- arbitrarily large value to start
			local new_wp = entity_data[e.self:GetID()]['wp'];
		
			for i, v in ipairs(entity_data[e.self:GetID()]['path']) do
				distance = dist(e.self:GetX(), e.self:GetY(), v[1], v[2]);
				if distance < min_dist and i >= new_wp then
					min_dist = distance;
					new_wp = i
				end
			end

			entity_data[e.self:GetID()]['wp'] = new_wp;
			-- ensures that mobs kited during walking phase get properly set to running when kited closer to end of path
			if new_wp > 1 and e.self:GetNPCTypeID() ~= narandiNPCID then
				e.self:SetRunning(true);
			end
		
			issue_move(e.self:GetID(), e.self:GetNPCTypeID())
		end
	end
end

function Badain_Waypoint_Arrive(e)
	eq.signal(aldikarNPCID,999);
end

function GMControl(e)
	if e.self:Admin() > 100 then
		if(e.message:findi("help")) then
			e.self:Message(1, 'This is a simple control script - at any point after giants start spawning, say [stage1] to reset event to start of first set of waves, [stage2] to reset event to start of second set of waves, [stage3] to reset event to start of third set of waves, or [Narandi] to start Narandi timer directly.')
		elseif e.message:findi("stage") then
			if stage > 0 then
				local stage_num = tonumber(string.sub(e.message, string.find(e.message, '%d+')));
				stage_set(stage_num);
				e.self:Message(1, 'Stage set.')
				eq.debug(string.format('Ring10 event - %s set war to stage %s', e.self:GetName(), stage_num))
			else
				e.self:Message(1, 'Please wait to set stage.')
			end
		elseif e.message:findi("narandi") then
			if stage > 0 then
				stage_set(4);
				e.self:Message(1, 'Stage set.')
				eq.debug(string.format('Ring10 event - %s set war to Narandi', e.self:GetName()))
			else
				e.self:Message(1, 'Please wait to set stage.')
			end
		end
	end
end

function stage_set(target)
	eq.stop_all_timers();
	eq.set_timer("TMHB", 100);
	eq.set_timer("RingTenHB", 5000);
	eq.zone_emote(1, "Urged on by a higher power, the giants regroup and change their tactics.");
	
	if target < 4 then
		stage = target;
		boss_count = 0;
	elseif target == 4 then
		stage = 3;
		boss_count = 4;
	end
	
	miss_count = 0;
	GiantSpawn();
end

function AllWaypoint(e)
	if is_in(e.self:GetNPCTypeID(), Giants) then
		e.self:SetRunning(true);
	end
	if (entity_data[e.self:GetID()]) then
		entity_data[e.self:GetID()]['wp'] = entity_data[e.self:GetID()]['wp'] + 1;
	end
	issue_move(e.self:GetID(), e.self:GetNPCTypeID())
end

function issue_move(id, npc)
	local heading;
	if is_in(npc, Giants) then
		heading = 0;
	else
		heading = 128;
	end

	local status, wp = pcall(waypoint_helper, entity_data[id]);
	if status then
		eq.move_to(wp['x'], wp['y'], wp['z'], heading, true);
	end
end

function waypoint_helper(data)
	return get_waypoint(data['path'][data['wp']], data['x'], data['y'])
end

function get_waypoint(locs, offX, offY)
	local way = {};

	way['x'] = locs[1] + offX * locs[4];
	way['y'] = locs[2] + offY * locs[4];
	way['z'] = locs[3];
	
	return way
end

function load_entity_data(path, myX, myY, group)
	local off = {};
	local start_loc = path[0];
	
	off['x'] = myX - start_loc[1];
	off['y'] = myY - start_loc[2];
	off['wp'] = 1;
	off['path'] = path;
	off['groupID'] = group;
	
	return off
end

function spawn_helper(npcs, path, col, row, spacing, heading)
	spawn_Mobs_tables(npcs, PathInfo[path][0], col, row, spacing, heading);
	for i in pairs(npcs) do
		if i ~= narandiNPCID then
			eq.signal(i, path);
		else
			eq.signal(i, path, 60000);
		end
	end
end

function spawn_Mobs(npcId, startX, startY, startZ, endX, endY, endZ, heading, numMobs, grid)
	local xDiff = round((startX - endX) / numMobs, 0) * -1;
	local yDiff = round((startY - endY) / numMobs, 0) * -1;
	local zDiff = round((startZ - endZ) / numMobs, 0) * -1;
	
	for i = 0, numMobs-1 do
		eq.spawn2(npcId, grid, 0, startX + (xDiff*i), startY + (yDiff*i), startZ + (zDiff*i), heading);
	end
end

function spawn_Mobs_tables(npcs, locs, columns, rows, spacing, heading)
	-- npcs is a table of format { [npcID] = number_to_spawn }
	local startX = locs[1] - (rows / 2) * spacing;
	local startY = locs[2] - (columns / 2) * spacing;
	local startZ = locs[3];
	
	-- iterate over whole table to get all keys
	local keyset = {};
	for k, v in pairs(npcs) do
		if v > 0 then
			table.insert(keyset, k)
		end
	end
	
	local empty = false;
	for j = 0, rows-1 do
		if empty then
			break
		end
		for i = 0, columns-1 do
			if next(keyset) == nil then
				empty = true
				break
			end
			
			local k = math.random(#keyset);
			local new_npc = keyset[k];
			eq.spawn2(new_npc, 0, 0, startX + spacing*j, startY + spacing*i, startZ, heading);
			npcs[keyset[k]] = npcs[keyset[k]] - 1;
			if npcs[keyset[k]] == 0 then
				table.remove(keyset, k)
			end
		end
	end

end

function depop_except(except, timer)
	timer = timer or false;
	-- grab the entity list
	local entity_list = eq.get_entity_list();
	local npc_list = entity_list:GetNPCList();
	local exclude_npc_list = Set(except);
	if (npc_list ~= nil) then
		for npc in npc_list.entries do
			if (exclude_npc_list[npc:GetNPCTypeID()] == nil) then
				-- npc.valid will be true if the NPC is actually spawned - also skips pets
				if npc.valid and not npc:IsPet() and npc:GetRace() ~= 216 then
					if timer then
						npc:Depop(true)
					else
						npc:Depop()
					end
				end
			end
		end
	end
end

function load_paths()
	-- path format is X, Y, Z, spread multiplier (no spread multiplier for spawn location at this time)
	local wps = {};
	
	-- STATIC NPCS
	wps[0] = { [0] = {0, 0, 0} }; 
	
	-- GIANTS
	-- south spawn - line spawn
	wps[1] = { [0] = {250, -2300, -55}; [1] = {150, -1700, 15, .75}; [2] = {-50, -1000, 50, 0.35}; [3] = {-110, -20, 125, 0}; [4] = {-110, 50, 125, 0}};
	
	-- far east spawn (near spires) - clustered spawn
	wps[2] = { [0] = {-2400, -1900, -10}; [1] = {-2050, -850, 130, 1}; [2] = {-1900, -600, 100, 1}; [3] = {-600, -1200, 50, 0.5}; [4] = {-50, -1000, 50, 0.5}; [5] = {-110, -20, 125, 0}; [6] = {-110, 50, 125, 0} };
	
	-- near east spawn (behind spearmen) - clustered spawn
	wps[3] = { [0] = {-1100, -2100, -30}; [1] = {0, -2100, -30, 0.75}; [2] = {-50, -1000, 50, 0.35}; [3] = {-110, -20, 125, 0}; [4] = {-110, 50, 125, 0} };
	
	-- west spawn, north route - clustered spawn
	wps[4] = { [0] = {1200, -2100, -40}; [1] = {1400, -1500, 195, 1}; [2] = {1550, -1000, 355, 1}; [3] = {1000, -1000, 235, 0.75}; [4] = {-50, -1000, 50, 0.5}; [5] = {-110, -20, 125, 0}; [6] = {-110, 50, 125, 0}  };
	
	-- west spawn, river route - clustered spawn
	wps[5] = { [0] = {1200, -2100, -30}; [1] = {600, -2000, -5, 1}; [2] = {600, -1300, 25, 1}; [3] = {400, -1000, 40, 0.75}; [4] = {-50, -1000, 40, 0.5}; [5] = {-110, -20, 115, 0}; [6] = {-110, 50, 115, 0}  };
	
	
	-- DWARVES
	-- Dobbin group at towers
	wps[6] = { [0] = {-10, -1080, 25} };
	-- Garadain group at spire
	wps[7] = { [0] = {-1800, -540, 70} };
	-- Churn group at Tizmak cave
	wps[8] = { [0] = {1600, -1000, 330} };
	-- Corbin group at Tizmak cave
	wps[9] = { [0] = {200, -2900, -150} };

	-- NARANDI
	wps[10] = { [0] = {250, -2300, -80}; [1] = {-1100, -2100, -55, 1}; [2] = {-2400, -1900, -35, 1}; [3] = {-4750, -1800, 240, 1}};  --not used
	return wps
end

function round(num, dec)
	local temp = 10^dec;
	return math.floor(num * temp + .5) / temp;
end

function is_in(el, array)
	for i,v in pairs(array) do
		if v == el then
			return true
		end
	end

	return false
end

function dist(x1, y1, x2, y2)
	local dist = 0;
	dist = math.abs(x1 - x2) + math.abs(y1 - y2);
	
	return dist
end

-- Set function example from Programming In Lua
-- http://www.lua.org/pil/11.5.html
function Set(list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

function table_concat(table1, table2)
	local table_final = {};
	for k, v in pairs(table1) do
		table.insert(table_final, v)
	end
	for k, v in pairs(table2) do
		table.insert(table_final, v)
	end
	return table_final
end
