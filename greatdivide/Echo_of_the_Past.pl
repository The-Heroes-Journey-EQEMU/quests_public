my $expedition_name = "The Great Divide";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "greatdivide";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}