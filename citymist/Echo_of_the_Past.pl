my $expedition_name = "City of Mist";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "citymist";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}