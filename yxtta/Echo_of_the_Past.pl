my $expedition_name = "Yxtta, Pulpit of Exiles";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "yxtta";

sub EVENT_SAY {
  plugin::OfferStandardInstance($expedition_name, $min_players, $max_players, $dz_zone);
}