use warnings;
use strict;

my $nomeArqReg = "registro.txt";
my $inicioArq = 1;
my $fimArq = 2;

sub resgistraOpcao{

	open(my $entrada, "<:encoding(UTF-8)", $_[0]) or die "Erro! O arquivo não pode ser aberto: $!";

	seek($entrada,0,$inicioArq);
	my $opcao = <$entrada>;
	chomp($opcao);
	
	close $entrada or die "$entrada: $!";

	return $opcao;
}

sub registraString{

	my $strDsj;

	open(my $entrada, "<:encoding(UTF-8)", $_[0]) or die "Erro! O arquivo não pode ser aberto: $!";

	while(<$entrada>){
			$strDsj = <$entrada>;
			chomp($strDsj);
			seek($entrada,0,$fimArq);
	}
	close $entrada or die "$entrada: $!";

	return $strDsj;
}

sub filtraString{

	(my $nomeArq, my $strDjs) = @_;

	my $ocorrencia = 0;
	my @lista;

	open(my $entrada, "<:encoding(UTF-8)", $nomeArq) or die "Erro! O arquivo não pode ser aberto: $!";
	seek($entrada,0,1);

	while (<$entrada>) {

		chomp($_);
		my @sptLinha = split(/::/, $_);

		if($sptLinha [0] eq 'N'){

			if($sptLinha [1] =~ /$strDjs/){
				$ocorrencia++;
				$lista [$ocorrencia - 1] = $sptLinha [1];
			}

		}

	}

	close $entrada or die "$entrada: $!";

	return $ocorrencia, @lista;

}

my $opcao = resgistraOpcao($nomeArqReg);
my $stringDesejada = registraString($nomeArqReg);

if ($opcao eq "FNEL"){
	my $ocorrencia;
	my @lista;
	($ocorrencia, @lista) = filtraString($nomeArqReg, $stringDesejada);
	print("Filtrar por string: $stringDesejada\n");
	print("Numero de ocorrencias encontradas: ", $ocorrencia);

	print("\nArquivos encontrados: \n"); 
	if($ocorrencia == 0){
		print("NENHUM!")
	}
	foreach (@lista) {
		print ($_,"\n");
	}
}







