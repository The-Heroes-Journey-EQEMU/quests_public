use List::Util qw(max);

sub DoEventRewards {
    my $client = shift || plugin::val('client');
    my $event_key = $client->AccountID() . "-event-";

    if (!$event_key || !$client) {
        return;
    }

    # Christmas 2024
    my $nice_24 = quest::get_data($event_key . "xmas24_ret_nice") || 0;
    my $nice_24_r = quest::get_data($event_key . "xmas24_ret_nice-rewarded") || 0;

    if (defined $nice_24 && $nice_24) {
        # Base Reward (val 1)
        if ($nice_24 >= 1 && $nice_24_r < 1) {
            plugin::AddTitleFlag(208);

            $client->SummonFixedItem(2827);
            $client->SummonFixedItem(2827);
            $client->SummonFixedItem(2827);
            $client->SummonFixedItem(2827);
            $client->SummonFixedItem(2827);

            quest::set_data($event_key . "xmas24_ret_nice-rewarded", max($nice_24_r, 1));
        }

        # 50 or More
        if ($nice_24 >= 2 && $nice_24_r < 2) {
            plugin::AddTitleFlag(209);
            if ($nice_24_r < 2) {
                $client->SummonFixedItem(2004041);
                quest::set_data($event_key . "xmas24_ret_nice-rewarded", max($nice_24_r, 2));
            }           
        }

        # Top 100
        if ($nice_24 == 3 && $nice_24_r < 3) {
            $client->SummonFixedItem(66314);
            quest::set_data($event_key . "xmas24_ret_nice-rewarded", max($nice_24_r, 3));
        }

        # Top 50
        if ($nice_24 == 4 && $nice_24_r < 4) {
            $client->SummonFixedItem(1066314);
            quest::set_data($event_key . "xmas24_ret_nice-rewarded", max($nice_24_r, 4));
        }

        # Top 10
        if ($nice_24 == 5 && $nice_24_r < 5) {
            $client->SummonFixedItem(2066314);
            quest::set_data($event_key . "xmas24_ret_nice-rewarded", max($nice_24_r, 5));
        }
    }
    
    my $destroyed = quest::get_data($client->AccountID() . "-ess-items-destroyed") || 0;
    my $opened    = quest::get_data($client->AccountID() . "-ess-items-opened") || 0;
    if ($opened || $destroyed) {
        plugin::AddTitleFlag(210);
    }

    if ($destroyed >= 50) {
         plugin::AddTitleFlag(211);
    }
}   