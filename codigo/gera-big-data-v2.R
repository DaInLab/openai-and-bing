# Gerando um grande banco de dados
# Variáveis: idade, gênero e salário.
# Criar um conjunto de dados grande (10 milhões de linhas)
df <- data.frame(
  idade = sample(18:65, 10000000, replace = TRUE),
  genero = sample(c("feminino","masculino","lesbica","gay",
                    "bissexual","transgenero","queer","intersexual",
                    "assexual","pansexuais"),10000000, 
                  replace = TRUE,
                  prob = c(40.75,38,8,10,1,1,0.5,0.25,0.25,0.25)),
  salario = sample(1320:13200, 10000000, replace = TRUE)
)

# Gravando big data
write.table(df, file = "./dados/bigdatateste.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = c("idade", "genero", "salario"), qmethod = "double",
            fileEncoding = "")

#abs(rnorm(10))*10000