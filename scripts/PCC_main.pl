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

# ── Argument validation ───────────────────────────────────────────────────────
unless (@ARGV >= 2) {
    die join("\n",
        "Usage: perl scripts/PCC_main.pl <query_file> <reference_file> [output_file]",
        "  query_file     : tab-separated expression data (gene_id + values per column)",
        "  reference_file : tab-separated expression data (gene_id + values per column)",
        "  output_file    : output filename (default: PCC_output)",
        "",
    );
}

my ($query_file, $ref_file, $output_file) = @ARGV;
$output_file = "PCC_output" unless defined $output_file;

# ── Locate cor.pl relative to this script ────────────────────────────────────
my $cor_script = "$Bin/cor.pl";
die "Cannot find cor.pl at: $cor_script\n" unless -f $cor_script;

# ── Temp files — use PID suffix to avoid collisions ──────────────────────────
my $tmp_query = "tmp_pcc_q_$$";
my $tmp_ref   = "tmp_pcc_r_$$";

# Ensure temp files are removed even on error or signal
END { unlink $tmp_query, $tmp_ref if defined $tmp_query }

# ── Open query file ───────────────────────────────────────────────────────────
open(my $fh_query, "<", $query_file)
    or die "Cannot open query file '$query_file': $!\n";

# ── For each query gene, compare against every reference gene ─────────────────
while (my $query_line = <$fh_query>) {
    chomp $query_line;
    next if $query_line =~ /^\s*$/;    # skip blank lines

    # Write this single query gene to the temp file
    open(my $out_q, ">", $tmp_query)
        or die "Cannot write temp file '$tmp_query': $!\n";
    print $out_q "$query_line\n";
    close $out_q;

    # Open reference file for each query gene
    open(my $fh_ref, "<", $ref_file)
        or die "Cannot open reference file '$ref_file': $!\n";

    while (my $ref_line = <$fh_ref>) {
        chomp $ref_line;
        next if $ref_line =~ /^\s*$/;    # skip blank lines

        # Write this single reference gene to the temp file
        open(my $out_r, ">", $tmp_ref)
            or die "Cannot write temp file '$tmp_ref': $!\n";
        print $out_r "$ref_line\n";
        close $out_r;

        # Compute PCC for this pair and append to output
        system("perl $cor_script $tmp_query $tmp_ref >> $output_file") == 0
            or warn "Warning: cor.pl returned non-zero for a gene pair\n";
    }
    close $fh_ref;
}
close $fh_query;

print "Done. Results written to: $output_file\n";
