

sub EVENT_SAY {
	

		if ($text=~/Hail/i) {
			quest::say("Sup bitch");
			quest::setglobal("pop_pot_shadyglade",1,5,"F");
		}
}