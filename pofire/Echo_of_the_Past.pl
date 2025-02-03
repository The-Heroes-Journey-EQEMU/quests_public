my $expedition_name = "Doomfire, the Burning Lands";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "pofire";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}