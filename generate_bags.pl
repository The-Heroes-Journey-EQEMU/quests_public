#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use POSIX;
use JSON;
use List::Util qw(max min);

# Ensure that 'strict' is used to enforce good programming practices.

sub LoadMysql {
    # Standard use declarations are needed only once at the beginning.
    my $content;
    open(my $fh, '<', "../eqemu_config.json") or die "Unable to open config file: $!";
    {
        local $/;
        $content = <$fh>;
    }
    close($fh);

    my $json = new JSON();
    my $config = $json->decode($content);

    my $db   = $config->{"server"}{"database"}{"db"};
    my $host = $config->{"server"}{"database"}{"host"};
    my $user = $config->{"server"}{"database"}{"username"};
    my $pass = $config->{"server"}{"database"}{"password"};
    my $dsn = "dbi:mysql:$db:$host:3306";

    my $connect = DBI->connect($dsn, $user, $pass, {RaiseError => 1, AutoCommit => 1}) or die "Could not connect to database: $DBI::errstr";
    return $connect;
}

sub ceil_to_nearest_5 {
    my ($value) = @_;
    return ceil($value / 5) * 5;
}

sub duplicate_and_modify_items {
    my $dbh = LoadMysql();
    die "Failed to connect to database." unless $dbh;

    my $sth = $dbh->prepare("SELECT * FROM items WHERE itemtype = 11 AND bagslots > 0 AND itemclass = 1 AND bagtype IN (0, 1, 3, 4, 5, 6, 7) AND id <= 999999 AND id NOT IN (199999, 17423)");
    $sth->execute() or die $DBI::errstr;

    while (my $original_row = $sth->fetchrow_hashref()) {
        foreach my $multiplier (1, 2) {
            my %row = %$original_row; 
            my $increment = 10 * $multiplier; 
            my $new_value = $row{bagwr} + $increment;

            $row{id} += 1000000 * $multiplier;  
            $row{Name} = ($multiplier == 1 ? "Rose Colored " : "Apocryphal ") . $original_row->{Name};
            
            $increment = ($multiplier * 2) + floor(3 * $multiplier * $row{bagwr}/100);

	    $row{bagslots} += ($increment % 2 == 0) ? $increment : $increment + 1;
            $row{bagwr} = min(100,  $row{bagwr} + (10 * (max(1,($row{bagsize} - 4)/2)) * $multiplier)); 

            my $columns = join(",", map { $dbh->quote_identifier($_) } keys %row);
            my $values  = join(",", map { $dbh->quote($row{$_}) } keys %row);
            my $sql = "REPLACE INTO items ($columns) VALUES ($values)";  

            print "Creating: $row{id} ($row{Name})\n"; 
            my $isth = $dbh->prepare($sql) or die "Failed to prepare insert: $DBI::errstr";
            $isth->execute() or die "Failed to execute insert: $DBI::errstr";
        }
    }   

    $sth->finish();
    $dbh->disconnect();
}

duplicate_and_modify_items(LoadMysql());