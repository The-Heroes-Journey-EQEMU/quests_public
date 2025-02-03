#!/usr/bin/perl
use strict;
use warnings;
use DBI;

sub update_bag_slots {
    my ($dbh, $old_start, $old_end, $new_base, $slot_range_description) = @_;
    
    my $fetch_sql = $dbh->prepare("SELECT charid, slotid, itemid FROM peq.inventory WHERE slotid BETWEEN ? AND ?");
    my $update_sql = $dbh->prepare("UPDATE peq.inventory SET slotid = ? WHERE charid = ? AND slotid = ?");
    
    my $max_bag_slots = 200; # New max slots per bag, consistent across all bag types

    $fetch_sql->execute($old_start, $old_end);

    while (my $row = $fetch_sql->fetchrow_hashref) {
        my $charid = $row->{charid};
        my $old_slotid = $row->{slotid};

        # Determine the primary_slot_offset based on the old slot range
        my $primary_slot_offset = int(($old_slotid - $old_start) / 10);
        my $relative_position_within_bag = ($old_slotid - $old_start) % 10;

        # Calculate new slotid based on the new layout
        my $new_slotid = $new_base + ($primary_slot_offset * $max_bag_slots) + $relative_position_within_bag;

        # Update the item's slotid in the database
        $update_sql->execute($new_slotid, $charid, $old_slotid);
    }
    
    print "Inventory slots update for $slot_range_description completed.\n";
}

sub update_shared_bag_slots {
    my ($dbh, $old_start, $old_end, $new_base, $slot_range_description) = @_;
    
    my $fetch_sql = $dbh->prepare("SELECT acctid, slotid, itemid FROM peq.sharedbank WHERE slotid BETWEEN ? AND ?");
    my $update_sql = $dbh->prepare("UPDATE peq.sharedbank SET slotid = ? WHERE acctid = ? AND slotid = ?");
    
    my $max_bag_slots = 200; # New max slots per bag, consistent across all bag types

    $fetch_sql->execute($old_start, $old_end);

    while (my $row = $fetch_sql->fetchrow_hashref) {
        my $charid = $row->{acctid};
        my $old_slotid = $row->{slotid};

        # Determine the primary_slot_offset based on the old slot range
        my $primary_slot_offset = int(($old_slotid - $old_start) / 10);
        my $relative_position_within_bag = ($old_slotid - $old_start) % 10;

        # Calculate new slotid based on the new layout
        my $new_slotid = $new_base + ($primary_slot_offset * $max_bag_slots) + $relative_position_within_bag;

        # Update the item's slotid in the database
        $update_sql->execute($new_slotid, $charid, $old_slotid);
    }
    
    print "Inventory slots update for $slot_range_description completed.\n";
}

# Database connection details
my $dbname = 'peq';
my $host = 'mariadb';
my $port = '3306'; # default MySQL port
my $user = 'eqemu';
my $password = 'dDye40WrWKOn2LwQDxAPK5dJIzSeNmh';

# DSN for MySQL connection
my $dsn = "DBI:mysql:database=$dbname;host=$host;port=$port";

# Connect to the database
my $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1, AutoCommit => 0 }) or die $DBI::errstr;

# Update logic for GENERAL_BAGS
update_bag_slots($dbh, 251, 350, 4010, "GENERAL_BAGS");

# Update logic for BANK_BAGS
update_bag_slots($dbh, 2031, 2270, 6210, "BANK_BAGS");

# Update logic for SHARED_BAGS
update_shared_bag_slots($dbh, 2531, 2550, 11010, "SHARED_BAGS");

# Commit the changes and clean up
$dbh->commit;
$dbh->disconnect;
