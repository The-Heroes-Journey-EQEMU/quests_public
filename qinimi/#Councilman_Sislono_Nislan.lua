local thunder_dome_locs 		= {[1] = {-1833.56, -1077.92, -16.87, 133}, [2] = {-1831.30, 1639.81, -16.87, 133}, [3] = {-66.72, 1639.5, -18.12, 133} };
local controllers				= {281145, 281164, 281185};
local mass_of_stones			= {281146, 281076, 281041};
local encounter_names			= {"thunder_dome_one", "thunder_dome_two", "thunder_dome_three"};
local thunder_dome_id;
local raid_id_by_thunder_dome	= {};
local zone_id					= eq.get_zone_id();

function event_say(e)
	local qglobals = eq.get_qglobals(e.self, e.other);
	local instance_id = eq.get_zone_instance_id();
	local raid = e.other:GetRaid();
	local raid_id = raid:GetID();
	local event_up_1 = eq.get_entity_list():GetMobByNpcTypeID(mass_of_stones[1]);
	local event_up_2 = eq.get_entity_list():GetMobByNpcTypeID(mass_of_stones[2]);
	local event_up_3 = eq.get_entity_list():GetMobByNpcTypeID(mass_of_stones[3]);

	if qglobals["bic_qin"] ~= nil and qglobals["bic_qin"] > "2" then
		if e.message:findi("ritual") then
			e.other:Message(MT.NPCQuestSay, "While animating stone comes easy for us, sometimes we need an extremely powerful stone worker to help with the city. These stone servants were made through a ritual which combined the power of eight geomancers into a ninth. This geomancer would then imbue a stone worker with this power, resulting in a more powerful construct. We stopped doing the ritual when we discovered that it could take away our ability over time. If [she] has somehow figured out a way to absorb this power, then my people could be in more danger than I thought possible.'");
		elseif e.message:findi("she") then
			e.other:Message(MT.NPCQuestSay, "We refer to her as the silent one, but the legion calls her Xictic. She is one of their kind who can use magic and she seems to be quite feared by everyone in this area. She comes here sometimes and takes three of us into the building with the glowing dome around it. Along with her are eight magic-using invaders and some of the slavers. When they are finished, only members of the legion leave. None of my people who enter are ever seen again. If what this says is true, you must stop her. If she succeeds, she will be able to control our stone servants at will and cause even more destruction. I beg you to stop her. I will help you in any way if you [promise] to stop her.'");
		elseif e.message:findi("promise") then
			e.other:Message(MT.NPCQuestSay, "I cannot tell you how relieved this makes me. Now to the issue at hand. While Xictic and those she chooses can roam freely in and out of the magical dome surrounding the chamber, if anyone else tries to enter they are held back. As a councilman, I was granted a device that allows access into the dome and I've managed to keep it away from the prying eyes of the Mata Muram. Using it is not without its consequences, though. As soon as an outsider shows up within the dome, they will know what has occurred and will come searching for the culprit so be certain you are ready to face the challenges ahead before you embark upon this venture. Only eighteen of you will be allowed into the chamber at one time so gather your forces and tell me you are [ready] to face Xictic.'");
		elseif e.message:findi("ready") then
			if e.other:GetGroupMemberCount() >= 1 or e.other:IsRaidGrouped() then
				e.self:Emote("pulls out a small stone and closes it in his hand. 'Please be careful. What you are about to see may shock you at first, but don't let yourself be distracted for too long. These beings are merciless and once they have discovered your presence, they will stop at nothing to add your corpse to the others in the area.'");

				if qglobals["gates_thunder_dome_event_1"] == nil and event_up_1.valid and raid_id_by_thunder_dome[1] == nil then
					raid_id_by_thunder_dome[1] = raid_id;	-- assign new raid id
					thunder_dome_id = 1;					-- thunder_dome_id 1 available
				elseif qglobals["gates_thunder_dome_event_2"] == nil and event_up_2.valid and raid_id_by_thunder_dome[2] == nil then
					raid_id_by_thunder_dome[2] = raid_id;	-- assign new raid id
					thunder_dome_id = 2;					-- thunder_dome_id 2 available
				elseif qglobals["gates_thunder_dome_event_3"] == nil and event_up_3.valid and raid_id_by_thunder_dome[3] == nil then
					raid_id_by_thunder_dome[3] = raid_id;	-- assign new raid id
					thunder_dome_id = 3;					-- thunder_dome_id 3 available
				else
					thunder_dome_id = -1;					-- no thunder_dome_ids available
				end
				
				if thunder_dome_id > 0 and thunder_dome_id < 4 and raid_id_by_thunder_dome[thunder_dome_id] == raid:GetID() then
					local instance_id = eq.get_zone_instance_id();
					e.self:Emote("SCREAMS and Ports everyone up... maybe?");
					raid:TeleportRaid(e.self, zone_id, instance_id, unpack(thunder_dome_locs[thunder_dome_id]))
					eq.depop_all(controllers[thunder_dome_id]) -- Depop TD_Status_One Prior
					eq.load_encounter(encounter_names[thunder_dome_id]);
				else
					e.self:Say("Event is not available");
				end
			else
				e.other:Message(MT.Red, "You are very brave to offer your assistance, but you should join a raiding party before I bring you into the land of nightmares.");
			end
		end
	elseif qglobals["bic_qin"] ~= nil and qglobals["bic_qin"] == "2" then
		if e.message:findi("thing") then
			e.other:Message(MT.NPCQuestSay, "Councilman Sislono Nislan says, 'The geomantic device which raises you into the courtroom is an ancient one and takes time to reset after it has been used. If you are having trouble entering, be patient. You will know it is ready to receive a key when you hear a grinding sound from the base of the device as it settles into place. Please be sure you are fully prepared before entering. While it once was a place of peaceful discussion, the courtroom is now a place where terrible torture is conducted by those the legion wants information from. When they see uninvited guests, they will not be very happy. The leader of this area's force is known as Tixxrt and stopping him is the only way you can save the small one, called Kreshin.'");
		elseif e.message:findi("stone of entry") then
			e.other:Message(MT.NPCQuestSay, "Councilman Sislono Nislan says, 'Gaining access to such a private place has always been reserved for the elders of my people. While the legion may have destroyed our home, they have yet to figure out a way around many of our wards that bar access to our sacred areas. Unfortunately, their frustration at gaining entry resulted in the painful torture of many of my people until they were given the keys to enter. The courtroom requires one of these keys and while the invaders hold all of the existing keys, I can create one if you can retrieve the proper [items].'");
		elseif e.message:findi("items") then
			e.other:Message(MT.NPCQuestSay, "Councilman Sislono Nislan says, 'The key consists of mud, some stonedust particles, and a piece of chalk. The mud can be found in the sewers beneth the city. The stonedust is plentiful near the coliseum, and the chalk can be found all over this area. Bring these to me and I will make you a temporary key which will grant you access to the courtroom. I implore you to hurry. I fear the one you seek may not be alive much longer.'");
		end
	else
		if e.message:findi("hail") then
			e.other:Message(MT.NPCQuestSay, "Councilman Sislono Nislan says, 'While I place my own life at risk by helping you, I feel a strong sense of honor amongst you and those who have come with you. It is because of this that I will try to help in anyway I can.'")
		end
	end
end

function event_signal(e)
	raid_id_by_thunder_dome[e.signal] = nil;
	eq.delete_global("gates_thunder_dome_event_" .. e.signal);
	eq.depop_all(controllers[e.signal])									-- Depop TD_Status Prior
	eq.unload_encounter(encounter_names[e.signal]);						-- Unload Encounter
	eq.spawn2(controllers[e.signal],0,0,-1745.66,-1078.70,-16.50,128);	-- TD_Status
	eq.signal(controllers[e.signal],1);									-- TD_Status - Start booting anyone who zones in after event
end

function event_trade(e)
	local qglobals = eq.get_qglobals(e.self, e.other);
	local item_lib = require("items");
	if qglobals["bic"] ~= nil and qglobals["bic"] >= "1" and item_lib.check_turn_in(e.trade, {item1 = 67700}) then -- Item: Kreshin's Journal Page
		e.other:Message(MT.NPCQuestSay, "Councilman Sislono Nislan says, 'Yes, I have seen this and others like it before. While we do not understand where it comes from, we have come to the conclusion that these strange glyphs express somthing important to your people. These particular glyphs were made by the small one they hold captive in the courtroom. If you wish to help him, you will have to retrieve the [stone of entry]. Only with this stone can you enter the courtroom and help the one who calls himself Kreshin.");
		eq.set_global("bic_qin","2",5,"F");
	elseif qglobals["bic_qin"] ~= nil and qglobals["bic_qin"] == "2" and item_lib.check_turn_in(e.trade, {item1 = 67398,item2 = 67399,item3 = 67400}) then -- Item: Stonedust Particles, Glob of Mud, Piece of Chalk
		e.other:Message(MT.NPCQuestSay, "Sislono covers the three pieces in his hands, closes his eyes, and begins to chant. A glow begins to emanate from his hands and he begins to chant louder. Then, just as quickly as it began, the glow in his hands dims and the chanting stops. 'There you are -- the key which grants you and your party access to the courtroom. Just stand on the pedestal in the center of the large building in this part of the city with the key in your hand and say you wish to enter. There is one more [thing] I must tell you before you go.'");
		e.other:QuestReward(e.self,0,0,0,0,67415,eq.ExpHelper(60)); -- Item: Stone of Entry
	elseif item_lib.check_turn_in(e.trade, {item1 = 67403}) then -- Item: Stonedust Particles, Glob of Mud, Piece of Chalk
		e.other:Message(MT.NPCQuestSay, "These glyphs look quite familiar. They are definitely in my language, but it seems as if the one who etched them did so against his will. Where did you get this? Wait, don't tell me. I know. Kreshin must have been successful in finding out what was going on in the Chamber of Souls. These glyphs detail how to animate stone using our geomancy abilities. There are some strange symbols toward the bottom, but for the most part, this is our language. Could he be trying to conduct the [ritual] of my people?'");
		if qglobals["bic_qin"] ~= nil and qglobals["bic_qin"] < "3" then
			eq.set_global("bic_qin","3",5,"F");
		end
	end
	item_lib.return_items(e.self, e.other, e.trade)
end
