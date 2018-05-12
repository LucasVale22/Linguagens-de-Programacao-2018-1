use warnings;
use strict;
use Math::Round qw/round/;
use Time::localtime qw/localtime/;

my @resposta = ('S', 'S');
while ($resposta [0] eq 'S') {
	print "Entre com o nome do arquivo que deseja criar: ";
	my $nomeArq = <STDIN>;
	chomp ($nomeArq);

	open(my $entrada, ">:encoding(UTF-8)", $nomeArq.".txt") or die "Erro! O arquivo não pode ser criado: $!";

	print "Deseja escrever algum texto no arquivo? (S/N)) ";
	$resposta [1] = <STDIN>;
	chomp ($resposta [1]);
	if ($resposta [1] eq 'S'){
		print "Escreva o texto desejado: ";
		my $texto = <STDIN>; 
		print $entrada $texto;
	}

	close $entrada or die "$entrada: $!";

	my @statusArq = stat ($nomeArq.".txt");
	print "\n";
	foreach (@statusArq) {
		print ($_,"\t");
	}
	print "\n";
	$statusArq [7] /= 1024;
	$statusArq [7] = round ($statusArq [7]);
	$statusArq [9] = localtime ($statusArq [9]);

	open($entrada, ">>:encoding(UTF-8)", "registro.txt") or die "Erro! O arquivo não pode ser modificado: $!";
	print $entrada "\nN::$nomeArq".".txt"."\nDI::$nomeArq\nDA::12/05/2018 $statusArq[9]\nT::$statusArq[7] KB";
	close $entrada or die "$entrada: $!";

	print "Deseja criar um novo arquivo? (S/N) ";
	$resposta [0] = <STDIN>;
	chomp ($resposta [0]);
}
