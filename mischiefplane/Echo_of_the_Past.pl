my $expedition_name = "The Plane of Mischief";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "mischiefplane";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}