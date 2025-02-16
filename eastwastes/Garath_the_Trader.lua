function event_say(e)
	if e.message:findi("hail") then
		e.self:Say("Hail to ya, Traveller, and well met! My Name's Garath, a warrior by trade, though I do dabble in some merchanting on the side. My exploring brought me here, and I saw some wonderous things. I ventured inside this ancient tomb with some friends, and oh! The horrors we encountered! I barely made it out alive, but I did manage to pick up some [weapons to trade].");
	elseif e.message:findi("weapons") then
		e.self:Say("Interested in a trade, are ya? Well, let me tell ya.. I headed into this tomb in hopes of getting a sword I could use, maybe a warhammer.. Humm, yeah a hammer woulda been good also.. Anyhow, I was unlucky in finding those, but I did manage to get a couple weapons... Sadly, they're really more suited to a [Monk] or a [Knight], not really much use to a warrior like myself at all.");
	elseif e.message:findi("monk") then
		e.self:Say("Ah, my eyes fail me lately.. Maybe the cold weather is getting to me? Well, in any case, I picked up some velium hand wraps inside the Tomb here, quite nice.. Yes indeed. I guess I would trade them to ya if you were to give me a warhammer for em. I gotta say, I'm not picky. I'd accept either a primal or a priceless warhammer, and give you these wraps in a straight trade. Heck, I'd take one of each and give you both these hand wraps.");
	elseif e.message:findi("knight") then
		e.self:Say("Knight? Yeah, I don't make much distinction, paladin or shadow knight, they're all knights to me. Well, look here, I got two swords from inside the tomb, but I'll be damned if either of em was suited for a warrior. Clearly a knight's blade, what bad luck for me. I was hopin for a good warsword. That's why I'm standin out here ya know? I was hopin I could find someone who might swap me either a primal or priceless warsword, and take one of these knightly swords in trade.");
	elseif e.message:findi("lungi") then
		e.self:Say("I don't care much for those silly robe wearers me self, but to each their own I suppose. You've got the look of someone who's lookin' for something a litte more intimidatin' than a dress. I'll trade ya your Lungi for somethin' with a rougher look!");
	end
end

function event_trade(e)
    local item_lib = require("items");
	
    if item_lib.check_turn_in(e.trade, {item1 = 27301}) then		-- Item: Priceless Velium Battlehammer
        e.self:Say("Ah, excellent! Guess standin out here in the cold proved worthwhile for me after all. You take that weapon and enjoy it, I know I`ll be getting some use of this one. Safe travel to ya, friend!");
        e.other:QuestReward(e.self,0,0,0,0,5833);					-- Item: Priceless Velium Fist Wraps
    elseif item_lib.check_turn_in(e.trade, {item1 = 27321}) then	-- Item: Primal Velium Battlehammer
        e.self:Say("Ah, excellent! Guess standin out here in the cold proved worthwhile for me after all. You take that weapon and enjoy it, I know I`ll be getting some use of this one. Safe travel to ya, friend!");
        e.other:QuestReward(e.self,0,0,0,0,27320);					-- Item: Primal Velium Fist Wraps
    elseif item_lib.check_turn_in(e.trade, {item1 = 27300}) then	-- Item: Priceless Velium Warsword
        e.self:Say("Ah, excellent! Guess standin out here in the cold proved worthwhile for me after all. You take that weapon and enjoy it, I know I`ll be getting some use of this one. Safe travel to ya, friend!");
        e.other:QuestReward(e.self,0,0,0,0,5834);					-- Item: Priceless Velium Knight's Sword
    elseif item_lib.check_turn_in(e.trade, {item1 = 27328}) then	-- Item: Primal Velium Warsword
        e.self:Say("Ah, excellent! Guess standin out here in the cold proved worthwhile for me after all. You take that weapon and enjoy it, I know I`ll be getting some use of this one. Safe travel to ya, friend!");
        e.other:QuestReward(e.self,0,0,0,0,5835);					-- Item: Primal Velium Knight's Sword
	elseif item_lib.check_turn_in(e.trade, {item1 = 29456}) then	-- Item: Lungi of the Forbidden
        e.self:Say("There ya are "..e.other:GetCleanName()..". Ya look much better now. If ya decide you don't like the look later on bring it back and I'll see what I can do.");
        e.other:QuestReward(e.self,0,0,0,0,59949);					-- Item: Lungi of the Forsaken
	elseif item_lib.check_turn_in(e.trade, {item1 = 59949}) then	-- Item: Lungi of the Forsaken
        e.self:Emote("grumbles as he hands back the Lungi. 'I got no idea why you'd want to go into battle wearin' a dress, but I won't be the one to stop ya. Good journey's "..e.other:GetCleanName()..".");
        e.other:QuestReward(e.self,0,0,0,0,29456);					-- Item: Lungi of the Forbidden
    end
    item_lib.return_items(e.self, e.other, e.trade);
end
