use strict;
use warnings;
 
my $filename = 'registro.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Não foi possível abrir o arquivo '$filename' $!";
 
while (my $row = <$fh>) {
  chomp $row; #remover o caracter de enter (\n)"
  my @splRow = split(/::/, $row);
  foreach (values @splRow) {
  	print("\t", $_);	
  }
  print "\n";
}