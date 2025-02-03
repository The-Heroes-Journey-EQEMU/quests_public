my $expedition_name = "The Wakening Land";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "wakening";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}