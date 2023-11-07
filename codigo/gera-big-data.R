# Gerando um grande banco de dados
# Variáveis: idade, gênero e salário.
# Criar um conjunto de dados grande (100 milhões de linhas)
df <- data.frame(
  idade = sample(18:65, 1000000, replace = TRUE),
  genero = sample(c("feminino", "masculino", "lesbica", "gay", "bissexual", 
                    "transgenero", "queer", "intersexual", "assexual", "pansexuais"),
                  1000000, replace = TRUE),
  salario = abs(rnorm(10))*10000
)

# Gravando big data
write.table(df, file = "./dados/bigdatateste.csv", append = FALSE, quote = TRUE, sep = ";",
            eol = "\n", na = "NA", dec = ".", row.names = TRUE,
            col.names = c("idade", "genero", "salario"), qmethod = "double",
            fileEncoding = "")
