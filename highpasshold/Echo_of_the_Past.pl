my $expedition_name = "Highpass Hold";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "highpasshold";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}