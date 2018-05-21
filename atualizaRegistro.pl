use warnings;
use strict;
use Math::Round qw/round/;
use Time::localtime;
use File::stat;

my $nomeArqReg = "registro.txt";
#Atualiza o arquivo de registros alterando o tamanho e data
sub atualizaRegistro{
	(my $nomeArqReg) = $_[0];	
	print "o nome do arquivo eh";
	print $nomeArqReg;
	open(my $entradaReg, "<", $nomeArqReg) or die "Erro! O arquivo não pode ser aberto: $!";		
		#percorre as linhas do arquivo de registro
				my $i=0;
				while(<$entradaReg>){
					if($i==1){chomp($_);}
					open(my $arqTemp,">>", 'registro2.txt');
						print $arqTemp $_;
					close $arqTemp;
					$i++;
					if($i==2){last;}
				}

				while (<$entradaReg>) {

					chomp($_);
					my @sptLinha = split(/::/, $_);
					#quando encontrar um nome de arquivo abre esse arquivo
					if($sptLinha [0] ne ";P"){						
						open(my $entradaArq, "<", $sptLinha [0]) or die "Erro! O arquivo não pode ser aberto: $!";
							my $statusArq = stat ($entradaArq);
							my $tamanho = $statusArq->size;
							$tamanho = int ($tamanho * 1000) / 1000;
							my $dataHora = ctime ($statusArq->mtime);
							open(my $arqTemp,">>", 'registro2.txt');
								print $arqTemp "\n".$sptLinha[0]."::".$sptLinha[1]."::".ctime($statusArq->mtime)."::".$statusArq->size." bytes";
							close $arqTemp;
						close $entradaArq or die "$entradaArq: $!";
					}

				}
				print("Atualizado com sucesso\n");
	close $entradaReg or die "$entradaReg: $!";
	rename 'registro2.txt', $nomeArqReg;
}


atualizaRegistro($nomeArqReg);