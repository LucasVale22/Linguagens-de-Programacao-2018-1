use warnings;
use strict;
use Cwd;
use Cwd 'abs_path';
mkdir("TESTE",0777); #die "Não foi possível dar mkdir: $!";

my $dir = getcwd;

my $abs_path = abs_path('TESTE/economia.txt');

print "\n".$dir."\n";
print "\n".$abs_path."\n";