#!/usr/bin/perl
use warnings;
use DBI;
use POSIX;
use JSON;

sub LoadMysql {
        use DBI;
        use DBD::mysql;
        use JSON;

        my $json = new JSON();

        #::: Load Config
        my $content;
        open(my $fh, '<', "../eqemu_config.json") or die; {
                local $/;
                $content = <$fh>;
        }
        close($fh);

        #::: Decode
        $config = $json->decode($content);

        #::: Set MySQL Connection vars
        $db   = $config->{"server"}{"content_database"}{"db"};
        $host = $config->{"server"}{"content_database"}{"host"};
        $user = $config->{"server"}{"content_database"}{"username"};
        $pass = $config->{"server"}{"content_database"}{"password"};

        #::: Map DSN
        $dsn = "dbi:mysql:$db:$host:3306";

        #::: Connect and return
        $connect = DBI->connect($dsn, $user, $pass);

        return $connect;
}

# Use the LoadMysql function to get the database handle
my $dbh = LoadMysql();

# Check if successfully connected
unless ($dbh) {
    die "Failed to connect to database.";
}

# Fetch all data from row with id 700000 (if needed)
my $base_data_query = $dbh->prepare("SELECT * FROM items WHERE id = 700000");
$base_data_query->execute();
my $base_data = $base_data_query->fetchrow_hashref();
$base_data_query->finish();

# Prepare statement to select rows based on your criteria
my $select_query = $dbh->prepare(<<'SQL');
    SELECT i.*
    FROM items i
    WHERE i.id = (
        SELECT MIN(id)
        FROM items
        WHERE Name = i.Name
          AND id < 1000000
          AND classes
          AND races
          AND (slots & 4 OR slots & 128 OR slots & 512 OR slots & 4096 OR slots & 131072 OR slots & 262144 OR slots & 524288)
          AND material > 0
          AND itemtype = 10
    )
    ORDER BY i.id ASC;
SQL

$select_query->execute();

my $id_offset = 910000;  # Starting ID for new items
my $current_id = $id_offset;

my $allowed_slots_mask = 4 | 128 | 512 | 4096 | 131072 | 262144 | 524288;

while (my $row = $select_query->fetchrow_hashref()) {
    # Set data for id, name, and idfile from current row

    my $suffix = " Glamour-Stone";
    my $ellipsis = '...';
    my $max_original_length = 64 - length($suffix) - length($ellipsis);

    my $formatted_name;
    if (length($row->{Name}) > $max_original_length) {
        $formatted_name = "'" . substr($row->{Name}, 0, $max_original_length) . $ellipsis . "'"; 
    } else {
        $formatted_name = "'" . $row->{Name} . "'";
    }

    my $new_name = $formatted_name . $suffix;

    print "Creating item with Name: $new_name\n";

    $base_data->{id}            = $current_id;  # Use incremented ID
    $base_data->{Name}          = $new_name;    
    $base_data->{icon}          = $row->{icon};
    $base_data->{color}         = $row->{color};
    $base_data->{material}      = $row->{material};   
    $base_data->{augrestrict}   = 1;    
    $base_data->{slots}         = $row->{slots} & $allowed_slots_mask;
    $base_data->{itemtype}      = 54;
    $base_data->{herosforgemodel} = 0;

    # Construct dynamic SQL for insertion
    my $columns = join(", ", map { "`$_`" } keys %$base_data);  # Add backticks around column names
    my $placeholders = join(", ", map { "?" } keys %$base_data);
    my $values = [values %$base_data];

    my $insert_sql = "INSERT INTO items ($columns) VALUES ($placeholders)";

    # Prepare the dynamic SQL statement and execute
    my $insert = $dbh->prepare($insert_sql);
    eval {
        $insert->execute(@$values);
    };
    if ($@) {
        print "Failed to insert Name: $new_name\n";  # <-- Add this line to output the problematic name
    }
    $insert->finish();

    $current_id++;  # Increment the ID for the next item
}

$select_query->finish();
$dbh->disconnect();
