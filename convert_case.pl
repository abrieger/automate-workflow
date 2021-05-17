#!/usr/bin/perl -w

# Program creates new file with converted case
# Option -s converts to snake case and -c converts to camel case
# Assumes strings do not contain escaped quotations

# Written by Adam Brieger

sub usage_exit {
    print STDERR "usage: $0 [ -s | -c ] <file>\n";
    exit 1;
}

sub convert_to_camel {
    if (! $in_string) {
        $word =~ s/_(.)/uc($1)/ge;
    }
}

sub convert_to_snake {
    if (! $in_string) {
        @caps = ($word =~ /([A-Z])/g);
        foreach $cap (@caps) {
            $lower = lc $cap;
            $word =~ s/$cap/_$lower/g;
        }
    }
}

# Only one option and one file to be provided in command line
usage_exit() if ($#ARGV + 1) != 2;

# Process command line options
use Getopt::Std;
our ($opt_s, $opt_c) = (0, 0);
getopts("sc");

# Process file
$file = shift @ARGV or usage_exit();
open my $in, '<', $file or die "$0: Unable to open file $file\n";
@lines = <$in>;
close $in;

# Prepare new file
$new_file = "snake_" . $file if $opt_s;
$new_file = "camel_" . $file if $opt_c;
if (-e "$new_file" ) {
    print STDERR "$new_file already exists!\n";
    exit 1;
}

# Transform case
foreach $line (@lines) {

    $in_string = 0; 
    @words = split(/ /, $line);

    foreach $word (@words) {

        # Do not transform strings
        if ($word =~ /^[^"']*("|')[^"']*$/ and ! $in_string) {
            # String begins with this word
            $in_string = 1;
            $marker = $1; # Store style of quotation
            next; 
        } elsif ($word =~ /^[^"']*("|')[^"']*$/ and $in_string) {
            # String ends with this word
            if ("$1" eq "$marker") {
                $in_string = 0;
                next; 
            }
        }

        convert_to_camel() if $opt_c;
        convert_to_snake() if $opt_s;
    }
    
    $line = join(' ', @words);
    print $line;
}

# Write to new file
open my $out, '>', $new_file or die "$0: Unable to create file $new_file";
print $out @lines;
close $out;