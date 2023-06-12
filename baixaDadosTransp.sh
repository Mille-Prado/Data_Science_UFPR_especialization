#!/bin/bash

# Este é um script em BASH que baixa dados do portal da tranparência (http://portaldatransparencia.gov.br/download-de-dados/despesas) de um período pré-determinado, extrai destes arquivos de interesse e os agrupa em um único 'arquivo.csv'. Para tanto, deve receber 4 (quatro) parâmetros e precisa ser invocado como 'baixaDadosTransp diaIni diaFim mes ano', onde: 'baixaDadosTransp' é o nome do script, 'diaIni' é o dia inicial a ser baixado, 'diaFim' é o dia final a ser baixado, 'mes' é o mês dos dados requeridos, 'ano' é o ano dos dados requeridos.

# Um exemplo de execução do script é: ./baixaDadosTransp.sh 05 2015

# Para debug, descomentar a próxima linha (gera um output no terminal descrevendo o passo-a-passo dos processos realizados pelo script):
#set -x

# Indicando qual o endereço do site
siteDownload="http://portaldatransparencia.gov.br/download-de-dados/despesas"

#Variáveis que indicam os dias do mês da busca, o mês e o ano que irá buscar

diaIni=$1 #inicioPeriodo
diaFim=$2 #fimPeriodo
mes=$3
ano=$4

# Diretórios para baixar os dados e processá-los
dataDir="./dados"
tmpDir="./tmp"

# Cria diretório
mkdir $dataDir

# Iteração para cada dia (inicio e fim) do período
for dia in $(seq -f "%02g" $diaIni $diaFim); do
  zipFile=$ano$mes$dia.zip

  # Download do arquivo zip com os dados do site 
  echo -n "Baixando arquivo $zipFile ..."
  wget $siteDownload/$zipFile 2> /dev/null
  echo OK

  # Descompactação no diretório temporário
  echo -n "Descompactando arquivo $zipFile ..."
  unzip -o $zipFile '*ItemEmpenho.csv' -d $tmpDir > /dev/null
  unzip -o $zipFile '*Pagamento.csv' -d $tmpDir > /dev/null
  echo OK

  # Remoção do arquivo zip
  echo -n "Removendo arquivo $zipFile ..."
  rm -f $zipFile
  echo OK
done

# Transferência da cópia dos dados do diretório temporário para o diretório 'dados'
cat $tmpDir/*ItemEmpenho.csv > $dataDir/$ano$mes-ItemEmpenho.csv
cat $tmpDir/*Pagamento.csv > $dataDir/$ano$mes-Pagamento.csv

# Remoção do diretório temporário
rm -f $tmpDir/*.csv
rmdir $tmpDir

