my $expedition_name = "Kedge Keep";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "kedge";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}