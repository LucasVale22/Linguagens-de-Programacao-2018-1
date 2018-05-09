#use warnings;
use strict;

my $nomeArqReg = "registro.txt";
#chop($nomeArquivoRegistro); 
my $posicao = 0;
my $opcao;
my $palavra;
my @lista = ();
my $ocorrencia = 0;

open(my $linha, "<:encoding(UTF-8)", $nomeArqReg) or die "Erro! O arquivo não pode ser aberto: $!";

	while (<$linha>) {

		$posicao++;
		chomp($_);
		my @sptLinha = split(/::/, $_);

		if ($sptLinha [0] eq 'O'){
			$opcao = $sptLinha [1];
			print($sptLinha [0], "\t",$opcao, "\n");
		}
		if ($sptLinha [0] eq 'S'){
			$palavra = $sptLinha [1];
			print($sptLinha [0], "\t",$palavra, "\n");
		}
		if($sptLinha [0] eq 'N'){

			print($sptLinha [0], "\t", $sptLinha [1], "\n");

			if($sptLinha [1] =~ /$palavra/){
				$ocorrencia++;
				$lista [$posicao - 1] = $sptLinha [1];
			}

		}

	}

close $linha or die "$linha: $!";
print("Numero de ocorrencias da palavra $palavra: ", $ocorrencia);
print("\nArquivos encontrados: \n");
foreach (@lista) {print $_, "\n"};
