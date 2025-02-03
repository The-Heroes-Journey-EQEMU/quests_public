sub EVENT_SAY {
    if ($text =~ /Hail/i)
    {
    $bind = $client->GetBindZoneID;
    $bindh = $client->GetBindHeading;
    $bindx = $client->GetBindX;
    $bindy = $client->GetBindY;
    $bindz = $client->GetBindZ;
    quest::say("Hello $name! Would you like to [Return to your bind]?")
    }
    if ($text =~ /Return to your bind/i)
    {
    $client->MovePC($bind, $bindx, $bindy, $bindz, $bindh);
    }
}
s