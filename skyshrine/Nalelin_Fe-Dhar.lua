-- Skyshrine Velious Armor - Ranger
local quest_helper		= require('velious_quest_helper');
local SKYSHRINE_ARMOR	= quest_helper.SKYSHRINE_ARMOR;

local QUEST_ITEMS = {
	quest_helper:melee_helmet(SKYSHRINE_ARMOR.Chain_Coif,		31112),	-- Items: Golden Leaf Helm
	quest_helper:melee_chest(SKYSHRINE_ARMOR.Chain_Tunic,		31113),	-- Items: Golden Leaf Breastplate
	quest_helper:melee_arms(SKYSHRINE_ARMOR.Chain_Sleeves,		31114),	-- Items: Golden Leaf Vambraces
	quest_helper:melee_bracer(SKYSHRINE_ARMOR.Chain_Bracer,		31115),	-- Items: Golden Leaf Bracer
	quest_helper:melee_gloves(SKYSHRINE_ARMOR.Chain_Gauntlets,	31116),	-- Items: Golden Leaf Gauntlets
	quest_helper:melee_legs(SKYSHRINE_ARMOR.Chain_Leggings,		31117),	-- Items: Golden Leaf Greaves
	quest_helper:melee_boots(SKYSHRINE_ARMOR.Chain_Boots,		31118)	-- Items: Golden Leaf Boots
};

function event_say(e)
	if e.other:GetFaction(e.self) == 1 then -- Ally
		if e.message:findi("hail") then
			e.self:Say("Greetings, I seek the ones who stalk through the forests protecting it. If you are one known as a ranger, submit to my will and become stronger. The tasks I set forth will not be easy. Are you ready to [" .. eq.say_link("submit to your will",false,"submit to my will") .. "]?");
		elseif e.message:findi("submit to your will") then
			e.self:Say("That is good, for there is nothing like the wrath of nature, woodland warrior. And Nature's wrath shall you be, with this armor to protect you in your struggle. I shall forge a [coif], [breastplate], [sleeves], [bracers], [gauntlets], [leggings], and [boots] for you.");
		elseif e.message:findi("coif") then
			e.self:Say("This coif shall protect you from battle and the elements. What I require of you are these: an unadorned chain coif and three pieces of crushed coral. Do not waste precious time!");
		elseif e.message:findi("breastplate") then
			e.self:Say("Even as the hardest tree in the forest gains protection from its bark, so shall you gain the protection of this breastChain. Bring these components for me - an unadorned chain tunic and three flawless diamonds.");
		elseif e.message:findi("sleeves") then
			e.self:Say("I require unadorned chain sleeves, as well as three flawed emeralds. Do this so that I may grant you them as a gift for your diligence.");
		elseif e.message:findi("bracers") then
			e.self:Say("This shall help shield your forearms from any stray blows. Bring me an unadorned chain bracelet and three crushed flame emeralds.");
		elseif e.message:findi("gauntlets") then
			e.self:Say("Bring me these items, for I will not grant you your pair until then - a pair of unadorned chain gauntlets and a set of three crushed topaz.");
		elseif e.message:findi("leggings") then
			e.self:Say("A pair of leggings you seek? I seek something as well. Bring me a pair of unadorned chain leggings and three flawed sea sapphires. Go now. The struggle continues as we speak.");
		elseif e.message:findi("boots") then
			e.self:Say("For the boots, I shall require a pair of unadorned chain boots as well as three pieces of crushed black marble.");
		end
	else
		e.self:Say("You must prove your dedication to the Claws of Veeshan before I will speak to you.");
	end
end

function event_trade(e)
	quest_helper:quest_turn_in(e, 1, QUEST_ITEMS, quest_helper.skyshrine_armor_success);
end
