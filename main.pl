use warnings;
use strict;
use Text::TabularDisplay;

my $tabela = Text::TabularDisplay->new;

my $nomeArqReg = "registro.txt";
#Constantes padrão que definem início e fim de um arquivo
my $inicioArq = 0;
my $atualArq = 1; 
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
	my $ocorreu = 0;

	open(my $entrada, "<:encoding(UTF-8)", $nomeArq) or die "Erro! O arquivo não pode ser aberto: $!";

	$lista[$ocorrencia]{nome} = "Nome";
	$lista[$ocorrencia]{diretorio} = "Diretorio";
	$lista[$ocorrencia]{dataHora} = "Data e Hora";
	$lista[$ocorrencia]{tamanho} = "Tamanho";
	#percorre cada linha do arquivo
	while (<$entrada>) {

		chomp($_);
		my @sptLinha = split(/::/, $_); #separa identificador e nome: $splitLinha[0] -> identificador e $splitLinha[1] -> nome

		#toda vez que encontrar identificador = N (nome)
		if($sptLinha [0] eq 'N'){
			#verifica se a string desejada está contida no nome do arquivo e armazena o mesmo numa lista
			if($sptLinha [1] =~ /$strDsj/){
				$ocorrencia++;
				$lista[$ocorrencia]{nome} = $sptLinha [1];
				$ocorreu = 1;
			}
		}
		elsif($sptLinha [0] eq "DI" && $ocorreu == 1) {
			$lista[$ocorrencia]{diretorio} = $sptLinha [1];
		}
		elsif($sptLinha [0] eq "DA" && $ocorreu == 1) {
			$lista[$ocorrencia]{dataHora} = $sptLinha [1];
		}
		elsif($sptLinha [0] eq 'T' && $ocorreu == 1) {
			$lista[$ocorrencia]{tamanho} = $sptLinha [1];
			$ocorreu = 0;
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
	my $numLinhasArqReg = 0; #numero de linhas de cada arquivo 
	my $ocorrenciaTotal = 0;	#ocorrencia total em todos os arquivos

	$lista[$numLinhasArqReg]{nome} = "Nome do Arquivo";
	$lista[$numLinhasArqReg]{ocorrenciaArq} = "Ocorrencias";
	$lista[$numLinhasArqReg]{numLinOcorr} = "Linhas de Ocorrencia";
	$numLinhasArqReg++;

	open(my $entradaReg, "<:encoding(UTF-8)", $nomeArq) or die "Erro! O arquivo não pode ser aberto: $!";

	#percorre as linhas do arquivo de registro
	while (<$entradaReg>) {

		chomp($_);
		my @sptLinha = split(/::/, $_);

		#quando encontrar um nome de arquivo abre esse arquivo
		if($sptLinha [0] eq 'N'){
			
			my $ocorrenciaArq = 0; #ocorrencia em cada arquivo
			my $numLinOcorr = 0;	#numero de linhas em que aparecem a string
			
			open(my $entradaArq, "<:encoding(UTF-8)", $sptLinha [1]) or die "Erro! O arquivo não pode ser aberto: $!";

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
			
			#salva numa lista todas ocorencias de cada arquivo e em quantas linhas se deram
			if ($ocorrenciaArq != 0) {
				$lista[$numLinhasArqReg]{nome} = $sptLinha[1];
				$lista[$numLinhasArqReg]{ocorrenciaArq} = $ocorrenciaArq;
				$lista[$numLinhasArqReg]{numLinOcorr} = $numLinOcorr;
				$numLinhasArqReg++;
			}

		}

	}

	close $entradaReg or die "$entradaReg: $!";

	return $ocorrenciaTotal, @lista;

}

sub filtraDataHora {

	#formato mandado pelo arquivo de registro: string que indica o intervalo de pesquisa
	#D1/M1/A1-H:M:S::D2/M2/A2-H:S:M


}

#gera arquivo contendo uma lista com as saídas desejadas (filtragem) de acordo com cada opção passada no arquivo de registro
sub geraArqLista {

	my $tabela = $_[0];

	unlink "lista-de-retorno.txt";
	open(my $entrada, ">>:encoding(UTF-8)", "lista-de-retorno.txt") or die "Erro! O arquivo não pode ser gerado: $!";
	
	print $entrada $tabela->render;
	print $tabela->render;

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

if ($opcao eq "FSTR"){
	
	print("<Filtrando por nome de arquivo...>\n");
	print ("String desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = filtraString($nomeArqReg, $stringDesejada);
	
	print("Numero de ocorrencias encontradas: ", $ocorrencia);
	print("\nArquivos encontrados: \n"); 
	if($ocorrencia == 0){
		print("NENHUM!")
	}

	for my $href ( @lista ) {
    	$tabela->add($href->{nome}, $href->{diretorio}, $href->{dataHora}, $href->{tamanho});
	}

	geraArqLista ($tabela);
}

elsif ($opcao eq "CONT"){

	print("<Filtrando por conteúdo de arquivo...>\n");
	print ("String desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = contaOcorrencias ($nomeArqReg, $stringDesejada);

	print("Numero de ocorrencias totais encontradas: ", $ocorrencia, "\n\n");

	for my $href ( @lista ) {
    	$tabela->add($href->{nome}, $href->{ocorrenciaArq}, $href->{numLinOcorr});
	}

	geraArqLista ($tabela);
}

elsif ($opcao eq "FDAT"){

	print("<Filtrando por período de modificação de arquivo...>\n");
	print ("Data desejada: $stringDesejada\n\n");
	@lista = filtraDataHora ($nomeArqReg, $stringDesejada);

	for my $href ( @lista ) {
    	$tabela->add($href->{nome}, $href->{ocorrenciaArq}, $href->{numLinOcorr});
	}

	geraArqLista ($tabela);
}







