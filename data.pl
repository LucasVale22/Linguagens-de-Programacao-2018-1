use warnings;

#pequeno programa que compara duas strings de data e hora

sub comparaDataHora {
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

#esse é o formato padrão chamado de localtime
my $dataHora1 = "Dec 15 23:35:09 2018";
my $dataHora2 = "Oct 15 23:35:09 2018";

#dataHora1 é menor que dataHora2????
#operador lt significa "less than"
if (comparaDataHora($dataHora1) lt comparaDataHora($dataHora2)) {
   print "SIM";
} else {
   print "NAO";
}