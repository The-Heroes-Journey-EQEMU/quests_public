my $expedition_name = "Unrest";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "unrest";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}