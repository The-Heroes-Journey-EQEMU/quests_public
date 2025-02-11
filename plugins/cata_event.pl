sub CustomEventEntry {
    my $npc = shift || plugin::val('npc');

    if (!($npc && $npc->IsNPC())) {
        return;
    }
}