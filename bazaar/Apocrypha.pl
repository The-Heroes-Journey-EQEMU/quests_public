# Basic Design
# EoM (Server-Wide) buffs work by three methods;
# 1) Send a worldwide client signal, global_player catches it and applies the requested buffs
# 2) Set a bucket value with a 4 hour expiration.
# 3) Zone and Login methods in global_player apply the requested buffs with the requested durations

my $duration_override = 1200; #set this value to override 'regular' buffs duration

my $buff_map = {
    1 => [2525, 314, 278, 145, 170], # Free - Harnessing of Spirit, Resolution, Spirit of Wolf, Chloroplast, Alacrity
    20 => [2525, 314, 278, 145, 170], # 10pp - Harnessing of Spirit, Resolution, Spirit of Wolf, Chloroplast, Alacrity
    46 => [2530, 2510, 2524, 2528, 2895, 2570], # 250pp - Khura's Focus, Blessing of Aegolism, Spirit of Bih'li, Regrowth of Dark Khura, Speed of the Brood, Koadics Endless Intellect
    61 => [3397, 3479, 2524, 3441, 3178, 3360], # 500pp - Voice of Quellious, Vallons Quickening, Blessing of Replenishment, Spirit of Bih'li, Hand of Virtue, Focus of the Seventh
    # ... more ...
};

my $price_map = {
    1  => 0,
    20 => 10,
    46 => 100,
    61 => 250,
};

sub get_level_breakpoint {
    my ($client_level) = @_;
    my $closest_level = 0;

    foreach my $level (keys %$buff_map) {
        if ($level <= $client_level && $level > $closest_level) {
            $closest_level = $level;
        }
    }

    return $closest_level;
}

sub apply_buffs {
    my ($client, $closest_level, $duration_override, $duration_scale, $price_scale) = @_;

    $duration_override *= $duration_scale;

    if ($closest_level > 0) {
        if ($client->TakeMoneyFromPP($price_map->{$closest_level} * 1000 * $price_scale, 1)) {
            my $price = $price_map->{$closest_level} * $price_scale;
            $client->Message(15, "You have given $price platinum to Apocrypha.");
            my $buffs = $buff_map->{$closest_level};

            foreach my $buff (@$buffs) {
                my $group = $client->GetGroup();

                if ($group) {
                    for ($count = 0; $count < $group->GroupCount(); $count++) {
                        my $player = $group->GetMember($count);       
                        if ($player) {
                            $player->ApplySpell($buff, $duration_override);
                            if ($player->GetPet()) {
                                $player->GetPet()->ApplySpellBuff($buff, $duration_override);
                            }
                        }
                    }
                } else {
                    $client->ApplySpell($buff, $duration_override);
                    if ($client->GetPet()) {
                        $client->GetPet()->ApplySpellBuff($buff, $duration_override);
                    }
                }
            }

            plugin::Whisper("Enjoy your newfound power.");
        } else {
            plugin::Whisper("You do not have enough coin to afford that.");
        }
    }
}

sub handle_buff_for_level {
    my $client_level = $client->GetLevel();
    my $closest_level = get_level_breakpoint($client_level);
    my ($duration_scale, $price_scale) = @_;
    
    $duration_scale //= 1;  # Set to 1 if not provided
    $price_scale //= 1;     # Set to 1 if not provided
    
    if (!plugin::IsSeasonal($client)) {
        apply_buffs($client, $closest_level, $duration_override, $duration_scale, $price_scale);
    }
}

sub EVENT_SAY {
    my $response = "";
    my $clientName = $client->GetCleanName();
    my $buff_id = 0;
    my $cost = 5;

    if ($text=~/hail/i) {
        if ($client->IsSeasonal() || plugin::MultiClassingEnabled()) {
            $response = "Hail, Adventurer. I seek to empower your ilk for my own profit. In exchange for [exotic payment], I will enhance the power of all adventurers in the world.";
        } else {
            $response = "Hail, Adventurer. I seek to empower your ilk for my own profit. For a [modest fee], I will enhance the power of your group for a time. In exchange for more [exotic payment], I will enhance the power of all adventurers in the world.";
        }
    }

    elsif ($text=~/modest fee/i) {
        my $level_break = get_level_breakpoint($client->GetLevel());

        my $plat_price = $price_map->{get_level_breakpoint($client->GetLevel())};        
       
        if ($plat_price == 0) {
            $response = "I will enhance you and your party with several [buffs] free of charge.";
        } else {
            $response = "In exchange for a fee of $plat_price platinum, I will enhance you and your party with several [buffs]. I can also apply these buffs for [double] their durations for three times the price.";
        }
    }

    elsif ($text=~/exotic payment/i) {
        $response = "In exchange for five [Echo of Memory], I can enchant the entire world! Each should co-exist with over versions of this type of effect, and will last four hours. If the world is already enchanted in this way, purchasing additional enhancement will extend the duration of the current enchantment. Would you like to enhance the [Experience Gain], [Hit Points and Armor Class], [Combat Statistics], [Movement Speed], [Mana Regeneration], [Attack Speed], or [Health Regeneration]? Alternatively, for twenty-five Echoes, I can cast [all of these enchantments]!";

        $response = $response . " For merely ten Echoes, I can [influence the tides of fate] in order to increase the rate that adventurers find rare items in the world!"
    }

    elsif ($text=~/experience gain/i) {        
        $buff_id = 43002;       
    }
    elsif ($text=~/hit points and armor class/i) {
        $buff_id = 43003;        
    }
    elsif ($text=~/combat statistics/i) {
        $buff_id = 43004;       
    }
    elsif ($text=~/movement speed/i) {
        $buff_id = 43005;
    }
    elsif ($text=~/mana regeneration/i) {
        $buff_id = 43006;
    }
    elsif ($text=~/attack speed/i) {
        $buff_id = 43007;
    }
    elsif ($text=~/health regeneration/i) {
        $buff_id = 43008;
    }

    elsif ($text=~/all of these enchantments/i) {
        if (plugin::SpendEOM($client, 25)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";            
            for my $value (43002 .. 43008) {
                plugin::ApplyWorldWideBuff($value);                
            }
            quest::reload_global_buffs();
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }

    elsif ($text=~/influence the tides of fate/i) {
        #Echo of Luck
        $buff_id = 17779;
        $cost = 10;
    }

    elsif ($text=~/buffs/i && !($client->IsSeasonal() || plugin::MultiClassingEnabled())) {        
        handle_buff_for_level();
    }

    elsif ($text=~/double/i && !($client->IsSeasonal() || plugin::MultiClassingEnabled())) {        
        handle_buff_for_level(2, 3);
    }

    if ($buff_id) {
        if (plugin::SpendEOM($client, $cost) && plugin::ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
            quest::reload_global_buffs();
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }        
    }  

    if ($response) {
        plugin::Whisper($response);
    }
}

sub EVENT_ITEM {
	#:: Return unused items
	plugin::return_items(\%itemcount);
}

sub ApplyGroupBuff {
    my $buff_id = shift;

    if ($client->TakeMoneyFromPP($platinum_price * 1000, 1)) {
        $client->ApplySpellGroup($buff_id, 2400);
        return 1;
    } else {
        return 0;
    }    
}