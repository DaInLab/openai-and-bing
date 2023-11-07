# Load required libraries
library(tm)
library(wordcloud)

# Ler os dados do arquivo texto
text_data <- readLines("./dados/situacao_durante_pandemia.txt")

# Criar um objeto do tipo Corpus
corpus <- Corpus(VectorSource(text_data))

# Pré-processamento do texto
corpus <- tm_map(corpus, tolower)  # Converter para minúsculas
corpus <- tm_map(corpus, removeNumbers)  # Remover os números
corpus <- tm_map(corpus, removePunctuation)  # Remover a pontuação
corpus <- tm_map(corpus, removeWords, stopwords("portuguese"))  # Remover palavras irrelevantes (stopwords)
corpus <- tm_map(corpus, stripWhitespace)  # Remover espaço em branco

# Criar uma matriz documento-termo
# Uma matriz de termo de documento é uma matriz matemática que descreve a frequência de termos que ocorrem em uma coleção de documentos. 
# Em uma matriz documento-termo, as linhas correspondem aos documentos da coleção e as colunas correspondem aos termos. 
tdm <- TermDocumentMatrix(corpus)

# Converter a matriz termo-documento em uma matriz de frequências
freq_matrix <- as.matrix(tdm)

# Calcular frequências de palavras
word_freq <- sort(rowSums(freq_matrix), decreasing = TRUE)

# Gerar a nuvem de palavras
wordcloud(names(word_freq), freq = word_freq, random.order = FALSE)

# Salvar a nuvem de palavras como imagem 
png("./figuras/wordcloud.png")
wordcloud(names(word_freq), freq = word_freq, random.order = FALSE)
dev.off()
