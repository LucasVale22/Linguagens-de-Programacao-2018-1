use warnings;
use strict;
use Math::Round qw/round/;
use Time::localtime;
use File::stat;

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

	my $statusArq = stat ($nomeArq.".txt");

	my $tamanho = $statusArq->size;

	if ($tamanho >= 1024) {
		$tamanho /= 1024;
		$tamanho = int ($tamanho * 100) / 100;
		$tamanho = $tamanho." KB";
	}
	elsif ($tamanho >= (1024 * 1024)) {
		$tamanho /= (1024 * 1024);
		$tamanho = int ($tamanho * 100) / 100;
		$tamanho = $tamanho." MB";
	}
	else {$tamanho = $tamanho." bytes";}

	my $dataHora = ctime ($statusArq->mtime);
	

	open($entrada, ">>:encoding(UTF-8)", "registro.txt") or die "Erro! O arquivo não pode ser modificado: $!";
	print $entrada "\n".$nomeArq.".txt::".$nomeArq."::".$dataHora."::".$tamanho;
	close $entrada or die "$entrada: $!";

	print "Deseja criar um novo arquivo? (S/N) ";
	$resposta [0] = <STDIN>;
	chomp ($resposta [0]);
}
