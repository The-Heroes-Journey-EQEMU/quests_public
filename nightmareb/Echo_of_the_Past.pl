my $expedition_name = "Lair of Terris-Thule";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "nightmareb";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}