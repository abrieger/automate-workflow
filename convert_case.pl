#!/usr/bin/perl -w

# Option -s converts to snake case and -c converts to camel case
# Assumes strings use double quotes

# Written by Adam Brieger

sub usage_exit {
    print STDERR "usage: $0 [ -s | -c ] <file>\n";
    exit 1;
}

# Only one option and one file to be provided in command line
usage_exit() if ($#ARGV + 1) != 2;

# Process command line options
use Getopt::Std;
our ($opt_s, $opt_c) = (0, 0);
getopts("sc");

$file = shift @ARGV or usage_exit();
open my $f, '<', $file or die "$0: Unable to open file $file\n";
@lines = <$f>;
close $f;

# Transform case
foreach $line (@lines) {

    $in_string = 0; # Assume not within string
    @words = split(/ /, $line);

    foreach $word (@words) {

        if ($word =~ /^[^"]*"[^"]*$/ and ! $in_string) {
            # String begins with this word
            # print("String opened with $word\n");
            $in_string = 1;
            next; # Do not transform this word
        } elsif ($word =~ /^[^"]*"[^"]*$/ and $in_string) {
            # String ends with this word
            # print("String closed with $word\n");
            $in_string = 0;
            next; # Do not transform this word
        }

        if ($opt_c and ! $in_string) {
            $word =~ s/_(.)/uc($1)/ge;
        }

        if ($opt_s and ! $in_string) {
            $word =~ s/_(.)/uc($1)/ge;
        }

    }
    
    $line = join(' ', @words);
    print $line;

}

# Write to new file
# if ($opt_c) {
#     $new_file = 
# }
# open my $f, '>', 