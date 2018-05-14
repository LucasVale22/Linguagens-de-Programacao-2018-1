# Linguagens-de-Programacao-2018-1
# Sistema Gerenciador de Arquivos em Perl e C++

Primeiro trabalho da disciplina Linguagens de Programação

Lucas dos Santos Gonçalves de Miranda 
Lucas do Vale Santos


# Definição do Problema

O presente trabalho consiste em um sistema gerenciador, onde implementaremos algumas funcionalidades essenciais para organizar e manipular arquivos através de diretórios. Haverá um arquivo  de registros responsável por armazenar dados relevantes sobre cada arquivo de texto (como nome, diretório ao qual ele pertence, data de alteração, etc.).

A princípio o sistema trabalhará apenas com arquivos que suportem textos em seu conteúdo (ex.: .txt, .pdf, .docx, etc) para simplificar a nossa análise. O usuário vai interagir a partir do terminal, onde lhe será fornecido um menu entrada, através do qual possa escolher algumas opções: 

Acessar diretórios e listar arquivos por características, como por exemplo, nome (ordem alfabética), formato, data de alteração, tamanho, etc.;
Separar e organizar os arquivos em diretórios de acordo com o conteúdo (por assunto/tema) de cada arquivo;
Manipular arquivos através de operações fundamentais como excluir, renomear, mover ou copiar;
Listar alguma informações básicas, como número de diretórios, quantidade de arquivos por diretório, número. 
        
O gerenciador C++ terá uma função responsável por interagir com o Perl através de uma API, fornecendo uma saída em arquivo txt que vai ser analisado como entrada no processador Perl. Esse arquivo conterá uma cópia dos registros originais acrescidos de uma chave que identifica a operação que o usuário escolher. O processador executará as seguintes tarefas:

Classificar por características nominais: busca arquivos através do nome, letra ou expressão informados, bem como pelo formato de arquivo, através da consulta em um arquivo de registros.
Classificar por conteúdo: Utiliza critérios mais refinados para realizar a busca e classificação por conteúdo de texto, analisando e verificando o padrão de ocorrências de palavras ou expressões dentro do arquivo.
Armazenar recorrências: Conta a quantidade de caracteres, número de recorrência de palavras ou expressões, número de páginas, ou tipos de arquivo.
Classificar por data de modificação: consulta as datas de modificação no registro de arquivos e manipula a data conforme critérios de ordenação (arquivos mais recentes ou mais antigos).
Gerenciar arquivo de registros: Dentro do arquivo de registros, adiciona ou remove o os dados relevantes de algum arquivo de texto (seu nome, diretório, data).
    
Após o processamento no Perl, será retornado como saída para o C++ um novo arquivo txt contendo os resultados das análises. A partir disso, o gerenciador fornecerá na saída para o usuário uma lista contendo os arquivos e suas respectivas informações de acordo com o que escolheu como na entrada do sistema. 

