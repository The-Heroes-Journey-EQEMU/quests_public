# Warder control for 2nd raid target(s) on 1st floor of vexthal

sub EVENT_SPAWN {
	return; # AHR is already gated, no need to deal with this.
	quest::spawn2(158088,0,0,1874.4,2.1,3.1,380); # NPC: Akhevan_Warder
	quest::spawn2(158088,0,0,1767.3,2.3,67.1,126); # NPC: Akhevan_Warder
	quest::spawn2(158088,0,0,1837.0,1.9,63.1,126); # NPC: Akhevan_Warder
	quest::spawn2(158088,0,0,1736.6,-64.3,63.1,126); # NPC: Akhevan_Warder
	quest::spawn2(158088,0,0,1736.6,64.3,63.1,126); # NPC: Akhevan_Warder
}

sub EVENT_DEATH_COMPLETE {
  quest::depopall(158088);
}

#End of File, Zone:vexthal  NPC:158014 -- #Diabo_Xi_Va
