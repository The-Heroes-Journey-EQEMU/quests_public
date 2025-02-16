-- Skyshrine Velious Armor - Shaman
local quest_helper		= require('velious_quest_helper');
local SKYSHRINE_ARMOR	= quest_helper.SKYSHRINE_ARMOR;

local QUEST_ITEMS = {
	quest_helper:priest_helmet(SKYSHRINE_ARMOR.Chain_Coif,		31105),	-- Items: Wolf Caller's Helm
	quest_helper:priest_chest(SKYSHRINE_ARMOR.Chain_Tunic,		31106),	-- Items: Wolf Caller's Breastplate
	quest_helper:priest_arms(SKYSHRINE_ARMOR.Chain_Sleeves,		31107),	-- Items: Wolf Caller's Vambraces
	quest_helper:priest_bracer(SKYSHRINE_ARMOR.Chain_Bracer,	31108),	-- Items: Wolf Caller's Bracer
	quest_helper:priest_gloves(SKYSHRINE_ARMOR.Chain_Gauntlets,	31109),	-- Items: Wolf Caller's Gauntlets
	quest_helper:priest_legs(SKYSHRINE_ARMOR.Chain_Leggings,	31110),	-- Items: Wolf Caller's Greaves
	quest_helper:priest_boots(SKYSHRINE_ARMOR.Chain_Boots,		31111)	-- Items: Wolf Caller's Boots
};

function event_say(e)
	if e.other:GetFaction(e.self) == 1 then -- Ally
		if e.message:findi("hail") then
			e.self:Emote("speaks in a deep tone.");
			e.self:Say("Greetings. I wish to speak only to a shaman, so I might aid them with protection from the world in the form of [armor].");
		elseif e.message:findi("armor") then
			e.self:Say("For you I shall make a [coif], [breastplate], [sleeves], [bracers], [gauntlets], [leggings], and [boots]. Each piece is a quest unto itself. To seek the components, you must search the lands for them and test the power of the spirit within.");
		elseif e.message:findi("coif") then
			e.self:Say("For you I shall make a coif, breastplate, sleeves, bracers, gauntlets, leggings, and boots. Each piece is a quest unto itself. To seek the components, you must search the lands for them and test the power of the spirit within.");
		elseif e.message:findi("breastplate") then
			e.self:Say("A breastplate to protect the spirit within. I shall make one for you granted that you retrieve the components I shall need. An unadorned chain tunic and three pieces of black marble. I await your return.");
		elseif e.message:findi("sleeves") then
			e.self:Say("Sleeves I shall make upon receipt of unadorned chain sleeves and a set of three jaundice gems. Complete this simple task and they are yours.");
		elseif e.message:findi("bracer") then
			e.self:Say("A bracer of mystic power I shall grant you. All I require is the acquisition of an unadorned chain bracer and three crushed opals.");
		elseif e.message:findi("gauntlet") then
			e.self:Say("I shall require three crushed lava rubies and an unadorned pair of chain gauntlets to complete my ritual.");
		elseif e.message:findi("leggings") then
			e.self:Say("You seek leggings? Then provide for me unadorned chain leggings and three chipped onyx sapphires and I will give them to you for your service.");
		elseif e.message:findi("boots") then
			e.self:Say("These boots will help you in your never-ending quest. I shall grant them upon receipt of a pair of unadorned chain boots and three crushed flame emeralds.");
		end
	else
		e.self:Say("You must prove your dedication to the Claws of Veeshan before I will speak to you.");
	end
end

function event_trade(e)
	quest_helper:quest_turn_in(e, 1, QUEST_ITEMS, quest_helper.skyshrine_armor_success);
end
