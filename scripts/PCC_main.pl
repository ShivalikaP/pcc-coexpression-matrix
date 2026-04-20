#@author Shivalika Pathania
#CSIR-IHBT
open(FH,$ARGV[0])||die;
while($line=<FH>)
{
chomp($line);
open (OUT1,">new1")||die;
print OUT1 "$line\n";
open(FH1,$ARGV[1])||die;
while($line1=<FH1>)
{
chomp($line1);
open (OUT,">new")||die;
print OUT "$line1\n";
system ("perl cor.pl new1 new >>PCC_output");
}
}
