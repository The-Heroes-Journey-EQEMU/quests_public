my $expedition_name = "Western Wastes";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "westwastes";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}