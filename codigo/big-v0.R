# Versão Bing Edge
# Pergunta: Mostrar o exemplo de um código na linguagem R que trabalhe utilizando Big Data.
# Resposta: Claro! Aqui está um exemplo de código na linguagem R que trabalha utilizando Big Data:
# Este código cria um conjunto de dados com 1 milhão de linhas e 10 colunas e 
# calcula a média de cada coluna do conjunto de dados².
# Fonte: https://pt.stackoverflow.com/questions/30631/estrat%c3%a9gias-para-analisar-bases-de-dados-muito-grandes-em-r-que-n%c3%a3o-caibam-na-m)


# Instalar e carregar os pacotes utilizados
testa.bib <- function(bib) if(!(bib) %in% installed.packages()) install.packages(bib)

# Testando se os pacotes já estão instalados
# Se não estiverem instalados, instala-os!
testa.bib("ff") 
testa.bib("bigmemory")
testa.bib("biganalytics")

#Carregando os pacotes necessários
library(ff)
library(bigmemory)
library(biganalytics)

# Criando um conjunto de dados de 1 milhão de linhas e 10 colunas
dados <- matrix(rnorm(1e7), ncol = 10)

# Convertendo o conjunto de dados em um objeto big.matrix
bm <- as.big.matrix(dados)

# Calculando a média de cada coluna do conjunto de dados
colMeans(bm)
# Error in colMeans(bm) : 'x' must be an array of at least two dimensions