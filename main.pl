use warnings;
use strict;
use fileManager qw (registraParametros filtraString contaOcorrencias converteDataHora filtraDataHora atualizaRegistro filtraTamanho geraArqLista);

#programa principal que extrai dados importantes do arquivo de registros

system("cls");
print ("*************************************\n");
print ("********PROCESSADOR DE TEXTOS********\n");
print ("*************************************\n\n");

my @lista;
my $ocorrencia;
my $arqParametros = "parametros.txt";
(my $opcao, my $stringDesejada, my $arqRegistro) = registraParametros($arqParametros);

if ($opcao eq "FSTR"){
	
	print("<Filtrando por nome de arquivo...>\n");
	print ("String desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = filtraString($arqRegistro, $stringDesejada);
	
	print("Numero de ocorrencias: ", $ocorrencia);

	geraArqLista ($ocorrencia, @lista);
}

elsif ($opcao eq "FCON"){

	print("<Filtrando por conteúdo de arquivo...>\n");
	print ("String desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = contaOcorrencias ($arqRegistro, $stringDesejada);

	print("Numero de ocorrencias totais encontradas: ", $ocorrencia, "\n\n");

	geraArqLista ($ocorrencia, @lista);
	
}

elsif ($opcao eq "FDAT"){

	print("<Filtrando por periodo de modificacao de arquivo...>\n\n");
	print ("Periodo de Data desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = filtraDataHora ($arqRegistro, $stringDesejada);

	geraArqLista ($ocorrencia, @lista);
}

elsif ($opcao eq "FTAM"){

	print("<Filtrando por faixa de tamanho de arquivo...>\n\n");
	print ("Faixa desejada: $stringDesejada\n\n");
	($ocorrencia, @lista) = filtraTamanho ($arqRegistro, $stringDesejada);

	geraArqLista ($ocorrencia, @lista);
}

elsif ($opcao eq "MREG"){

	print("<Atualizando Arquivo de Registro...>\n\n");
	atualizaRegistro($arqRegistro);
	print("\nArquivo de Registro Atualizado com sucesso\n");
}







