# Warder control for 1st raid target(s) on 2nd floor of vexthal

sub EVENT_SPAWN {
	return; # AHR is already gated, no need to deal with this.
	quest::spawn2(158090,0,0,1736.1,-250.1,115.6,0); # NPC: Akhevan_Warder
	quest::spawn2(158090,0,0,1736.1,250.1,115.6,254); # NPC: Akhevan_Warder
}

sub EVENT_DEATH_COMPLETE {
  quest::depopall(158090);
}

#End of File, Zone:vexthal  NPC:158008 -- #Thall_Va_Kelun
