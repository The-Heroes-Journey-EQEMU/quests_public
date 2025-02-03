use strict;
use warnings;
use DBI;

# Subroutine to calculate new ID
sub calculate_new_id {
    my ($id, $Name) = @_;
    my $new_id = $id; # Default to original ID

    if ($Name =~ /^Rose Colored/) {
        # Assuming the 'normal' ID can be directly inferred (which may need adjustment)
        $new_id = ($id < 100000) ? ($id - 70000) : ($id - 700000);
        $new_id += 1000000; # Apply +1 million offset
    } elsif ($Name =~ /^Apocryphal/) {
        # Similarly, adjust based on actual logic for 'Apocryphal' items
        $new_id = ($id < 100000) ? ($id - 80000) : ($id - 800000);
        $new_id += 2000000; # Apply +2 million offset
    }

    return $new_id;
}

sub add_new_item_rows {
    my ($dbh,$item_type) = @_;
    my $prefix = $item_type eq 'Rose Colored' ? 'Rose Colored' : 'Apocryphal';
    my $like_pattern = $prefix . '%';

    # Fetch 'Rose Colored' or 'Apocryphal' items
    my $sth = $dbh->prepare("SELECT * FROM items WHERE Name LIKE ?");
    $sth->execute($like_pattern);

    # Dynamically determine column Names, excluding 'id'
    my @columns = @{$sth->{NAME}};
    # Assuming @columns does not include 'id' after this operation
    my ($id_index) = grep { $columns[$_] eq 'id' } 0..$#columns;
    splice(@columns, $id_index, 1) if defined $id_index;  # Remove 'id' if found

    # Build the columns list for SQL, ensuring `id` is not duplicated
    my $columns_list = join(", ", map { "`$_`" } @columns);  # Use backticks for safety

    # Build placeholders, accounting for 'id' already being prepended
    my $placeholders = join(", ", ("?") x @columns);  # Placeholder for each column except 'id'

    # Prepare the INSERT statement, including 'id' explicitly only once
    my $insert_item_sql = "REPLACE INTO items (`id`, $columns_list) VALUES (?, $placeholders)";
    my $insert_item_sth = $dbh->prepare($insert_item_sql);

    my $insert_map_sql = "REPLACE INTO item_id_mapping (old_id, new_id) VALUES (?, ?)";
    my $insert_map_sth = $dbh->prepare($insert_map_sql);

    # Define the delete statement for old items
    my $delete_sql = "DELETE FROM items WHERE id = ?";
    my $delete_sth = $dbh->prepare($delete_sql);

    while (my $row = $sth->fetchrow_hashref) {
        
        unless (defined $row->{Name}) {
            # Print debug output if 'Name' is undefined
            print "Debug: Item ID $row->{id} has a NULL Name.\n";
            next;  # Skip the rest of the loop for this row
        }        

        my $new_id = calculate_new_id($row->{id}, $row->{Name});

        printf("Updating: [%-64s] from ID: [%07d] to new ID: [%07d]\n", $row->{Name}, $row->{id}, $new_id);
        
        # Prepare values for insertion, excluding 'id'
        my @values = map { $row->{$_} } @columns;
        
        # Insert the new item row with the new ID
        $insert_item_sth->execute($new_id, @values);

        # Insert the mapping from old ID to new ID
        $insert_map_sth->execute($row->{id}, $new_id);

        # Delete the old item row
        $delete_sth->execute($row->{id});
    }
}

sub update_secondary_table_item_ids {
    my ($dbh,$table_Name, $column_Name) = @_;

    # Prepare the SQL statement for updating the table
    my $update_sql = "UPDATE $table_Name 
                  SET $column_Name = COALESCE((SELECT new_id FROM item_id_mapping WHERE old_id = $table_Name.$column_Name), $column_Name)";

    my $update_sth = $dbh->prepare($update_sql);

    # Execute the update
    $update_sth->execute();

    # Check for errors
    if ($update_sth->err) {
        warn "Error updating $table_Name: " . $update_sth->errstr;
    } else {
        print "Updated item IDs in $table_Name successfully.\n";
    }
}

sub ensure_table_exists {
    my ($dbh) = @_;

    # SQL to create the table if it doesn't exist
    my $create_table_sql = q{
        CREATE TABLE IF NOT EXISTS item_id_mapping (
            old_id INT NOT NULL,
            new_id INT NOT NULL,
            PRIMARY KEY (old_id),
            UNIQUE (new_id)
        )
    };

    # Execute the SQL statement
    my $sth = $dbh->prepare($create_table_sql);
    $sth->execute();
}


# Database connection details
my $dbName = 'peq';
my $host = 'mariadb';
my $port = '3306'; # default MySQL port
my $user = 'eqemu';
my $password = 'dDye40WrWKOn2LwQDxAPK5dJIzSeNmh';

# DSN for MySQL connection
my $dsn = "DBI:mysql:database=$dbName;host=$host;port=$port";

# Connect to the database
my $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1, AutoCommit => 0 }) or die $DBI::errstr;

ensure_table_exists($dbh);

add_new_item_rows($dbh,'Rose Colored');
add_new_item_rows($dbh,'Apocryphal');

update_secondary_table_item_ids($dbh,'sharedbank', 'itemid');
update_secondary_table_item_ids($dbh,'sharedbank', 'augslot1');
update_secondary_table_item_ids($dbh,'sharedbank', 'augslot2');
update_secondary_table_item_ids($dbh,'sharedbank', 'augslot3');
update_secondary_table_item_ids($dbh,'sharedbank', 'augslot4');
update_secondary_table_item_ids($dbh,'sharedbank', 'augslot5');
update_secondary_table_item_ids($dbh,'sharedbank', 'augslot6');
update_secondary_table_item_ids($dbh,'inventory', 'itemid');
update_secondary_table_item_ids($dbh,'inventory', 'augslot1');
update_secondary_table_item_ids($dbh,'inventory', 'augslot2');
update_secondary_table_item_ids($dbh,'inventory', 'augslot3');
update_secondary_table_item_ids($dbh,'inventory', 'augslot4');
update_secondary_table_item_ids($dbh,'inventory', 'augslot5');
update_secondary_table_item_ids($dbh,'inventory', 'augslot6');
update_secondary_table_item_ids($dbh,'lootdrop_entries', 'item_id');

# Commit the changes and clean up
$dbh->commit;
$dbh->disconnect;
