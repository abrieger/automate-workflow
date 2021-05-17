#!/usr/bin/perl -w

# Program checks how many lines of code are repeated
# and recommends refactoring for a > 10% repetition rate

# Written by Adam Brieger

use POSIX;

sub usage_exit {
    print STDERR "usage: $0 <file>\n";
    exit 1;
}

$file = shift @ARGV or usage_exit();

open my $f, '<', $file or die "$0: unable to open file $file\n";

while (<$f>) {
    chomp;
    $lines{$_}++;
}

# Note finding duplicates is simpler in shell using sort and uniq
print("--------------\n");
print("REPETITION CHECK:\n");
print("--------------\n");
$total_dups = 0;
foreach $key (sort { $lines{$b} <=> $lines{$a} } keys %lines) {
    # Print from most repetitive to least repetitive, excluding unique lines
    next if $lines{$key} == 1; 
    $percentage = POSIX::round(($lines{$key} / $.) * 100);
    print("\"$key\" : repeated $lines{$key} times (approx. $percentage% of file)\n");
    $total_dups = $total_dups + ($lines{$key} - 1); # Minus 1 for the unique occurrence
}

$total_dup_percent = POSIX::round(($total_dups / $.) * 100);
print("--------------\n");
print("SUMMARY:\n");
print("--------------\n");
print("$total_dup_percent% of lines are repetitive in this program\n");
if ($total_dup_percent >= 10 ) {
    print("Refactoring is strongly recommended to reduce repetitive code\n");
} elsif ($total_dup_percent >= 5) {
    print("Code looks okay, but some refactoring should be considered\n");
} else {
    print("Code looks great! Less than 5% of lines are repetitive");
}
