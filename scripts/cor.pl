#!/usr/bin/perl
use strict;
use warnings;

# =============================================================================
# cor.pl — Pearson Correlation Coefficient computation
# =============================================================================
# Author:  Shivalika Pathania (CSIR-IHBT)
# Purpose: Read one query gene and one or more reference genes from two
#          tab-separated files, compute PCC for each pair, print results
#          sorted by PCC in descending order.
#
# Usage (standalone):
#   perl scripts/cor.pl <query_file> <reference_file>
#
# Typically called from PCC_main.pl with single-gene temp files.
#
# Input format (both files):
#   gene_id <TAB> value1 <TAB> value2 <TAB> ...
#
# Output:
#   query_gene_id <TAB> ref_gene_id <TAB> PCC_value
# =============================================================================

unless (@ARGV == 2) {
    die "Usage: perl scripts/cor.pl <query_file> <reference_file>\n";
}

# Shared data structures accessed by subroutines
our @x;       # $x[1][i] = query values, $x[2][i] = ref values
our @mean;    # mean[1] = query mean,    mean[2] = ref mean
our $nbdata;  # number of expression values per gene

# ── Read query gene ───────────────────────────────────────────────────────────
open(my $fh_query, '<', $ARGV[0])
    or die "Cannot open query file '$ARGV[0]': $!\n";

my ($query_id, @query_vals);
while (<$fh_query>) {
    chomp;
    my @fields  = split("\t", $_);
    $query_id   = shift @fields;
    @query_vals = @fields;
}
close $fh_query;

$nbdata = scalar @query_vals;
die "No expression values found in query file\n" unless $nbdata > 0;

for my $i (0 .. $nbdata - 1) {
    $x[1][$i] = $query_vals[$i];
}

# ── Read reference genes and compute PCC for each ─────────────────────────────
open(my $fh_ref, '<', $ARGV[1])
    or die "Cannot open reference file '$ARGV[1]': $!\n";

my %results;
while (<$fh_ref>) {
    chomp;
    my @fields = split(/\t/, $_);
    my $ref_id = shift @fields;

    for my $i (0 .. $#fields) {
        $x[2][$i] = $fields[$i];
    }

    $results{"$query_id\t$ref_id"} = correlation();
}
close $fh_ref;

for my $key (sort { $results{$b} <=> $results{$a} } keys %results) {
    print "$key\t$results{$key}";
}

# ── Subroutines ───────────────────────────────────────────────────────────────

sub correlation {
    $mean[1] = mean(1);
    $mean[2] = mean(2);
    my $ssxx = ss(1, 1);
    my $ssyy = ss(2, 2);
    my $ssxy = ss(1, 2);
    my $pcc  = correl($ssxx, $ssyy, $ssxy);
    return sprintf("%.4f\n", $pcc);
}

sub mean {
    my ($a)  = @_;
    my $sum  = 0;
    for my $j (0 .. $nbdata - 1) {
        $sum += $x[$a][$j];
    }
    return $sum / $nbdata;
}

sub ss {
    my ($row, $col) = @_;
    my $sum = 0;
    for my $i (0 .. $nbdata - 1) {
        $sum += ($x[$row][$i] - $mean[$row]) * ($x[$col][$i] - $mean[$col]);
    }
    return $sum;
}

sub correl {
    my ($ssxx, $ssyy, $ssxy) = @_;
    return 0 if $ssxx == 0 || $ssyy == 0;
    my $sign = $ssxy == 0 ? 1 : $ssxy / abs($ssxy);
    return $sign * sqrt($ssxy * $ssxy / ($ssxx * $ssyy));
}
