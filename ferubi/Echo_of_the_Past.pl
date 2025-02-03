my $expedition_name = "Ferubi, Forgotten Temple of Taelosia";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "ferubi";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}