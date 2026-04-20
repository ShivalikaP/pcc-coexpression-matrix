#@author Shivalika Pathania
#CSIR-IHBT
#!/usr/bin/perl -w
#use strict;
#use warnings;
open(QUERY, "<", $ARGV[0]) or die "Couldn't open query: $!";
open (ANNOT, "<", $ARGV[1]) or die "Couldn't open csv: $!";
 
my @arrx;
$f="";
while (<QUERY>){
        chomp;
        my @arr = split("\t", $_);
        my $gene_id_1=shift @arr;
$f = $gene_id_1;
        foreach my $ele (@arr){
                push(@arrx, $ele);
        }
#print "@arrx\n";



}
#print "$gene_id_1\n";
my @x;
my $i = 0;
foreach my $elex (@arrx){
        $x[1][$i]=$elex;
        $i++;
}
#my $numx = $i;
my $nbdata = $i;
my @mean;
my %hash;
while(<ANNOT>){
        chomp;
        my @arry = split(/\t/, $_);
        my $gene_id = shift @arry;
#print "$gene_id\n";
        my $i=0;
        foreach my $eley (@arry){
                $x[2][$i]=$eley;
                $i++;
        }
#        if ($i != $numx){
 #               die "Arrays not the same size\n";
  #      }
        my $correl = correlation();
#print "$gene_id\t$f\n";
$name_of_cor= "$f\t$gene_id";
        $hash{$name_of_cor}=$correl;
}
foreach my $key (sort {$hash{$b} <=> $hash{$a}} keys %hash){
        print "$key\t$hash{$key}";
}
sub correlation {
        $mean[1] = mean(1);
        $mean[2] = mean(2);
        my $ssxx = ss(1,1);
        my $ssyy = ss(2,2);
        my $ssxy = ss(1,2);
        #print "$ssxx\t$ssyy\t$ssxy\n";
        my $correl = correl($ssxx, $ssyy, $ssxy);
        $correl =	 sprintf("%.4f\n", $correl);
        return $correl;
 
}
sub mean {
 
        my ($a)=@_;
        my ($j,$sum)=(0,0);
 
        for ($j=0;$j<$nbdata;$j++){
                $sum=$sum+$x[$a][$j];
        }
        my $mu=$sum/$nbdata;
 
        return $mu;
 
}
 
 
sub ss{
        my ($row, $col) = @_;
        my $sum = 0;
        for (my $i = 0; $i<$nbdata; $i++){
                $sum += ($x[$row][$i]-$mean[$row])*($x[$col][$i]-$mean[$col]);
        }
        return $sum;
}
sub correl{
        my ($ssxx, $ssyy, $ssxy) = @_;
        my $sign = $ssxy/abs($ssxy);
        my $correl = $sign*sqrt($ssxy*$ssxy/($ssxx*$ssyy));
        return $correl;
}
