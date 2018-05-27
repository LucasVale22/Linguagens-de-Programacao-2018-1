use warnings;
use strict;
use fileManager qw (registraParametros filtraString contaOcorrencias converteDataHora filtraDataHora atualizaRegistro filtraTamanho obtemDadosArq geraArqLista);
my $tabela = Text::TabularDisplay->new;
#programa principal que extrai dados importantes do arquivo de registros

system("cls");
print ("*************************************\n");
print ("********PROCESSADOR DE TEXTOS********\n");
print ("*************************************\n\n");

my @lista;
my $ocorrencia;
my $arqParametros = "parametros.txt";
my $diretorio = "./myFiles";
(my $opcao, my $stringDesejada, my $arqRegistro) = registraParametros($arqParametros);

if ($opcao eq "FSTR"){
	
	print("<Filtrando por nome de arquivo...>\n");
	print ("String desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = filtraString($arqRegistro, $stringDesejada);
	
	print("Numero de ocorrencias: ", $ocorrencia);

	if ($ocorrencia == 0) {
        print ("\n\n*** NENHUM RESULTADO ENCONTRADO! ***\n");
    }
    else {
        print("\nArquivos encontrados: \n"); 
        
        for my $href ( @lista ) { 
            $tabela->add($href->{nome}, $href->{diretorio}, $href->{dataHora}, $href->{tamanho});
        }
    }

	geraArqLista ($ocorrencia, $tabela);
}

elsif ($opcao eq "FCON"){

	print("<Filtrando por conteúdo de arquivo...>\n");
	print ("String (s) desejada (s): $stringDesejada\n");
	($ocorrencia, @lista) = contaOcorrencias ($diretorio, $arqRegistro, $stringDesejada);

	print("Numero de ocorrencias totais encontradas: ", $ocorrencia, "\n\n");

	if ($ocorrencia == 0) {
        print ("\n\n*** NENHUM RESULTADO ENCONTRADO! ***\n");
    }
    else {
        print("\nArquivos encontrados: \n"); 
        
        for my $href ( @lista ) { 
            $tabela->add($href->{nome}, $href->{ocorrenciaArq}, $href->{numLinOcorr});
        }
    }

	geraArqLista ($ocorrencia,$tabela);
	
}

elsif ($opcao eq "FDAT"){

	print("<Filtrando por periodo de modificacao de arquivo...>\n\n");
	print ("Periodo de Data desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = filtraDataHora ($arqRegistro, $stringDesejada);

	if ($ocorrencia == 0) {
        print ("\n\n*** NENHUM RESULTADO ENCONTRADO! ***\n");
    }
    else {
        print("\nArquivos encontrados: \n"); 
        
        for my $href ( @lista ) { 
            $tabela->add($href->{nome}, $href->{diretorio}, $href->{dataHora}, $href->{tamanho});
        }
    }

	geraArqLista ($ocorrencia, $tabela);
}

elsif ($opcao eq "FTAM"){

	print("<Filtrando por faixa de tamanho de arquivo...>\n\n");
	print ("Faixa desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = filtraTamanho ($arqRegistro, $stringDesejada);

	if ($ocorrencia == 0) {
        print ("\n\n*** NENHUM RESULTADO ENCONTRADO! ***\n");
    }
    else {
        print("\nArquivos encontrados: \n"); 
        
        for my $href ( @lista ) { 
            $tabela->add($href->{nome}, $href->{diretorio}, $href->{dataHora}, $href->{tamanho});
        }
    }

	geraArqLista ($ocorrencia,$tabela);
}

elsif ($opcao eq "SARQ"){

	print("<Dados dos Arquivos...>\n\n");
	(my $totalArquivos, my $tamanhoTotal, @lista) = obtemDadosArq ($diretorio, $arqRegistro);
    print ("Total de Arquivos: ", $totalArquivos,"\n");
    print ("Tamanho total dos Arquivos: ", $tamanhoTotal,"\n");
   for my $href ( @lista ) { 
       $tabela->add($href->{nome}, $href->{totalLinhas}, $href->{totalCaracteres}, $href->{totalPalavras}, $href->{totalEspacos});
   }

	geraArqLista ($ocorrencia,$tabela);
}


elsif ($opcao eq "MREG"){
	print("<Atualizando Arquivo de Registro...>\n\n");
	atualizaRegistro($diretorio, $arqRegistro);
    print("\nATUALIZADO COM SUCESSO!!!");
}







