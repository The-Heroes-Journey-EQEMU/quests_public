my $expedition_name = "The Howling Stones";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "charasis";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}