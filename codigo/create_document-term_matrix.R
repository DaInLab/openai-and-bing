

# Non-text analysis packages to be used.
library(tidyverse)
if(!("ggpubr") %in% installed.packages()) install.packages("ggpubr")
library(ggpubr)
library(Matrix)
library(slam)
if(!("bench") %in% installed.packages()) install.packages("bench")
library(bench)
library(dplyr)
if(!("rtrek") %in% installed.packages()) install.packages("rtrek")
library(rtrek)


# Text analysis R packages to be used
packages <- c("tidytext", 
              "tm", 
              "quanteda", 
              "text2map",
              "text2vec",
              "textTinyR",
              "corpustools",
              "textmineR",
              "wactor",
              "gofastr",
              "udpipe")

#install.packages(packages)
invisible(lapply(packages, library, character.only = TRUE))

## GETTING STARTED
# Getting scripts from Star Trek from the rtrek package

df.trek <-  rtrek::st_transcripts() |>
  unnest(cols = c(text) ) |>
  filter(!is.na(line)) |>
  group_by(series, number) |> 
  summarize(text = paste0(line, collapse = " "),
            doc_id = first(title),
            season = first(season),
            airdate = first(airdate)) |> ungroup()

df.tng <-  rtrek::st_transcripts() |>
  unnest(cols = c(text) ) |>
  filter(series == "TNG") |> # limit to TNG
  filter(!is.na(line)) |>
  group_by(number) |> 
  summarize(text = paste0(line, collapse = " "),
            doc_id = first(title),
            season = first(season),
            airdate = first(airdate)) |> ungroup()

# Doing a tiny bit of preprocessing (lowercasing, smooshing contractions, removing punctuation, numbers, and getting rid of extra spaces).
df.trek <- df.trek |>
  dplyr::mutate(
    clean_text = tolower(text),
    clean_text = gsub("[']", "", clean_text), 
    clean_text = gsub("[[:punct:]]", " ", clean_text),
    clean_text = gsub('[[:digit:]]+', " ", clean_text),
    clean_text = gsub("[[:space:]]+", " ", clean_text),
    clean_text = trimws(clean_text)) 

df.tng <- df.tng |>
  dplyr::mutate(
    clean_text = tolower(text),
    clean_text = gsub("[']", "", clean_text), 
    clean_text = gsub("[[:punct:]]", " ", clean_text),
    clean_text = gsub('[[:digit:]]+', " ", clean_text),
    clean_text = gsub("[[:space:]]+", " ", clean_text),
    clean_text = trimws(clean_text))

## BASE R, DENSE DTMS
# Creating two base R methods for creating dense DTMs

# The first function uses a for loop with the table function to count the number of instances of a given token
base_loop <- function(text, doc_id){
  tokns <- strsplit(text, " ", fixed=TRUE)
  vocab <- sort(unique(unlist(tokns)))
  dtm <- matrix(data = 0L, 
                ncol = length(vocab), nrow = length(tokns),
                dimnames = list(doc_id, vocab) )
  freqs <- lapply(tokns, table)
  for (i in 1:length(freqs) ){
    doc <- freqs[[i]]
    dtm[i, names(doc)] <- as.integer(doc)
  }
  return(dtm)
}

# The second uses only lapply with the tabulate function to count tokens
base_lapply <- function(text, doc_id){
  tokns <- strsplit(text, " ") 
  vocab <- sort(unique(unlist(tokns)))
  FUN <- function(x, lev){tabulate(factor(x, levels = lev, 
                                          ordered = TRUE), 
                                   nbins = length(lev))}
  out <- lapply(tokns, FUN, lev = vocab)
  dtm <- as.matrix(t(do.call(cbind, out) ) )
  dimnames(dtm) <- list(doc_id, vocab) 
  return(dtm)
}

dtm1 <- base_loop(df.trek$clean_text, df.trek$doc_id)
dtm2 <- base_lapply(df.trek$clean_text, df.trek$doc_id)

# check that these two methods produced identical results.
# (1) check that they're the same dimensions, 
# (2) check they sum to the same number of total tokens in the corpus, 
# (3) and check that the words and document IDs (episode titles) are the same
dim(dtm1) == dim(dtm2)
# [1] TRUE TRUE
sum(dtm2) == sum(dtm1)
# [1] TRUE
dimnames(dtm1) %in% dimnames(dtm2)
# [1] TRUE TRUE

# Which method is more efficient?
# To compare methods the mark() function from the bench package will be used.

df.mark <- bench::mark(
  dtm_bloop <- base_loop(df.trek$clean_text, df.trek$doc_id),
  dtm_blapply <- base_lapply(df.trek$clean_text, df.trek$doc_id),
  check = FALSE,
  iterations = 10,
  memory = TRUE
)
# Warning message:
# Some expressions had a GC in every iteration; so filtering is disabled.

df.mark |>
  mutate(expression = c("loop", "lapply")) |>
  select(expression, mem_alloc, median)
# A tibble: 2 × 3
#   expression mem_alloc   median
#   <chr>      <bch:byt> <bch:tm>
# 1 loop          1.06GB     5.9s
# 2 lapply        2.36GB      12s

# For loop function beat the lapply!

# SPARSE DTMS
# As a result of the nature of language, DTMs tend to be very "sparse" ---meaning, 
# they have lots and lots of zeros. 
# how many cells are zeros in one of the dense DTMs created based on Star Trek: TNG script?
total.cells <- ncol(dtm1) * nrow(dtm1)
zero.cells  <- sum(dtm1==0)
zero.cells/total.cells
# [1] 0.9708137
# That is a lot of zero cells!
# The two functions above produced a basic "dense" matrix, which can quickly take up a lot of memory.
# The most straightforward way to deal with memory limitations is to simply represent a matrix as a slightly different kind of data object called a "sparse" matrix. Simply put, when a matrix has a lot of zeros, the sparse format will produce a smaller object. 


