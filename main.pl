use warnings;
use strict;
use Text::TabularDisplay;

my $tabela = Text::TabularDisplay->new;

my $nomeArqReg = "registro.txt";
#Constantes padrão que definem início e fim de um arquivo
my $inicioArq = 0;
my $atualArq = 1; 
my $fimArq = 2;

#Armazena a primeira e a segunda linha do arquivo de registro (que contem a opção e a string) a ser passada pelo gerenciador C++
sub registraParametros {

	open(my $entradaReg, "<", $_[0]) or die "Erro! O arquivo não pode ser aberto: $!";

	my @linhasReg = <$entradaReg>;
	chomp($linhasReg [0]);
	chomp($linhasReg [1]);
	my @opcao = split (/::/, $linhasReg [0]); 	#pega o parametro da primeira linha
	my @strDsj = split (/::/, $linhasReg [1]); 	#pega o parametro da segunda linha

	return $opcao [1], $strDsj [1];
}

#filtra nomes de arquivo por string passada no arquivo de registros
sub filtraString{

	(my $nomeArqReg, my $strDsj) = @_;

	my $ocorrencia = 0;
	my @lista;
	my $ocorreu = 0;

	open(my $entradaReg, "<", $nomeArqReg) or die "Erro! O arquivo não pode ser aberto: $!";

	$lista[$ocorrencia]{nome} = "Nome";
	$lista[$ocorrencia]{diretorio} = "Diretorio";
	$lista[$ocorrencia]{dataHora} = "Data e Hora";
	$lista[$ocorrencia]{tamanho} = "Tamanho";

	#percorre cada linha do arquivo
	while (<$entradaReg>) {

		chomp($_);

		my @sptLinha = split(/::/, $_); #separa identificador e nome: $splitLinha[0] -> identificador e $splitLinha[1] -> nome

		#toda vez que encontrar identificador diferente de ';P' (ou seja, a partir da terceira linha do arq de reg)
		if($sptLinha [0] ne ";P"){
			#verifica se a string desejada está contida no nome do arquivo e armazena o mesmo numa lista
			if($sptLinha [0] =~ /$strDsj/){
				$ocorrencia++;
				$lista[$ocorrencia]{nome} = $sptLinha [0];
				$lista[$ocorrencia]{diretorio} = $sptLinha [1];
				$lista[$ocorrencia]{dataHora} = $sptLinha [2];
				$lista[$ocorrencia]{tamanho} = $sptLinha [3];
			}
		}

	}

	close $entradaReg or die "$entradaReg: $!";

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

	open(my $entradaReg, "<", $nomeArq) or die "Erro! O arquivo não pode ser aberto: $!";

	#percorre as linhas do arquivo de registro
	while (<$entradaReg>) {

		chomp($_);
		my @sptLinha = split(/::/, $_);

		#quando encontrar um nome de arquivo abre esse arquivo
		if($sptLinha [0] ne ";P"){
			
			my $ocorrenciaArq = 0; #ocorrencia em cada arquivo
			my $numLinOcorr = 0;	#numero de linhas em que aparecem a string
			
			open(my $entradaArq, "<", $sptLinha [0]) or die "Erro! O arquivo não pode ser aberto: $!";

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
				$lista[$numLinhasArqReg]{nome} = $sptLinha[0];
				$lista[$numLinhasArqReg]{ocorrenciaArq} = $ocorrenciaArq;
				$lista[$numLinhasArqReg]{numLinOcorr} = $numLinOcorr;
				$numLinhasArqReg++;
			}

		}

	}

	close $entradaReg or die "$entradaReg: $!";

	return $ocorrenciaTotal, @lista;

}

sub converteDataHora {
	   my ($dataHora) = @_;
	   
	   #extrai os paraêmtros da string de data e hora através de um expressão regular
	   my ($mes,$dia,$hora,$min,$seg,$ano) = $dataHora =~ m{^([\w]{3})\s([0-9]{2})\s([0-9]{2}):([0-9]{2}):([0-9]{2})\s([0-9]{4})\z}
	      or die;
	   #converte os meses para numeros
	   my @mes = ("Jan", "Feb", "Apr", "Mar", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
	   my @numMes = keys @mes;
	   foreach(@numMes){
	   		if($mes[$_] eq $mes){
	   			$mes = $_ + 1;
	   		}
	   }
	   #retorna uma string concatenada em formato ideal para comparação: ANOMESDIAHORAMINUTOSEGUNDO
	   return "$ano$mes$dia$hora$min$seg";
	}

sub filtraDataHora {

	(my $arqReg, my $dataHoraDsj) = @_;

	my @lista;
	my $ocorrencia = 0;

	my @dHDsj = split(/::/,$dataHoraDsj);
	my $dHI = int(converteDataHora($dHDsj[0]));
	my $dHF = int(converteDataHora($dHDsj[1]));

    $lista[$ocorrencia]{nome} = "Nome";
	$lista[$ocorrencia]{diretorio} = "Diretorio";
	$lista[$ocorrencia]{dataHora} = "Data e Hora";
	$lista[$ocorrencia]{tamanho} = "Tamanho";

	open(my $entradaReg, "<", $arqReg) or die "Erro! O arquivo não pode ser aberto: $!";

	my $i=0;
	while(<$entradaReg>){
		$i++;
		if($i==2){last;}
	}

	while (<$entradaReg>) {
		chomp($_);
		
		my @sptLinha = split (/-/, $_);
		
		my $dataHoraArq = $sptLinha[2];
		
		$dataHoraArq = converteDataHora ($dataHoraArq);
		if ($dHI <= $dataHoraArq && $dataHoraArq <= $dHF) {
			$ocorrencia++;
			$lista[$ocorrencia]{nome} = $sptLinha[0];
			$lista[$ocorrencia]{diretorio} = $sptLinha[1];
			$lista[$ocorrencia]{dataHora} = $sptLinha[2];
			$lista[$ocorrencia]{tamanho} = $sptLinha[3];
		}
	}

	close $entradaReg or die "$entradaReg: $!";

	return $ocorrencia, @lista;

}

#gera arquivo contendo uma lista com as saídas desejadas (filtragem) de acordo com cada opção passada no arquivo de registro
sub geraArqLista {

	my $tabela = $_[0];

	unlink "lista-de-retorno.txt";
	open(my $entrada, ">>", "lista-de-retorno.txt") or die "Erro! O arquivo não pode ser gerado: $!";
	
	print $entrada $tabela->render;
	print $tabela->render;

	close $entrada or die "$entrada: $!";

}

#programa principal que extrai dados importantes do arquivo de registros

system("cls");
print ("*************************************\n");
print ("********PROCESSADOR DE TEXTOS********\n");
print ("*************************************\n\n");

(my $opcao, my $stringDesejada) = registraParametros($nomeArqReg);
my @lista;
my $ocorrencia;

if ($opcao eq "FSTR"){
	
	print("<Filtrando por nome de arquivo...>\n");
	print ("String desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = filtraString($nomeArqReg, $stringDesejada);
	
	print("Numero de ocorrencias: ", $ocorrencia);

	if ($ocorrencia == 0) {
		print ("\n\n*** NENHUM RESULTADO ENCONTRADO! ***\n")
	}
	else {
		print("\nArquivos encontrados: \n"); 
		for my $href ( @lista ) {
	    	$tabela->add($href->{nome}, $href->{diretorio}, $href->{dataHora}, $href->{tamanho});
		}

		geraArqLista ($tabela);
	}
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
	($ocorrencia, @lista) = filtraDataHora ($nomeArqReg, $stringDesejada);

	for my $href ( @lista ) {
    	$tabela->add($href->{nome}, $href->{diretorio}, $href->{dataHora}, $href->{tamanho});
	}

	geraArqLista ($tabela);
}







