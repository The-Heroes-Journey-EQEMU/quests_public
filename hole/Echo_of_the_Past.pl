my $expedition_name = "The Ruins of Old Paineel";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "hole";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}