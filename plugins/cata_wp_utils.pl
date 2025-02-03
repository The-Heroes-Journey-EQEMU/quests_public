my @categories = (
    'Antonica',  # 0 
    'Faydwer',   # 1 
    'Odus',      # 2 
    'Kunark',    # 3 
    'Velious',   # 4 
    'Luclin',    # 5 
    'The Planes',# 6 
    'Taelosia',  # 7 
    'Discord'    # 8 
);

#     'shortname'       => ["Long Name", category, x, y, z, h],
my %waypoints = (
    # Antonica (0)
    'blackburrow'   => ["Blackburrow", 0, -7, 38, 3, 300],
    'commons'       => ["West Commonlands (Roadside Inn)", 0, 503, -127, -51, 128],
    'ecommons'      => ["East Commonlands", 0, -356, -1603, 3, 0],
    'feerrott'      => ["The Feerrott", 0, -1830, 430, 18, 33],
    'freportw'      => ["West Freeport", 0, -396, -283, -23, 500],
    'grobb'         => ["Grobb", 0, -200, 223, 3.75, 414],
    'everfrost'     => ["Everfrost", 0, -6972, 2133, -58, 163],
    'halas'         => ["Halas", 0, 0, 26, 3.75, 256],
    'highkeep'      => ["High Keep", 0, -1, -17, -4, 388],
    'lavastorm'     => ["Lavastorm Mountains (Druid Ring)", 0, 1318, 918, 119, 270],
    'neriakb'       => ["Neriak Commons", 0, -493, 3, -10, 128],
    'northkarana'   => ["Northern Plains of Karana (Gypsy Camp)", 0, -175, -688, -7.5, 10],
    'eastkarana'    => ["Eastern Plains of Karana (Druid Ring)", 0, 423, 1333, 1, 210],
    'oasis'         => ["Oasis of Marr", 0, 110, 532, 6, 225],
    'oggok'         => ["Oggok", 0, 513, 465, 3.75, 205],
    'oot'           => ["The Ocean of Tears", 0, -9172, 394, 6, 188],
    'qey2hh1'       => ["Western Plains of Karana (Combine Spires)", 0, -14816, -3570, 36, 400],
    'qeynos2'       => ["North Qeynos", 0, 392, 165, 4, 310],
    'qrg'           => ["Surefall Glade", 0, -66, 45, 4, 200],
    'rivervale'     => ["Rivervale", 0, -140, -10, 4, 220],
    'gukbottom'     => ["Lower Guk (Undead Side)", 0, -233, 1157, -80, 418],
    'lakerathe'     => ["Lake Rathetear (Outside Arena)", 0, 2673, 2404, 95, 381],

    # Faydwer (1)
    'akanon'        => ["Ak'anon", 1, -761, 1279, -24.25, 182.25],
    'cauldron'      => ["Dagnor's Cauldron (Near Unrest)", 1, -700, -1790, 100, 11],
    'felwithea'     => ["Northern Felwithe", 1, -626, 240, -10.25, 330],
    'gfaydark'      => ["Greater Faydark (Druid Ring)", 1, -385, 458, 0, 0],
    'kaladima'      => ["Southern Kaladim", 1, 197, 90, 3.75, 492],
    'mistmoore'     => ["Castle of Mistmoore", 1, 122, -294, -179, 135],

    # Odus (2)
    'erudnext'      => ["Erudin", 2, -240, -1216, 52, 510],
    'hole'          => ["The Ruins of Old Paineel", 2, -543, 287, -140, 125],
    'paineel'       => ["Paineel", 2, 210, 839, 4, 275],
    'tox'           => ["The Toxxulia Forest", 2, -916, -1510, -33, 0],
    'stonebrunt'    => ["Stonebrunt Mountains", 2, 673, -4531, 0],
    'dulak'         => ["Dulak Harbor", 2, -1190, -190, 4, 128],
    'gunthak'       => ["The Gulf of Gunthak", 2, -410, 1402, 3, 0],

    # Kunark (3)
    'burningwood'   => ["Burning Wood (Chardok)", 3, -3876, 7407, -233, 303],
    'cabeast'       => ["Eastern Cabilis", 3, -136, 969, 4.68, 271],
    'citymist'      => ["The City of Mist", 3, -572, 249, 4, 130],
    'dreadlands'    => ["The Dreadlands", 3, 9633, 3005, 1049, 0],
    'fieldofbone'   => ["The Field of Bone", 3, 1617, -1684, -55, 0],
    'firiona'       => ["Firiona Vie", 3, 1825, -2397, -98, 423],
    'frontiermtns'  => ["Frontier Mountains", 3, 392, 53, -102, 39],
    'karnor'        => ["Karnor's Castle", 3, 160, 251, 3.75, 310],
    'lakeofillomen' => ["Lake of Ill Omen", 3, -1070, 985, 78, 145],
    'overthere'     => ["The Overthere", 3, 1480, -2757, 11, 500],
    'skyfire'       => ["The Skyfire Mountains", 3, 780, -3100, -158, 0],
    'southkarana'   => ["Southern Plains of Karana (Aviak Village)", 0, 1027, -6689, 0, 260],
    'timorous'      => ["The Firepot Room (Secret)", 3, 4366.5, -12256.8, -278, 256],
    'trakanon'      => ["Trakanon's Teeth", 3, -4720, -1620, -473, 320],
    'chardokb'      => ["The Halls of Betrayal", 3, -210, 315, 1.5, 200],

    # Velious (4)
    'cobaltscar'    => ["Cobalt Scar", 4, -1633, -1064, 296, 115],
    'eastwastes'    => ["Eastern Wastes (Crystal Caverns)", 4, 464, -4037, 144, 178],
    'greatdivide'   => ["Great Divide (Velketor's Labyrinth)", 4, 3287, -6646, -35, 251],
    'iceclad'       => ["The Iceclad Ocean (Tower of Frozen Shadow)", 4, 3127, 1300, 111, 500],
    'wakening'      => ["The Wakening Land", 4, 4552, 1455, -60, 130],
    'westwastes'    => ["The Western Wastes (Temple of Veeshan)", 4, 808, 1323, -196, 373],
    'cobaltscar'    => ["Cobalt Scar", 4, -1634, -1065, 299, 0],
    'sirens'        => ["Siren's Grotto", 4, 20, -590, -93, 0],

    # Luclin (5)
    'dawnshroud'    => ["The Dawnshroud Peaks", 5, -1260, -280, 97, 500],
    'fungusgrove'   => ["Fungus Grove", 5, 1359, 2398, -261, 256],
    'sharvahl'      => ["The City of Shar Vahl", 5, 250, 55, -188, 400],
    'ssratemple'    => ["Ssraeshza Temple", 5, -6.5, 0, 4, 0],
    'tenebrous'     => ["Tenebrous Mountains", 5, -967, -1514, -56, 443],
    'umbral'        => ["The Umbral Plains", 5, 1840, -640, 24, 0],
    'twilight'      => ["The Twilight Sea", 5, -1028, 1338, 39, 0],
    'scarlet'       => ["The Scarlet Desert", 5, -1777, -956, -99, 0],
    'paludal'       => ["Paludal Caverns", 5, 220, -1175, -236, 0],
    'bazaar'        => ["The Bazaar", 5, 105, -175, -15, 65],

    # The Planes (6)
    'airplane'      => ["The Plane of Sky", 6, 700, 1560, -680, 300],
    'fearplane'     => ["The Plane of Fear", 6, 1065, -1305, 3, 500],
    'hateplaneb'    => ["The Plane of Hate", 6, -400, 680, 4, 330],
    'poknowledge'   => ["The Plane of Knowledge", 6, -215, 50, -160, 128],
    'potranquility' => ["The Plane of Tranquility", 6, -8, -192, -628, 115],
    'potimea'       => ["The Plane of Time", 6, 0, 110, 8, 0],

    # Taelosia (7)
    'barindu'       => ["Barindu, Hanging Gardens", 7, 210, -515, -117, 510],
    'kodtaz'        => ["Kod'Taz, Broken Trial Grounds", 7, 1536, -2422, -348, 4],
    'natimbi'       => ["Natimbi, the Broken Shores", 7, -310, 125, 520, 70],
    'qvic'          => ["Qvic, Prayer Grounds of Calling", 7, -1018, -1403, -490, 3],
    'txevu'         => ["Txevu, Lair of the Elite", 7, -316, -20, -420, 430],

    # Discord (8)
    'wallofslaughter' => ["Wall of Slaughter", 8, -943, 13, 130, 0],
);

sub AwardBonusUnlocks {
    my $client = plugin::val('$client');
    my $eligible = quest::get_data($client->AccountID() . "-TL-Account-A") ||
                   quest::get_data($client->AccountID() . "-TL-Account-O") ||
                   quest::get_data($client->AccountID() . "-TL-Account-F") ||
                   quest::get_data($client->AccountID() . "-TL-Account-K") ||
                   quest::get_data($client->AccountID() . "-TL-Account-V");

    if ($eligible && !$client->IsSeasonal() && !$client->IsHardcore() && !plugin::IsTHJ()) {
        AddWaypoint('qeynos2');
        AddWaypoint('qrg');
        AddWaypoint('freportw');
        AddWaypoint('rivervale');
        AddWaypoint('qey2hh1');
        AddWaypoint('northkarana');
        AddWaypoint('southkarana');
        AddWaypoint('eastkarana');
        AddWaypoint('blackburrow');
        AddWaypoint('commons');
        AddWaypoint('erudnext');
        AddWaypoint('lavastorm');
        AddWaypoint('halas');
        AddWaypoint('highkeep');
        AddWaypoint('oasis');
        AddWaypoint('hole');
        AddWaypoint('neriakb');
        AddWaypoint('feerrott');
        AddWaypoint('oggok');
        AddWaypoint('grobb');
        AddWaypoint('gfaydark');
        AddWaypoint('akanon');
        AddWaypoint('mistmoore');
        AddWaypoint('kaladima');
        AddWaypoint('felwithea');
        AddWaypoint('oot');
        AddWaypoint('cauldron');
        AddWaypoint('paineel');
        AddWaypoint('fieldofbone');
        AddWaypoint('firiona');
        AddWaypoint('lakeofillomen');
        AddWaypoint('dreadlands');
        AddWaypoint('karnor');
        AddWaypoint('citymist');
        AddWaypoint('skyfire');
        AddWaypoint('overthere');
        AddWaypoint('trakanon');
        AddWaypoint('cabeast');
        AddWaypoint('iceclad');
        AddWaypoint('eastwastes');
        AddWaypoint('cobaltscar');
        AddWaypoint('wakening');
        AddWaypoint('westwastes');
        AddWaypoint('sharvahl');
        AddWaypoint('ssratemple');
        AddWaypoint('dawnshroud');
        AddWaypoint('umbral');
        AddWaypoint('hateplaneb');
        AddWaypoint('airplane');
        AddWaypoint('fearplane');
        AddWaypoint('poknowledge');
        AddWaypoint('potranquility');
        AddWaypoint('gunthak');
        AddWaypoint('natimbi');
        AddWaypoint('barindu');
        AddWaypoint('kodtaz');
        AddWaypoint('qvic');
        AddWaypoint('txevu');
    }
}

sub AddDefaultAttunement {
    my $client = shift || plugin::val('$client');
    if ($client) {
        AddWaypoint('qeynos2');
        AddWaypoint('freportw');
        AddWaypoint('rivervale');
        AddWaypoint('erudnext');
        AddWaypoint('halas');
        AddWaypoint('neriakb');
        AddWaypoint('oggok');
        AddWaypoint('grobb');
        AddWaypoint('gfaydark');
        AddWaypoint('felwithea');
        AddWaypoint('akanon');
        AddWaypoint('kaladima');
        AddWaypoint('cabeast');
        AddWaypoint('sharvahl');
        AddWaypoint('paineel');
        AddWaypoint('ecommons');
        AddWaypoint('bazaar');

        if (!plugin::IsTHJ()) {
            AddWaypoint("lavastorm");
            AddWaypoint("northkarana");
            AddWaypoint("tox");
            AddWaypoint("iceclad");
            AddWaypoint("cobaltscar");
            AddWaypoint("twilight");
            AddWaypoint("wallofslaughter");
            AddWaypoint("barindu");
            AddWaypoint("potimea");
            AddWaypoint("fieldofbone");
            AddWaypoint("westwastes");
            AddWaypoint("scarlet");
            AddWaypoint("everfrost");
        }

        if ($client->GetLevel() >= 46) {
            AddWaypoint("hateplaneb");
        }

        if ($client->GetLevel() >= 46) {
            AddWaypoint("airplane");
        }
    }
}

sub CheckSpawnWaypoints {
    my $entity_list = plugin::val('$entity_list');
    my $zonesn      = plugin::val('$zonesn');

    if (exists $waypoints{$zonesn}) {
        my @waypoint = @{$waypoints{$zonesn}};
        if (!$entity_list->IsMobSpawnedByNpcTypeID(26999)) {
            my $npc = quest::spawn2(26999, 0, 0, $waypoint[2], $waypoint[3], $waypoint[4], $waypoint[5]);
        }
    }
}

sub AddWaypoint {
    my $waypoint = shift || plugin::val('$zonesn');
    my $client   = shift || plugin::val('$client');
    my $return_feedback = 0;

    if ($client) {
        if (plugin::is_eligible_for_zone($client, $waypoint, 0)) {
            my %account_data = map { $_ => 1 } split(',', quest::get_data("Waypoints-" . $client->AccountID()));
            my %character_data = map { $_ => 1 } split(',', $client->GetBucket("Waypoints"));        

            if (exists $waypoints{$waypoint}) {
                if (!exists $account_data{$waypoint}) {
                    $account_data{$waypoint} = 1;
                    quest::set_data("Waypoints-" . $client->AccountID(), join(',', keys %account_data));
                    $return_feedback = 1;
                }

                if (!exists $character_data{$waypoint}) {
                    $character_data{$waypoint} = 1;
                    $client->SetBucket("Waypoints", join(',', keys %character_data));
                    if ($client->IsSeasonal() || $client->IsHardcore()) {
                        $return_feedback = 1;
                    }
                }
            } else {
                quest::debug("Attempted to add an invalid or undefined waypoint ($waypoint) to " . $client->GetName());
            }
        }
    } else {
        quest::debug("Attempted to add a waypoint to a nonspecified client.");
    }

    return $return_feedback;
}

sub GetContinents {
    my $client = shift;
    my %eligible_continents;
    
    if (defined $client) {
        foreach my $key (keys %waypoints) {
            my $continent = $waypoints{$key}[1];
            if (plugin::is_eligible_for_zone($client, $key, 0)) {
                $eligible_continents{$continent} = 1;
            }
        }
    } else {
        quest::debug("Attempted to get continents for an invalid or unspecified client.");
        return ();
    }

    return keys %eligible_continents;
}

sub GetContinentName {
    my $index = shift;
    return $categories[$index];
}

sub GetWaypoints {
    my $continent = shift;
    my $client = shift;
    my %data;
    my %return;

    if ($client) {
        %data = map { $_ => 1 } split(',', quest::get_data("Waypoints-" . $client->AccountID()));

        foreach my $key (keys %waypoints) {
            if (exists $data{$key} &&
                ($continent == -1 || $waypoints{$key}[1] == $continent) &&
                plugin::is_eligible_for_zone($client, $key, 0)) {
                $return{$key} = $waypoints{$key};
            }
        }

        # Include race-specific waypoints if they are on the correct continent
        my $race_waypoints = GetRaceSpecificWaypoint($client->GetBaseRace());
        foreach my $waypoint (@$race_waypoints) {
            if (exists $waypoints{$waypoint} &&
                ($continent == -1 || $waypoints{$waypoint}[1] == $continent)) {
                $return{$waypoint} = $waypoints{$waypoint};
            }
        }
    } else {
        quest::debug("Attempted to get waypoints for an invalid or unspecified client.");
        return ();
    }

    return %return;
}

sub GetRaceSpecificWaypoint {
    my $race_id = shift;

    my %race_to_home_cities = (
        1   => ['freportw', 'qeynos2'],  # Human
        2   => ['halas'],                # Barbarian
        3   => ['erudin'],               # Erudite
        4   => ['gfaydark'],             # Wood Elf
        5   => ['felwithea'],            # High Elf
        6   => ['neriakb'],              # Dark Elf
        7   => ['freportw', 'qeynos2', 'gfaydark'], # Half Elf        
        8   => ['kaladim'],              # Dwarf
        9   => ['grobb', 'neriakb'],     # Troll
        10  => ['oggok', 'neriakb'],     # Ogre        
        11  => ['rivervale'],            # Halfling        
        12  => ['akanon'],               # Gnome
        128 => ['cabeast'],              # Iksar
        130 => ['sharvahl'],             # Vah Shir
        330 => ['qeynos2'],              # Guktan
    );

    if (exists $race_to_home_cities{$race_id}) {
        return $race_to_home_cities{$race_id};  # Return an array reference of home cities
    } else {
        return [];  # Return an empty array reference if no specific waypoint for this race
    }
}

sub GetWaypointCapturePattern {
    my $continent = shift;
    my $client = shift;

    my %data;
    my %eligible_waypoints;  # Hash to store eligible waypoints
    my @eligible_keys;  # Array to store the keys for the regex pattern

    if ($client) {
        %data = map { $_ => 1 } split(',', quest::get_data("Waypoints-" . $client->AccountID()));

        # Get race-specific waypoints for the client's base race
        my $race_specific_waypoints = GetRaceSpecificWaypoint($client->GetBaseRace());

        foreach my $key (keys %waypoints) {
            if (
                (exists $data{$key} || grep { $_ eq $key } @$race_specific_waypoints) && 
                ($continent == -1 || $waypoints{$key}->[1] == $continent) &&  # Correctly access the continent from the waypoint array
                plugin::is_eligible_for_zone($client, $key, 0)
            ) {
                $eligible_waypoints{$key} = $waypoints{$key};  # Store the full waypoint data
                push @eligible_keys, quotemeta($key);  # Escape special characters in keys and add to regex list
            }
        }
    } else {
        quest::debug("Attempted to get waypoints for an invalid or unspecified client.");
        return;
    }

    # Join the eligible waypoint keys into a regex pattern
    my $pattern = join('|', @eligible_keys);
    
    # Return the pattern wrapped in a capturing group and the eligible waypoints hash
    return (qr/\b($pattern)\b/i, \%eligible_waypoints);
}

sub GetContinentCapturePattern {
    # Create a mapping of names to IDs
    my %continent_map = map { $categories[$_] => $_ } 0..$#categories;

    # Join the category names into a regex pattern
    my $pattern = join('|', map { quotemeta($_) } @categories);
    
    # Return the pattern wrapped in a capturing group and the map
    return (qr/\b($pattern)\b/i, \%continent_map);
}

sub GetWaypoint {
    my ($shortname, $client) = @_;

    # Get race-specific waypoints for the client's base race
    my $race_specific_waypoints = GetRaceSpecificWaypoint($client->GetBaseRace());

    # Check if the shortname exists in the waypoints hash
    if (exists $waypoints{$shortname}) {
        # Check if the client is eligible for this waypoint
        if (plugin::is_eligible_for_zone($client, $shortname, 0)) {
            # Check if the waypoint is attuned for the client or is one of the race-specific waypoints
            my %attuned_waypoints = map { $_ => 1 } split(',', quest::get_data("Waypoints-" . $client->AccountID()));
            if (exists $attuned_waypoints{$shortname} || grep { $_ eq $shortname } @$race_specific_waypoints) {
                return $waypoints{$shortname};  # Return the array reference for the waypoint
            }
        }
    }

    return undef;  # Return undef if the waypoint does not exist, is not attuned, or the client is not eligible
}