use warnings;
use strict;

my $nomeArqReg = "registro.txt";
my $inicioArq = 1;
my $fimArq = 2;

sub resgistraOpcao {

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

	(my $nomeArq, my $strDsj) = @_;

	my $ocorrencia = 0;
	my @lista;

	open(my $entrada, "<:encoding(UTF-8)", $nomeArq) or die "Erro! O arquivo não pode ser aberto: $!";
	seek($entrada,0,$inicioArq);

	while (<$entrada>) {

		chomp($_);
		my @sptLinha = split(/::/, $_);

		if($sptLinha [0] eq 'N'){

			if($sptLinha [1] =~ /$strDsj/){
				$ocorrencia++;
				$lista [$ocorrencia - 1] = $sptLinha [1];
			}

		}

	}

	close $entrada or die "$entrada: $!";

	return $ocorrencia, @lista;

}

sub geraArqLista {

	unlink "lista-de-retorno.txt";
	open(my $entrada, ">>:encoding(UTF-8)", "lista-de-retorno.txt") or die "Erro! O arquivo não pode ser gerado: $!";
	seek($entrada,0,$inicioArq);
	foreach (@_) {
		print $entrada "$_\n";
		print "$_\n";
	}
	close $entrada or die "$entrada: $!";

}

sub contaOcorrencias {

	(my $nomeArq, my $strDsj) = @_;

	my @lista;
	my @entrada;
	my $numLinhasArqReg = 0;
	my $numLinOcorr = 0;
	
	open(my $entradaReg, "<:encoding(UTF-8)", $nomeArq) or die "Erro! O arquivo nÃ£o pode ser aberto: $!";

	while (<$entradaReg>) {

		chomp($_);
		my @sptLinha = split(/::/, $_);

		if($sptLinha [0] eq 'N'){
			
			my $ocorrencia = 0;
			
			open(my $entradaArq, "<:encoding(UTF-8)", $sptLinha [1]) or die "Erro! O arquivo nÃ£o pode ser aberto: $!";

			while (<$entradaArq>) {
				if ($_ =~ /$strDsj/) {
					$numLinOcorr++; 
				}
				while ($_ =~ m/($strDsj)/g){
					$ocorrencia++;
				}
			}

			close $entradaArq or die "$entradaArq: $!";
			
			$lista [$numLinhasArqReg] = "$sptLinha[1]: $ocorrencia ocorrencias de <$strDsj> encontradas em $numLinOcorr linhas";
			$numLinhasArqReg++;

		}

	}

	close $entradaReg or die "$entradaReg: $!";

	return @lista;

}

my $opcao = resgistraOpcao($nomeArqReg);
my $stringDesejada = registraString($nomeArqReg);
my @lista;

if ($opcao eq "FNEL"){
	my $ocorrencia;
	($ocorrencia, @lista) = filtraString($nomeArqReg, $stringDesejada);
	print("Filtrar por string: $stringDesejada\n");
	print("Numero de ocorrencias encontradas: ", $ocorrencia);

	print("\nArquivos encontrados: \n"); 
	if($ocorrencia == 0){
		print("NENHUM!")
	}

	geraArqLista (@lista);
}

elsif ($opcao eq "CONT"){

	@lista = contaOcorrencias ($nomeArqReg, $stringDesejada);
	geraArqLista (@lista)
}







