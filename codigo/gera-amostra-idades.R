# Versão ChatGPT - OpenAI

# Pergunta: Escrever código na linguagem R que gere, randômicamente, uma amostra de idades compreendendo a faixa de 18 a 65 anos de idade. 

# Resposta: Claro! Aqui está um exemplo de código em R que gera uma amostra aleatória de idades entre 18 e 65 anos:

# Definir o tamanho da amostra desejada
tamanho_amostra <- 100

# Gerar a amostra de idades aleatórias
amostra_idades <- sample(18:65, tamanho_amostra, replace = TRUE)

# Exibir a amostra gerada
print(amostra_idades)

#Neste código, a função `sample` é usada para gerar uma amostra aleatória de números entre 18 e 65 (inclusive), 
# com substituição. O parâmetro `tamanho_amostra` define o tamanho desejado da amostra. 
# A amostra gerada é armazenada na variável `amostra_idades` e, em seguida, exibida na saída.

#Você pode ajustar o valor de `tamanho_amostra` para o tamanho de amostra desejado.