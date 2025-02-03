sub EVENT_SAY {
  if ($text=~/hail/i)
  {
	quest::say("Have some PvP! To turn it off, either zone, camp, or die! Let me know if you'd like to [participate] in the Arena Challenge! (This is not yet enabled!)");
	quest::pvp(on);
	quest::get_data($pvp);
	quest::set_data($pvp, 1);
  }
}

sub EVENT_SPAWN {
	quest::set_proximity($x - 100, $x + 100, $y - 100, $y + 100, $z - 100, $z + 100);
}

sub EVENT_ENTER {
	if (quest::get_data($pvp) == "") {
	quest::pvp(on);
    quest::set_data($pvp, 1);
}

	if (quest::get_data($pvp) == 0) {
	quest::pvp(on);
    quest::set_data($pvp, 1);
}

	if (quest::get_data($pvp) == 2) {
	quest::pvp(on);
    quest::set_data($pvp, 1);
}
}

