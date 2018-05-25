use warnings;
use strict;
use fileManager qw (registraParametros filtraString contaOcorrencias converteDataHora filtraDataHora atualizaRegistro geraArqLista);

my $tabela = Text::TabularDisplay->new;

#Constantes padrão que definem início e fim de um arquivo
my $inicioArq = 0;
my $atualArq = 1; 
my $fimArq = 2;

#programa principal que extrai dados importantes do arquivo de registros

system("cls");
print ("*************************************\n");
print ("********PROCESSADOR DE TEXTOS********\n");
print ("*************************************\n\n");

my @lista;
my $ocorrencia;
my $nomeArqReg = "registroTemp.txt";
(my $opcao, my $stringDesejada) = registraParametros($nomeArqReg);

if ($opcao eq "FSTR"){
	
	print("<Filtrando por nome de arquivo...>\n");
	print ("String desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = filtraString($nomeArqReg, $stringDesejada);
	
	print("Numero de ocorrencias: ", $ocorrencia);

	if ($ocorrencia == 0) {
		print ("\n\n*** NENHUM RESULTADO ENCONTRADO! ***\n");
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

	print("<Filtrando por periodo de modificacao de arquivo...>\n\n");
	print ("Periodo de Data desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = filtraDataHora ($nomeArqReg, $stringDesejada);

	for my $href ( @lista ) {
    	$tabela->add($href->{nome}, $href->{diretorio}, $href->{dataHora}, $href->{tamanho});
	}

	geraArqLista ($tabela);
}

elsif ($opcao eq "MREG"){

	print("<Atualizando Arquivo de Registro...>\n\n");
	atualizaRegistro($nomeArqReg);
	print("\nArquivo de Registro Atualizado com sucesso\n");
}







