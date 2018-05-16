use warnings;
use strict;

my $nomeArqReg = "registro.txt";
#Constantes padrão que definem início e fim de um arquivo
my $inicioArq = 1;  
my $fimArq = 2;

#Armazena a primeira linha do arquivo de registro (que contém a opção) a ser passada pelo gerenciador C++
sub registraOpcao {

	open(my $entrada, "<:encoding(UTF-8)", $_[0]) or die "Erro! O arquivo não pode ser aberto: $!";

	my $opcao = <$entrada>;
	chomp($opcao);
	
	close $entrada or die "$entrada: $!";

	return $opcao;
}

#Armazena a string de interesse da segunda linha do arquivo de registro (para análise de expressão regular) passada pelo gerenciador C++
sub registraString{

	my $strDsj;

	open(my $entrada, "<:encoding(UTF-8)", $_[0]) or die "Erro! O arquivo não pode ser aberto: $!";

	if(<$entrada>){
		$strDsj = <$entrada>;
		chomp($strDsj);
	}

	close $entrada or die "$entrada: $!";

	return $strDsj;
}

#filtra nomes de arquivo por string passada no arquivo de registros
sub filtraString{

	(my $nomeArq, my $strDsj) = @_;

	my $ocorrencia = 0;
	my @lista;

	open(my $entrada, "<:encoding(UTF-8)", $nomeArq) or die "Erro! O arquivo não pode ser aberto: $!";

	#percorre cada linha do arquivo
	while (<$entrada>) {

		chomp($_);
		my @sptLinha = split(/::/, $_); #separa identificador e nome

		#toda vez que encontrar identificador = N (nome)
		if($sptLinha [0] eq 'N'){

			#verifica se a string desejada está contida no nome do arquivo e armazena o mesmo numa lista
			if($sptLinha [1] =~ /$strDsj/){
				$ocorrencia++;
				$lista [$ocorrencia - 1] = $sptLinha [1];
			}

		}

	}

	close $entrada or die "$entrada: $!";

	return $ocorrencia, @lista;

}

#conta ocorrencias de uma string desejada dentro de cada arquivo
sub contaOcorrencias {

	(my $nomeArq, my $strDsj) = @_;

	my @lista;
	my @entrada;
<<<<<<< HEAD
	my $numLinhasArqReg = 0; #numero de linhas de cada arquivo 
	my $numLinOcorr = 0;	#numero de linhas em que aparecem a string
	my $ocorrenciaTotal = 0;	#ocorrencia total em todos os arquivos

	$lista [$numLinhasArqReg] = "Ocorrencia\tLinhas\t\tNome";
	$numLinhasArqReg++;

	open(my $entradaReg, "<:encoding(UTF-8)", $nomeArq) or die "Erro! O arquivo não pode ser aberto: $!";
=======
	my $numLinhasArqReg = 0;
	my $numLinOcorr = 0;
	
	open(my $entradaReg, "<:encoding(UTF-8)", $nomeArq) or die "Erro! O arquivo nÃ£o pode ser aberto: $!";
>>>>>>> 22314bd5e5efd3605d8e14fe730917b42e2f0678

	#percorre as linhas do arquivo de registro
	while (<$entradaReg>) {

		chomp($_);
		my @sptLinha = split(/::/, $_);

		#quando encontrar um nome de arquivo abre esse arquivo
		if($sptLinha [0] eq 'N'){
			
			my $ocorrenciaArq = 0; #ocorrencia em cada arquivo
			
			open(my $entradaArq, "<:encoding(UTF-8)", $sptLinha [1]) or die "Erro! O arquivo nÃ£o pode ser aberto: $!";

			#percorre todas as linhas do arquivo aberto e conta em quantas linhas há ocorrencia e quantas ocorrencias naquele arquivo
			while (<$entradaArq>) {
				if ($_ =~ /$strDsj/) {
					$numLinOcorr++; 
				}
				while ($_ =~ m/($strDsj)/g){
					$ocorrenciaArq++;
				}
			}
			$ocorrenciaTotal += $ocorrenciaArq;

			close $entradaArq or die "$entradaArq: $!";
			
<<<<<<< HEAD
			#salva numa lista todas ocorencias de cada arquivo e em quantas linhas se deram
			$lista [$numLinhasArqReg] = "$ocorrenciaArq\t\t$numLinOcorr\t\t$sptLinha[1]";
=======
			$lista [$numLinhasArqReg] = "$sptLinha[1]: $ocorrencia ocorrencias de <$strDsj> encontradas em $numLinOcorr linhas";
>>>>>>> 22314bd5e5efd3605d8e14fe730917b42e2f0678
			$numLinhasArqReg++;

		}

	}

	close $entradaReg or die "$entradaReg: $!";

	return $ocorrenciaTotal, @lista;

}

#gera arquivo contendo uma lista com as saídas desejadas (filtragem) de acordo com cada opção passada no arquivo de registro
sub geraArqLista {

	unlink "lista-de-retorno.txt";
	open(my $entrada, ">>:encoding(UTF-8)", "lista-de-retorno.txt") or die "Erro! O arquivo não pode ser gerado: $!";
	
	foreach (@_) {
		print $entrada "$_\n";
		print "$_\n";
	}
	close $entrada or die "$entrada: $!";

}

#programa principal que extrai dados importantes do arquivo de registros

system("cls");
print ("*************************************\n");
print ("********PROCESSADOR DE TEXTOS********\n");
print ("*************************************\n\n");


my $opcao = registraOpcao($nomeArqReg);
my $stringDesejada = registraString($nomeArqReg);
my @lista;
my $ocorrencia;

if ($opcao eq "FNEL"){
	
	print("<Filtrando por nome de arquivo...>\n");
	print ("String desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = filtraString($nomeArqReg, $stringDesejada);
	
	print("Numero de ocorrencias encontradas: ", $ocorrencia);
	print("\nArquivos encontrados: \n"); 
	if($ocorrencia == 0){
		print("NENHUM!")
	}

	geraArqLista (@lista);
}

elsif ($opcao eq "CONT"){

	print("<Filtrando por conteúdo de arquivo...>\n");
	print ("String desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = contaOcorrencias ($nomeArqReg, $stringDesejada);

	print("Numero de ocorrencias totais encontradas: ", $ocorrencia, "\n\n");
	geraArqLista (@lista)
}







