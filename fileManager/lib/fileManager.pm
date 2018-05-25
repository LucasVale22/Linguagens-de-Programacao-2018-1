package fileManager;

use 5.026001;
use strict;
use warnings;
use Carp;
use Text::TabularDisplay;
use Math::Round qw/round/;
use Time::localtime;
use File::stat;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use fileManager ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = qw( registraParametros filtraString contaOcorrencias converteDataHora filtraDataHora atualizaRegistro filtraTamanho geraArqLista );

our @EXPORT = qw(
	
);

#Armazena a primeira e a segunda linha do arquivo de registro (que contem a opção e a string) a ser passada pelo gerenciador C++
sub registraParametros {

    open(my $entrParam, "<", $_[0]) or die "Erro! O arquivo $_[0] não pode ser aberto: $!";

    my @linhasParam = <$entrParam>;

    #extrai os parametros das três linhas do parametros.txt
    my $opcao = $linhasParam [0];  
    my $strDsj = $linhasParam [1]; 
    my $arqReg = $linhasParam [2];

    chomp($opcao);
    chomp($strDsj);

    close $entrParam or die "$entrParam: $!";

    return $opcao, $strDsj, $arqReg;
}

#filtra nomes de arquivo por string passada no arquivo de registros
sub filtraString{

    (my $nomeArqReg, my $strDsj) = @_;

    my $ocorrencia = 0;
    my @lista;

    open(my $entradaReg, "<", $nomeArqReg) or die "Erro! O arquivo não pode ser aberto: $!";

    $lista[$ocorrencia]{nome} = "Nome";
    $lista[$ocorrencia]{diretorio} = "Diretorio";
    $lista[$ocorrencia]{dataHora} = "Data e Hora";
    $lista[$ocorrencia]{tamanho} = "Tamanho";

    #percorre cada linha do arquivo
    while (<$entradaReg>) {

        chomp($_);
        my @sptLinha = split(/::/, $_); #separa as cacterísticas nominais dos arquivos

        #verifica se a string desejada está contida no nome do arquivo e armazena o mesmo numa lista
        if($sptLinha [0] =~ /$strDsj/){
            $ocorrencia++;
            $lista[$ocorrencia]{nome} = $sptLinha [0];
            $lista[$ocorrencia]{diretorio} = $sptLinha [1];
            $lista[$ocorrencia]{dataHora} = $sptLinha [2];
            $lista[$ocorrencia]{tamanho} = $sptLinha [3];
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
    my $ocorrenciaTotal = 0;    #ocorrencia total em todos os arquivos

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
            
        my $ocorrenciaArq = 0; #ocorrencia em cada arquivo
        my $numLinOcorr = 0;    #numero de linhas em que aparecem a string
            
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

    close $entradaReg or die "$entradaReg: $!";

    return $ocorrenciaTotal, @lista;

}

sub converteDataHora {
       (my $dataHora) = @_;
       #extrai os paraêmtros da string de data e hora através de um expressão regular
       my ($diaS,$mes,$dia,$hora,$min,$seg,$ano) = $dataHora =~ m{^([\w]{3})\s([\w]{3})\s([0-9]{2})\s([0-9]{2}):([0-9]{2}):([0-9]{2})\s([0-9]{4})\z}
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

    my @dHDsj = split(/-->/,$dataHoraDsj);
    
    my $dHI = int(converteDataHora($dHDsj[0]));
    my $dHF = int(converteDataHora($dHDsj[1]));


    $lista[$ocorrencia]{nome} = "Nome";
    $lista[$ocorrencia]{diretorio} = "Diretorio";
    $lista[$ocorrencia]{dataHora} = "Data e Hora";
    $lista[$ocorrencia]{tamanho} = "Tamanho";

    open(my $entradaReg, "<", $arqReg) or die "Erro! O arquivo não pode ser aberto: $!";

    while (<$entradaReg>) {
        chomp($_);
        
        my @sptLinha = split (/::/, $_);
        
        my $dataHoraArq = $sptLinha[2];
        
        $dataHoraArq = int(converteDataHora ($dataHoraArq));
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

#Atualiza o arquivo de registros alterando o tamanho e data
sub atualizaRegistro{
    (my $nomeArqReg) = $_[0];   
    open(my $entradaReg, "<", $nomeArqReg) or die "Erro! O arquivo não pode ser aberto: $!";        
        #percorre as linhas do arquivo de registro

                while (<$entradaReg>) {

                    chomp($_);
                    my @sptLinha = split(/::/, $_);
                    #quando encontrar um nome de arquivo abre esse arquivo
                                         
                    open(my $entradaArq, "<", $sptLinha [0]) or die "Erro! O arquivo não pode ser aberto: $!";
                        my $statusArq = stat ($entradaArq);
                        my $tamanho = $statusArq->size;
                        
                        if ($tamanho >= 1024) {
                            $tamanho /= 1024;
                            $tamanho = int ($tamanho * 100) / 100;
                            $tamanho = $tamanho." KB";
                        }
                        elsif ($tamanho >= (1024 * 1024)) {
                            $tamanho /= (1024 * 1024);
                            $tamanho = int ($tamanho * 100) / 100;
                           $tamanho = $tamanho." MB";
                        }
                        else {$tamanho = $tamanho." bytes";}
                        my $dataHora = ctime ($statusArq->mtime);

                            #depois tenta isso, tem que ter o modulo File::Slurp
                            #my $strSubs = read_file "registro.txt";
                            #$strSubs =~ s/$sptLinha[2]/$dataHora/g;
                            #$strSubs =~ s/$sptLinha[3]/$tamanho/g;
                            #write_file "registro.txt", $strSubs;

                        open(my $arqTemp,">>", 'temporario.txt');
                            print $arqTemp $sptLinha[0]."::".$sptLinha[1]."::".ctime($statusArq->mtime)."::".$tamanho."\n";
                        close $arqTemp;
                    close $entradaArq or die "$entradaArq: $!";

                }
                
    close $entradaReg or die "$entradaReg: $!";
    rename 'temporario.txt', 'registro.txt';
}

sub filtraTamanho {

    (my $arqReg, my $faixaTamDsj) = @_;

    my @lista;
    my $ocorrencia = 0;

    my @tamDsj = split(/-->/,$faixaTamDsj);
    my @tamI = split(/\s/, $tamDsj [0]);
    my @tamF = split(/\s/, $tamDsj [1]);

    if ($tamI [1] eq "KB") {
        $tamI [0] = int($tamI[0]) * 1024;
    }

    if ($tamF [1] eq "KB") {
        $tamF [0] = int($tamF[0]) * 1024;
    }

    $lista[$ocorrencia]{nome} = "Nome";
    $lista[$ocorrencia]{diretorio} = "Diretorio";
    $lista[$ocorrencia]{dataHora} = "Data e Hora";
    $lista[$ocorrencia]{tamanho} = "Tamanho";

    open(my $entradaReg, "<", $arqReg) or die "Erro! O arquivo não pode ser aberto: $!";

    while (<$entradaReg>) {
        chomp($_);
        
        my @sptLinha = split (/::/, $_);
        
        my @tamArq = split(/\s/, $sptLinha[3]);

        if ($tamArq [1] eq "KB") {
            $tamArq [0] = ($tamArq [0]) * 1024;
        }
        
        if ($tamI [0] <= $tamArq [0] && $tamArq [0] <= $tamF [0]) {
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

    (my $ocorrencia, my @lista) = @_;
    my $tabela = Text::TabularDisplay->new;
    if ($ocorrencia == 0) {
        print ("\n\n*** NENHUM RESULTADO ENCONTRADO! ***\n");
    }
    else {
        print("\nArquivos encontrados: \n"); 
        for my $href ( @lista ) {
            $tabela->add($href->{nome}, $href->{diretorio}, $href->{dataHora}, $href->{tamanho});
        }

        unlink "lista-de-retorno.txt";
        open(my $entrada, ">>", "lista-de-retorno.txt") or die "Erro! O arquivo não pode ser gerado: $!";
        
        print $entrada $tabela->render;
        print $tabela->render;

        close $entrada or die "$entrada: $!";
    }

}

our $VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&fileManager::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('fileManager', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

fileManager - Perl extension for blah blah blah

=head1 SYNOPSIS

  use fileManager;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for fileManager, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

A. U. Thor, E<lt>a.u.thor@a.galaxy.far.far.awayE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2018 by A. U. Thor

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.26.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
