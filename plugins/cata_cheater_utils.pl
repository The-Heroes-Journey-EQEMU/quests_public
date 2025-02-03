sub GetSoulmark {
    my $client = shift;

    my $soulmark = quest::get_data($client->AccountID() . "-CheaterFlag");

    return $soulmark;
}

sub DisplayWarning {
    my $client = shift;

    my $message = "Greetings adventurer! Your account has been flagged for violations of server rules and additional tracking.
                   Consider this your one and only warning. Please play fairly and read our rules in Discord for any questions. 
                   To dispute this, please send Aporia a message in Discord. Any further detection will be cause for suspension
                   or other enforcement actions. Thank you for your cooperation.";

    $client->Message(13, $message);
}