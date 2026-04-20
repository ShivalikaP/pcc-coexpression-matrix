#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);

# =============================================================================
# PCC_main.pl — Batch Pearson Correlation Coefficient Calculator
# =============================================================================
# Author:  Shivalika Pathania (CSIR-IHBT)
# Purpose: For every query gene, compute PCC against every reference gene.
#          Calls cor.pl for each gene pair and appends results to an output file.
#
# Usage:
#   perl scripts/PCC_main.pl <query_file> <reference_file> [output_file]
#
# Arguments:
#   query_file      Tab-separated: gene_id <TAB> value1 <TAB> value2 ...
#   reference_file  Tab-separated: gene_id <TAB> value1 <TAB> value2 ...
#   output_file     Output filename (optional; default: PCC_output)
#
# Output:
#   Tab-separated: query_gene_id <TAB> ref_gene_id <TAB> PCC_value
#   Sorted by PCC descending within each query gene.
# =============================================================================

unless (@ARGV >= 2) {
    die join("\n",
        "Usage: perl scripts/PCC_main.pl <query_file> <reference_file> [output_file]",
        "  query_file     : tab-separated expression data (gene_id TAB value1 TAB ...)",
        "  reference_file : tab-separated expression data (gene_id TAB value1 TAB ...)",
        "  output_file    : results filename (default: PCC_output)",
        "",
    );
}

my ($query_file, $ref_file, $output_file) = @ARGV;
$output_file //= 'PCC_output';

my $cor_script = "$Bin/cor.pl";
die "Cannot find cor.pl at: $cor_script\n" unless -f $cor_script;

# Temp files with PID suffix to avoid collisions
my $tmp_query = "tmp_pcc_q_$$";
my $tmp_ref   = "tmp_pcc_r_$$";

END { unlink $tmp_query, $tmp_ref }

open(my $fh_query, '<', $query_file)
    or die "Cannot open query file '$query_file': $!\n";

while (my $query_line = <$fh_query>) {
    chomp $query_line;
    next if $query_line =~ /^\s*$/;

    open(my $fh_tmp_q, '>', $tmp_query)
        or die "Cannot write temp file '$tmp_query': $!\n";
    print $fh_tmp_q "$query_line\n";
    close $fh_tmp_q;

    open(my $fh_ref, '<', $ref_file)
        or die "Cannot open reference file '$ref_file': $!\n";

    while (my $ref_line = <$fh_ref>) {
        chomp $ref_line;
        next if $ref_line =~ /^\s*$/;

        open(my $fh_tmp_r, '>', $tmp_ref)
            or die "Cannot write temp file '$tmp_ref': $!\n";
        print $fh_tmp_r "$ref_line\n";
        close $fh_tmp_r;

        system("perl $cor_script $tmp_query $tmp_ref >> $output_file");
    }

    close $fh_ref;
}

close $fh_query;
